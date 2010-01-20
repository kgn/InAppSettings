//
//  InAppSettingsViewController.m
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettings.h"
#import "InAppSettingsSpecifier.h"
#import "InAppSettingsConstants.h"
#import "InAppSettingsPSMultiValueSpecifierTable.h"

//@interface InAppSettings : NSObject {}
//
//+ (void)registerDefaults{
//    //keep track of which files we haev read to avoid cervular references
//    NSMutableArray *consumedFiles = [[NSMutableArray alloc] inti];
//    
//    NSString *file = InAppSettingsRootFile;
//    NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:InAppSettingsFullPlistPath(file)];
//    NSArray *preferenceSpecifiers = [settingsDictionary objectForKey:InAppSettingsPreferenceSpecifiers];
//    NSString *stringsTable = [settingsDictionary objectForKey:InAppSettingsStringsTable];
//    
//    [consumedFiles release];
//}
//
//@end

@implementation InAppSettingsModalViewController

- (id)init{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    self = [[UINavigationController alloc] initWithRootViewController:settings];
    [settings addDoneButton];
    [settings release];
    return self;
}

@end

@implementation InAppSettingsViewController

@synthesize file;
@synthesize settingsTableView;
@synthesize firstResponder;
@synthesize settingsReader;

#pragma mark modal view

- (void)dismissModalView{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)addDoneButton{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                   target:self 
                                   action:@selector(dismissModalView)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
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
    self.firstResponder = nil;
    
    self.settingsTableView.contentInset = UIEdgeInsetsZero;
    self.settingsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [self.settingsTableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.firstResponder = nil;
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    self.firstResponder = nil;
    [file release];
    [settingsTableView release];
    [settingsReader release];
    [super dealloc];
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

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    if(self.firstResponder == nil){
        // get the keybaord rect
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
        
        // determin the bottom inset for the table view
        UIEdgeInsets settingsTableInset = self.settingsTableView.contentInset;
        CGPoint tableViewScreenSpace = [self.settingsTableView.superview convertPoint:self.settingsTableView.frame.origin toView:nil];
        CGFloat tableViewBottomOffset = InAppSettingsScreenHeight-(tableViewScreenSpace.y+self.settingsTableView.frame.size.height);
        settingsTableInset.bottom = keyboardRect.size.height-tableViewBottomOffset;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:InAppSettingsKeyboardAnimation];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = settingsTableInset;
        self.settingsTableView.scrollIndicatorInsets = settingsTableInset;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    if(self.firstResponder == nil){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:InAppSettingsKeyboardAnimation];
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
    return [self.settingsReader.headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.settingsReader.headers objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.settingsReader.settings objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(InAppSettingsDisplayPowered && [self.file isEqualToString:InAppSettingsRootFile] && section == (NSInteger)[self.settingsReader.headers count]-1){
        return InAppSettingsPoweredBy;
    }
    
    return nil;
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
        cell = [[[nsclass alloc] initWithReuseIdentifier:cellType] autorelease];
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
        [multiValueSpecifier release];
    }else if([setting isType:InAppSettingsPSChildPaneSpecifier]){
        InAppSettingsViewController *childPane = [[InAppSettingsViewController alloc] initWithFile:[setting valueForKey:InAppSettingsSpecifierFile]];
        childPane.title = [setting localizedTitle];
        [self.navigationController pushViewController:childPane animated:YES];
        [childPane release];
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

