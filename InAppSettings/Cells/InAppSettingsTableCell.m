//
//  InAppSettingsTableCell.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettingsTableCell.h"

@implementation InAppSettingsTableCell

@synthesize setting;

#pragma mark Cell lables

- (void)setTitle{
    [self setTitle:[self.setting valueForKey:@"Title"]];
}

- (void)setDetail{
    [self setDetail:[self getValue]];
}

- (void)setTitle:(NSString *)title{
    self.textLabel.text = NSLocalizedString(title, nil);   
}

- (void)setDetail:(NSString *)detail{
    self.detailTextLabel.text = NSLocalizedString(detail, nil);
}

#pragma mark Value

- (id)getValue{
    id value = [[NSUserDefaults standardUserDefaults] valueForKey:[self.setting valueForKey:@"Key"]];
    if(value == nil){
        value = [self.setting valueForKey:@"DefaultValue"];
    }
    return value;
}

- (void)setValue{
    //implement this per cell type
}

- (UIControl *)getValueInput{
    return nil;
}

- (void)setValue:(id)newValue{
    [[NSUserDefaults standardUserDefaults] setObject:newValue forKey:[self.setting valueForKey:@"Key"]];
}

#pragma mark -

- (id)initWithSetting:(InAppSetting *)inputSetting reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.setting = inputSetting;
    }
    return self;
}

- (void)setupCell{
    //implement this per cell type
}

- (void)dealloc{
    [setting release];
    [super dealloc];
}

@end
