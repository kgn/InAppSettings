//
//  InAppSettingsConstants.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <Availability.h>

#define InAppSettingsRootFile @"Root"
#define InAppSettingsProjectName @"InAppSettings"

#define InAppSettingsFontSize 17.0f
#define InAppSettingsCellPadding 9.0f
#define InAppSettingsTablePadding 10.0f
#define InAppSettingsCellTextFieldMinX 115.0f
#define InAppSettingsCellToggleSwitchWidth 94.0f
#define InAppSettingsTotalCellPadding InAppSettingsCellPadding*2
#define InAppSettingsTotalTablePadding InAppSettingsTablePadding*2
#define InAppSettingsCellTitleMaxWidth CGRectGetWidth(self.bounds)-(InAppSettingsTotalTablePadding+InAppSettingsTotalCellPadding)
#define InAppSettingsBoldFont [UIFont boldSystemFontOfSize:InAppSettingsFontSize]
#define InAppSettingsNormalFont [UIFont systemFontOfSize:InAppSettingsFontSize]
#define InAppSettingsBlue [UIColor grayColor];

#define InAppSettingsBundlePath [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"]
#define InAppSettingsFullPlistPath(file) \
    [InAppSettingsBundlePath stringByAppendingPathComponent:[file stringByAppendingPathExtension:@"plist"]]
#define InAppSettingsLocalize(stringKey, tableKey) \
    [[NSBundle bundleWithPath:InAppSettingsBundlePath] localizedStringForKey:stringKey value:stringKey table:tableKey]

// settings strings
#define InAppSettingsStringsTable @"StringsTable"
#define InAppSettingsPreferenceSpecifiers @"PreferenceSpecifiers"

#define InAppSettingsPSGroupSpecifier @"PSGroupSpecifier"
#define InAppSettingsPSSliderSpecifier @"PSSliderSpecifier"
#define InAppSettingsPSChildPaneSpecifier @"PSChildPaneSpecifier"
#define InAppSettingsPSTextFieldSpecifier @"PSTextFieldSpecifier"
#define InAppSettingsPSTitleValueSpecifier @"PSTitleValueSpecifier"
#define InAppSettingsPSMultiValueSpecifier @"PSMultiValueSpecifier"
#define InAppSettingsPSToggleSwitchSpecifier @"PSToggleSwitchSpecifier"

#define InAppSettingsSpecifierKey @"Key"
#define InAppSettingsSpecifierType @"Type"
#define InAppSettingsSpecifierFile @"File"
#define InAppSettingsSpecifierTitle @"Title"
#define InAppSettingsSpecifierFooterText @"FooterText"
#define InAppSettingsSpecifierTitles @"Titles"
#define InAppSettingsSpecifierValues @"Values"
#define InAppSettingsSpecifierDefaultValue @"DefaultValue"
#define InAppSettingsSpecifierMinimumValue @"MinimumValue"
#define InAppSettingsSpecifierMaximumValue @"MaximumValue"
#define InAppSettingsSpecifierInAppURL @"InAppURL"
#define InAppSettingsSpecifierInAppTwitter @"InAppTwitter"
#define InAppSettingsSpecifierInAppTitle @"InAppTitle"
#define InAppSettingsSpecifierInAppMultiType @"InAppMultiType"
#define InAppSettingsSpecifierTap @"InAppTap"

// test if the value of PSMultiValueSpecifier should be on the right or left if there is no title
#define InAppSettingsUseNewMultiValueLocation [[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.0
