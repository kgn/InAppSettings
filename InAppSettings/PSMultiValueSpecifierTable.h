//
//  PSMultiValueSpecifierTable.h
//  InAppSettings
//
//  Created by David Keegan on 11/3/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSetting.h"

@interface PSMultiValueSpecifierTable : UITableViewController {
    InAppSetting *setting;
}

@property (nonatomic, retain) InAppSetting *setting;

- (id)initWithSetting:(InAppSetting *)inputSetting;
- (NSString *)getValue;
- (void)setValue:(NSString *)newValue;

@end
