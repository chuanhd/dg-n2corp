//
//  LoginViewController.h
//  Digitz
//
//  Created by chuanhd on 4/16/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"

@interface LoginViewController : UIViewController <ServerManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginButtonTapped:(id)sender;
@end
