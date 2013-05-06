//
//  InstagramAuthViewController.m
//  Digitz
//
//  Created by chuanhd on 5/3/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "InstagramAuthViewController.h"
#import "MBProgressHUD.h"
#import "ServerManager.h"

@interface InstagramAuthViewController ()

@end

@implementation InstagramAuthViewController

@synthesize mUrl;

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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mUrl = [self instagramAuthenticationURLString];
    self.oauthWebView.delegate = self;
    
    // load saved url
    if (mUrl) {
        [self.oauthWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: mUrl]]];
        NSLog(@"instagram url: %@", mUrl);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) instagramAuthenticationURLString
{
    // setup auth url
    NSString* baseURL = @"https://api.instagram.com/oauth/authorize/";
    NSString* scope   = @"basic";
    NSString* authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@",
                         baseURL,
                         INSTAGRAM_CLIENT_ID,
                         INSTAGRAM_REDIRECT_URI,
                         scope];
    
    // return url string
    return authURL;
}

#pragma mark UIWebview Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    [self checkRequestForCallbackURL:request];
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Error: %@", error);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    NSLog(@"urlString: %@", urlString);
    
    // check, if auth was succesfull (check for redirect URL)
    if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
    {
        // extract and handle access token
        NSRange range = [urlString rangeOfString: @"code="];
        NSLog(@"range %@", [urlString substringFromIndex:range.location+range.length]);
        //[self handleAuth: [urlString substringFromIndex: range.location+range.length]];
        NSString *code = [urlString substringFromIndex:range.location+range.length];
        
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:INSTAGRAM_OAUTH_URI]];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:INSTAGRAM_CLIENT_ID, @"client_id",
                               INSTAGRAM_CLIENT_SECRET, @"client_secret",@"authorization_code",@"grant_type",INSTAGRAM_REDIRECT_URI, @"redirect_uri", code, @"code", nil];
        
        NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:@"access_token" parameters:params];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSDictionary *result = JSON;
            NSLog(@"sign up json response: %@", result);
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"instagramOAuthViewDidFinish"
             object:self
             userInfo:result];
            
            if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
                [self dismissModalViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
                [self dismissModalViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [operation start];
        
        return NO;
    }
    
    return YES;
}
@end
