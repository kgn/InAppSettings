//
//  InAppSettingsReader.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 1/19/10.
//  Copyright 2010 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsReader.h"
#import "InAppSettingsSpecifier.h"
#import "InAppSettingsConstants.h"

@implementation InAppSettingsReaderRegisterDefaults

- (void)loadFile:(NSString *)file{
    //if the file is not in the files list we havn't read it yet
    NSInteger fileIndex = [self.files indexOfObject:file];
    if(fileIndex == NSNotFound){
        [self.files addObject:file];
        
        //load plist
        NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:InAppSettingsFullPlistPath(file)];
        NSArray *preferenceSpecifiers = [settingsDictionary objectForKey:InAppSettingsPreferenceSpecifiers];
        NSString *stringsTable = [settingsDictionary objectForKey:InAppSettingsStringsTable];
        [preferenceSpecifiers enumerateObjectsUsingBlock:^(NSDictionary *setting, NSUInteger idx, BOOL *stop) {
            InAppSettingsSpecifier *settingsSpecifier = [[InAppSettingsSpecifier alloc] initWithDictionary:setting andStringsTable:stringsTable];
            if([settingsSpecifier isValid]){
                if([settingsSpecifier isType:InAppSettingsPSChildPaneSpecifier]){
                    [self loadFile:[settingsSpecifier valueForKey:InAppSettingsSpecifierFile]];
                }else if([settingsSpecifier hasKey]){
                    if([settingsSpecifier valueForKey:InAppSettingsSpecifierDefaultValue]){
                        [self.values setObject:[settingsSpecifier valueForKey:InAppSettingsSpecifierDefaultValue] forKey:[settingsSpecifier getKey]];
                    }
                }
            }
        }];
    }
}

- (id)init{
    if((self = [super init])){
        self.files = [[NSMutableArray alloc] init];
        self.values = [[NSMutableDictionary alloc] init];
        [self loadFile:InAppSettingsRootFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:self.values];
    }
    return self;
}



@end

@implementation InAppSettingsReader

- (id)initWithFile:(NSString *)inputFile{
    if((self = [super init])){
        self.file = inputFile;
        
        //load plist
        NSDictionary *settingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:InAppSettingsFullPlistPath(self.file)];
        NSArray *preferenceSpecifiers = [settingsDictionary objectForKey:InAppSettingsPreferenceSpecifiers];
        NSString *stringsTable = [settingsDictionary objectForKey:InAppSettingsStringsTable];
        
        //initialize the arrays
        self.headersAndFooters = [[NSMutableArray alloc] init];
        self.settings = [[NSMutableArray alloc] init];
        
        //load the data
        [preferenceSpecifiers enumerateObjectsUsingBlock:^(NSDictionary *setting, NSUInteger idx, BOOL *stop) {
            InAppSettingsSpecifier *settingsSpecifier = [[InAppSettingsSpecifier alloc] initWithDictionary:setting andStringsTable:stringsTable];
            if([settingsSpecifier isValid]){
                if([settingsSpecifier isType:InAppSettingsPSGroupSpecifier]){
                    [self.headersAndFooters addObject:@[[settingsSpecifier localizedTitle], [settingsSpecifier localizedFooterText]]];
                    [self.settings addObject:[NSMutableArray array]];
                }else{
                    //if there are no settings make an initial container
                    if([self.settings count] < 1){
                        [self.headersAndFooters addObject:@[@"", @""]];
                        [self.settings addObject:[NSMutableArray array]];
                    }
                    [[self.settings lastObject] addObject:settingsSpecifier];
                }
            }
        }];
    }
    return self;
}


@end
