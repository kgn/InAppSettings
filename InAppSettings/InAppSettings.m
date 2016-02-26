//
//  InAppSettingsViewController.m
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettings.h"
#import "InAppSettingsPSMultiValueSpecifierTable.h"

NSString *const InAppSettingsViewControllerDelegateWillDismissedNotification = @"InAppSettingsViewControllerDelegateWillDismissedNotification";
NSString *const InAppSettingsViewControllerDelegateDidDismissedNotification = @"InAppSettingsViewControllerDelegateDidDismissedNotification";
NSString *const InAppSettingsValueChangeNotification = @"InAppSettingsValueChangeNotification";
NSString *const InAppSettingsTapNotification = @"InAppSettingsTapNotification";

@implementation InAppSettings

+ (void)registerDefaults{
    id __unused defaults = [[InAppSettingsReaderRegisterDefaults alloc] init];
}

@end

@implementation InAppSettingsModalViewController

- (id)init{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [settings addDoneButton];
    return [[InAppSettingsModalViewController alloc] initWithRootViewController:settings];
}

@end

@implementation InAppSettingsViewController

#pragma mark modal view

- (IBAction)dismissModalView:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppSettingsViewControllerDelegateWillDismissedNotification object:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:InAppSettingsViewControllerDelegateDidDismissedNotification object:self];
    }];
}

- (void)addDoneButton{
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
     target:self
     action:@selector(dismissModalView:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark setup view

- (id)initWithFile:(NSString *)inputFile{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self != nil){
        self.file = inputFile;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //if the title is nil set it to Settings
    if(!self.title){
        self.title = NSLocalizedString(@"Settings", nil);
    }
    
    //load settigns plist
    if(!self.file){
        self.file = InAppSettingsRootFile;
    }
    
    self.settingsReader = [[InAppSettingsReader alloc] initWithFile:self.file];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Get indexpath for highlighted cell, to re-highlight
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    
    [self.tableView reloadData];
    
    // Re-select cell
    [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)applicationWillEnterForeground:(NSNotification*)notify{
    // reload in settings in case they were changed in the prefs app.
    [[NSUserDefaults standardUserDefaults] synchronize];
    // show any changes if they happened in the background.
    [self.tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

#pragma mark text field cell delegate

- (void)textFieldDidBeginEditing:(UITextField *)cellTextField{
    //TODO: find a better way to get the cell from the text view
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[cellTextField superview] superview]];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)cellTextField{
    [cellTextField resignFirstResponder];
    return YES;
}

#pragma mark Table view methods

- (InAppSettingsSpecifier *)settingAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.settingsReader.settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.settingsReader.headersAndFooters count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.settingsReader.headersAndFooters objectAtIndex:section][0];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [self.settingsReader.headersAndFooters objectAtIndex:section][1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.settingsReader.settings objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSettingsSpecifier *setting = [self settingAtIndexPath:indexPath];
    
    //get the NSClass for a specifier, if there is none use the base class InAppSettingsTableCell
    NSString *cellType = [setting cellName];
    Class nsclass = NSClassFromString(cellType);
    if(!nsclass){
        cellType = @"InAppSettingsTableCell";
        nsclass = NSClassFromString(cellType);
    }
    
    InAppSettingsTableCell *cell = ((InAppSettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellType]);
    if (cell == nil){
        cell = [[nsclass alloc] initWithReuseIdentifier:cellType];
        //setup the cells controlls
        [cell setupCell];
    }
    
    //set the values of the cell, this is separated from setupCell for reloading the table
    cell.setting = setting;
    [cell setValueDelegate:self];
    [cell setUIValues];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSettingsSpecifier *setting = [self settingAtIndexPath:indexPath];
    if([setting isType:InAppSettingsPSMultiValueSpecifier]){
        InAppSettingsPSMultiValueSpecifierTable *multiValueSpecifier = [[InAppSettingsPSMultiValueSpecifierTable alloc] initWithSetting:setting];
        [self.navigationController pushViewController:multiValueSpecifier animated:YES];
    }else if([setting isType:InAppSettingsPSChildPaneSpecifier]){
        InAppSettingsViewController *childPane = [[InAppSettingsViewController alloc] initWithFile:[setting valueForKey:InAppSettingsSpecifierFile]];
        childPane.title = [setting localizedTitle];
        [self.navigationController pushViewController:childPane animated:YES];
    }else if([setting isType:InAppSettingsPSTitleValueSpecifier]){
        NSString *InAppURL = [setting valueForKey:InAppSettingsSpecifierInAppURL];
        NSString *InAppTwitter = [setting valueForKey:InAppSettingsSpecifierInAppTwitter];
        if(InAppURL){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:InAppURL]];
        }else if(InAppTwitter){
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", InAppTwitter]]];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", InAppTwitter]]];
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSettingsTableCell *cell = ((InAppSettingsTableCell *)[tableView cellForRowAtIndexPath:indexPath]);
    
    if([cell.setting isType:@"PSTextFieldSpecifier"]){
        [cell.valueInput becomeFirstResponder];
    }else if(cell.canSelectCell){
        [self.firstResponder resignFirstResponder];
        return indexPath;
    }
    return nil;
}

@end
