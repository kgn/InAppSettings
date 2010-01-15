//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface InAppSettingsViewController : UITableViewController {
    NSString *file;
    IBOutlet InAppSettingsTableCell *cell;
    NSMutableArray *headers, *displayHeaders, *settings;
}

@property (nonatomic, copy) NSString *file;

- (void)controlEditingDidBeginAction:(UIControl *)control;

@end
