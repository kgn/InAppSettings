//
//  InAppSettingsViewController.m
//  InAppSettings
//
//  Created by DavNSString *Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsViewController.h"
#import "InAppSetting.h"
#import "InAppSettingConstants.h"
#import "PSMultiValueSpecifierTable.h"

@implementation InAppSettingsViewController

@synthesize file;
@synthesize firstResponder;
@synthesize headers, displayHeaders, settings;

#pragma mark validate plist data

- (BOOL)addSetting:(InAppSetting *)setting{
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

- (id)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithFile:(NSString *)inputFile{
    self = [super init];
    if (self != nil){
        self.file = inputFile;
    }
    return self;
}

- (void)viewDidLoad{
    //if the table is not group styled make a new one that is
    if(self.tableView.style != UITableViewStyleGrouped){
        CGRect tableViewFrame = self.tableView.frame;
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    }
    
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
        BOOL addSetting = YES;
        InAppSetting *setting = [[InAppSetting alloc] initWithDictionary:eachSetting andStringsTable:stringsTable];
        
        //type is required
        if(![setting getType]){
            addSetting = NO;
        }else if([setting isType:@"PSGroupSpecifier"]){
            currentHeader = [setting localizedTitle];
            [self.headers addObject:currentHeader];
            [self.displayHeaders addObject:currentHeader];
            [self.settings addObject:[NSMutableArray array]];
            addSetting = NO;
        }else{
            addSetting = [self addSetting:setting];
        }
        
        if(addSetting){
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
}

- (void)viewWillAppear:(BOOL)animated {
    //TODO: fix the table positioning from the keyboad #10
    //this code does not work, but it looks like its on the right track
//    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.firstResponder resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [file release];
    [headers release];
    [displayHeaders release];
    [settings release];
    self.firstResponder = nil;
    [super dealloc];
}

#pragma mark text field cell delegate

- (void)textFieldDidBeginEditing:(UITextField *)cellTextField{
    //TODO: find a better way to get the cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[cellTextField superview] superview]];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    self.firstResponder = cellTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)cellTextField{
    [cellTextField resignFirstResponder];
    self.firstResponder = nil;
    return YES;
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
    InAppSettingsTableCell *cell = ((InAppSettingsTableCell *)[self.tableView cellForRowAtIndexPath:indexPath]);
    if([cell.setting isType:@"PSTextFieldSpecifier"]){
        [cell.valueInput becomeFirstResponder];
    }else if(cell.canSelectCell){
        return indexPath;
    }
    return nil;
}

@end

