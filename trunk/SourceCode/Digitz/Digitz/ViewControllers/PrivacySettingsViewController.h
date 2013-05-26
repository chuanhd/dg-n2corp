//
//  PrivacySettingsViewController.h
//  Digitz
//
//  Created by chuanhd on 5/11/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"

@interface PrivacySettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ServerManagerDelegate>

@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) NSMutableArray *privacyFieldsAcc;
@property (strong, nonatomic) NSMutableArray *privacyFieldsBus;
@property (strong, nonatomic) NSMutableArray *privacyFieldsFri;
@property (strong, nonatomic) UIViewController *parentVC;

@property (weak, nonatomic) IBOutlet UITableView *privacySettingTable;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;

- (void) addFieldToArrayType:(NSInteger)type withField:(NSString *)field;
- (void) removeFieldFromArrayType:(NSInteger)type withField:(NSString *)field;

@end
