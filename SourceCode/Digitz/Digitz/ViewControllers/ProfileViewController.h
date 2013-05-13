//
//  ProfileViewController.h
//  Digitz
//
//  Created by chuanhd on 5/2/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "GPPSignIn.h"
#import <Twitter/Twitter.h>
#import "OAuthLoginView.h"
#import "InstagramAuthViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ProfileViewController : UIViewController <ServerManagerDelegate, UITableViewDataSource, UITableViewDelegate, GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet UIButton *googleBtn;
@property (weak, nonatomic) IBOutlet UIButton *instagramBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *linkedlnBtn;

@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) NSMutableDictionary *paramsDict;

@property BOOL personalInfoFilled;
@property BOOL optionalInfoFilled;
@property BOOL privacySettingFilled;
@property BOOL agreeTermAndCondition;

- (IBAction)backBtnTapped:(id)sender;
- (IBAction)signOutBtnTapped:(id)sender;
- (IBAction)facebookBtnTapped:(id)sender;
- (IBAction)googleBtnTapped:(id)sender;
- (IBAction)instagramBtnTapped:(id)sender;
- (IBAction)twitterBtnTapped:(id)sender;
- (IBAction)linkedinBtnTapped:(id)sender;
- (IBAction)updateInfoBtnTapped:(id)sender;




@end
