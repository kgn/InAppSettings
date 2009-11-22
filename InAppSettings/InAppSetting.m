//
//  InAppSetting.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSetting.h"

@implementation InAppSetting

- (id)valueForKey:(NSString *)key{
    return [settingDictionary objectForKey:key];
}

#pragma mark init/dealloc

- (id)init{
    return [self initWithDictionary:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self != nil) {
        if(dictionary){
            settingDictionary = [dictionary retain];
        }
    }
    return self;
}

- (void)dealloc{
    [settingDictionary release];
    [super dealloc];
}

@end
