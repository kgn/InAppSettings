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

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.viewControllers.count == 0){
        InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
        [settings addDoneButton];
        self.viewControllers = @[settings];
    }
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
    self = [super init];
    if (self != nil){
        self.file = inputFile;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //setup the table
    self.settingsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.settingsTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.settingsTableView.delegate = self;
    self.settingsTableView.dataSource = self;
    [self.view addSubview:self.settingsTableView];
    
    //if the title is nil set it to Settings
    if(!self.title){
        self.title = NSLocalizedString(@"Settings", nil);
    }
    
    //load settigns plist
    if(!self.file){
        self.file = InAppSettingsRootFile;
    }
    
    self.settingsReader = [[InAppSettingsReader alloc] initWithFile:self.file];
    
    //setup keyboard notification
    self.firstResponder = nil;
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.firstResponder = nil;
    
    self.settingsTableView.contentInset = UIEdgeInsetsZero;
    self.settingsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [self.settingsTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.firstResponder = nil;
}

- (void)dealloc{
    self.firstResponder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

#pragma mark text field cell delegate

- (void)textFieldDidBeginEditing:(UITextField *)cellTextField{
    self.firstResponder = cellTextField;
    
    //TODO: find a better way to get the cell from the text view
    NSIndexPath *indexPath = [self.settingsTableView indexPathForCell:(UITableViewCell *)[[cellTextField superview] superview]];
    [self.settingsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)cellTextField{
    self.firstResponder = nil;
    [cellTextField resignFirstResponder];
    return YES;
}

#pragma mark keyboard notification

// TODO: handle the case where the settings are in a popover or sheet modal
// The offset amount will not be the same as on iPhone
// Maybe bring in KGKeyboardChangeManager?

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    if(self.firstResponder == nil){
        CGRect keyboardEndFrame;
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        NSDictionary *userInfo = [notification userInfo];
        [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

        UIEdgeInsets settingsTableInset = self.settingsTableView.contentInset;
        CGPoint tableViewScreenSpace = [self.settingsTableView.superview convertPoint:self.settingsTableView.frame.origin toView:nil];
        CGFloat tableViewBottomOffset = CGRectGetHeight(self.view.bounds)-(tableViewScreenSpace.y+self.settingsTableView.frame.size.height);
        settingsTableInset.bottom = CGRectGetHeight(keyboardEndFrame)-tableViewBottomOffset;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];        
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = settingsTableInset;
        self.settingsTableView.scrollIndicatorInsets = settingsTableInset;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    if(self.firstResponder == nil){
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        NSDictionary *userInfo = [notification userInfo];
        [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = UIEdgeInsetsZero;
        self.settingsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
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
