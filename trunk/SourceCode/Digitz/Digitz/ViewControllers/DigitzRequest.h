//
//  DigitzRequest.h
//  Digitz
//
//  Created by chuanhd on 5/8/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DigitzRequest : NSObject

@property (strong, nonatomic) User *sender;
@property (strong, nonatomic) User *receiver;
@property (strong, nonatomic) NSString *requestId;

- (id) initWithId:(NSString *)_requestId withSender:(User *)_sender withReceiver:(User *)_receiver;

@end
