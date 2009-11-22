//
//  InAppSettingsTableCell.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSetting.h"

@interface InAppSettingsTableCell : UITableViewCell {
    InAppSetting *setting;
}

@property (nonatomic, retain) InAppSetting *setting;

- (void)setTitle;
- (void)setDetail;
- (void)setTitle:(NSString *)title;
- (void)setDetail:(NSString *)detail;

- (id)getValue;
- (void)setValue;
- (void)setValue:(id)newValue;

- (void)setupCell;
- (id)initWithSetting:(InAppSetting *)inputSetting reuseIdentifier:(NSString *)reuseIdentifier;

@end
