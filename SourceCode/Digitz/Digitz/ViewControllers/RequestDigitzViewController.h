//
//  RequestDigitzViewController.h
//  Digitz
//
//  Created by chuanhd on 5/2/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ServerManager.h"

@interface RequestDigitzViewController : UIViewController <ServerManagerDelegate>

@property (strong, nonatomic) User *requestUser;
@property (strong, nonatomic) ServerManager *serverManager;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *txtUsername;
@property (weak, nonatomic) IBOutlet UILabel *txtLocation;

- (IBAction)btnAcqAddTapped:(id)sender;
- (IBAction)btnBusiAddTapped:(id)sender;
- (IBAction)btnFriendAddTapped:(id)sender;
- (IBAction)backBtnTapped:(id)sender;
@end
