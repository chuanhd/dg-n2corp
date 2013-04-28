//
//  PersonalInfo.m
//  Digitz
//
//  Created by chuanhd on 4/27/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "PersonalInfo.h"

@interface PersonalInfo ()
{
    NSArray *fields;
}
@end

static NSString *gender = @"male";
static NSArray *stateArray;

@implementation PersonalInfo

@synthesize serverManager;
//@synthesize mKeyboardControls;

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
    
    self.txtName.delegate = self;
    self.txtName.enabled = YES;
    self.txtBirthday.delegate = self;
    self.txtPhoneNumber.delegate = self;
    self.txtEmail.delegate = self;
    self.txtCity.delegate = self;
    self.txtState.delegate = self;
    
    self.serverManager = [[ServerManager alloc] init];
    self.serverManager.delegate = self;
    
    stateArray = [NSArray arrayWithObjects:@"Hawaii", @"New York", @"Washington DC", @"Nevada", nil];
    self.statePicker.dataSource = self;
    self.statePicker.delegate = self;
        
    fields = @[self.txtName, self.txtBirthday, self.txtPhoneNumber, self.txtEmail, self.txtCity, self.txtState];
//    [self setMKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
//    [self.mKeyboardControls setDelegate:self];
    //self.mKeyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    //self.mKeyboardControls.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{    
    self.txtName.text = [self.parentVC.paramsDict objectForKey:kKey_UpdateName];
    self.txtBirthday.text = [self.parentVC.paramsDict objectForKey:kKey_UpdateBirthday];
    self.txtEmail.text = [self.parentVC.paramsDict objectForKey:kKey_UpdateEmail];
    self.txtCity.text = [self.parentVC.paramsDict objectForKey:kKey_UpdateHometown];
    if ([[self.parentVC.paramsDict objectForKey:kKey_UpdateGender] isEqualToString:@"male"]) {
        [self.btnMale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
        [self.btnFemale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
        gender = @"male";
    }else{
        [self.btnMale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
        [self.btnFemale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
        gender = @"female";
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtBirthday:nil];
    [self setTxtPhoneNumber:nil];
    [self setTxtEmail:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setBtnMale:nil];
    [self setBtnFemale:nil];
    [self setDatePicker:nil];
    [self setStatePicker:nil];
    [self setPickerView:nil];
    [self setKeyboardToolbar:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

}

- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)maleBtnPressed:(id)sender {
    [self.btnMale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
    [self.btnFemale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
    gender = @"male";
}

- (IBAction)femaleBtnPressed:(id)sender {
    [self.btnFemale setImage:[UIImage imageNamed:@"icon-check-box"] forState:UIControlStateNormal];
    [self.btnMale setImage:[UIImage imageNamed:@"icon-uncheck-box"] forState:UIControlStateNormal];
    gender = @"female";
}

- (IBAction)saveBtnPressed:(id)sender {
    self.serverManager.delegate = self;
    
    //    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    //    NSString *token = [df objectForKey:kKey_UserToken];
    
    if (self.txtName.text.length == 0 || self.txtBirthday.text.length == 0 || self.txtPhoneNumber.text.length == 0 || self.txtEmail.text.length == 0 || self.txtCity.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must fill all required fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //[self.parentVC.paramsDict setObject:token forKey:kKey_UserToken];
    
    [self.parentVC.paramsDict setObject:self.txtBirthday.text forKey:kKey_UpdateBirthday];
    [self.parentVC.paramsDict setObject:self.txtEmail.text forKey:kKey_UpdateEmail];
    [self.parentVC.paramsDict setObject:self.txtCity.text forKey:kKey_UpdateHometown];
    [self.parentVC.paramsDict setObject:self.txtPhoneNumber.text forKey:kKey_UpdatePhone];
    [self.parentVC.paramsDict setObject:gender forKey:kKey_UpdateGender];
    
    self.parentVC.personalInfoFilled = YES;
    
    //    [self.serverManager updateUserInformationWithParams:dic];
    //
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptBtnPressed:(id)sender {
    NSDate *dateFromPicker = self.datePicker.date;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //[formater setDateFormat:@"yyyy-MM-dd"];
    [formater setDateFormat:@"MM-dd-yyyy"];
    self.txtBirthday.text = [formater stringFromDate:dateFromPicker];
    self.pickerView.hidden = YES;
}

- (NSInteger) getIndexOfTextFieldIsEditting
{
    for (NSInteger i = 0; i < fields.count; i++) {
        @autoreleasepool {
            UITextField *textField = [fields objectAtIndex:i];
            if ([textField isEditing]) {
                return i;
            }
        }
    }
    return -1;
}

- (IBAction)prevFieldTapped:(id)sender {
    @autoreleasepool {
        NSInteger i = [self getIndexOfTextFieldIsEditting];
        if (i != -1) {
            UITextField *current = [fields objectAtIndex:i];
            [current resignFirstResponder];
            NSInteger j = i - 1;
            if (j < 0) {
                j = fields.count - 1;
            }
            UITextField *prev = [fields objectAtIndex:j];
            [prev becomeFirstResponder];
        }
    }
}

- (IBAction)nextFieldTapped:(id)sender {
    @autoreleasepool {
        NSInteger i = [self getIndexOfTextFieldIsEditting];
        if (i != -1) {
            UITextField *current = [fields objectAtIndex:i];
            [current becomeFirstResponder];
//            NSInteger j = i + 1;
//            if (j > fields.count - 1) {
//                j = 0;
//            }
//            UITextField *prev = [fields objectAtIndex:j];
//            [prev becomeFirstResponder];
        }
    }
}

- (IBAction)closeKeyboardTapped:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
    });
}


- (void) showPickerViewWithTag:(id)sender
{
    [self.view endEditing:YES];
    UITextField *textField = (UITextField *) sender;
    [textField resignFirstResponder];
    
    if ([textField isEqual:self.txtBirthday]) {
        self.datePicker.hidden = NO;
        self.statePicker.hidden = YES;
    }else if ([textField isEqual:self.txtState])
    {
        self.datePicker.hidden = YES;
        self.statePicker.hidden = NO;
    }
    
    self.pickerView.hidden = NO;
}

#pragma mark -
#pragma mark Text Field Delegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    NSLog(@"textField should begin editting");
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textField did begin editting");
//    //    [self.mKeyboardControls setActiveField:textField];
//    textField.inputAccessoryView = self.keyboardToolbar;
//    
//    if ([textField isEqual:self.txtBirthday]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.view endEditing:YES];
//            [self showPickerViewWithTag:textField];
//            //[self.keyboardControls.activeField resignFirstResponder];
//            //[self keyboardControlsDonePressed:self.keyboardControls];
//            //self.keyboardControls.hidden = YES;
//        });
//        
//        return;
//        
//    }
//    
//    if ([textField isEqual:self.txtState]) {
//        [textField resignFirstResponder];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.view endEditing:YES];
//            [self showPickerViewWithTag:textField];
//            //[self.keyboardControls.activeField resignFirstResponder];
//            //[self keyboardControlsDonePressed:self.keyboardControls];
//            //self.keyboardControls.hidden = YES;
//        });
//        return;
//    }
//    
//    
//    NSLog(@"textField %f", textField.frame.origin.y);
//    if (textField.superview.frame.origin.y > 180) {
//		[UIView beginAnimations: @"moveField" context: nil];
//		[UIView setAnimationDelegate: self];
//		[UIView setAnimationDuration: 0.25f];
//		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//		self.view.frame = CGRectMake(0, -textField.superview.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
//		[UIView commitAnimations];
//	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.25f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
	[self textFieldShouldReturn:textField];
    //    [self.mKeyboardControls.activeField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Text View Delegate

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    //    [self.mKeyboardControls setActiveField:textView];
//}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    //UIView *view = mKeyboardControls.activeField.superview.superview;
    //[self.view scrollRectToVisible:view.frame animated:YES];
    
    if (field.frame.origin.y > 160) {
		[UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.view.frame = CGRectMake(0, -field.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.25f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [keyboardControls.activeField resignFirstResponder];
    
}

#pragma mark
#pragma mark Picker view delegate and datasource
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
    
    return NO;
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
