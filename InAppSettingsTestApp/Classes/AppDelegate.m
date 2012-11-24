//
//  InAppSettingsTestAppAppDelegate.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/24/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "InAppSettings.h"

@implementation AppDelegate

+ (void)initialize{
    if([self class] == [AppDelegate class]){
		[InAppSettings registerDefaults];
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application{
    [self.window addSubview:self.tabBarController.view];
}


@end

