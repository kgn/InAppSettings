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
@synthesize titleLabel, valueLabel;
@synthesize valueInput;
@synthesize delegate;

#pragma mark Cell lables

- (void)setTitle{
    [self setTitle:[self.setting valueForKey:@"Title"]];
}

- (void)setDetail{
    [self setDetail:[self getValue]];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = InAppSettingLocalize(title, self.setting.stringsTable);
    
    CGFloat maxTitleWidth = InAppSettingTableWidth-(InAppSettingCellPadding*4);
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    if(titleSize.width > maxTitleWidth){
        titleSize.width = maxTitleWidth;
    }
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size = titleSize;
    titleFrame.origin.x = InAppSettingCellPadding;
    titleFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(titleSize.height*0.5f))-InAppSettingOffsetY;
    self.titleLabel.frame = titleFrame;
}

- (void)setDetail:(NSString *)detail{
    //the detail is not localized
    self.valueLabel.text = detail;

    NSUInteger disclosure = 0;
    if(self.accessoryType == UITableViewCellAccessoryDisclosureIndicator){
        disclosure = 2;
    }
    CGFloat maxValueWidth = (InAppSettingTableWidth-(InAppSettingCellPadding*(4+disclosure)))-(self.titleLabel.frame.size.width+InAppSettingCellPadding);
    CGSize valueSize = [self.valueLabel.text sizeWithFont:self.valueLabel.font];
    if(valueSize.width > maxValueWidth){
        valueSize.width = maxValueWidth;
    }
    CGRect valueFrame = self.valueLabel.frame;
    valueFrame.size = valueSize;
    if([self.setting isType:@"PSMultiValueSpecifier"] && [[self.setting localizedTitle] length] == 0){
        valueFrame.origin.x = InAppSettingCellPadding;
    }else{
        valueFrame.origin.x = (CGFloat)round((InAppSettingTableWidth-(InAppSettingCellPadding*(3+disclosure)))-valueFrame.size.width);
    }
    valueFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(valueSize.height*0.5f))-InAppSettingOffsetY;
    self.valueLabel.frame = valueFrame;
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

- (void)setValue:(id)newValue{
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:[self.setting valueForKey:@"Key"]];
}

#pragma mark -

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    //the docs say UITableViewCellStyleValue1 is used for settings, 
    //but it doesn't look 100% the same so we will just draw our own UILabels
    #if InAppSettingUseNewCells
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    #else
    self = [super initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier];
    #endif
    
    return self;
}

#pragma mark implement in cell

- (void)setUIValues{
    //implement this per cell type
}

- (void)setupCell{
    //setup title label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = InAppSettingBoldFont;
    self.titleLabel.highlightedTextColor = [UIColor whiteColor];
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.titleLabel];
    
    //setup value label
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.valueLabel.font = InAppSettingNormalFont;
    self.valueLabel.textColor = InAppSettingBlue;
    self.valueLabel.highlightedTextColor = [UIColor whiteColor];
//    self.valueLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.valueLabel];
}

- (void)dealloc{
    [setting release];
    [titleLabel release];
    [valueLabel release];
    self.delegate = nil;
    self.valueInput = nil;
    [super dealloc];
}

@end
