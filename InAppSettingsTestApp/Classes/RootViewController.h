//
//  RootViewController.h
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright InScopeApps{+} 2009. All rights reserved.
//

@interface RootViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *userSettingsLabel1;
@property (nonatomic, strong) IBOutlet UILabel *userSettingsLabel2;
@property (nonatomic, strong) IBOutlet UILabel *userSettingsLabel3;
@property (nonatomic, strong) IBOutlet UILabel *userSettingsLabel4;

- (IBAction)showSettings;
- (IBAction)presentSettings;

@end
