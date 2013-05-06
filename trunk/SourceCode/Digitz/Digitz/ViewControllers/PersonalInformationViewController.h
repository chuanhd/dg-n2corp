//
//  PersonalInformationViewController.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "EnterYourDigitzViewController.h"
#import "BSKeyboardControls.h"

@interface PersonalInformationViewController : UIViewController <UITextFieldDelegate, ServerManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BSKeyboardControlsDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtAge;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtHometown;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtState;

@property (strong, nonatomic) ServerManager *serverManager;
//@property (strong, nonatomic) EnterYourDigitzViewController *parentVC;
@property (strong, nonatomic) UIViewController *parentVC;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;

- (IBAction)touchBtnMale:(id)sender;
- (IBAction)touchBtnFemale:(id)sender;
- (IBAction)touchBtnSave:(id)sender;
- (IBAction)touchBtnBack:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)closeDatePickerTapped:(id)sender;

@end
