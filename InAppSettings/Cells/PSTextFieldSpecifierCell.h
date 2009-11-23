//
//  PSToggleSwitchSpecifier.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"

@interface PSTextFieldSpecifierCell : InAppSettingsTableCell {
    UITextField *textField;
}

- (BOOL)isSecure;
- (UIKeyboardType)getKeyboardType;
- (UITextAutocapitalizationType)getAutocapitalizationType;
- (UITextAutocorrectionType)getAutocorrectionType;
- (void)textChangeAction;

@end
