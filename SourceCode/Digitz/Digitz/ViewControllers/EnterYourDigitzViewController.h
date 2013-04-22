//
//  EnterYourDigitzViewController.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface EnterYourDigitzViewController : UIViewController <ServerManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property BOOL personalInfoFilled;
@property NSMutableDictionary *paramsDict;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPwd;
- (IBAction)btnContinueTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebookTapped;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogleTapped;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagramTapped;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitterTapped;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedInTapped;

@property (strong, nonatomic) ServerManager *serverManager;

- (IBAction)btnFacebookTapped:(id)sender;
- (IBAction)btnGoogleTapped:(id)sender;
- (IBAction)btnInstagramTapped:(id)sender;
- (IBAction)btnTwitterTapped:(id)sender;
- (IBAction)btnLinkedInTapped:(id)sender;

@end
