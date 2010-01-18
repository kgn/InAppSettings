//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface InAppSettingsViewController : UITableViewController <UITextFieldDelegate> {
    NSString *file;
    UIControl *firstResponder;
    NSMutableArray *headers, *displayHeaders, *settings;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, assign) UIControl *firstResponder;
@property (nonatomic, retain) NSMutableArray *headers, *displayHeaders, *settings;

@end
