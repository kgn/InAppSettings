//
//  InAppSettingsViewController.m
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsViewController.h"
#import "InAppSetting.h"
#import "InAppSettingConstants.h"
#import "PSMultiValueSpecifierTable.h"

@implementation InAppSettingsViewController

@synthesize file;
@synthesize settingsTableView;
@synthesize headers, displayHeaders, settings;
@synthesize displayKeyboard;

#pragma mark validate plist data

- (BOOL)isValidSetting:(InAppSetting *)setting{
    NSString *type = [setting getType];
    if([type isEqualToString:@"PSMultiValueSpecifier"]){
        if(![setting hasKey]){
            return NO;
        }
        
        if(![setting hasDefaultValue]){
            return NO;
        }
         
        if(![setting hasTitle] || [[setting valueForKey:@"Title"] length] == 0){
            return NO;
        }
        
        NSArray *titles = [setting valueForKey:@"Titles"];
        if((!titles) || ([titles count] == 0)){
            return NO;
        }
        
        NSArray *values = [setting valueForKey:@"Values"];
        if((!values) || ([values count] == 0)){
            return NO;
        }
        
        if([titles count] != [values count]){
            return NO;
        }
    }
    
    else if([type isEqualToString:@"PSSliderSpecifier"]){
        if(![setting hasKey]){
            return NO;
        }
        
        if(![setting hasDefaultValue]){
            return NO;
        }
        
        NSNumber *minValue = [setting valueForKey:@"MinimumValue"];
        if(!minValue){
            return NO;
        }
        
        NSNumber *maxValue = [setting valueForKey:@"MaximumValue"];
        if(!maxValue){
            return NO;
        }
    }
    
    else if([type isEqualToString:@"PSToggleSwitchSpecifier"]){
        if(![setting hasKey]){
            return NO;
        }
        
        if(![setting hasDefaultValue]){
            return NO;
        }
        
        if(![setting hasTitle]){
            return NO;
        }
    }
    
    else if([type isEqualToString:@"PSTitleValueSpecifier"]){
        if(![setting hasKey]){
            return NO;
        }
        
        if(![setting hasDefaultValue]){
            return NO;
        }
    }
    
    else if([type isEqualToString:@"PSChildPaneSpecifier"]){
        if(![setting hasTitle]){
            return NO;
        }
        
        NSString *plistFile = [setting valueForKey:@"File"];
        if(!plistFile){
            return NO;
        }
    }
    
    return YES;
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
        self.file = InAppSettingRootFile;
    }
    
    //load plist
    NSString *plistFile = [self.file stringByAppendingPathExtension:@"plist"];
    NSString *settingsRootPlist = [InAppSettingBundlePath stringByAppendingPathComponent:plistFile];
    NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:settingsRootPlist];
    NSArray *preferenceSpecifiers = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    NSString *stringsTable = [settingsDictionary objectForKey:@"StringsTable"];
    
    //create an array for headers(PSGroupSpecifier) and a dictonary to hold arrays of settings
    self.headers = [[NSMutableArray alloc] init];
    self.displayHeaders = [[NSMutableArray alloc] init];
    self.settings = [[NSMutableArray alloc] init];
    
    //if the first item is not a PSGroupSpecifier create a header to store the settings
    NSString *currentHeader = InAppSettingNullHeader;
    InAppSetting *firstSetting = [[InAppSetting alloc] initWithDictionary:[preferenceSpecifiers objectAtIndex:0] andStringsTable:stringsTable];
    if(![firstSetting isType:@"PSGroupSpecifier"]){
        [self.headers addObject:currentHeader];
        [self.displayHeaders addObject:@""];
        [self.settings addObject:[NSMutableArray array]];
    }
    [firstSetting release];
    
    //set the first value in the display header to "", while the real header is set to InAppSettingNullHeader
    //this way whats set in the first entry to headers will not be seen
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(NSDictionary *eachSetting in preferenceSpecifiers){
        BOOL shouldAddSetting = YES;
        InAppSetting *setting = [[InAppSetting alloc] initWithDictionary:eachSetting andStringsTable:stringsTable];
        
        //type is required
        if(![setting getType]){
            shouldAddSetting = NO;
        }else if([setting isType:@"PSGroupSpecifier"]){
            currentHeader = [setting localizedTitle];
            [self.headers addObject:currentHeader];
            [self.displayHeaders addObject:currentHeader];
            [self.settings addObject:[NSMutableArray array]];
            shouldAddSetting = NO;
        }else{
            shouldAddSetting = [self isValidSetting:setting];
        }
        
        if(shouldAddSetting){
            NSInteger currentHeaderIndex = [self.headers indexOfObject:currentHeader];
            if((currentHeaderIndex >= 0) && (currentHeaderIndex < (NSInteger)[self.headers count])){
                NSMutableArray *currentArray = [self.settings objectAtIndex:currentHeaderIndex];
                [currentArray addObject:setting];
            }
        }
        [setting release];
    }
    [pool drain];
    [settingsDictionary release];
    
    //setup keyboard notification
    self.displayKeyboard = NO;
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    self.displayKeyboard = NO;
    [self.settingsTableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.displayKeyboard = NO;
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [file release];
    [settingsTableView release];
    [headers release];
    [displayHeaders release];
    [settings release];
    [super dealloc];
}

#pragma mark text field cell delegate

- (void)textFieldDidBeginEditing:(UITextField *)cellTextField{
    NSLog(@"textFieldDidBeginEditing");
    self.displayKeyboard = YES;
    
    //TODO: find a better way to get the cell
    NSIndexPath *indexPath = [self.settingsTableView indexPathForCell:(UITableViewCell *)[[cellTextField superview] superview]];
    [self.settingsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)cellTextField{
    NSLog(@"textFieldShouldReturn");
    self.displayKeyboard = NO;
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
    if(!self.displayKeyboard){
        NSLog(@"%@", notification.name);
        
        // get the keybaord rect
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
        
        // determin the bottom inset for the table view
        UIEdgeInsets settingsTableInset = self.settingsTableView.contentInset;
        CGPoint tableViewScreenSpace = [self.settingsTableView.superview convertPoint:self.settingsTableView.frame.origin toView:nil];
        CGFloat tableViewBottomOffset = InAppSettingTableHeight-(tableViewScreenSpace.y+self.settingsTableView.frame.size.height);
        settingsTableInset.bottom = keyboardRect.size.height-tableViewBottomOffset;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:InAppSettingKeyboardAnimation];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = settingsTableInset;
        self.settingsTableView.scrollIndicatorInsets = settingsTableInset;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    if(!self.displayKeyboard){
        NSLog(@"%@", notification.name);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:InAppSettingKeyboardAnimation];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = UIEdgeInsetsZero;
        self.settingsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
}

#pragma mark Table view methods

- (InAppSetting *)settingAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.displayHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.settings objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(InAppSettingDisplayPowered && [self.file isEqualToString:InAppSettingRootFile] && section == (NSInteger)[self.headers count]-1){
        return InAppSettingPoweredBy;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSetting *setting = [self settingAtIndexPath:indexPath];
    
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
    InAppSetting *setting = [self settingAtIndexPath:indexPath];
    if([setting isType:@"PSMultiValueSpecifier"]){
        PSMultiValueSpecifierTable *multiValueSpecifier = [[PSMultiValueSpecifierTable alloc] initWithSetting:setting];
        [self.navigationController pushViewController:multiValueSpecifier animated:YES];
        [multiValueSpecifier release];
    }else if([setting isType:@"PSChildPaneSpecifier"]){
        InAppSettingsViewController *childPane = [[InAppSettingsViewController alloc] initWithFile:[setting valueForKey:@"File"]];
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
        return indexPath;
    }
    return nil;
}

@end

