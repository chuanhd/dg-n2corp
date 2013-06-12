//
//  DigitzActivity.h
//  Digitz
//
//  Created by chuanhd on 6/9/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DigitzActivity : NSObject

@property (strong, nonatomic) NSString *activityDesc;
@property (strong, nonatomic) NSString *time;
@property NSInteger timeInSeconds;

- (id)initWithDescription:(NSString *)_desc;
- (id)initWithDescription:(NSString *)_desc andTime:(NSString *)_activityTime;

@end
