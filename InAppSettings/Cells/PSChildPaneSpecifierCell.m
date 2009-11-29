//
//  PSToggleSwitchSpecifier.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "PSChildPaneSpecifierCell.h"
#import "InAppSettingConstants.h"

@implementation PSChildPaneSpecifierCell

- (void)setupCell{
    [super setupCell];
    
    [self setTitle];
    [self setDisclosure:YES];
}

@end
