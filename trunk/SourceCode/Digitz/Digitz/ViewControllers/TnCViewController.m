//
//  TnCViewController.m
//  Digitz
//
//  Created by chuanhd on 6/9/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "TnCViewController.h"
#import "MBProgressHUD.h"
#import "EnterYourDigitzViewController.h"
#import "ProfileViewController.h"

@interface TnCViewController ()

@end

@implementation TnCViewController

@synthesize parentVC;

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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"termcondition" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:plistPath];
    [self.webTnC loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptBtnTapped:(id)sender {
    if ([self.parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        __weak EnterYourDigitzViewController *temp = (EnterYourDigitzViewController *) self.parentVC;
        temp.agreeTermAndCondition = YES;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"personalInfoFilled"
         object:self
         userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];

    }else if ([self.parentVC isKindOfClass:[ProfileViewController class]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have already accepted terms and conditions" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
