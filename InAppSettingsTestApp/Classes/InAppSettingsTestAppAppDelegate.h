//
//  InAppSettingsTestAppAppDelegate.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

@interface InAppSettingsTestAppAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

