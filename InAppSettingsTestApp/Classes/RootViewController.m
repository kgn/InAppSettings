//
//  RootViewController.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import "RootViewController.h"
#import "InAppSettingsViewController.h"

@implementation RootViewController

- (IBAction)showSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.

    return cell;
}

- (void)dealloc {
    [super dealloc];
}

@end

