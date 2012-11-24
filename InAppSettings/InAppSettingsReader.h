//
//  InAppSettingsReader.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 1/19/10.
//  Copyright 2010 InScopeApps{+}. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InAppSettingsReaderRegisterDefaults : NSObject {
    //keep track of what files we've read to avoid circular references
    NSMutableArray *files;
    NSMutableDictionary *values;
}

@property (nonatomic, strong) NSMutableArray *files;
@property (nonatomic, strong) NSMutableDictionary *values;

@end

@interface InAppSettingsReader : NSObject {
    NSString *file;
    NSMutableArray *headers, *settings;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, strong) NSMutableArray *headers, *settings;

- (id)initWithFile:(NSString *)inputFile;

@end
