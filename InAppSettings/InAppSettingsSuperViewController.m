//
//  InAppSettingsSuperViewController.m
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsSuperViewController.h"

@implementation InAppSettingsSuperViewController

- (id)initWithTitle:(NSString *)viewTitle{
    self = [super init];
    if (self != nil) {
        self.title = viewTitle;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}

@end

