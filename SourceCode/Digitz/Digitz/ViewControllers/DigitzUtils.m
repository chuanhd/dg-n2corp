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
	[hud hide:YES afterDelay:2.0f];
    hud = nil;
}

+ (NSMutableArray *)splitString:(NSString *)source withSeparator:(NSString *)separator
{
    @autoreleasepool {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        
        if (source == nil || [source isEqual:[NSNull null]]) {
            return nil;
        }
        
        NSInteger foundIndex = [source rangeOfString:separator].location;
        while (foundIndex != NSNotFound) {
            @autoreleasepool {
                NSString *temp = [source substringWithRange:NSMakeRange(0, foundIndex)];
                [result addObject:temp];
                source = [source substringFromIndex:foundIndex + separator.length];
                foundIndex = [source rangeOfString:separator].location;
            }
        }
        
        // add the remaining string to result
        [result addObject:source];
        
        return result;
    }
}

+ (NSString *) buildFieldsStringFromArray:(NSMutableArray *)array
{
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i++) {
        if (i == array.count - 1) {
            [result appendString:[array objectAtIndex:i]];
        }else{
            [result appendFormat:@"%@,",[array objectAtIndex:i]];
        }
    }
    return result;
}

@end
