//
//  OptionalInfoViewController.m
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "OptionalInfoViewController.h"

NSString * const kPlaceholderPostMessage = @"[Your personal bio]";


@interface OptionalInfoViewController ()

@end

@implementation OptionalInfoViewController

@synthesize parentVC;
@synthesize mKeyboardControls;


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
    
    NSArray *fields = [NSArray arrayWithObjects:self.txtOrganization, self.txtAddress, self.txtHomepage, self.txtAlterEmail, self.txtAlterPhoneNo, self.txtPersonalBio, nil];
    
    self.txtOrganization.delegate = self;
    self.txtAddress.delegate = self;
    self.txtHomepage.delegate = self;
    self.txtAlterEmail.delegate = self;
    self.txtAlterPhoneNo.delegate = self;
    self.txtPersonalBio.delegate = self;
    
    self.mKeyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    self.mKeyboardControls.delegate = self;
    
    self.scrllViewFields.contentSize = CGSizeMake(304, 550);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnTapped:(id)sender {
}

- (void) resetYourBioTextView
{
    self.txtPersonalBio.text = kPlaceholderPostMessage;
    self.txtPersonalBio.textColor = [UIColor lightGrayColor];
}

#pragma mark uitextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.mKeyboardControls setActiveField:textField];
}

#pragma mark uitextview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.mKeyboardControls setActiveField:textView];
    
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [self resetYourBioTextView];
    }
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    
    NSLog(@"frame: %f", keyboardControls.activeField.frame.origin.y);
    
    if (keyboardControls.activeField.frame.origin.y > 100) {
        CGRect rect = CGRectMake(keyboardControls.activeField.frame.origin.x, keyboardControls.activeField.frame.origin.y - 25, self.scrllViewFields.frame.size.width, self.scrllViewFields.frame.size.height);
        NSLog(@"scroll to rect: %@", NSStringFromCGRect(rect));
        [self.scrllViewFields scrollRectToVisible:rect animated:YES];
    }
    
    //UIView *view = keyboardControls.activeField.superview;
    //[self.scrllViewFields scrollRectToVisible:keyboardControls.activeField.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
    
    if ([keyboardControls.activeField isKindOfClass:[UITextView class]]) {
        if ([((UITextView *) keyboardControls.activeField).text isEqualToString:@""]) {
            [self resetYourBioTextView];
        }
    }
}

@end
