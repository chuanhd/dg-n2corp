//
//  DigitzActivity.m
//  Digitz
//
//  Created by chuanhd on 6/9/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "DigitzActivity.h"
#import "DigitzUtils.h"

@implementation DigitzActivity

@synthesize activityDesc;
@synthesize time;
@synthesize timeInSeconds;

- (id)initWithDescription:(NSString *)_desc
{
    self = [super init];
    if (self) {
        self.activityDesc = _desc;
        self.timeInSeconds = [[NSDate date] timeIntervalSince1970];
    }

    return self;
}

- (id)initWithDescription:(NSString *)_desc andTime:(NSString *)_activityTime
{
    self = [super init];
    if (self) {
        self.activityDesc = _desc;
        self.time = _activityTime;
    }
    
    return self;
}

@end
