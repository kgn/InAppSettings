//
//  InAppSettingsTableCell.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsSpecifier.h"

@interface InAppSettingsTableCell : UITableViewCell

@property (nonatomic, strong) InAppSettingsSpecifier *setting;
@property (nonatomic, strong) UILabel *titleLabel, *valueLabel;
@property (nonatomic, weak) UIControl *valueInput;
@property (nonatomic) BOOL canSelectCell;

- (void)setTitle;
- (void)setDetail;
- (void)setDetail:(NSString *)detail;
- (void)setDisclosure:(BOOL)disclosure;

- (void)setValueDelegate:(id)delegate;

- (void)setupCell;
- (void)setUIValues;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
