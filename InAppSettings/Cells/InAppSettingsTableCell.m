//
//  InAppSettingsTableCell.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsTableCell.h"
#import "InAppSettingConstants.h"

@implementation InAppSettingsTableCell

@synthesize setting;

#pragma mark Cell lables

- (void)setTitle{
    [self setTitle:[self.setting valueForKey:@"Title"]];
}

- (void)setDetail{
    [self setDetail:[self getValue]];
}

- (void)setTitle:(NSString *)title{
    titleLabel.text = NSLocalizedString(title, nil);
    
    CGFloat maxTitleWidth = InAppSettingTableWidth-(InAppSettingCellPadding*4);
    CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font];
    if(titleSize.width > maxTitleWidth){
        titleSize.width = maxTitleWidth;
    }
    CGRect titleFrame = titleLabel.frame;
    titleFrame.size = titleSize;
    titleFrame.origin.x = InAppSettingCellPadding;
    titleFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(titleSize.height*0.5f))-InAppSettingOffsetY;
    titleLabel.frame = titleFrame;
}

- (void)setDetail:(NSString *)detail{
    valueLabel.text = NSLocalizedString(detail, nil);

    NSUInteger disclosure = 0;
    if(self.accessoryType == UITableViewCellAccessoryDisclosureIndicator){
        disclosure = 2;
    }
    CGFloat maxValueWidth = (InAppSettingTableWidth-(InAppSettingCellPadding*(4+disclosure)))-(titleLabel.frame.size.width+InAppSettingCellPadding);
    CGSize valueSize = [valueLabel.text sizeWithFont:valueLabel.font];
    if(valueSize.width > maxValueWidth){
        valueSize.width = maxValueWidth;
    }
    CGRect valueFrame = valueLabel.frame;
    valueFrame.size = valueSize;
    valueFrame.origin.x = (CGFloat)round((InAppSettingTableWidth-(InAppSettingCellPadding*(3+disclosure)))-valueFrame.size.width);
    valueFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(valueSize.height*0.5f))-InAppSettingOffsetY;
    valueLabel.frame = valueFrame;
}

- (void)setDisclosure:(BOOL)disclosure{
    if(disclosure){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark Value

- (id)getValue{
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:[self.setting valueForKey:@"Key"]];
    if(value == nil){
        value = [self.setting valueForKey:@"DefaultValue"];
    }
    return value;
}

- (void)setValue{
    //implement this per cell type
}

- (UIControl *)getValueInput{
    return nil;
}

- (void)setValue:(id)newValue{
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:[self.setting valueForKey:@"Key"]];
}

#pragma mark -

- (id)initWithSetting:(InAppSetting *)inputSetting reuseIdentifier:(NSString *)reuseIdentifier{
    //the docs say UITableViewCellStyleValue1 is used for settings, 
    //but it doesn't look 100% the same so we will just draw our own UILabels
    #if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_2_2
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    #else
    self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier];
    #endif

    if (self != nil){
        self.setting = inputSetting;
    }
    return self;
}

- (void)setupCell{
    //setup title label
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = InAppSettingBoldFont;
    titleLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:titleLabel];
    
    //setup value label
    valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLabel.font = InAppSettingNormalFont;
    valueLabel.textColor = InAppSettingBlue;
    valueLabel.highlightedTextColor = [UIColor whiteColor];
    [self.contentView addSubview:valueLabel];
}

- (void)dealloc{
    [setting release];
    [super dealloc];
}

@end
