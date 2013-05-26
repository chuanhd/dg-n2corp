//
//  CustomTabBarViewController.m
//  Digitz
//
//  Created by chuanhd on 5/23/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "CustomTabBarViewController.h"

@implementation CustomTabBarViewController

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    
    if (self.moreNavigationController.viewControllers.count > 1) {
        self.moreNavigationController.viewControllers = [NSArray arrayWithObjects:self.moreNavigationController.visibleViewController, nil];
    }
}

@end
