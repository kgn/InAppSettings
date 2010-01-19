//
//  InAppSettingsConstants.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#define InAppSettingsRootFile @"Root"
#define InAppSettingsNullHeader @"InAppSettingsNullHeader"
#define InAppSettingsCellPadding 10.0f
#define InAppSettingsCellTextFieldMinX 115.0f
#define InAppSettingsKeyboardAnimation 0.3f
#define InAppSettingsScreenBounds [[UIScreen mainScreen] bounds]
#define InAppSettingsScreenWidth InAppSettingsScreenBounds.size.width
#define InAppSettingsScreenHeight InAppSettingsScreenBounds.size.height
#define InAppSettingsOffsetY 1.0f
#define InAppSettingsBlue [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
#define InAppSettingsFontSize 17.0f
#define InAppSettingsBoldFont [UIFont boldSystemFontOfSize:InAppSettingsFontSize]
#define InAppSettingsNormalFont [UIFont systemFontOfSize:InAppSettingsFontSize]

#define InAppSettingsBundlePath [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"]
#define InAppSettingsLocalize(stringKey, tableKey) \
    [[NSBundle bundleWithPath:InAppSettingsBundlePath] localizedStringForKey:stringKey value:stringKey table:tableKey]

// settings strings
#define InAppSettingsStringsTable @"StringsTable"
#define InAppSettingsPreferenceSpecifiers @"PreferenceSpecifiers"

#define InAppSettingsPSGroupSpecifier @"PSGroupSpecifier"
#define InAppSettingsPSSliderSpecifier @"PSSliderSpecifier"
#define InAppSettingsPSChildPaneSpecifier @"PSChildPaneSpecifier"
#define InAppSettingsPSTitleValueSpecifier @"PSTitleValueSpecifier"
#define InAppSettingsPSMultiValueSpecifier @"PSMultiValueSpecifier"
#define InAppSettingsPSToggleSwitchSpecifier @"PSToggleSwitchSpecifier"

#define InAppSettingsSpecifierKey @"Key"
#define InAppSettingsSpecifierType @"Type"
#define InAppSettingsSpecifierFile @"File"
#define InAppSettingsSpecifierTitle @"Title"
#define InAppSettingsSpecifierTitles @"Titles"
#define InAppSettingsSpecifierValues @"Values"
#define InAppSettingsSpecifierDefaultValue @"DefaultValue"
#define InAppSettingsSpecifierMinimumValue @"MinimumValue"
#define InAppSettingsSpecifierMaximumValue @"MaximumValue"

// test what cell init code should be used
#define InAppSettingsUseNewCells __IPHONE_3_0 && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0

// if you dont want to display the 'Powered by' footer set this to NO
#define InAppSettingsDisplayPowered YES 

// please don't change this value
#define InAppSettingsPoweredBy @"Powered by InAppSettings"
