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

@synthesize userSettingsLabel1;
@synthesize userSettingsLabel2;
@synthesize userSettingsLabel3;
@synthesize userSettingsLabel4;
@synthesize userSettingsLabel5;

//code for testing [InAppSettings registerDefaults];
- (void)viewWillAppear:(BOOL)animated{
    self.userSettingsLabel1.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"textEntry_EmailAddress"]];
    self.userSettingsLabel2.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"colors_keyC"]];
    self.userSettingsLabel3.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"slider_key"]];
    self.userSettingsLabel4.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"textEntry_NumbersAndPunctuation"]];
    self.userSettingsLabel5.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"toogle_notrue"]];
    [super viewWillAppear:animated];
}

//push InAppSettings onto the navigation stack
- (IBAction)showSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

//present InAppSettings as a modal view
- (IBAction)presentSettings{
    InAppSettingsModalViewController *settings = [[InAppSettingsModalViewController alloc] init];
    [self presentModalViewController:settings animated:YES];
    [settings release];
}

- (void)dealloc{
    [userSettingsLabel1 release];
    [userSettingsLabel2 release];
    [userSettingsLabel3 release];
    [userSettingsLabel4 release];
    [userSettingsLabel5 release];
    [super dealloc];
}

@end

