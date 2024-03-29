//
//  PersonalInformationViewController.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "MBProgressHUD.h"
#import "ProfileViewController.h"

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
@synthesize keyboardControls = _keyboardControls;

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
    self.txtFirstName.delegate = self;
    self.txtLastName.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtState.delegate = self;
    self.txtAutoState.delegate = self;
    
    self.serverManager = [[ServerManager alloc] init];
    self.serverManager.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"plist"];
    stateArray = [NSArray arrayWithContentsOfFile:plistPath];
    //stateArray = [dict objectForKey:@"Root"];
    //stateArray = [NSArray arrayWithObjects:@"Hawaii", @"New York", @"Washington DC", @"Nevada", nil];
    NSLog(@"stateArray count: %d", stateArray.count);
    self.statePicker.dataSource = self;
    self.statePicker.delegate = self;
    
    gender = @"male";
    
    NSArray *fields = @[self.txtFirstName, self.txtLastName, self.txtAge, self.txtPhoneNumber, self.txtEmail, self.txtHometown, self.txtState];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    self.keyboardControls.delegate = self;

//    UITapGestureRecognizer *txtAgeTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPickerViewWithTag:)];
//    [self.txtAge addGestureRecognizer:txtAgeTapped];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtFirstName:nil];
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
    
    if ([self.parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        
        self.txtFirstName.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateFirstName];
        self.txtLastName.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateLastName];
        
//        self.txtFirstName.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateName];
        //self.txtAge.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateBirthday];
        self.txtEmail.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateEmail];
        self.txtHometown.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateHometown];
        if ([[((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateGender] isEqualToString:@"male"]) {
            [btnMale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
            [btnFemale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
            gender = @"male";
        }else{
            [btnMale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
            [btnFemale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
            gender = @"female";
        }
        
        NSString *birthday = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateBirthday];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formater dateFromString:birthday];
        [formater setDateFormat:@"MM-dd-yyyy"];
        birthday = [formater stringFromDate:date];
        NSLog(@"birthday: %@", birthday);
        
        self.txtAge.text = birthday;
        
        self.txtPhoneNumber.text  = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdatePhone];
        self.txtState.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateState];
    }else if([self.parentVC isKindOfClass:[ProfileViewController class]]){
        
        self.txtFirstName.text = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateFirstName];
        self.txtLastName.text = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateLastName];
        
        //self.txtAge.text = [((EnterYourDigitzViewController *) parentVC).paramsDict objectForKey:kKey_UpdateBirthday];
        self.txtEmail.text = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateEmail];
        self.txtHometown.text = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateHometown];
        if ([[((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateGender] isEqualToString:@"male"]) {
            [btnMale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
            [btnFemale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
            gender = @"male";
        }else{
            [btnMale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
            [btnFemale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
            gender = @"female";
        }
        
        NSString *birthday = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateBirthday];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formater dateFromString:birthday];
        [formater setDateFormat:@"MM-dd-yyyy"];
        birthday = [formater stringFromDate:date];
        NSLog(@"birthday: %@", birthday);
        
        self.txtAge.text = birthday;
        
        self.txtPhoneNumber.text  = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdatePhone];
        self.txtState.text = [((ProfileViewController *) parentVC).paramsDict objectForKey:kKey_UpdateState];
    }
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
    self.serverManager.delegate = self;
    
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    NSString *token = [df objectForKey:kKey_UserToken];
    
    if (self.txtFirstName.text.length == 0 || self.txtAge.text.length == 0 || self.txtPhoneNumber.text.length == 0 || self.txtEmail.text.length == 0 || self.txtHometown.text.length == 0 || self.txtLastName.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must fill all required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //[self.parentVC.paramsDict setObject:token forKey:kKey_UserToken];
    
    if ([self.parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:self.txtFirstName.text forKey:kKey_UpdateFirstName];
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:self.txtLastName.text forKey:kKey_UpdateLastName];
    }else if ([self.parentVC isKindOfClass:[ProfileViewController class]]){
        [((ProfileViewController *) self.parentVC).paramsDict setObject:self.txtFirstName.text forKey:kKey_UpdateFirstName];
        [((ProfileViewController *) self.parentVC).paramsDict setObject:self.txtLastName.text forKey:kKey_UpdateLastName];
    }
    
    
    //[self.parentVC.paramsDict setObject:self.txtName.text forKey:kKey_UpdateName];
    NSString *birthday = self.txtAge.text;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [formater dateFromString:birthday];
    [formater setDateFormat:@"yyyy-MM-dd"];
    birthday = [formater stringFromDate:date];
    NSLog(@"birthday: %@", birthday);
    
    if (birthday.length == 0 || birthday == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must fill birthday fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:birthday forKey:kKey_UpdateBirthday];
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:self.txtEmail.text forKey:kKey_UpdateEmail];
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:self.txtHometown.text forKey:kKey_UpdateHometown];
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:self.txtPhoneNumber.text forKey:kKey_UpdatePhone];
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:gender forKey:kKey_UpdateGender];
        [((EnterYourDigitzViewController *) self.parentVC).paramsDict setObject:self.txtState.text forKey:kKey_UpdateState];
        
        ((EnterYourDigitzViewController *) self.parentVC).personalInfoFilled = YES;
    }else if ([self.parentVC isKindOfClass:[ProfileViewController class]]) {
        [((ProfileViewController *) self.parentVC).paramsDict setObject:birthday forKey:kKey_UpdateBirthday];
        [((ProfileViewController *) self.parentVC).paramsDict setObject:self.txtEmail.text forKey:kKey_UpdateEmail];
        [((ProfileViewController *) self.parentVC).paramsDict setObject:self.txtHometown.text forKey:kKey_UpdateHometown];
        [((ProfileViewController *) self.parentVC).paramsDict setObject:self.txtPhoneNumber.text forKey:kKey_UpdatePhone];
        [((ProfileViewController *) self.parentVC).paramsDict setObject:gender forKey:kKey_UpdateGender];
        [((ProfileViewController *) self.parentVC).paramsDict setObject:self.txtState.text forKey:kKey_UpdateState];
        
        ((ProfileViewController *) self.parentVC).personalInfoFilled = YES;
    }
    
//    [self.parentVC.paramsDict setObject:birthday forKey:kKey_UpdateBirthday];
//    [self.parentVC.paramsDict setObject:self.txtEmail.text forKey:kKey_UpdateEmail];
//    [self.parentVC.paramsDict setObject:self.txtHometown.text forKey:kKey_UpdateHometown];
//    [self.parentVC.paramsDict setObject:self.txtPhoneNumber.text forKey:kKey_UpdatePhone];
//    [self.parentVC.paramsDict setObject:gender forKey:kKey_UpdateGender];
//    [self.parentVC.paramsDict setObject:self.txtState.text forKey:kKey_UpdateState];
//    
//    self.parentVC.personalInfoFilled = YES;
    
    
//    [self.serverManager updateUserInformationWithParams:dic];
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"personalInfoFilled"
     object:self
     userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)touchBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)closeDatePickerTapped:(id)sender {
    if (self.datePicker.hidden == NO) {
        NSDate *dateFromPicker = self.datePicker.date;
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"MM-dd-yyyy"];
        self.txtAge.text = [formater stringFromDate:dateFromPicker];
    }else{
        NSInteger selectedRow = [self.statePicker selectedRowInComponent:0];
        self.txtState.text = [stateArray objectAtIndex:selectedRow];
    }
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            [self showPickerViewWithTag:textField];
        });
        return;

    }
    
    if ([textField isEqual:self.txtState]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view endEditing:YES];
            [self showPickerViewWithTag:textField];
        });
        return;
    }
    
    [_keyboardControls setActiveField:textField];
    
    NSLog(@"textField frame y: %f", textField.frame.origin.y);
    
    if (textField.frame.origin.y > 130) {
		[UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.view.frame = CGRectMake(0, -textField.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}
    
    if ([textField isEqual:self.txtAutoState]) {
        [self.view bringSubviewToFront:self.datePickerView];

        [UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.datePickerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
//    if (field.frame.origin.y > 130) {
//		[UIView beginAnimations: @"moveField" context: nil];
//		[UIView setAnimationDelegate: self];
//		[UIView setAnimationDuration: 0.25f];
//		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//		self.view.frame = CGRectMake(0, -field.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
//		[UIView commitAnimations];
//	}
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.25f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [_keyboardControls.activeField resignFirstResponder];
}

- (void) showPickerViewWithTag:(id)sender
{
    //    for (UIView *subView in self.datePickerView.subviews) {
    //        subView.hidden = NO;
    //    }
    [self.view endEditing:YES];
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
    self.datePickerView.hidden = YES;
    
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtPhoneNumber) {
        int length = [self getLength:textField.text];
        //NSLog(@"Length  =  %d ",length);
        
        if(length == 10)
        {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3)
        {
            NSString *num = [self formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6)
        {
            NSString *num = [self formatNumber:textField.text];
            //NSLog(@"%@",[num  substringToIndex:3]);
            //NSLog(@"%@",[num substringFromIndex:3]);
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
        
        return YES;
    }
    
    if ([textField isEqual:self.txtAutoState]) {
        
        NSString *typed = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSLog(@"entered state: %@ - typed: %@", textField.text, typed);
        
//        [self performSelector:@selector(scrollTo)];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSInteger i = 0; i < stateArray.count; i++) {
                @autoreleasepool {
                    NSString *state = [stateArray objectAtIndex:i];
                    if ([state rangeOfString:typed options:NSCaseInsensitiveSearch].location == 0) {
                        
                        NSLog(@"Scroll to index: %d", i);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.statePicker selectRow:i inComponent:0 animated:YES];
                        });
                        break;
                    }
                }
            }
//        });
        
    }
    
    return YES;
}

- (void) scrollTo
{
    NSLog(@"txtState: %@", self.txtAutoState.text);
    
    for (NSInteger i = 0; i < stateArray.count; i++) {
        @autoreleasepool {
            NSString *state = [stateArray objectAtIndex:i];
            if ([state rangeOfString:self.txtAutoState.text options:NSCaseInsensitiveSearch].location == 0) {
                
                NSLog(@"Scroll to index: %d", i);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.statePicker selectRow:i inComponent:0 animated:YES];
                });
                break;
            }
        }
    }
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
    
    
}

@end
