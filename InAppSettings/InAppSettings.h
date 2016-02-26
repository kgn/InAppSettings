//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"
#import "InAppSettingsReader.h"
#import "InAppSettingsSpecifier.h"
#import "InAppSettingsConstants.h"

extern NSString *const InAppSettingsViewControllerDelegateWillDismissedNotification;
extern NSString *const InAppSettingsViewControllerDelegateDidDismissedNotification;
extern NSString *const InAppSettingsValueChangeNotification;
extern NSString *const InAppSettingsTapNotification;

@interface InAppSettings : NSObject

+ (void)registerDefaults;

@end

@interface InAppSettingsModalViewController : UINavigationController

@end

@interface InAppSettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSString *file;
@property (nonatomic, weak) UIControl *firstResponder;
@property (nonatomic, strong) InAppSettingsReader *settingsReader;

// modal view
- (IBAction)dismissModalView:(id)sender;
- (void)addDoneButton;

@end
