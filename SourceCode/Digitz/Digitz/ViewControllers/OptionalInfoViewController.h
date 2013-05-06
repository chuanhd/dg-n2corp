//
//  OptionalInfoViewController.h
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@interface OptionalInfoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UITextField *txtOrganization;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtHomepage;

@property (weak, nonatomic) IBOutlet UITextField *txtAlterEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtAlterPhoneNo;
@property (weak, nonatomic) IBOutlet UITextView *txtPersonalBio;

@property (weak, nonatomic) IBOutlet UIScrollView *scrllViewFields;

@property (strong, nonatomic) UIViewController *parentVC;
@property (strong, nonatomic) BSKeyboardControls *mKeyboardControls;

- (IBAction)backBtnTapped:(id)sender;
- (IBAction)saveBtnTapped:(id)sender;


@end
