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

//    The value associated with the preference when the toggle switch 
//    is in the ON position. The value type for this key can be any 
//    scalar type, including Boolean, String, Number, Date, or Data. 
//    If this key is not present, the default value type is a Boolean.

- (BOOL)getBool{
    id value = [self getValue];
    if([value isKindOfClass:[NSNumber class]]){
        //TODO: just cause its an NSNumber does not mean its a BOOL...
        return [[self getValue] boolValue];
    }
    if([value isEqual:[self.setting valueForKey:@"TrueValue"]]){
        return YES;
    }
    return NO;
}

- (void)setBool:(BOOL)newValue{
    id value = [NSNumber numberWithBool:newValue];
    if(newValue){
        id trueValue = [self.setting valueForKey:@"TrueValue"];
        if(trueValue){
            value = trueValue;
        }
    }
    else{
        id falseValue = [self.setting valueForKey:@"FalseValue"];
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
}

- (void)dealloc{
    [valueSwitch release];
    [super dealloc];
}

@end
