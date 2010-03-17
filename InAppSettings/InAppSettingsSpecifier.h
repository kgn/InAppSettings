//
//  InAppSetting.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InAppSettingsSpecifierDelegate;

@interface InAppSettingsSpecifier : NSObject {
    NSString *stringsTable;
    NSDictionary *settingDictionary;
    id<InAppSettingsSpecifierDelegate> delegate;
}

@property (nonatomic, copy) NSString *stringsTable;
@property (assign) id<InAppSettingsSpecifierDelegate> delegate;

- (NSString *)getKey;
- (NSString *)getType;
- (BOOL)isType:(NSString *)type;
- (id)getValue;
- (void)setValue:(id)newValue;
- (id)valueForKey:(NSString *)key;
- (NSString *)localizedTitle;
- (NSString *)cellName;

- (BOOL)hasTitle;
- (BOOL)hasKey;
- (BOOL)hasDefaultValue;
- (BOOL)isValid;

- (id)initWithDictionary:(NSDictionary *)dictionary andStringsTable:(NSString *)table;

@end

@protocol InAppSettingsSpecifierDelegate <NSObject>

- (void)settingsSpecifierUpdated:(InAppSettingsSpecifier *)specifier;

@end
