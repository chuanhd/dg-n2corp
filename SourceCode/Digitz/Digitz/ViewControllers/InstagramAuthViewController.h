//
//  InstagramAuthViewController.h
//  Digitz
//
//  Created by chuanhd on 5/3/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#define INSTAGRAM_CLIENT_ID     @"f70dfc5002654cc7839710b1ada36493"
#define INSTAGRAM_CLIENT_SECRET @"b51c74f0db85433bb5f25558100a9b4a"
#define INSTAGRAM_REDIRECT_URI  @"digitzinsta://auth"
#define INSTAGRAM_OAUTH_URI @"https://api.instagram.com/oauth/"

#define KEYCHAIN_AUTH_TOKEN_USER_KEY     @"KEYCHAIN_AUTH_TOKEN_USER_KEY"
#define KEYCHAIN_AUTH_TOKEN_SERVICE_KEY  @"KEYCHAIN_AUTH_TOKEN_SERVICE_KEY"

@interface InstagramAuthViewController : UIViewController <UIWebViewDelegate>
{
    AFHTTPClient *_httpClient;
}
@property (strong, nonatomic) NSString *mUrl;

@property (weak, nonatomic) IBOutlet UIWebView *oauthWebView;

@end
