//
//  ForgotPwdViewController.h
//  Digitz
//
//  Created by chuanhd on 6/17/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPwdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)continueBtnTapped:(id)sender;
- (IBAction)backBtnTapped:(id)sender;
@end
