//
//  SocialHubViewController.h
//  Digitz
//
//  Created by chuanhd on 5/23/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitzInfoViewController.h"
#import "SocialInfoViewController.h"
#import "CustomTabBarViewController.h"
#import "User.h"

@interface SocialHubViewController : UIViewController <UITabBarControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) CustomTabBarViewController *tabBarController;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

-(IBAction) backToPreviousVC:(id)sender;

@end
