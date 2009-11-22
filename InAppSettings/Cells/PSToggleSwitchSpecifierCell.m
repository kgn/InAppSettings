//
//  PSToggleSwitchSpecifier.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "PSToggleSwitchSpecifierCell.h"
#import "InAppSettingConstants.h"

@implementation PSToggleSwitchSpecifierCell

- (BOOL)getBool{
    id value = [self getValue];
    //the value of PSToggleSwitchSpecifier can be a string or a bool
    if([value isKindOfClass:[NSString class]]){
        if([value isEqualToString:[self.setting valueForKey:@"TrueValue"]]){
            return YES;
        }
        return NO;
    }
    
    return [[self getValue] boolValue];
}

- (void)setBool:(BOOL)newValue{
    //if there is a true or flase value the user default will be a string
    //if not it will be a bool
    id value = [NSNumber numberWithBool:newValue];
    if(newValue){
        NSString *trueValue = [self.setting valueForKey:@"TrueValue"];
        if(trueValue){
            value = trueValue;
        }
    }
    else{
        NSString *falseValue = [self.setting valueForKey:@"FalseValue"];
        if(falseValue){
            value = falseValue;
        }
    }
    [self setValue:value];
}

- (void)switchAction{
    [self setBool:[valueSwitch isOn]];
}

- (void)setValue{
    [super setValue];
    
    valueSwitch.on = [self getBool];
}

- (void)setupCell{
    [super setupCell];
    
    [self setTitle];
    
    //create the switch
    valueSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    CGRect valueSwitchFrame = valueSwitch.frame;
    valueSwitchFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(valueSwitchFrame.size.height*0.5f));
    valueSwitchFrame.origin.x = (CGFloat)round((self.contentView.frame.size.width-(InAppSettingCellPadding*3))-valueSwitchFrame.size.width);
    valueSwitch.frame = valueSwitchFrame;
    [valueSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:valueSwitch];
    [valueSwitch release];
}

- (void)dealloc{
    [valueSwitch release];
    [super dealloc];
}

@end
