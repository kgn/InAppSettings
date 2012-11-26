//
//  InAppSettingsViewController.m
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "InAppSettings.h"
#import "InAppSettingsPSMultiValueSpecifierTable.h"

NSString *const InAppSettingsViewControllerDelegateWillDismissedNotification = @"InAppSettingsViewControllerDelegateWillDismissedNotification";
NSString *const InAppSettingsViewControllerDelegateDidDismissedNotification = @"InAppSettingsViewControllerDelegateDidDismissedNotification";

@implementation InAppSettings

+ (void)registerDefaults{
    id __unused defaults = [[InAppSettingsReaderRegisterDefaults alloc] init];
}

@end

@implementation InAppSettingsModalViewController

- (id)init{
    InAppSettingsViewController *settings = [[InAppSettingsViewController alloc] init];
    self = (InAppSettingsModalViewController *)[[UINavigationController alloc] initWithRootViewController:settings];
    [settings addDoneButton];
    return self;
}

@end

@implementation InAppSettingsViewController

#pragma mark modal view

- (IBAction)dismissModalView:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:InAppSettingsViewControllerDelegateWillDismissedNotification object:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:InAppSettingsViewControllerDelegateDidDismissedNotification object:self];
    }];
}

- (void)addDoneButton{
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
     target:self
     action:@selector(dismissModalView:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark setup view

- (id)initWithFile:(NSString *)inputFile{
    self = [super init];
    if (self != nil){
        self.file = inputFile;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //setup the table
    self.settingsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.settingsTableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.settingsTableView.delegate = self;
    self.settingsTableView.dataSource = self;
    [self.view addSubview:self.settingsTableView];
    
    //if the title is nil set it to Settings
    if(!self.title){
        self.title = NSLocalizedString(@"Settings", nil);
    }
    
    //load settigns plist
    if(!self.file){
        self.file = InAppSettingsRootFile;
    }
    
    self.settingsReader = [[InAppSettingsReader alloc] initWithFile:self.file];
    
    //setup keyboard notification
    self.firstResponder = nil;
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.firstResponder = nil;
    
    self.settingsTableView.contentInset = UIEdgeInsetsZero;
    self.settingsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [self.settingsTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.firstResponder = nil;
}

- (void)dealloc{
    self.firstResponder = nil;
    
}

#pragma mark text field cell delegate

- (void)textFieldDidBeginEditing:(UITextField *)cellTextField{
    self.firstResponder = cellTextField;
    
    //TODO: find a better way to get the cell from the text view
    NSIndexPath *indexPath = [self.settingsTableView indexPathForCell:(UITableViewCell *)[[cellTextField superview] superview]];
    [self.settingsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)cellTextField{
    self.firstResponder = nil;
    [cellTextField resignFirstResponder];
    return YES;
}

#pragma mark keyboard notification

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    if(self.firstResponder == nil){
        // get the keybaord rect
#if InAppSettingsUseNewKeyboard
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
#else
        CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
#endif
        // determin the bottom inset for the table view
        UIEdgeInsets settingsTableInset = self.settingsTableView.contentInset;
        CGPoint tableViewScreenSpace = [self.settingsTableView.superview convertPoint:self.settingsTableView.frame.origin toView:nil];
        CGFloat tableViewBottomOffset = CGRectGetHeight(self.view.bounds)-(tableViewScreenSpace.y+self.settingsTableView.frame.size.height);
        settingsTableInset.bottom = keyboardRect.size.height-tableViewBottomOffset;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:InAppSettingsKeyboardAnimation];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = settingsTableInset;
        self.settingsTableView.scrollIndicatorInsets = settingsTableInset;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    if(self.firstResponder == nil){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:InAppSettingsKeyboardAnimation];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.settingsTableView.contentInset = UIEdgeInsetsZero;
        self.settingsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
}

#pragma mark Table view methods

- (InAppSettingsSpecifier *)settingAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.settingsReader.settings objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.settingsReader.headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.settingsReader.headers objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.settingsReader.settings objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(InAppSettingsDisplayPowered && [self.file isEqualToString:InAppSettingsRootFile] && section == (NSInteger)[self.settingsReader.headers count]-1){
        return InAppSettingsPowerFooterHeight;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(InAppSettingsDisplayPowered && [self.file isEqualToString:InAppSettingsRootFile] && section == (NSInteger)[self.settingsReader.headers count]-1){
        UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), InAppSettingsPowerFooterHeight)];
        
        //InAppSettings label
        CGSize InAppSettingsSize = [InAppSettingsProjectName sizeWithFont:InAppSettingsFooterFont];
        CGPoint InAppSettingsPos = CGPointMake((CGFloat)round((CGRectGetWidth(self.view.bounds)*0.5f)-(InAppSettingsSize.width*0.5f)), 
                                               (CGFloat)round((InAppSettingsPowerFooterHeight*0.5f)-(InAppSettingsSize.height*0.5f))-1);
        UILabel *InAppLabel = [[UILabel alloc] initWithFrame:CGRectMake(InAppSettingsPos.x, InAppSettingsPos.y, InAppSettingsSize.width, InAppSettingsSize.height)];
        InAppLabel.text = InAppSettingsProjectName;
        InAppLabel.font = InAppSettingsFooterFont;
        InAppLabel.backgroundColor = [UIColor clearColor];
        InAppLabel.textColor = InAppSettingsFooterBlue;
        InAppLabel.shadowColor = [UIColor whiteColor];
        InAppLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [powerView addSubview:InAppLabel];
        
        //lighting bolts
        CGPoint leftLightningBoltPos = CGPointMake(InAppSettingsPos.x-InAppSettingsLightingBoltSize,
                                               (CGFloat)round((InAppSettingsPowerFooterHeight*0.5f)-(InAppSettingsLightingBoltSize*0.5f)));
        InAppSettingsLightningBolt *leftLightningBolt = [[InAppSettingsLightningBolt alloc] 
                                                         initWithFrame:CGRectMake(leftLightningBoltPos.x, leftLightningBoltPos.y, 
                                                                                  InAppSettingsLightingBoltSize, InAppSettingsLightingBoltSize)];
        [powerView addSubview:leftLightningBolt];
        
        CGPoint rightLightningBoltPos = CGPointMake((CGFloat)round(InAppSettingsPos.x+InAppSettingsSize.width), leftLightningBoltPos.y);
        InAppSettingsLightningBolt *rightLightningBolt = [[InAppSettingsLightningBolt alloc] 
                                                          initWithFrame:CGRectMake(rightLightningBoltPos.x, rightLightningBoltPos.y, 
                                                                                   InAppSettingsLightingBoltSize, InAppSettingsLightingBoltSize)];
        rightLightningBolt.flip = YES;
        [powerView addSubview:rightLightningBolt];
        
        return powerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSettingsSpecifier *setting = [self settingAtIndexPath:indexPath];
    
    //get the NSClass for a specifier, if there is none use the base class InAppSettingsTableCell
    NSString *cellType = [setting cellName];
    Class nsclass = NSClassFromString(cellType);
    if(!nsclass){
        cellType = @"InAppSettingsTableCell";
        nsclass = NSClassFromString(cellType);
    }
    
    InAppSettingsTableCell *cell = ((InAppSettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:cellType]);
    if (cell == nil){
        cell = [[nsclass alloc] initWithReuseIdentifier:cellType];
        //setup the cells controlls
        [cell setupCell];
    }
    
    //set the values of the cell, this is separated from setupCell for reloading the table
    cell.setting = setting;
    [cell setValueDelegate:self];
    [cell setUIValues];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSettingsSpecifier *setting = [self settingAtIndexPath:indexPath];
    if([setting isType:InAppSettingsPSMultiValueSpecifier]){
        InAppSettingsPSMultiValueSpecifierTable *multiValueSpecifier = [[InAppSettingsPSMultiValueSpecifierTable alloc] initWithSetting:setting];
        [self.navigationController pushViewController:multiValueSpecifier animated:YES];
    }else if([setting isType:InAppSettingsPSChildPaneSpecifier]){
        InAppSettingsViewController *childPane = [[InAppSettingsViewController alloc] initWithFile:[setting valueForKey:InAppSettingsSpecifierFile]];
        childPane.title = [setting localizedTitle];
        [self.navigationController pushViewController:childPane animated:YES];
    }else if([setting isType:InAppSettingsPSTitleValueSpecifier]){
        InAppSettingsOpenUrl([NSURL URLWithString:[setting valueForKey:InAppSettingsSpecifierInAppURL]]);
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InAppSettingsTableCell *cell = ((InAppSettingsTableCell *)[tableView cellForRowAtIndexPath:indexPath]);
    
    if([cell.setting isType:@"PSTextFieldSpecifier"]){
        [cell.valueInput becomeFirstResponder];
    }else if(cell.canSelectCell){
        [self.firstResponder resignFirstResponder];
        return indexPath;
    }
    return nil;
}

@end

@implementation InAppSettingsLightningBolt

@synthesize flip;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.flip = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [InAppSettingsFooterBlue CGColor]);
    #if __IPHONE_3_2
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [[UIColor whiteColor] CGColor]);
    #else
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, -1.0f), 0.0f, [[UIColor whiteColor] CGColor]);
    #endif
    if(self.flip){
        CGContextMoveToPoint(context, 4.0f, 1.0f);
        CGContextAddLineToPoint(context, 13.0f, 1.0f);
        CGContextAddLineToPoint(context, 10.0f, 5.0f);
        CGContextAddLineToPoint(context, 12.0f, 7.0f);
        CGContextAddLineToPoint(context, 2.0f, 15.0f);
        CGContextAddLineToPoint(context, 5.0f, 7.0f);
        CGContextAddLineToPoint(context, 3.0f, 5.0f);
    }else{
        CGContextMoveToPoint(context, 3.0f, 1.0f);
        CGContextAddLineToPoint(context, 12.0f, 1.0f);
        CGContextAddLineToPoint(context, 13.0f, 5.0f);
        CGContextAddLineToPoint(context, 11.0f, 7.0f);
        CGContextAddLineToPoint(context, 14.0f, 15.0f);
        CGContextAddLineToPoint(context, 4.0f, 7.0f);
        CGContextAddLineToPoint(context, 6.0f, 5.0f); 
    }
    CGContextFillPath(context);
}

@end
