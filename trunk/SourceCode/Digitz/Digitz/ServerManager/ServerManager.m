//
//  ServerManager.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//
//

#import "ServerManager.h"
#import "JSONKit.h"
#import "DigitzUtils.h"
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
        [userDefault setObject:[result objectForKey:@"available"] forKey:kKey_UpdateAvailable];
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
    NSString *dvToken = [userDefault objectForKey:kKey_DeviceToken];
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
                [userDefault setObject:[result objectForKey:@"available"] forKey:kKey_UpdateAvailable];
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
                NSError *err = [NSError errorWithDomain:@"Invalid password" code:2001 userInfo:details];
                if (_delegate && [_delegate respondsToSelector:@selector(signInFailedWithError:)]) {
                    [_delegate performSelector:@selector(signInFailedWithError:) withObject:err];
                }
                break;
            }
                
            default: {
                [details setObject:@"Have a problem about service" forKey:NSLocalizedDescriptionKey];
                NSError *err = [NSError errorWithDomain:@"Have a problem about service" code:2002 userInfo:details];
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
    
    NSMutableURLRequest *request;
    
    if ([params objectForKey:kKey_UpdateImageData] != nil) {
        UIImage *image = [params objectForKey:kKey_UpdateImageData];
        NSData *imageData = UIImagePNGRepresentation(image);
        [mutableParams removeObjectForKey:kKey_UpdateImageData];
        request = [_httpClient multipartFormRequestWithMethod:@"POST" path:PATH_UPDATE_USER_INFO parameters:mutableParams constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"user[avatar]" fileName:@"user[avatar]" mimeType:@"user[avatar]"];
            //[formData appendPartWithFormData:imageData name:@"user[avatar]"];
        }];
    }else{
        request = [_httpClient requestWithMethod:@"POST" path:PATH_UPDATE_USER_INFO parameters:mutableParams];
    }
    
    
    NSLog(@"params: %@", mutableParams);

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
    if ([userDic objectForKey:@"id"] != nil) {
        newUser.avatarUrl = [userDic objectForKey:@"id"];
    }else{
        if ([userDic objectForKey:@"_id"] != nil) {
            newUser.avatarUrl = [userDic objectForKey:@"_id"];
        }
    }
    newUser.birthday = [userDic objectForKey:@"birthday"];
    
    NSLog(@"facebookUrl: %@", [userDic objectForKey:@"facebook_url"]);
    
    newUser.facebookUrl = [userDic objectForKey:@"facebook_url"];
    newUser.googleUrl = [userDic objectForKey:@"google_plus_url"];
    newUser.twitterUrl = [userDic objectForKey:@"twitter_url"];
    newUser.linkedinUrl = [userDic objectForKey:@"linkedin_url"];
    newUser.instagramUrl = [userDic objectForKey:@"instagram_url"];

    newUser.available = [[userDic objectForKey:@"available"] integerValue] == 1 ? YES : NO;
    
    //newUser.facebook_id = [userDic objectForKey:@"facebook_id"];
    //newUser.facebook_token = [userDic objectForKey:@"facebook_token"];
    //newUser.games_count = ([userDic objectForKey:@"games_count"] != (id)[NSNull null]) ? [[userDic objectForKey:@"games_count"] integerValue] : -1;
    //newUser.device_udid = [userDic objectForKey:@"device_udid"];
    if ([userDic objectForKey:@"avatar"] != nil) {
        newUser.avatarUrl = [userDic objectForKey:@"avatar"];
    }else{
        if ([userDic objectForKey:@"avatar_url"] != nil) {
            newUser.avatarUrl = [userDic objectForKey:@"avatar_url"];
        }
    }
    newUser.state = [userDic objectForKey:@"state"];
    newUser.company = [userDic objectForKey:@"company"];
    newUser.address = [userDic objectForKey:@"address"];
    newUser.homepage = [userDic objectForKey:@"homepage"];
    newUser.emailHome = [userDic objectForKey:@"email_home"];
    newUser.emailWork = [userDic objectForKey:@"email_work"];
    newUser.cellPhone = [userDic objectForKey:@"cell_phone"];
    newUser.phoneHome = [userDic objectForKey:@"home_phone"];
    newUser.phoneWork = [userDic objectForKey:@"work_phone"];
    newUser.bio = [userDic objectForKey:@"bio"];
    
    newUser.priAcc = [DigitzUtils splitString:[userDic objectForKey:@"privacy_a"] withSeparator:@","];
    newUser.priBus = [DigitzUtils splitString:[userDic objectForKey:@"privacy_b"] withSeparator:@","];
    newUser.priFri = [DigitzUtils splitString:[userDic objectForKey:@"privacy_f"] withSeparator:@","];
    
    return newUser;
}

- (void)getUserInfoWithToken:(NSString *)token
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token, @"auth_token", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"GET" path:PATH_GET_USER_INFO parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSDictionary *result = JSON;
        NSLog(@"get user info: %@", result);
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
        NSLog(@"find near by: %@", result);
        
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

- (void)sendFriendRequestWithUserId:(NSString *)userId withType:(NSString *)type
{
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", userId, @"receiver_id", type, @"type", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_SEND_FRIEND_REQ parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSDictionary *result = (NSDictionary *) JSON;
        NSLog(@"sendFriendRequest: %@", result);
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendFriendReqSuscess)]) {
            [_delegate performSelector:@selector(sendFriendReqSuscess)];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(sendFriendReqFailWithError:)]) {
            [_delegate performSelector:@selector(sendFriendReqFailWithError:) withObject:error];
        }
    }];
    
    [operation start];
}

- (void)getAllFriendRequest
{
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_ALL_RECEIVED_REQ parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSArray *result = (NSArray *) JSON;
        NSLog(@"getAllFriendRequest: %@", result);
        
        NSMutableArray *requestArray = [NSMutableArray array];
        
        for (NSDictionary *requestDict in result) {
            @autoreleasepool {
                NSString *reqId = [requestDict objectForKey:@"id"];
                NSDictionary *userDic = [requestDict objectForKey:@"sender"];
                User *sender = [self userFromDictionary:userDic];
                userDic = [requestDict objectForKey:@"receiver"];
                User *receiver = [self userFromDictionary:userDic];
                DigitzRequest *digitzReq = [[DigitzRequest alloc] initWithId:reqId withSender:sender withReceiver:receiver];
                [requestArray addObject:digitzReq];
            }
        }
        
        NSLog(@"requestArray: %d", requestArray.count);
        
        if (_delegate && [_delegate respondsToSelector:@selector(getAllFriendRequestSuccessWithArray:)]) {
            [_delegate performSelector:@selector(getAllFriendRequestSuccessWithArray:) withObject:requestArray];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(getAllFriendRequestFailWithError:)]) {
            [_delegate performSelector:@selector(getAllFriendRequestFailWithError:) withObject:error];
        }
    }];
    
    [operation start];
}

- (void)getAllFriendsOfUser
{
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_ADDRESS_BOOK parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSArray *result = (NSArray *) JSON;
        NSLog(@"getAllFriendOfUser: %@", result);
        
        NSMutableDictionary *friendsDict = [NSMutableDictionary dictionary];
        NSMutableArray *userArray = [NSMutableArray array];
        NSMutableArray *accFriendArray = [NSMutableArray array];
        NSMutableArray *busFriendArray = [NSMutableArray array];
        NSMutableArray *friFriendArray = [NSMutableArray array];
        
        for (NSDictionary *requestDict in result) {
            @autoreleasepool {
                User *friend = [self userFromDictionary:requestDict];
                [userArray addObject:friend];
                if ([[requestDict objectForKey:@"type"] isEqualToString:kKey_Accquaintance]) {
                    [accFriendArray addObject:friend];
                }else if ([[requestDict objectForKey:@"type"] isEqualToString:kKey_BusinessType]){
                    [busFriendArray addObject:friend];
                }else if ([[requestDict objectForKey:@"type"] isEqualToString:kKey_FamilyType]){
                    [friFriendArray addObject:friend];
                }
            }
        }
        
        [friendsDict setObject:userArray forKey:@"all"];
        [friendsDict setObject:accFriendArray forKey:kKey_Accquaintance];
        [friendsDict setObject:busFriendArray forKey:kKey_BusinessType];
        [friendsDict setObject:friFriendArray forKey:kKey_FamilyType];
        
        NSLog(@"requestArray: %d", userArray.count);
        
        if (_delegate && [_delegate respondsToSelector:@selector(getAllFriendSuccessWithDict:)]) {
            [_delegate performSelector:@selector(getAllFriendSuccessWithDict:) withObject:friendsDict];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(getALlFriendFailWithError:)]) {
            [_delegate performSelector:@selector(getALlFriendFailWithError:) withObject:error];
        }
    }];
    
    [operation start];

}

- (void)acceptFriendRequestWithFriendUsername:(NSString *)username withFields:(NSString *)fields withType:(NSString *)type
{
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", username, @"friend", fields, @"fields", type,@"type", nil];
    
    NSLog(@"accept friend param: %@", params);
    
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_SEND_INFO parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSDictionary *result = (NSDictionary *) JSON;
        NSLog(@"result: %@", result);
        
        if ([[result objectForKey:@"success"] boolValue] == YES) {
            if (_delegate && [_delegate respondsToSelector:@selector(acceptFriendSuccessful:)]) {
                [_delegate performSelector:@selector(acceptFriendSuccessful)];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(acceptFriendFailWithError:)]) {
                [_delegate performSelector:@selector(acceptFriendFailWithError:) withObject:nil];
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(acceptFriendFailWithError:)]) {
            [_delegate performSelector:@selector(acceptFriendFailWithError:) withObject:error];
        }
    }];
    
    [operation start];
    
}

- (void)declineFriendRequestWithRequestId:(NSString *)requestId
{
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", requestId, @"request_id", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_DECLINE_REQUEST parameters:params];
    [request setTimeoutInterval:TIME_OUT];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        NSDictionary *result = (NSDictionary *) JSON;
        NSLog(@"result: %@", result);
        
        if ([[result objectForKey:@"success"] boolValue] == YES) {
            if (_delegate && [_delegate respondsToSelector:@selector(declineFriendSuccessful)]) {
                [_delegate performSelector:@selector(declineFriendSuccessful)];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(declineFriendFailWithError:)]) {
                [_delegate performSelector:@selector(declineFriendFailWithError:) withObject:nil];
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        if (_delegate && [_delegate respondsToSelector:@selector(declineFriendFailWithError:)]) {
            [_delegate performSelector:@selector(declineFriendFailWithError:) withObject:error];
        }
    }];
    
    [operation start];
}

// Upload user avatar
- (void)updateUserAvatarWithImage: (UIImage *)avatar {
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", nil];
    NSData *imageData = UIImagePNGRepresentation(avatar);
    NSMutableURLRequest *request = [_httpClient multipartFormRequestWithMethod:@"POST" path:PATH_UPDATE_USER_INFO parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"user[avatar]" fileName:@"user[avatar]" mimeType:@"user[avatar]"];
        //[formData appendPartWithFormData:imageData name:@"user[avatar]"];
    }];
    request.timeoutInterval = 30.0;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        NSLog(@"%@", JSON);
        if ([[result objectForKey:@"success"] boolValue]) {
            NSDictionary *userDic = [result objectForKey:@"user"];
            User *newUser = [self userFromDictionary:userDic];
            if (_delegate && [_delegate respondsToSelector:@selector(updateUserAvatarSuccessWithUser:)]) {
                [_delegate performSelector:@selector(updateUserAvatarSuccessWithUser:) withObject:newUser];
            }
        }
        else {
            NSError *error = nil;
            NSDictionary *details = [[NSDictionary alloc] initWithObjectsAndKeys:@"Update Avatar Failed", NSLocalizedDescriptionKey, nil];
            error = [NSError errorWithDomain:@"Update Avatar Failed" code:2000 userInfo:details];
            if (_delegate && [_delegate respondsToSelector:@selector(updateUserAvatarFailedWithError:)]) {
                [_delegate performSelector:@selector(updateUserAvatarFailedWithError:) withObject:error];
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateUserAvatarFailedWithError:)]) {
            [_delegate performSelector:@selector(updateUserAvatarFailedWithError:) withObject:error];
        }
    }];
    [operation start];
}

//update user avatar from link image
- (void)updateUserAvatarWithLinkImage: (NSString *)urlImage {
    __weak NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:authToken, @"auth_token", urlImage, @"user[remote_avatar_url]", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_UPDATE_USER_INFO parameters:params];
    request.timeoutInterval = TIME_OUT;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        if ([[result objectForKey:@"success"] boolValue]) {
            User *user = [self userFromDictionary:[result objectForKey:@"user"]];
            if (_delegate && [_delegate respondsToSelector:@selector(updateUserAvatarFromLinkSuccess:)]) {
                [_delegate performSelector:@selector(updateUserAvatarFromLinkSuccess:) withObject:user];
            }
        }
        else {
            NSError *error = nil;
            NSDictionary *details = [[NSDictionary alloc] initWithObjectsAndKeys:@"Update Avatar Failed", NSLocalizedDescriptionKey, nil];
            error = [NSError errorWithDomain:@"Update Avatar Failed" code:2000 userInfo:details];
            if (_delegate && [_delegate respondsToSelector:@selector(updateUserAvatarFromLinkFailedWithError:)]) {
                [_delegate performSelector:@selector(updateUserAvatarFromLinkFailedWithError:) withObject:error];
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateUserAvatarFromLinkFailedWithError:)]) {
            [_delegate performSelector:@selector(updateUserAvatarFromLinkFailedWithError:) withObject:error];
        }
    }];
    [operation start];
}

- (void)sentResetPasswordWithEmail:(NSString *)email
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", nil];
    NSMutableURLRequest *request = [_httpClient requestWithMethod:@"POST" path:PATH_RESET_PASSWORD parameters:params];
    request.timeoutInterval = TIME_OUT;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *result = JSON;
        NSString *status = [result objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(sentResetPasswordRequestSuccess)]) {
                [_delegate performSelector:@selector(sentResetPasswordRequestSuccess)];
            }
        }
        else {
            NSError *error = nil;
            NSDictionary *details = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sent reset password failed", NSLocalizedDescriptionKey, nil];
            error = [NSError errorWithDomain:@"Sent reset password failed" code:2000 userInfo:details];
            if (_delegate && [_delegate respondsToSelector:@selector(sentResetPasswordRequestFailedWithError:)]) {
                [_delegate performSelector:@selector(sentResetPasswordRequestFailedWithError:) withObject:error];
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (_delegate && [_delegate respondsToSelector:@selector(sentResetPasswordRequestFailedWithError:)]) {
            [_delegate performSelector:@selector(sentResetPasswordRequestFailedWithError:) withObject:error];
        }
    }];
    [operation start];
}

@end
