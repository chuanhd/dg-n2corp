//
//  ServerManager.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#define BASE_URL @"http://free-my-monkey-backend.herokuapp.com/"
#define PATH_SIGNIN @"api/users/sign_in"
#define PATH_SIGNUP @"api/users/sign_up"

@protocol ServerManagerDelegate <NSObject>

@optional

// signUp
- (void)signUpFailedWithError: (NSError *)error;
- (void)signUpSuccess;

// signIn
- (void)signInFailedWithError: (NSError *)error;
- (void)signInSuccess;
@end

@interface ServerManager : NSObject
{
    __weak id<ServerManagerDelegate> _delegate;
    AFHTTPClient *_httpClient;
}

@property (weak, nonatomic) id<ServerManagerDelegate> delegate;

+(id)sharedInstance;

- (void)signUpWithUsername: (NSString *)username
               andPassword: (NSString *)password
                  andEmail: (NSString *)email;

- (void)signInWithUsername: (NSString *)username andPassword: (NSString *)password;

@end
