//
//  ServerManager.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//
//

#import "ServerManager.h"
#define TIME_OUT 30

@implementation ServerManager

static id sharedReactor = nil;

+(id)sharedInstance {
    if(sharedReactor == nil) sharedReactor = [[super allocWithZone:NULL] init];
    return sharedReactor;
}

@synthesize delegate = _delegate;

- (id)init {
    if (self = [super init]) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    }
    return self;
}

- (void)signUpWithUsername: (NSString *)username
               andPassword: (NSString *)password
                  andEmail: (NSString *)email {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", email, @"email", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_SIGNUP parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        NSLog(@"sign up json response: %@", result);
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[result objectForKey:@"token"] forKey:@"token"];
        [userDefault setObject:[result objectForKey:@"user"] forKey:@"username"];
        switch (status) {
            case 0:
                if (_delegate && [_delegate respondsToSelector:@selector(signUpSuccess)]) {
                    [_delegate performSelector:@selector(signUpSuccess)];
                }
                break;
            case 1:
            {
                NSError *error = nil;
                NSDictionary *details = [[NSDictionary alloc] initWithObjectsAndKeys:@"Email is invalid or already taken.", NSLocalizedDescriptionKey, nil];
                error = [NSError errorWithDomain:@"Email is invalid or already taken." code:2001 userInfo:details];
                if (_delegate && [_delegate respondsToSelector:@selector(signUpFailedWithError:)]) {
                    [_delegate performSelector:@selector(signUpFailedWithError:) withObject:error];
                }
                break;
            }
            default: {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setObject:@"Have a problem about service" forKey:NSLocalizedDescriptionKey];
                NSError *err = [NSError errorWithDomain:@"Have a problem about service" code:2000 userInfo:details];
                if (_delegate && [_delegate respondsToSelector:@selector(signUpFailedWithError:)]) {
                    [_delegate performSelector:@selector(signUpFailedWithError:) withObject:err];
                }
                break;
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (_delegate && [_delegate respondsToSelector:@selector(signUpFailedWithError:)]) {
            [_delegate performSelector:@selector(signUpFailedWithError:) withObject:error];
        }
    }];
    [operation start];
}

- (void)signInWithUsername: (NSString *)username andPassword: (NSString *)password {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *dvToken = [userDefault objectForKey:@"deviceToken"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", dvToken, @"user[device_udid]", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_SIGNIN parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        NSLog(@"login json response: %@", result);
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        switch (status) {
            case 0: {
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[result objectForKey:@"token"] forKey:@"token"];
                [userDefault setObject:[result objectForKey:@"user"] forKey:@"username"];
                if (_delegate && [_delegate respondsToSelector:@selector(signInSuccess)]) {
                    [_delegate performSelector:@selector(signInSuccess)];
                }
                break;
            }
                
            case 1: {
                [details setObject:@"Invalid username" forKey:NSLocalizedDescriptionKey];
                NSError *err = [NSError errorWithDomain:@"Invalid username" code:2000 userInfo:details];
                if (_delegate && [_delegate respondsToSelector:@selector(signInFailedWithError:)]) {
                    [_delegate performSelector:@selector(signInFailedWithError:) withObject:err];
                }
                break;
            }
            case 2:
            {
                [details setObject:@"Invalid password" forKey:NSLocalizedDescriptionKey];
                NSError *err = [NSError errorWithDomain:@"Invalid password" code:2000 userInfo:details];
                if (_delegate && [_delegate respondsToSelector:@selector(signInFailedWithError:)]) {
                    [_delegate performSelector:@selector(signInFailedWithError:) withObject:err];
                }
                break;
            }
                
            default: {
                [details setObject:@"Have a problem about service" forKey:NSLocalizedDescriptionKey];
                NSError *err = [NSError errorWithDomain:@"Have a problem about service" code:2000 userInfo:details];
                if (_delegate && [_delegate respondsToSelector:@selector(signInFailedWithError:)]) {
                    [_delegate performSelector:@selector(signInFailedWithError:) withObject:err];
                }
                break;
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (_delegate && [_delegate respondsToSelector:@selector(signInFailedWithError:)]) {
            [_delegate performSelector:@selector(signInFailedWithError:) withObject:error];
        }
    }];
    [operation start];
}

@end
