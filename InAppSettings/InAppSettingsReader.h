//
//  InAppSettingsReader.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 1/19/10.
//  Copyright 2010 InScopeApps{+}. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppSettingsReaderRegisterDefaults : NSObject

@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSMutableDictionary *values;

@end

@interface InAppSettingsReader : NSObject

@property (nonatomic, copy) NSString *file;
@property (nonatomic, strong) NSMutableArray *headersAndFooters, *settings;

- (id)initWithFile:(NSString *)inputFile;

@end
