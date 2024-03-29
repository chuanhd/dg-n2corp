//
//  ReceiveRequestViewController.h
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "User.h"
#import "DigitzRequest.h"

@interface ReceiveRequestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ServerManagerDelegate>

@property (strong, nonatomic) DigitzRequest *request;
@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) NSMutableArray *fields;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableSocialShare;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)settingBtnTapped:(id)sender;

- (IBAction)acceptBtnTapped:(id)sender;
- (IBAction)declineBtnTapped:(id)sender;

- (void) addFieldToArray:(NSString *)field;
- (void) removeFieldFromArray:(NSString *)field;

@end
