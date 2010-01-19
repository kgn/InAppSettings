//
//  InAppSetting.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsSpecifier.h"
#import "InAppSettingsConstants.h"

@implementation InAppSettingsSpecifier

@synthesize stringsTable;

- (NSString *)getType{
    return [self valueForKey:InAppSettingsSpecifierType];
}

- (BOOL)isType:(NSString *)type{
    return [[self getType] isEqualToString:type];
}

- (id)valueForKey:(NSString *)key{
    return [settingDictionary objectForKey:key];
}

- (NSString *)localizedTitle{
    return InAppSettingsLocalize([self valueForKey:InAppSettingsSpecifierTitle], self.stringsTable);
}

- (NSString *)cellName{
    return [NSString stringWithFormat:@"%@%@Cell", InAppSettingsProjectName, [self getType]];
}

#pragma mark validation

- (BOOL)hasTitle{
    return ([self valueForKey:InAppSettingsSpecifierTitle]) ? YES:NO;
}

- (BOOL)hasKey{
    NSString *key = [self valueForKey:InAppSettingsSpecifierKey];
    return (key && (![key isEqualToString:@""]));
}

- (BOOL)hasDefaultValue{
    return ([self valueForKey:InAppSettingsSpecifierDefaultValue]) ? YES:NO;
}

- (BOOL)isValid{
    NSString *type = [self getType];
    if([type isEqualToString:InAppSettingsPSMultiValueSpecifier]){
        if(![self hasKey]){
            return NO;
        }
        
        if(![self hasDefaultValue]){
            return NO;
        }
        
        if(![self hasTitle] || [[self valueForKey:InAppSettingsSpecifierTitle] length] == 0){
            return NO;
        }
        
        NSArray *titles = [self valueForKey:InAppSettingsSpecifierTitles];
        if((!titles) || ([titles count] == 0)){
            return NO;
        }
        
        NSArray *values = [self valueForKey:InAppSettingsSpecifierValues];
        if((!values) || ([values count] == 0)){
            return NO;
        }
        
        if([titles count] != [values count]){
            return NO;
        }
    }
    
    else if([type isEqualToString:InAppSettingsPSSliderSpecifier]){
        if(![self hasKey]){
            return NO;
        }
        
        if(![self hasDefaultValue]){
            return NO;
        }
        
        NSNumber *minValue = [self valueForKey:InAppSettingsSpecifierMinimumValue];
        if(!minValue){
            return NO;
        }
        
        NSNumber *maxValue = [self valueForKey:InAppSettingsSpecifierMaximumValue];
        if(!maxValue){
            return NO;
        }
    }
    
    else if([type isEqualToString:InAppSettingsPSToggleSwitchSpecifier]){
        if(![self hasKey]){
            return NO;
        }
        
        if(![self hasDefaultValue]){
            return NO;
        }
        
        if(![self hasTitle]){
            return NO;
        }
    }
    
    else if([type isEqualToString:InAppSettingsPSTitleValueSpecifier]){
        if(![self hasKey]){
            return NO;
        }
        
        if(![self hasDefaultValue]){
            return NO;
        }
    }
    
    else if([type isEqualToString:InAppSettingsPSChildPaneSpecifier]){
        if(![self hasTitle]){
            return NO;
        }
        
        NSString *plistFile = [self valueForKey:InAppSettingsSpecifierFile];
        if(!plistFile){
            return NO;
        }
    }
    
    return YES;
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
