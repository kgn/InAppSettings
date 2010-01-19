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

//load the InAppSettings with the settings button is pressed
- (IBAction)showSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

//load the InAppSettings with the settings button is pressed
- (void)dismissSettings:(id)sender{
    // the done button from addDoneButtonWithTarget is a custom UIBarButtonItem
    // this custom button stores its parents navigation controller
    [[sender parentNavigationController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)presentSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    
    // add InAppSettingsViewController to the navigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settings];
    // use the helper method on InAppSettingsViewController to add a done button
    [settings addDoneButtonWithTarget:self action:@selector(dismissSettings:)];
    [settings release];
    
    [self presentModalViewController:navController animated:YES];
    [navController release];
}

@end

