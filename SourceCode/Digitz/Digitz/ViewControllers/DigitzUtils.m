//
//  DigitzUtils.m
//  Digitz
//
//  Created by chuanhd on 5/8/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "DigitzUtils.h"

@implementation DigitzUtils

static NSMutableArray *recentActivity;

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

+ (NSMutableArray *)getRecentActivity
{
    if (!recentActivity) {
        recentActivity = [NSMutableArray array];
    }
    return recentActivity;
}

+ (void)addActivity:(id)activity
{
    if (!recentActivity) {
        recentActivity = [NSMutableArray array];
    }
    [recentActivity addObject:activity];
}

+ (NSMutableString *) getBeforeTimeOffsetString:(NSInteger)dateInSeconds{
    @autoreleasepool {
        
        if (dateInSeconds < 1) {
            return [NSMutableString stringWithString:@""];
        }
        
        //use timer offset to get current time
        NSInteger currentSeconds = [[NSDate date] timeIntervalSince1970];
        
        NSInteger dayOffset = (currentSeconds - dateInSeconds)/86400;
        if(dayOffset > 3 || currentSeconds < dateInSeconds){
            return [NSMutableString stringWithString:[DigitzUtils getFullDate:dateInSeconds withTZ:0]];
        }else if (dayOffset >= 1){
            return [NSString stringWithFormat:@"%d %@ %@", dayOffset, @"days", @"ago"];
        }else{
            NSInteger hourOffset = (currentSeconds - dateInSeconds) / 3600;
            if(hourOffset >= 1){
                return [NSString stringWithFormat:@"%d %@ %@", hourOffset, @"hours", @"ago"];
            }
            NSInteger minuteOffset = (currentSeconds - dateInSeconds) / 60;
            if(minuteOffset >= 1){
                return [NSString stringWithFormat:@"%d %@ %@", minuteOffset, @"minutes", @"ago"];
            }
            NSInteger secondOffset = (currentSeconds - dateInSeconds);
            return [NSString stringWithFormat:@"%d %@ %@", secondOffset, @"seconds", @"ago"];
        }
        
    }
}

+ (NSMutableString *) getNextTimeOffsetString:(NSInteger)dateInSeconds{
    @autoreleasepool {
        if (dateInSeconds < 1) {
            return [NSMutableString stringWithString:@""];
        }
        
        
        //user timer offset to get current time
        NSInteger currentSeconds = [[NSDate date] timeIntervalSince1970];
        NSInteger offset = dateInSeconds - currentSeconds;
        NSInteger dayOffset = offset/86400;
        offset = offset%86400;
        NSInteger hourOffset = offset/3600;
        offset = offset%3600;
        NSInteger minuteOffset = offset/60;
        offset = offset%60;
        NSInteger secondOffset = offset;
        
        if (dateInSeconds <= currentSeconds) {
            return [NSMutableString stringWithString:@""];
        }
        
        if (dayOffset > 365) //distance from before-time-offset
        {
            return [NSMutableString stringWithString:[DigitzUtils getFullDate:dateInSeconds withTZ:0]];
        } else if (dayOffset >= 1){
            return [NSString stringWithFormat:@"%d %@ %d %@ %@",dayOffset, @"days", hourOffset, @"hours", @"next"];
        }else{
            if(hourOffset >= 1){
                return [NSString stringWithFormat:@"%d %@ %d %@ %@",hourOffset, @"hours", minuteOffset, @"minutes", @"next"];
            }
            if(minuteOffset >= 1){
                return [NSString stringWithFormat:@"%d %@ %d %@ %@",minuteOffset, @"minutes", secondOffset, @"seconds", @"next"];
            }
            return [NSString stringWithFormat:@"%d %@ %@", secondOffset, @"seconds", @"next"];
        }
        
    }
    
}

+ (NSString *) getFullDate:(long)currentTimeSeconds withTZ:(NSInteger)mTimeZone
{
    //NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    //NSLog(@"System time zone: %@", destinationTimeZone);
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:currentTimeSeconds+(mTimeZone * 3600)];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormater stringFromDate:theDate];
    //NSInteger timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:theDate];
    //NSLog(@"timeZoneOffset: %d", timeZoneOffset);
    return dateString;
}

@end
