//
//  DigitzInfoViewController.m
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "DigitzInfoViewController.h"

@interface DigitzInfoViewController ()

@end

@implementation DigitzInfoViewController

@synthesize user = _user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"Digitz";
    self.tabBarItem.image = [UIImage imageNamed:@"icon-social-profile-white.png"];
    self.uiscrollview.contentSize = CGSizeMake(320, 900);
    
    self.lblAlterEmail.text = ![_user.emailHome isEqual:[NSNull null]] ? _user.emailHome : @"N/A";
    self.lblHomepage.text = ![_user.homepage isEqual:[NSNull null]] ? _user.homepage : @"N/A";
    self.lblEmail.text = ![_user.email isEqual:[NSNull null]] ? _user.email : @"N/A";
    self.lblAlterPhoneNo.text = ![_user.phoneHome isEqual:[NSNull null]] ? _user.phoneHome : @"N/A";
    self.lblBirthday.text = ![_user.birthday isEqual:[NSNull null]] ? _user.birthday : @"N/A";
    self.lblGender.text = _user.gender == 1 ? @"male" : @"female";
    self.lblHomeAddr.text = ![_user.address isEqual:[NSNull null]] ? _user.address : @"N/A";
    self.lblHometown.text = ![_user.hometown isEqual:[NSNull null]] ? _user.hometown : @"N/A";
    self.lblMobilePhone.text = ![_user.phoneNumber isEqual:[NSNull null]] ? _user.phoneNumber : @"N/A";
    self.lblOrganization.text = ![_user.company isEqual:[NSNull null]] ? _user.company : @"N/A";
    self.lblPersonalBio.text = ![_user.bio isEqual:[NSNull null]] ? _user.bio : @"N/A";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
}
@end
