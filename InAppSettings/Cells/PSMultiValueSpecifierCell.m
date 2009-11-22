//
//  PSToggleSwitchSpecifier.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "PSMultiValueSpecifierCell.h"
#import "InAppSettingConstants.h"

@implementation PSMultiValueSpecifierCell

- (NSString *)getValueTitle{
    NSArray *titles = [self.setting valueForKey:@"Titles"];
    NSArray *values = [self.setting valueForKey:@"Values"];
    NSInteger valueIndex = [values indexOfObject:[self getValue]];
    return [titles objectAtIndex:valueIndex];
}

- (void)setValue{
    [super setValue];
    
    [self setDetail:[self getValueTitle]];
}

- (void)setupCell{
    [super setupCell];
    
    [self setTitle];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
