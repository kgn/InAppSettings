//
//  InAppSetting.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppSetting : NSObject {
    NSDictionary *settingDictionary;
}

- (id)valueForKey:(NSString *)key;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
