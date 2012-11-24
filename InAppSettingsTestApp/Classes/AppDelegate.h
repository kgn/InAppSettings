//
//  InAppSettingsTestAppAppDelegate.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/24/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;

@end
