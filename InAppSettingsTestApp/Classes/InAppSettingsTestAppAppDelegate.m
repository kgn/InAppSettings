//
//  InAppSettingsTestAppAppDelegate.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import "InAppSettingsTestAppAppDelegate.h"
#import "RootViewController.h"


@implementation InAppSettingsTestAppAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

