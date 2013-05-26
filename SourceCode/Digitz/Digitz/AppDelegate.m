//
//  AppDelegate.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "EnterYourDigitzViewController.h"
#import <FacebookSDK/NSError+FBError.h>
#import "UAirship.h"
#import "UAPush.h"

NSString *const FBSessionStateChangedNotification = @"com.n2corp.digitz.login:FBSessionStateChangedNotification";

@implementation AppDelegate

@synthesize auth;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.rootViewController = [[RootViewController alloc] init];
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = naviVC;
    [self.window makeKeyAndVisible];
    [self.window makeKeyWindow];
    
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
//        [self openSessionWithAllowLoginUI:YES];
//    }
    
    NSMutableDictionary *takeOffOptions = [NSMutableDictionary dictionary];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    [UAirship takeOff:takeOffOptions];
    
    //Register for notification
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [UAirship land];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"source application: %@ and openUrl: %@", sourceApplication, url.scheme);
    //return [FBSession.activeSession handleOpenURL:url];
    
    if ([url.scheme isEqualToString:@"com.digitz.dg"]) { // Google+ url
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    return [FBSession.activeSession handleOpenURL:url];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTk = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString: @"<" withString: @""]
                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"Device Token: %@", deviceTk);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceTk forKey:@"deviceToken"];
    
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Fail to register for remote notification with error: %@", error);
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    //NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", nil];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"email, user_location, user_birthday", nil];
    
    //    return [FBSession openActiveSessionWithPublishPermissions:permissions
    //                                              defaultAudience:FBSessionDefaultAudienceFriends
    //                                                 allowLoginUI:allowLoginUI
    //                                            completionHandler:^(FBSession *session,
    //                                                                FBSessionState status,
    //                                                                NSError *error){
    //                                                [self sessionStateChanged:session state:status error:error];
    //                                            }];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error){
                                             [self sessionStateChanged:session state:status error:error];
                                         }];
}

/*
 *  Callback for session changes
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found: %@", session.accessTokenData.expirationDate);
                //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //});
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
        [self handleAuthError:error];
    }
}

- (void)handleAuthError:(NSError *)error{
    NSString *alertMessage, *alertTitle;
    
    if (error.fberrorShouldNotifyUser) {
        // If the SDK has a message for the user, surface it.
        if ([[error userInfo][FBErrorLoginFailedReason]
             isEqualToString:FBErrorLoginFailedReasonSystemDisallowedWithoutErrorValue]) {
            // Show a different error message
            alertTitle = @"App Disabled";
            alertMessage = @"Go to Settings > Facebook and turn ON Digitz.";
            // Perform any additional customizations
        } else {
            // If the SDK has a message for the user, surface it.
            alertTitle = @"Something Went Wrong";
            alertMessage = error.fberrorUserMessage;
        }
    } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
    }else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession){
        NSInteger underlyingSubCode = [[error userInfo]
                                       [@"com.facebook.sdk:ParsedJSONResponseKey"]
                                       [@"body"]
                                       [@"error"]
                                       [@"error_subcode"] integerValue];
        if (underlyingSubCode == 458) {
            alertTitle = @"Session Error";
            alertMessage = @"The app was removed. Please log in again.";
        }else {
            alertTitle = @"Session Error";
            alertMessage = [NSString stringWithFormat:@"Your current session is no longer valid. Please log in again. Error subcode: %d", underlyingSubCode];
            
            /*
             ACAccountStore *accountStore = [[ACAccountStore alloc] init];;
             ACAccountType *accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
             
             NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
             id account;
             if (fbAccounts && fbAccounts.count > 0) {
             account = [fbAccounts objectAtIndex:0];
             
             [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
             if (error) {
             NSLog(@"Error renew credentials for account: %@", error);
             }
             }];
             }
             */
            
        }
        
    }
    else {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
