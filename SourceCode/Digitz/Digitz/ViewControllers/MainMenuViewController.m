//
//  MainMenuViewController.m
//  Digitz
//
//  Created by chuanhd on 4/16/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "MainMenuViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "EnterYourDigitzViewController.h"
#import "MBProgressHUD.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

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

- (IBAction)loginButtonTapped:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signupButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([self validateField]) {
        ServerManager *server = [ServerManager sharedInstance];
        server.delegate = self;
        [server signUpWithUsername:self.txtUsername.text andPassword:self.txtPassword.text andEmail:@""];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid info" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}

- (BOOL) validateField
{
    if (self.txtUsername.text.length == 0 || self.txtPassword.text.length == 0) {
        return NO;
    }
    
//    if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
//        return NO;
//    }
    
    return YES;
}


- (void)signUpSuccess
{
    EnterYourDigitzViewController *vc = [[EnterYourDigitzViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) signUpFailedWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alertView show];
    
}

- (void)viewDidUnload {
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [super viewDidUnload];
}

#pragma mark text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textField %f", textField.frame.origin.y);
    if (textField.superview.frame.origin.y > 180) {
		[UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.view.frame = CGRectMake(0, -textField.superview.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
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
