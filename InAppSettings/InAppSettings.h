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

#define InAppSettingsNotification InAppSettingsNotificationName

@interface InAppSettings : NSObject

+ (void)registerDefaults;

@end

@interface InAppSettingsModalViewController : UIViewController

@end

@interface InAppSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSString *file;
@property (nonatomic, strong) UITableView *settingsTableView;
@property (nonatomic, weak) UIControl *firstResponder;
@property (nonatomic, strong) InAppSettingsReader *settingsReader;

// modal view
- (void)dismissModalView;
- (void)addDoneButton;

//keyboard notification
- (void)registerForKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

@end

@interface InAppSettingsLightningBolt : UIView

@property (nonatomic, assign) BOOL flip;

@end
