//
//  SignUpViewController.h
//  Digitz
//
//  Created by chuanhd on 4/16/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"

@interface SignUpViewController : UIViewController <ServerManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
- (IBAction)Signup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@end
