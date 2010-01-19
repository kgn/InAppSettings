//
//  RootViewController.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import "RootViewController.h"
#import "InAppSettings.h"

@implementation RootViewController

//push InAppSettings onto the navigation stack
- (IBAction)showSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

//present InAppSettings as a modal view
- (IBAction)presentSettings{
    InAppSettingsNavagationController *settings = [[InAppSettingsNavagationController alloc] init];
    [self presentModalViewController:settings animated:YES];
    [settings release];
}

@end

