//
//  DigitzInfoViewController.h
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DigitzInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *uiscrollview;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblMobilePhone;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblHometown;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblOrganization;
@property (weak, nonatomic) IBOutlet UILabel *lblHomeAddr;
@property (weak, nonatomic) IBOutlet UILabel *lblHomepage;
@property (weak, nonatomic) IBOutlet UILabel *lblAlterPhoneNo;
@property (weak, nonatomic) IBOutlet UILabel *lblAlterEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalBio;
- (IBAction)backBtnTapped:(id)sender;
- (IBAction)callBtnTapped:(id)sender;
- (IBAction)mailBtnTapped:(id)sender;
- (IBAction)smsBtnTapped:(id)sender;

@property (strong, nonatomic) User *user;

@end
