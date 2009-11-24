//
//  PSMultiValueSpecifierTable.m
//  InAppSettings
//
//  Created by David Keegan on 11/3/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "PSMultiValueSpecifierTable.h"
#import "InAppSettingConstants.h"

@implementation PSMultiValueSpecifierTable

@synthesize setting;

- (id)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithSetting:(InAppSetting *)inputSetting{
    self = [super init];
    if (self != nil){
        self.setting = inputSetting;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = NSLocalizedString([self.setting valueForKey:@"Title"], nil);
}

- (void)dealloc{
    [setting release];
    [super dealloc];
}

#pragma mark Value

- (NSString *)getValue{
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:[self.setting valueForKey:@"Key"]];
    if(value == nil){
        value = [self.setting valueForKey:@"DefaultValue"];
    }
    return value;
}

- (void)setValue:(NSString *)newValue{
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:[self.setting valueForKey:@"Key"]];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.setting valueForKey:@"Values"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PSMultiValueSpecifierTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    NSString *cellTitle = NSLocalizedString([[self.setting valueForKey:@"Titles"] objectAtIndex:indexPath.row], nil);
    NSString *cellValue = [[self.setting valueForKey:@"Values"] objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTitle;
	if([cellValue isEqualToString:[self getValue]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = InAppSettingBlue;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellValue = [[self.setting valueForKey:@"Values"] objectAtIndex:indexPath.row];
    [self setValue:cellValue];
    //TODO: make this behave like the settings, animate selection
    [self.tableView reloadData];
}

@end

