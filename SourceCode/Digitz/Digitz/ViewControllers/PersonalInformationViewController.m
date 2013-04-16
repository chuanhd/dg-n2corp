//
//  PersonalInformationViewController.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "MBProgressHUD.h"

@interface PersonalInformationViewController ()

@end

@implementation PersonalInformationViewController
@synthesize btnMale;
@synthesize btnFemale;

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
    self.txtAge.delegate = self;
    self.txtEmail.delegate = self;
    self.txtHometown.delegate = self;
    self.txtName.delegate = self;
    self.txtPhoneNumber.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtAge:nil];
    [self setTxtPhoneNumber:nil];
    [self setTxtEmail:nil];
    [self setTxtHometown:nil];
    [self setBtnMale:nil];
    [self setBtnFemale:nil];
    [super viewDidUnload];
}

static NSString *gender;

- (IBAction)touchBtnMale:(id)sender {
    [btnMale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
    [btnFemale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
    gender = @"male";
}

- (IBAction)touchBtnFemale:(id)sender {
    [btnMale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
    [btnFemale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
    gender = @"female";
}

- (IBAction)touchBtnSave:(id)sender {
    ServerManager *server = [ServerManager sharedInstance];
    server.delegate = self;
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *token = [df objectForKey:@"token"];
    
    if (self.txtName.text.length == 0 || self.txtAge.text.length == 0 || self.txtPhoneNumber.text.length == 0 || self.txtEmail.text.length == 0 || self.txtHometown.text.length == 0) {
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:token forKey:kKey_UserToken];
    
    [dic setObject:[NSNumber numberWithInteger:self.txtAge.text.integerValue] forKey:kKey_UpdateAge];
    [dic setObject:self.txtEmail.text forKey:kKey_UpdateEmail];
    [dic setObject:self.txtHometown forKey:kKey_UpdateHometown];
    [dic setObject:self.txtPhoneNumber forKey:kKey_UpdatePhone];
    [dic setObject:gender forKey:kKey_UpdateGender];
    
    [server updateUserInformationWithParams:dic];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
}

- (void)updateUserInformationWithParamsSuccess:(User *)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    hud.labelText = @"Update successful";
//    [hud showAnimated:YES whileExecutingBlock:nil completionBlock:^{
//        [hud hide:YES afterDelay:2.0];
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateUserInformationWithParamsFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)touchBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
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
