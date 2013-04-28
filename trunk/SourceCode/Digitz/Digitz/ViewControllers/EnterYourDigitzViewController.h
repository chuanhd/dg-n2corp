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
#import "GPPSignIn.h"
#import <Twitter/Twitter.h>
#import "BSKeyboardControls.h"
#import "OAuthLoginView.h"

#define kGoogle @"google"
#define kFacebook @"facebook"
#define kTwitter @"twitter"
#define kInstagram @"instagram"
#define kLinkedIn @"linkedin"

@interface EnterYourDigitzViewController : UIViewController <ServerManagerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, GPPSignInDelegate, BSKeyboardControlsDelegate>

@property BOOL personalInfoFilled;
@property NSMutableDictionary *paramsDict;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPwd;
- (IBAction)btnContinueTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnInstagram;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;

@property (strong, nonatomic) ServerManager *serverManager;
@property (nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (strong, nonatomic) OAuthLoginView *oauthLoginView;

- (IBAction)btnFacebookTapped:(id)sender;
- (IBAction)btnGoogleTapped:(id)sender;
- (IBAction)btnInstagramTapped:(id)sender;
- (IBAction)btnTwitterTapped:(id)sender;
- (IBAction)btnLinkedInTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;

@end
