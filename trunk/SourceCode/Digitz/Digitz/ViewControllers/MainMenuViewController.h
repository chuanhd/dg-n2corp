//
//  MainMenuViewController.h
//  Digitz
//
//  Created by chuanhd on 4/16/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "BSKeyboardControls.h"

@interface MainMenuViewController : UIViewController <ServerManagerDelegate, UITextFieldDelegate, BSKeyboardControlsDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;

- (IBAction)loginButtonTapped:(id)sender;
- (IBAction)signupButtonTapped:(id)sender;

@end
