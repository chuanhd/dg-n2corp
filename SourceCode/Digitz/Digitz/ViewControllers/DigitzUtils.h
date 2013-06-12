//
//  DigitzUtils.h
//  Digitz
//
//  Created by chuanhd on 5/8/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface DigitzUtils : NSObject
{
}

+ (NSMutableArray *) getRecentActivity;
+ (void) addActivity:(id)activity;
+ (void) showToast:(NSString *)message inView:(UIView *)view;
+ (NSMutableArray *)splitString:(NSString *)source withSeparator:(NSString *)separator;
+ (NSString *) buildFieldsStringFromArray:(NSMutableArray *)array;

+ (NSMutableArray *) getFullDate:(long)currentTimeMillis withTimeZone:(NSInteger)timeZone;
+ (NSMutableString *) getBeforeTimeOffsetString:(NSInteger)dateInSeconds;

@end
