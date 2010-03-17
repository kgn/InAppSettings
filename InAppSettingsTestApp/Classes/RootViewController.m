//
//  RootViewController.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize userSettingsLabel1;
@synthesize userSettingsLabel2;
@synthesize userSettingsLabel3;
@synthesize userSettingsLabel4;

//code for testing [InAppSettings registerDefaults];
- (void)viewWillAppear:(BOOL)animated{
    self.userSettingsLabel1.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"textSize"]];
    self.userSettingsLabel2.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"autoCorrectText"]];
    self.userSettingsLabel3.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUsername"]];
    self.userSettingsLabel4.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"]];
    [super viewWillAppear:animated];
}

//push InAppSettings onto the navigation stack
- (IBAction)showSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    settings.delegate = self;
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

//present InAppSettings as a modal view
- (IBAction)presentSettings{
    InAppSettingsModalViewController *settings = [[InAppSettingsModalViewController alloc] init];
    [self presentModalViewController:settings animated:YES];
    [settings release];
}

//implement the InAppSettingsDelegate method for when user default values change
- (void)InAppSettingsValue:(id)value forKey:(NSString *)key{
    NSLog(@"%@ - %@", key, value);
}

- (void)dealloc{
    [userSettingsLabel1 release];
    [userSettingsLabel2 release];
    [userSettingsLabel3 release];
    [userSettingsLabel4 release];
    [super dealloc];
}

@end

