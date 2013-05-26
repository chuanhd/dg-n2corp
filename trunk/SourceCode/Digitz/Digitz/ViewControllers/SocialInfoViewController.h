//
//  SocialInfoViewController.h
//  Digitz
//
//  Created by chuanhd on 5/23/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SocialInfoViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *socialLink;
@property (weak, nonatomic) IBOutlet UIWebView *webViewSocialNetwork;
- (IBAction)backBtnTapped:(id)sender;

@end
