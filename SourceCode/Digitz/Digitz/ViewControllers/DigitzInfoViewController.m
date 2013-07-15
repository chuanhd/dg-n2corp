//
//  DigitzInfoViewController.m
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "DigitzInfoViewController.h"
#import <MessageUI/MessageUI.h>

@interface DigitzInfoViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation DigitzInfoViewController

@synthesize user = _user;

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
    
    //self.title = @"Digitz";
    self.tabBarItem.image = [UIImage imageNamed:@"icon-social-profile-white.png"];
    self.uiscrollview.contentSize = CGSizeMake(320, 930);
    
    self.lblAlterEmail.text = ![_user.emailHome isEqual:[NSNull null]] ? _user.emailHome : @"N/A";
    self.lblHomepage.text = ![_user.homepage isEqual:[NSNull null]] ? _user.homepage : @"N/A";
    self.lblEmail.text = ![_user.email isEqual:[NSNull null]] ? _user.email : @"N/A";
    self.lblAlterPhoneNo.text = ![_user.phoneHome isEqual:[NSNull null]] ? _user.phoneHome : @"N/A";
    self.lblBirthday.text = ![_user.birthday isEqual:[NSNull null]] ? _user.birthday : @"N/A";
    self.lblGender.text = _user.gender == 1 ? @"male" : @"female";
    self.lblHomeAddr.text = ![_user.address isEqual:[NSNull null]] ? _user.address : @"N/A";
    self.lblHometown.text = ![_user.hometown isEqual:[NSNull null]] ? _user.hometown : @"N/A";
    self.lblMobilePhone.text = ![_user.phoneNumber isEqual:[NSNull null]] ? _user.phoneNumber : @"N/A";
    self.lblOrganization.text = ![_user.company isEqual:[NSNull null]] ? _user.company : @"N/A";
    self.lblPersonalBio.text = ![_user.bio isEqual:[NSNull null]] ? _user.bio : @"N/A";
    
    if (_user.avatarUrl != nil && ![_user.avatarUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageUrl = [NSURL URLWithString:_user.avatarUrl];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
}

- (IBAction)callBtnTapped:(id)sender {
    
    NSMutableString *phoneNumber = [NSMutableString stringWithString:_user.phoneNumber];
    
    [phoneNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, phoneNumber.length)];
    [phoneNumber replaceOccurrencesOfString:@")" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, phoneNumber.length)];
    [phoneNumber replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, phoneNumber.length)];
    [phoneNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, phoneNumber.length)];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
    
    NSLog(@"call url: %@", url);
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)mailBtnTapped:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        
         MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
         mailer.mailComposeDelegate = self;
//         [mailer setSubject:@"A Message from MobileTuts+"];
         NSArray *toRecipients = [NSArray arrayWithObjects:_user.email, nil];
         [mailer setToRecipients:toRecipients];
//         UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
//         NSData *imageData = UIImagePNGRepresentation(myImage);
//         [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
//         NSString *emailBody = @"Have you seen the MobileTuts+ web site?";
//         [mailer setMessageBody:emailBody isHTML:NO];

        mailer.mailComposeDelegate = self;
        
        if ([self respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self presentModalViewController:mailer animated:YES];
        }else{
            [self presentViewController:mailer animated:YES completion:NULL];
        }
        
        //NSString *pre = @"mailto:?subject=[BaoNet Iphone]&body=";

        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if ([controller respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [controller dismissModalViewControllerAnimated:YES];
    }else{
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)smsBtnTapped:(id)sender {
    
    if([MFMessageComposeViewController canSendText])
	{
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
		controller.recipients = [NSArray arrayWithObjects:_user.phoneNumber, nil];
		controller.messageComposeDelegate = self;

        if ([self respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [self presentModalViewController:controller animated:YES];
        }else{
            [self presentViewController:controller animated:YES completion:NULL];
        }
        
        /*
         NSString *pre = @"sms:12345678";
         pre = [pre stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
         NSURL *url = [NSURL URLWithString:pre];
         [[UIApplication sharedApplication] openURL:url];
         //[[UIApplication sharedApplication] openURL: @"sms:12345678"];
         */
	}else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot send your sms" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
        }
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
    if ([controller respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [controller dismissModalViewControllerAnimated:YES];
    }else{
        [controller dismissViewControllerAnimated:YES completion:NULL];
    }
}



@end
