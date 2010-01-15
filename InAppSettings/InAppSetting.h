//
//  InAppSetting.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppSetting : NSObject {
    NSString *stringsTable;
    NSDictionary *settingDictionary;
}

@property (nonatomic, copy) NSString *stringsTable;

- (NSString *)getType;
- (BOOL)isType:(NSString *)type;
- (id)valueForKey:(NSString *)key;
- (NSString *)localizedTitle;
- (NSString *)cellName;

- (BOOL)hasTitle;
- (BOOL)hasKey;
- (BOOL)hasDefaultValue;

- (id)initWithDictionary:(NSDictionary *)dictionary andStringsTable:(NSString *)table;

@end
