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
{
    NSArray *stateArray;
}

@end

@implementation PersonalInformationViewController
@synthesize btnMale;
@synthesize btnFemale;
@synthesize serverManager;
@synthesize parentVC;

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
    self.txtState.delegate = self;
    
    self.serverManager = [[ServerManager alloc] init];
    self.serverManager.delegate = self;
    
    stateArray = [NSArray arrayWithObjects:@"Hawaii", @"New York", @"Washington DC", @"Nevada", nil];
    self.statePicker.dataSource = self;
    self.statePicker.delegate = self;
    
//    UITapGestureRecognizer *txtAgeTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerViewWithTag:)];
//    [self.txtAge addGestureRecognizer:txtAgeTapped];
    
    
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
    [self setDatePicker:nil];
    [self setDatePickerView:nil];
    [self setStatePicker:nil];
    [self setTxtState:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    NSLog(@"token %@", token);
//    self.serverManager.delegate = self;
//    [self.serverManager getUserInfoWithToken:token];
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES withLabel:@"Fetching..."];
}

//- (void)getUserInformationSuccessWithUser:(User *)user
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//    self.txtName.text = user.name;
//    self.txtAge.text = [NSString stringWithFormat:@"%d", user.age];
//    self.txtPhoneNumber.text = user.phoneNumber;
//    self.txtHometown.text = user.hometown;
//    self.txtEmail.text = user.email;
//    
//    if (user.gender == MALE) {
//        [btnMale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
//        [btnFemale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
//        gender = @"male";
//    }else{
//        [btnMale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
//        [btnFemale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
//        gender = @"female";
//    }
//}
//
//- (void)getUserInformationFailedWithError:(NSError *)error
//{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occured" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
//    [alertView show];
//}

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
    self.serverManager.delegate = self;
    
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    NSString *token = [df objectForKey:kKey_UserToken];
    
    if (self.txtName.text.length == 0 || self.txtAge.text.length == 0 || self.txtPhoneNumber.text.length == 0 || self.txtEmail.text.length == 0 || self.txtHometown.text.length == 0) {
        return;
    }
    
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //[self.parentVC.paramsDict setObject:token forKey:kKey_UserToken];
    
    [self.parentVC.paramsDict setObject:self.txtAge.text forKey:kKey_UpdateBirthday];
    [self.parentVC.paramsDict setObject:self.txtEmail.text forKey:kKey_UpdateEmail];
    [self.parentVC.paramsDict setObject:self.txtHometown.text forKey:kKey_UpdateHometown];
    [self.parentVC.paramsDict setObject:self.txtPhoneNumber.text forKey:kKey_UpdatePhone];
    [self.parentVC.paramsDict setObject:gender forKey:kKey_UpdateGender];
    
    self.parentVC.personalInfoFilled = YES;
    
//    [self.serverManager updateUserInformationWithParams:dic];
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)updateUserInformationWithParamsSuccess:(User *)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (IBAction)closeDatePickerTapped:(id)sender {
    NSDate *dateFromPicker = self.datePicker.date;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    self.txtAge.text = [formater stringFromDate:dateFromPicker];
    self.datePickerView.hidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if ([textField isEqual:self.txtAge]) {
//        return NO;
//    }
//    
//    if ([textField isEqual:self.txtState]) {
//        return NO;
//    }
    
    return YES;
}

#pragma mark text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.txtAge]) {
        [self.txtName endEditing:YES];
        [textField resignFirstResponder];
        [self showPickerViewWithTag:textField];
        return;

    }
    
    if ([textField isEqual:self.txtState]) {
        [textField resignFirstResponder];
        [self showPickerViewWithTag:textField];
        return;
    }
    
    if (textField.frame.origin.y > 180) {
		[UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.view.frame = CGRectMake(0, -textField.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}

}

- (void) showPickerViewWithTag:(id)sender
{
//    for (UIView *subView in self.datePickerView.subviews) {
//        subView.hidden = NO;
//    }
    
    UITextField *textField = (UITextField *) sender;
    
    if ([textField isEqual:self.txtAge]) {
        self.datePicker.hidden = NO;
        self.statePicker.hidden = YES;
    }else if ([textField isEqual:self.txtState])
    {
        self.datePicker.hidden = YES;
        self.statePicker.hidden = NO;
    }
    
    self.datePickerView.hidden = NO;
}

- (void) datePickerValueChanged:(id)sender
{

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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return stateArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [stateArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.txtState.text = [stateArray objectAtIndex:row];
}

@end
