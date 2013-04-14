//
//  SocialHubViewController.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "SocialHubViewController.h"
#define kGoogle @"google"
#define kFacebook @"facebook"
#define kTwitter @"twitter"
#define kInstagram @"instagram"
#define kLinkedIn @"linkedin"

@interface SocialHubViewController ()

@end

@implementation SocialHubViewController
@synthesize socialName;
@synthesize txtAccount;
@synthesize txtPassword;
@synthesize imgViewIcon;

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
    UIImage *imgIcon;
    if ([socialName isEqualToString:kGoogle]){
        txtAccount.placeholder = @"Google Login Account";
        txtPassword.placeholder = @"Google Login Password";
        imgIcon = [UIImage imageNamed:@"bg-icon-google@2x"];
    } else if ([socialName isEqualToString:kFacebook]){
        txtAccount.placeholder = @"Facebook Login Account";
        txtPassword.placeholder = @"Facebook Login Password";
        imgIcon = [UIImage imageNamed:@"bg-icon-fb@2x"];
    } else if ([socialName isEqualToString:kTwitter]){
        txtAccount.placeholder = @"Twitter Login Account";
        txtPassword.placeholder = @"Twitter Login Password";
        imgIcon = [UIImage imageNamed:@"bg-icon-tw@2x"];
    } else if ([socialName isEqualToString:kInstagram]){
        txtAccount.placeholder = @"Instagram Login Account";
        txtPassword.placeholder = @"Instagram Login Password";
        imgIcon = [UIImage imageNamed:@"bg-icon-ins@2x"];
    } else if ([socialName isEqualToString:kLinkedIn]){
        txtAccount.placeholder = @"LinkedIn Login Account";
        txtPassword.placeholder = @"LinkedIn Login Password";
        imgIcon = [UIImage imageNamed:@"bg-icon-lnk@2x"];
    }
    imgViewIcon.frame = CGRectMake(self.view.frame.size.width-8-imgIcon.size.width, self.view.frame.size.height-imgIcon.size.height, imgIcon.size.width, imgIcon.size.height);
    imgViewIcon.image = imgIcon;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtAccount:nil];
    [self setTxtPassword:nil];
    [self setImgViewIcon:nil];
    [super viewDidUnload];
}

#pragma TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)touchBtnConnect:(id)sender {
}

- (IBAction)touchBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}
@end
