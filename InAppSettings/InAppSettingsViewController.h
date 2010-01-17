//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface InAppSettingsViewController : UITableViewController <InAppSettingsTableCellDelegate> {
    NSString *file;
    NSMutableArray *headers, *displayHeaders, *settings;
}

@property (nonatomic, copy) NSString *file;

@end
