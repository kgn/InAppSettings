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

@protocol InAppSettingsDelegate;

@interface InAppSettings : NSObject {}

+ (void)registerDefaults;

@end

@interface InAppSettingsModalViewController : UIViewController {}

@end

@interface InAppSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, InAppSettingsSpecifierDelegate> {
    NSString *file;
    UITableView *settingsTableView;
    UIControl *firstResponder;
    InAppSettingsReader *settingsReader;
    id<InAppSettingsDelegate> delegate;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, retain) UITableView *settingsTableView;
@property (nonatomic, assign) UIControl *firstResponder;
@property (nonatomic, retain) InAppSettingsReader *settingsReader;
@property (assign) id<InAppSettingsDelegate> delegate;

// modal view
- (void)dismissModalView;
- (void)addDoneButton;

//keyboard notification
- (void)registerForKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

@end

@interface InAppSettingsLightningBolt : UIView {
    BOOL flip;
}

@property (nonatomic, assign) BOOL flip;

@end

@protocol InAppSettingsDelegate <NSObject>

@optional
- (void)InAppSettingsValue:(id)value forKey:(NSString *)key;

@end
