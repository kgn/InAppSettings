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

- (id)init{
    return [self initWithTitle:NSLocalizedString(@"Settings", nil)];
}

- (BOOL)addSetting:(InAppSetting *)setting{
    NSString *type = [setting getType];
    
    NSString *key = [setting valueForKey:@"Key"];
    if((!key) || [key isEqualToString:@""]){
        return NO;
    }
    
    id defaultValue = [setting valueForKey:@"DefaultValue"];
    if(!defaultValue){
        return NO;
    }
    
    if([type isEqualToString:@"PSMultiValueSpecifier"]){
        NSString *title = [setting valueForKey:@"Title"];
        if(!title){
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
        NSString *title = [setting valueForKey:@"Title"];
        if(!title){
            return NO;
        }
    }
    
    return YES;
}

- (InAppSetting *)settingAtIndexPath:(NSIndexPath *)indexPath {
    NSString *header = [headers objectAtIndex:indexPath.section];
    return [[settings objectForKey:header] objectAtIndex:indexPath.row];
}

- (void)viewDidLoad{
    NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSString *settingsRootPlist = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:settingsRootPlist];
    
    //create an array for headers(PSGroupSpecifier) and a dictonary to hold arrays of settings
    headers = [[NSMutableArray alloc] init];
    displayHeaders = [[NSMutableArray alloc] init];
    settings = [[NSMutableDictionary alloc] init];
    
    //set the first value in the display header to "", while the real header is set to InAppSettingNullHeader
    //this way whats set in the first entry to headers will not be seen
    NSString *currentHeader = InAppSettingNullHeader;
    [headers addObject:currentHeader];
    [displayHeaders addObject:@""];
    [settings setObject:[[NSMutableArray alloc] init] forKey:currentHeader];//ignore this potential leak, this will be released with settings
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for(NSDictionary *eachSetting in [settingsDictionary objectForKey:@"PreferenceSpecifiers"]){
        BOOL addSetting = YES;
        InAppSetting *setting = [[InAppSetting alloc] initWithDictionary:eachSetting];
        
        //type is required
        if(![setting getType]){
            addSetting = NO;
        }
        else if([setting isType:@"PSGroupSpecifier"]){
            currentHeader = [setting valueForKey:@"Title"];
            [headers addObject:currentHeader];
            [displayHeaders addObject:currentHeader];
            [settings setObject:[[NSMutableArray alloc] init] forKey:currentHeader];//ignore this potential leak, this will be released with settings
            addSetting = NO;
        }
        else{
            addSetting = [self addSetting:setting];
        }
        
        if(addSetting){
            NSMutableArray *currentArray = [settings objectForKey:currentHeader];
            [currentArray addObject:setting];
        }
        [setting release];
    }
    [pool drain];
    [settingsDictionary release];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)dealloc{
    [headers release];
    [displayHeaders release];
    [settings release];
    [super dealloc];
}

#pragma mark Table view methods

- (void)controlEditingDidBeginAction:(UIControl *)control{
    //scroll the table view to the cell that is being edited
    //TODO: the cell does not animate to the middle of the table view when the keyboard is becoming active
    //TODO: find a better way to get the cell, what if the nesting changes?
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[[control superview] superview]];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [displayHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *header = [headers objectAtIndex:section];
    return [[settings objectForKey:header] count];
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
    
    cell = ((InAppSettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellType]);
    if (cell == nil){
        cell = [[[nsclass alloc] initWithSetting:setting reuseIdentifier:cellType] autorelease];
        //setup the cells controlls
        [cell setupCell];
        
        //if the cell is a PSTextFieldSpecifier setup an action to center the table view on the cell
        if([setting isType:@"PSTextFieldSpecifier"]){
            [[cell getValueInput] addTarget:self 
                                     action:@selector(controlEditingDidBeginAction:) 
                           forControlEvents:UIControlEventEditingDidBegin];
        }
    }
    
    //set the values of the cell, this is separated from setupCell for reloading the table
    [cell setValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSetting *setting = [self settingAtIndexPath:indexPath];
    if([setting isType:@"PSMultiValueSpecifier"]){
        PSMultiValueSpecifierTable *multiValueSpecifier = [[PSMultiValueSpecifierTable alloc] initWithSetting:setting];
        [self.navigationController pushViewController:multiValueSpecifier animated:YES];
        [multiValueSpecifier release];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSetting *setting = [self settingAtIndexPath:indexPath];
    if([setting isType:@"PSMultiValueSpecifier"]){
        return indexPath;
    }
    return nil;
}

@end

