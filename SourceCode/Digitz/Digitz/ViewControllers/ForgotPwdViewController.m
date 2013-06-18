//
//  ForgotPwdViewController.m
//  Digitz
//
//  Created by chuanhd on 6/17/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface ForgotPwdViewController () <ServerManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    ServerManager *serverManager;
}

@end

@implementation ForgotPwdViewController

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
    serverManager = [[ServerManager alloc] init];
    serverManager.delegate = self;
    
    self.txtEmail.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)continueBtnTapped:(id)sender {
    if (self.txtEmail.text.length < 3 || [self.txtEmail.text rangeOfString:@"@"].location == NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [serverManager sentResetPasswordWithEmail:self.txtEmail.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO];
    
}

- (void)sentResetPasswordRequestSuccess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your reset password instruction has been sent" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)sentResetPasswordRequestFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your reset password request was failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
