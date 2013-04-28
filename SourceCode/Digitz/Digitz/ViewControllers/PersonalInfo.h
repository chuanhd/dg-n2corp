//
//  PersonalInfo.h
//  Digitz
//
//  Created by chuanhd on 4/27/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "EnterYourDigitzViewController.h"
#import "BSKeyboardControls.h"

@interface PersonalInfo : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ServerManagerDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;


@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) EnterYourDigitzViewController *parentVC;
//@property (strong, nonatomic) BSKeyboardControls *mKeyboardControls;


- (IBAction)backBtnPressed:(id)sender;
- (IBAction)maleBtnPressed:(id)sender;
- (IBAction)femaleBtnPressed:(id)sender;
- (IBAction)saveBtnPressed:(id)sender;
- (IBAction)acceptBtnPressed:(id)sender;
- (IBAction)prevFieldTapped:(id)sender;

- (IBAction)nextFieldTapped:(id)sender;
- (IBAction)closeKeyboardTapped:(id)sender;




@end
