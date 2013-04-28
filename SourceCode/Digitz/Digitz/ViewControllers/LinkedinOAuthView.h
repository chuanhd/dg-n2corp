//
//  LinkedinOAuthView.h
//  Digitz
//
//  Created by chuanhd on 4/25/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@interface LinkedinOAuthView : UIView
{
    NSDictionary *profile;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
    OAConsumer *consumer;
}

@property(nonatomic, retain) OAToken *requestToken;
@property(nonatomic, retain) OAToken *accessToken;
@property(nonatomic, retain) NSDictionary *profile;

@property (weak, nonatomic) IBOutlet UIWebView *OAuthWebView;
- (IBAction)closeBtnTapped:(id)sender;

- (void) startOAuth;
- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;
- (void)testApiCall;

@end
