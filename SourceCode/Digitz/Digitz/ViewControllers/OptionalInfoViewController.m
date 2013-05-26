//
//  OptionalInfoViewController.m
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "OptionalInfoViewController.h"
#import "EnterYourDigitzViewController.h"
#import "ProfileViewController.h"

NSString * const kPlaceholderPostMessage = @"[Your personal bio]";


@interface OptionalInfoViewController ()
{
    BOOL avatarChanged;
}
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
    
    self.scrllViewFields.contentSize = CGSizeMake(304, 750);
    
    avatarChanged = NO;
    
    
    if ([self.parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        __weak EnterYourDigitzViewController *temp = (EnterYourDigitzViewController *) parentVC;
        self.txtOrganization.text = [temp.paramsDict objectForKey:kKey_UpdateCompany];
        self.txtAddress.text = [temp.paramsDict objectForKey:kKey_UpdateAddress];
        self.txtHomepage.text = [temp.paramsDict objectForKey:kKey_UpdateHomepage];
        self.txtAlterEmail.text = [temp.paramsDict objectForKey:kKey_UpdateAlterEmail];
        self.txtAlterPhoneNo.text = [temp.paramsDict objectForKey:kKey_UpdateAlterPhone];
        self.txtPersonalBio.text = [temp.paramsDict objectForKey:kKey_UpdatePersonalBio];
        
        if ([temp.paramsDict objectForKey:kKey_UpdateAvatar]) {
            [self showAvatarWithUrl:[temp.paramsDict objectForKey:kKey_UpdateAvatar]];
        }
        
    }else if ([self.parentVC isKindOfClass:[ProfileViewController class]]){
        __weak ProfileViewController *temp = (ProfileViewController *) parentVC;
        self.txtOrganization.text = [temp.paramsDict objectForKey:kKey_UpdateCompany];
        self.txtAddress.text = [temp.paramsDict objectForKey:kKey_UpdateAddress];
        self.txtHomepage.text = [temp.paramsDict objectForKey:kKey_UpdateHomepage];
        self.txtAlterEmail.text = [temp.paramsDict objectForKey:kKey_UpdateAlterEmail];
        self.txtAlterPhoneNo.text = [temp.paramsDict objectForKey:kKey_UpdateAlterPhone];
        self.txtPersonalBio.text = [temp.paramsDict objectForKey:kKey_UpdatePersonalBio];
        
        if ([temp.paramsDict objectForKey:kKey_UpdateAvatar]) {
            [self showAvatarWithUrl:[temp.paramsDict objectForKey:kKey_UpdateAvatar]];
        }
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
    [self.imgAvatar addGestureRecognizer:tapGesture];
    [self.imgAvatar setUserInteractionEnabled:YES];
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
    if ([self.parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        __weak EnterYourDigitzViewController *temp = (EnterYourDigitzViewController *) parentVC;
        if (self.txtOrganization.text != nil) {
            [temp.paramsDict setObject:self.txtOrganization.text forKey:kKey_UpdateCompany];
        }
        
        NSLog(@"organization: %@", self.txtOrganization.text);
        
        if (self.txtAddress.text != nil) {
            [temp.paramsDict setObject:self.txtAddress.text forKey:kKey_UpdateAddress];
        }
        
        NSLog(@"txtAddress: %@", self.txtAddress.text);

        
        if (self.txtHomepage.text != nil) {
            [temp.paramsDict setObject:self.txtHomepage.text forKey:kKey_UpdateHomepage];
        }
        
        NSLog(@"txtHomepage: %@", self.txtHomepage.text);

        if (self.txtAlterEmail.text != nil) {
            [temp.paramsDict setObject:self.txtAlterEmail.text forKey:kKey_UpdateAlterEmail];

        }

        NSLog(@"txtAlterEmail: %@", self.txtAlterEmail.text);

        
        if (self.txtAlterPhoneNo.text != nil) {
            [temp.paramsDict setObject:self.txtAlterPhoneNo.text forKey:kKey_UpdateAlterPhone];
        }

        NSLog(@"txtAlterPhoneNo: %@", self.txtAlterPhoneNo.text);
        
        if (self.txtPersonalBio.text != nil) {
            [temp.paramsDict setObject:self.txtPersonalBio.text forKey:kKey_UpdatePersonalBio];
        }

        
        if (avatarChanged) {
            [temp.paramsDict setObject:self.imgAvatar.image forKey:kKey_UpdateImageData];
        }
        
        NSLog(@"txtPersonalBio: %@", self.txtPersonalBio.text);
        
        NSLog(@"paramDict: %@", temp);
        
        temp.optionalInfoFilled = YES;
        
    }else{
        __weak ProfileViewController *temp = (ProfileViewController *) parentVC;
        if (self.txtOrganization.text != nil) {
            [temp.paramsDict setObject:self.txtOrganization.text forKey:kKey_UpdateCompany];
        }
        
        NSLog(@"organization: %@", self.txtOrganization.text);
        
        if (self.txtAddress.text != nil) {
            [temp.paramsDict setObject:self.txtAddress.text forKey:kKey_UpdateAddress];
        }
        
        NSLog(@"txtAddress: %@", self.txtAddress.text);
        
        
        if (self.txtHomepage.text != nil) {
            [temp.paramsDict setObject:self.txtHomepage.text forKey:kKey_UpdateHomepage];
        }
        
        NSLog(@"txtHomepage: %@", self.txtHomepage.text);
        
        if (self.txtAlterEmail.text != nil) {
            [temp.paramsDict setObject:self.txtAlterEmail.text forKey:kKey_UpdateAlterEmail];
            
        }
        
        NSLog(@"txtAlterEmail: %@", self.txtAlterEmail.text);
        
        
        if (self.txtAlterPhoneNo.text != nil) {
            [temp.paramsDict setObject:self.txtAlterPhoneNo.text forKey:kKey_UpdateAlterPhone];
        }
        
        NSLog(@"txtAlterPhoneNo: %@", self.txtAlterPhoneNo.text);
        
        if (self.txtPersonalBio.text != nil) {
            [temp.paramsDict setObject:self.txtPersonalBio.text forKey:kKey_UpdatePersonalBio];
        }
        
        if (avatarChanged) {
            [temp.paramsDict setObject:self.imgAvatar.image forKey:kKey_UpdateImageData];
        }
        
        NSLog(@"txtPersonalBio: %@", self.txtPersonalBio.text);
        
        NSLog(@"paramDict: %@", temp);
        
        temp.optionalInfoFilled = YES;

    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"personalInfoFilled"
     object:self
     userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)avatarTapped:(UITapGestureRecognizer *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick Avatar" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Gallery", nil];
    [actionSheet showInView:self.view];
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
    
    NSLog(@"frame: %f", textField.superview.frame.origin.y);
    
    if (textField.superview.frame.origin.y > 80) {
        CGRect rect = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, self.scrllViewFields.frame.size.width, 575 - textField.superview.frame.origin.y);
        NSLog(@"scroll to rect: %@", NSStringFromCGRect(rect));
        [self.scrllViewFields scrollRectToVisible:rect animated:YES];
    }
}

#pragma mark uitextview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.mKeyboardControls setActiveField:textView];
    
    NSLog(@"frame: %f", textView.frame.origin.y);
    
    if (textView.superview.frame.origin.y > 80) {
        CGRect rect = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, self.scrllViewFields.frame.size.width, self.scrllViewFields.contentSize.height - textView.superview.frame.origin.y);
        NSLog(@"scroll to rect: %@", NSStringFromCGRect(rect));
        [self.scrllViewFields scrollRectToVisible:rect animated:YES];
    }
    
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textField value: %@", textField.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [self resetYourBioTextView];
    }
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
        
//    if (keyboardControls.activeField.frame.origin.y > 80) {
//        CGRect rect = CGRectMake(keyboardControls.activeField.frame.origin.x, keyboardControls.activeField.frame.origin.y + 40, self.scrllViewFields.frame.size.width, self.scrllViewFields.frame.size.height);
//        NSLog(@"scroll to rect: %@", NSStringFromCGRect(rect));
//        [self.scrllViewFields scrollRectToVisible:rect animated:YES];
//    }
    
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

#pragma mark -
#pragma mark Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    }
    if (buttonIndex == 1) {
        [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark -
#pragma mark Image Picker Delegate
- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController
                           availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [mediaTypes count] > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        if ([picker respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self presentModalViewController:picker animated:YES];
        }else{
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device do not support camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    avatarChanged = YES;
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resizeImage = [self imageWithImage:pickedImage scaledToSize:CGSizeMake(160, 160)];
    self.imgAvatar.image = resizeImage;
    if ([picker respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [picker dismissModalViewControllerAnimated:YES];
    }else{
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) showAvatarWithUrl:(NSString *)urlString
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

        NSURL *imageUrl = [NSURL URLWithString:urlString];
        __block NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // update image
            if (imageData != nil) {
                self.imgAvatar.image = [UIImage imageWithData:imageData];
                imageData = nil;
            }
        });
        
        imageUrl = nil;
    });
}

@end
