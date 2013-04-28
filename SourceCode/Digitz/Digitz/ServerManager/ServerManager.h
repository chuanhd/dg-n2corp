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
#import "User.h"

#define BASE_URL @"http://digitz.herokuapp.com/"
#define PATH_SIGNIN @"api/users/sign_in"
#define PATH_SIGNUP @"api/users/sign_up"
#define PATH_UPDATE_USER_INFO @"api/users/update_info"
#define PATH_GET_USER_INFO @"api/users"
#define PATH_FIND_FRIENDS @"api/users/find_friends"

#define kKey_UserToken @"auth_token"
#define kKey_UpdateUsername @"user[username]"
#define kKey_UpdateEmail @"user[email]"
#define kKey_UpdateFacebookId @"user[facebook_id]"
#define kKey_UpdatePassword @"user[password]"
#define kKey_UpdateCoin @"user[avatar]"
#define kKey_UpdateUDID @"user[device_udid]"
#define kKey_UpdateAge @"user[age]"
#define kKey_UpdateGender @"user[gender]"
#define kKey_UpdatePhone @"user[phone]"
#define kKey_UpdateHometown @"user[hometown]"
#define kKey_UpdateBirthday @"user[birthday]"
#define kKey_UpdateBlogUrl @"user[blog_url]"
#define kKey_UpdateNotes @"user[notes]"
#define kKey_UpdateName @"user[name]"
#define kKey_UpdateFacebookUrl @"user[facebook_url]"
#define kKey_UpdateGooglePlusUrl @"user[google_plus_url]"
#define kKey_UpdateTwitterUrl @"user[twitter_url]"
#define kKey_UpdateLinkedLnUrl @"user[linkedin_url]"
#define kKey_UpdateInstagramUrl @"user[instagram_url]"
#define kKey_UpdateLocationLong @"user[location_lng]"
#define kKey_UpdateLocationLat @"user[location_lat]"
#define kKey_UpdateAvatar @"user[avatar]"
#define kKey_UpdateState @"user[state]"

@protocol ServerManagerDelegate <NSObject>

@optional

// signUp
- (void)signUpFailedWithError: (NSError *)error;
- (void)signUpSuccess;

// signIn
- (void)signInFailedWithError: (NSError *)error;
- (void)signInSuccess;

// update infomation
- (void)updateUserInformationWithParamsSuccess: (User *)user;
- (void)updateUserInformationWithParamsFailedWithError: (NSError *)error;

// get user infomation
- (void)getUserInformationSuccessWithUser: (User *)user;
- (void)getUserInformationFailedWithError: (NSError *)error;

// find friends
- (void) findNearByFriendsSuccessWithArray:(NSArray *)users;
- (void) findNearByFriendFailWithError:(NSError *)error;

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
- (void) signUpwithParamsDict:(NSDictionary *)_paramsDict;

- (void)signInWithUsername: (NSString *)username andPassword: (NSString *)password;
- (void)updateUserInformationWithParams: (NSDictionary *)params;
- (void) getUserInfoWithToken:(NSString *)token;
//- (void) findNearByFriendsWithToken:(NSString *)token withLong:(float)_long withLat:(float)_lat;
- (void) findNearByFriendsWithToken:(NSString *)token;


@end
