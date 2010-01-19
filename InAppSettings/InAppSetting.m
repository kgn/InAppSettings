//
//  InAppSetting.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSetting.h"
#import "InAppSettingConstants.h"

@implementation InAppSetting

@synthesize stringsTable;

- (NSString *)getType{
    return [self valueForKey:@"Type"];
}

- (BOOL)isType:(NSString *)type{
    return [[self getType] isEqualToString:type];
}

- (id)valueForKey:(NSString *)key{
    return [settingDictionary objectForKey:key];
}

- (NSString *)localizedTitle{
    return InAppSettingsLocalize([self valueForKey:@"Title"], self.stringsTable);
}

- (NSString *)cellName{
    return [NSString stringWithFormat:@"%@Cell", [self getType]];
}

#pragma mark validation

- (BOOL)hasTitle{
    return ([self valueForKey:@"Title"]) ? YES:NO;
}

- (BOOL)hasKey{
    NSString *key = [self valueForKey:@"Key"];
    return (key && (![key isEqualToString:@""]));
}

- (BOOL)hasDefaultValue{
    return ([self valueForKey:@"DefaultValue"]) ? YES:NO;
}

#pragma mark init/dealloc

- (id)init{
    return [self initWithDictionary:nil andStringsTable:nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary andStringsTable:(NSString *)table{
    self = [super init];
    if (self != nil){
        if(dictionary){
            self.stringsTable = table;
            settingDictionary = [dictionary retain];
        }
    }
    return self;
}

- (void)dealloc{
    [stringsTable release];
    [settingDictionary release];
    [super dealloc];
}

@end
