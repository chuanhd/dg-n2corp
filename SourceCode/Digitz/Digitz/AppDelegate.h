//
//  AppDelegate.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "GPPURLHandler.h"
#import "GTMOAuth2Authentication.h"
#import "MainMenuViewController.h"


@class RootViewController;

static NSString * const kClientId = @"48661555086.apps.googleusercontent.com";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) GTMOAuth2Authentication *auth;


@end
