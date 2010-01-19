//
//  PSToggleSwitchSpecifier.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsPSSliderSpecifierCell.h"
#import "InAppSettingsConstants.h"

@implementation InAppSettingsPSSliderSpecifierCell

@synthesize valueSlider;

- (void)slideAction{
    [self setValue:[NSNumber numberWithFloat:[self.valueSlider value]]];
}

- (void)setUIValues{
    [super setUIValues];

    //get the abolute path to the images
    NSString *minImagePath = [InAppSettingsBundlePath stringByAppendingPathComponent:[self.setting valueForKey:@"MinimumValueImage"]];
    NSString *maxImagePath = [InAppSettingsBundlePath stringByAppendingPathComponent:[self.setting valueForKey:@"MaximumValueImage"]];
    
    //setup the slider
    self.valueSlider.minimumValue = [[self.setting valueForKey:InAppSettingsSpecifierMinimumValue] floatValue];
    self.valueSlider.maximumValue = [[self.setting valueForKey:InAppSettingsSpecifierMaximumValue] floatValue];
    self.valueSlider.minimumValueImage = [UIImage imageWithContentsOfFile:minImagePath];
    self.valueSlider.maximumValueImage = [UIImage imageWithContentsOfFile:maxImagePath];
    CGRect valueSliderFrame = self.valueSlider.frame;
    valueSliderFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(valueSliderFrame.size.height*0.5f))-InAppSettingsOffsetY;
    valueSliderFrame.origin.x = InAppSettingsCellPadding;
    valueSliderFrame.size.width = InAppSettingsScreenWidth-(InAppSettingsCellPadding*4);
    self.valueSlider.frame = valueSliderFrame;
    
    self.valueSlider.value = [[self getValue] floatValue];
}

- (void)setupCell{
    [super setupCell];
    
    //create the slider
    self.valueSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.valueSlider addTarget:self action:@selector(slideAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.valueSlider];
}

- (void)dealloc{
    [valueSlider release];
    [super dealloc];
}

@end
