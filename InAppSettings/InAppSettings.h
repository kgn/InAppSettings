//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface InAppSettingsModalViewController : UIViewController {}

@end

@interface InAppSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSString *file;
    UITableView *settingsTableView;
    NSMutableArray *headers, *displayHeaders, *settings;
    BOOL displayKeyboard;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, retain) UITableView *settingsTableView;
@property (nonatomic, retain) NSMutableArray *headers, *displayHeaders, *settings;
@property (nonatomic, assign) BOOL displayKeyboard;

// modal view
- (void)dismissModalView;
- (void)addDoneButton;

//keyboard notification
- (void)registerForKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

@end
