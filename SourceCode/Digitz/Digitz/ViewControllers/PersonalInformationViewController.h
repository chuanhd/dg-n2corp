//
//  PersonalInformationViewController.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalInformationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtAge;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtHometown;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;

- (IBAction)touchBtnMale:(id)sender;
- (IBAction)touchBtnFemale:(id)sender;
- (IBAction)touchBtnSave:(id)sender;
- (IBAction)touchBtnBack:(id)sender;
- (IBAction)touchBackground:(id)sender;

@end
