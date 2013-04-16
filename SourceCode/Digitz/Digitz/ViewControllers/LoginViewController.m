//
//  LoginViewController.m
//  Digitz
//
//  Created by chuanhd on 4/16/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "LoginViewController.h"
#import "EnterYourDigitzViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.txtPassword.delegate = self;
    self.txtUsername.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}

- (IBAction)loginButtonTapped:(id)sender {
    ServerManager *server = [ServerManager sharedInstance];
    server.delegate = self;
    [server signInWithUsername:self.txtUsername.text andPassword:self.txtPassword.text];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO];
}

- (void)signInSuccess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    EnterYourDigitzViewController *vc = [[EnterYourDigitzViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signInFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.frame.origin.y > 180) {
		[UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.view.frame = CGRectMake(0, -textField.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.25f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
	[self textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
