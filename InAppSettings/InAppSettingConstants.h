//
//  InAppSettingConstants.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#define InAppSettingRootFile @"Root"
#define InAppSettingNullHeader @"InAppSettingNullHeader"
#define InAppSettingCellPadding 10.0f
#define InAppSettingCellTextFieldMinX 115.0f
#define InAppSettingKeyboardAnimation 0.3f
#define InAppSettingScreenBounds [[UIScreen mainScreen] bounds]
#define InAppSettingTableWidth [[UIScreen mainScreen] bounds].size.width
#define InAppSettingTableHeight [[UIScreen mainScreen] bounds].size.height
#define InAppSettingOffsetY 1.0f
#define InAppSettingBlue [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
#define InAppSettingFontSize 17.0f
#define InAppSettingBoldFont [UIFont boldSystemFontOfSize:InAppSettingFontSize]
#define InAppSettingNormalFont [UIFont systemFontOfSize:InAppSettingFontSize]

#define InAppSettingBundlePath [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"]
#define InAppSettingLocalize(stringKey, tableKey) \
[[NSBundle bundleWithPath:InAppSettingBundlePath] localizedStringForKey:stringKey value:stringKey table:tableKey]

// test what cell init code should be used
#define InAppSettingUseNewCells __IPHONE_3_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0

// if you dont want to display the 'Powered by' footer set this to NO
#define InAppSettingDisplayPowered YES 
#define InAppSettingPoweredBy @"Powered by InAppSettings"
