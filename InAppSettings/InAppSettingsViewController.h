//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface InAppSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSString *file;
    UITableView *settingsTableView;
    UIControl *firstResponder;
    NSMutableArray *headers, *displayHeaders, *settings;
    BOOL keyboardShown;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, retain) UITableView *settingsTableView;
@property (nonatomic, assign) UIControl *firstResponder;
@property (nonatomic, retain) NSMutableArray *headers, *displayHeaders, *settings;
@property (nonatomic, assign) BOOL keyboardShown;

//keyboard notification
- (void)registerForKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;

@end
