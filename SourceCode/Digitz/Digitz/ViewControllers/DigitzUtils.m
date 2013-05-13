//
//  DigitzUtils.m
//  Digitz
//
//  Created by chuanhd on 5/8/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "DigitzUtils.h"

@implementation DigitzUtils

+ (void) showToast:(NSString *)message inView:(UIView *)view
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES cancelable:NO];
    // Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
    
    hud.yOffset = 140.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.0f];
    hud = nil;
}

@end
