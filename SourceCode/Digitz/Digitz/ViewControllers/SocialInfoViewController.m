//
//  SocialInfoViewController.m
//  Digitz
//
//  Created by chuanhd on 5/23/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "SocialInfoViewController.h"
#import "DigitzUtils.h"

@interface SocialInfoViewController ()

@end

@implementation SocialInfoViewController

@synthesize tag = _tag;
@synthesize socialLink = _socialLink;

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
    
    if ([_tag isEqualToString:@"facebook"]) {
        self.tabBarItem.image = [UIImage imageNamed:@"icon-social-fb-white.png"];
    }else if ([_tag isEqualToString:@"google"]){
        self.tabBarItem.image = [UIImage imageNamed:@"icon-social-gg-white.png"];
    }else if ([_tag isEqualToString:@"twitter"]){
        self.tabBarItem.image = [UIImage imageNamed:@"icon-social-tw-white.png"];
    }else if ([_tag isEqualToString:@"linkedin"]){
        self.tabBarItem.image = [UIImage imageNamed:@"icon-social-lnk-white.png"];
        //self.title = @"Linkedin";
        //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Linkedin" image:[UIImage imageNamed:@"icon-social-lnk-white.png"] tag:5];
    }else if ([_tag isEqualToString:@"instagram"]){
        self.tabBarItem.image = [UIImage imageNamed:@"icon-social-ins-white.png"];
        //self.title = @"Instagram";
    }
    
    self.webViewSocialNetwork.delegate = self;
    if(self.socialLink != nil){
        NSURL *socialUrl = [NSURL URLWithString:self.socialLink];
        NSURLRequest *request = [NSURLRequest requestWithURL:socialUrl];
        [self.webViewSocialNetwork loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Loading"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Load fail with error %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
