//
//  ServerManager.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//
//

#import "ServerManager.h"
#import "JSONKit.h"
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
        [userDefault setObject:[result objectForKey:@"token"] forKey:kKey_UserToken];
        [userDefault setObject:[result objectForKey:@"user"] forKey:@"username"];
        [userDefault synchronize];
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

- (void)signUpwithParamsDict:(NSDictionary *)_paramsDict
{
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_SIGNUP parameters:_paramsDict];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        NSLog(@"sign up json response: %@", result);
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[result objectForKey:@"token"] forKey:kKey_UserToken];
        [userDefault setObject:[result objectForKey:@"user"] forKey:@"username"];
        [userDefault synchronize];
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
                [userDefault setObject:[result objectForKey:@"token"] forKey:kKey_UserToken];
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

- (void)updateUserInformationWithParams: (NSDictionary *)params {
    
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if ([params objectForKey:kKey_UserToken] == nil) {
        NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
        [mutableParams setObject:auth_token forKey:kKey_UserToken];
    }
    
    NSLog(@"params: %@", mutableParams);

    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_UPDATE_USER_INFO parameters:mutableParams];
    request.timeoutInterval = TIME_OUT;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        NSLog(@"json update user info: %@", result);
        User *newUser = nil;
        if ([[result objectForKey:@"success"] boolValue]) {
            NSDictionary *userDic = [result objectForKey:@"user"];
            newUser = [self userFromDictionary:userDic];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(updateUserInformationWithParamsSuccess:)]) {
            [_delegate performSelector:@selector(updateUserInformationWithParamsSuccess:) withObject:newUser];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateUserInformationWithParamsFailedWithError:)]) {
            [_delegate performSelector:@selector(updateUserInformationWithParamsFailedWithError:) withObject:error];
        }
    }];
    [operation start];
}

- (User *)userFromDictionary: (NSDictionary *)userDic {
    User *newUser = [[User alloc] init];
    newUser.username = [userDic objectForKey:@"username"];
    newUser.name = [userDic objectForKey:@"name"];
    newUser.email = [userDic objectForKey:@"email"];
    //newUser.age = [userDic objectForKey:@"age"];
    newUser.phoneNumber = [userDic objectForKey:@"phone_number"];
    newUser.hometown = [userDic objectForKey:@"hometown"];
    if ([userDic objectForKey:@"gender"] != [NSNull null]) {
        if ([[userDic objectForKey:@"gender"] isEqualToString:@"male"]) {
            newUser.gender = MALE;
        }else{
            newUser.gender = FEMALE;
        }
    }else{
        newUser.gender = MALE;
    }
    newUser.userId = [userDic objectForKey:@"id"];
    //newUser.facebook_id = [userDic objectForKey:@"facebook_id"];
    //newUser.facebook_token = [userDic objectForKey:@"facebook_token"];
    //newUser.games_count = ([userDic objectForKey:@"games_count"] != (id)[NSNull null]) ? [[userDic objectForKey:@"games_count"] integerValue] : -1;
    //newUser.device_udid = [userDic objectForKey:@"device_udid"];
    //newUser.avatar = [userDic objectForKey:@"avatar"];
    
    return newUser;
}

- (void)getUserInfoWithToken:(NSString *)token
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token, @"auth_token", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"GET" path:PATH_GET_USER_INFO parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSDictionary *result = JSON;
        NSLog(@"json update user info: %@", result);
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        if (status) {
            switch (status) {
                case 1: {
                    NSString *error = [result objectForKey:@"error"];
                    [details setObject:error forKey:NSLocalizedDescriptionKey];
                    NSError *err = [NSError errorWithDomain:error code:2000 userInfo:details];
                    if (_delegate && [_delegate respondsToSelector:@selector(getUserInformationFailedWithError:)]) {
                        [_delegate performSelector:@selector(getUserInformationFailedWithError:) withObject:err];
                    }
                    break;
                }
            }
        }else{
            User *newUser = nil;
            newUser = [self userFromDictionary:result];
            if (_delegate && [_delegate respondsToSelector:@selector(getUserInformationSuccessWithUser:)]) {
                [_delegate performSelector:@selector(getUserInformationSuccessWithUser:) withObject:newUser];
            }
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(getUserInformationFailedWithError:)]) {
            [_delegate performSelector:@selector(getUserInformationFailedWithError:) withObject:error];
        }
    }];
    
    [operation start];
}

- (void)findNearByFriendsWithToken:(NSString *)token
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token, @"auth_token", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"GET" path:PATH_FIND_FRIENDS parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSDictionary *result = JSON;
        NSLog(@"json update user info: %@", result);
        
        NSArray *users = [result objectForKey:@"users"];
        NSLog(@"users: %d", users.count);
        NSMutableArray *usersArray = [NSMutableArray array];
        for (NSDictionary *user in users) {
            //NSLog(@"user: %@", user);
            @autoreleasepool {
                User *_user = [self userFromDictionary:user];
                [usersArray addObject:_user];
            }
        }
        
        users = nil;
        
        if (_delegate && [_delegate respondsToSelector:@selector(findNearByFriendsSuccessWithArray:)]) {
            [_delegate performSelector:@selector(findNearByFriendsSuccessWithArray:) withObject:usersArray];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(findNearByFriendFailWithError:)]) {
            [_delegate performSelector:@selector(findNearByFriendFailWithError:) withObject:error];
        }
    }];
    
    [operation start];
}

@end
