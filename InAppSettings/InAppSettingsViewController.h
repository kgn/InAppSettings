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
    IBOutlet InAppSettingsTableCell *cell;
    NSMutableArray *headers, *displayHeaders;
    NSMutableDictionary *settings;
}

- (void)controlEditingDidBeginAction:(UIControl *)control;

@end
