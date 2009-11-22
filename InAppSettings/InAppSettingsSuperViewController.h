//
//  InAppSettingsSuperViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface InAppSettingsSuperViewController : UITableViewController {
    IBOutlet InAppSettingsTableCell *cell; 
}

- (id)initWithTitle:(NSString *)viewTitle;

@end
