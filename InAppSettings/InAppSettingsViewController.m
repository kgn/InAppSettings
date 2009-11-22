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

- (void)viewDidLoad{
    NSString *settingsBundlePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSString *settingsRootPlist = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:settingsRootPlist];
    
    //create an array for headers(PSGroupSpecifier) and a dictonary to hold arrays of settings
    headers = [[NSMutableArray alloc] init];
    displayHeaders = [[NSMutableArray alloc] init];
    settings = [[NSMutableDictionary alloc] init];
    
    //set the first value in the display header to "", while the read header is set to InAppSettingNullHeader
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
        if(![setting valueForKey:@"Type"]){
            addSetting = NO;
        }
        else if([[setting valueForKey:@"Type"] isEqualToString:@"PSGroupSpecifier"]){
            currentHeader = [setting valueForKey:@"Title"];
            [headers addObject:currentHeader];
            [displayHeaders addObject:currentHeader];
            [settings setObject:[[NSMutableArray alloc] init] forKey:currentHeader];//ignore this potential leak, this will be released with settings
            addSetting = NO;
        }
        else if([[setting valueForKey:@"Type"] isEqualToString:@"PSMultiValueSpecifier"]){
            NSArray *titles = [setting valueForKey:@"Titles"];
            NSArray *values = [setting valueForKey:@"Values"];
            //these conditions need to be true to display the PSMultiValueSpecifier
            if(([titles count] == 0) || ([values count] == 0) || ([titles count] != [values count])){
                addSetting = NO;
            }
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
    [settings release];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [displayHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *header = [headers objectAtIndex:section];
    return [[settings objectForKey:header] count];
}

- (InAppSetting *)settingAtIndexPath:(NSIndexPath *)indexPath {
    NSString *header = [headers objectAtIndex:indexPath.section];
    return [[settings objectForKey:header] objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InAppSetting *setting = [self settingAtIndexPath:indexPath];
    
    NSString *cellType = [NSString stringWithFormat:@"%@Cell", [setting valueForKey:@"Type"]];
    Class nsclass = NSClassFromString(cellType);
    if(!nsclass){
        cellType = @"InAppSettingsTableCell";
        nsclass = NSClassFromString(cellType);
    }
    
    cell = ((InAppSettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellType]);
    if (cell == nil) {
        cell = [[[nsclass alloc] initWithSetting:setting reuseIdentifier:cellType] autorelease];
        //set up the cell here to fix a display issue when the cell leaves and re-enters frame
        [cell setupCell];
    }
    
    [cell setValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSetting *setting = [self settingAtIndexPath:indexPath];
    if([[setting valueForKey:@"Type"] isEqualToString:@"PSMultiValueSpecifier"]){
        PSMultiValueSpecifierTable *multiValueSpecifier = [[PSMultiValueSpecifierTable alloc] initWithSetting:setting];
        [self.navigationController pushViewController:multiValueSpecifier animated:YES];
        [multiValueSpecifier release];
    }
}

@end

