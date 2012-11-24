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

//this method is called by InAppSettingsNotification when a user default is changed by InAppSettings
- (void)InAppSettingsNotificationHandler:(NSNotification*)notification{
    //the object of an InAppSettingsNotification is the user defaults key
    NSString *userDefaultsKey = [notification object];
    id userDefaultObject = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsKey];
    
    NSLog(@"%@=%@", userDefaultsKey, userDefaultObject);
    
    if([userDefaultsKey isEqualToString:@"textEntry_NumbersAndPunctuation"]){
        self.userSettingsLabel1.text = [NSString stringWithFormat:@"%@", userDefaultObject];
    }else if([userDefaultsKey isEqualToString:@"textEntry_URL"]){
        self.userSettingsLabel2.text = [NSString stringWithFormat:@"%@", userDefaultObject];
    }else if([userDefaultsKey isEqualToString:@"toogle_string"]){
        self.userSettingsLabel3.text = [NSString stringWithFormat:@"%@", userDefaultObject];
    }else if([userDefaultsKey isEqualToString:@"slider_key"]){
        self.userSettingsLabel4.text = [NSString stringWithFormat:@"%@", userDefaultObject];
    }
}

- (void)awakeFromNib{    
    self.userSettingsLabel1.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"textEntry_NumbersAndPunctuation"]];
    self.userSettingsLabel2.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"textEntry_URL"]];
    self.userSettingsLabel3.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"toogle_string"]];
    self.userSettingsLabel4.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"slider_key"]];
    
    //setup InAppSettings notifications of then user defaults change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InAppSettingsNotificationHandler:) name:InAppSettingsNotification object:nil];
}

//push InAppSettings onto the navigation stack
- (IBAction)showSettings{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}

//present InAppSettings as a modal view
- (IBAction)presentSettings{
    InAppSettingsModalViewController *settings = [[InAppSettingsModalViewController alloc] init];
    [self presentViewController:settings animated:YES completion:nil];
}


@end

