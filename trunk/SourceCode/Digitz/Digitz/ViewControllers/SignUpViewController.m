//
//  SignUpViewController.m
//  Digitz
//
//  Created by chuanhd on 4/16/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "SignUpViewController.h"
#import "EnterYourDigitzViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    
    self.txtEmail.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToSelector:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)respondTapGestureRecognizer:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPassword:nil];
    [self setTxtEmail:nil];
    [super viewDidUnload];
}

- (IBAction)Signup:(id)sender {
    
    [self.txtEmail resignFirstResponder];
    
    if ([self validateField]) {
        ServerManager *server = [ServerManager sharedInstance];
        server.delegate = self;
        [server signUpWithUsername:self.txtUsername.text andPassword:self.txtPassword.text andEmail:self.txtEmail.text];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid info" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alertView show];

    }
}

- (BOOL) validateField
{
    if (self.txtUsername.text.length == 0 || self.txtPassword.text.length == 0 || self.txtConfirmPassword.text.length == 0) {
        return NO;
    }
    
    if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text]) {
        return NO;
    }
    
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
