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

@property (weak, nonatomic) IBOutlet UITableView *privacySettingTable;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;
@end
