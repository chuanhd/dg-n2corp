//
//  SocialHubViewController.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SocialHubViewController : UIViewController

@property (strong, nonatomic) NSString *socialName;
@property (strong, nonatomic) IBOutlet UITextField *txtAccount;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewIcon;

- (IBAction)touchBtnConnect:(id)sender;
- (IBAction)touchBtnBack:(id)sender;
- (IBAction)touchBackground:(id)sender;

@end
