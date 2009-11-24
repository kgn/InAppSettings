//
//  InAppSettingsTestAppAppDelegate.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/24/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import "InAppSettingsTestAppAppDelegate.h"


@implementation InAppSettingsTestAppAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [window addSubview:tabBarController.view];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

