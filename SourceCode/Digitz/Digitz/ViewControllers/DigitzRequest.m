//
//  DigitzRequest.m
//  Digitz
//
//  Created by chuanhd on 5/8/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "DigitzRequest.h"

@implementation DigitzRequest

@synthesize requestId;
@synthesize sender;
@synthesize receiver;

- (id)initWithId:(NSString *)_requestId withSender:(User *)_sender withReceiver:(User *)_receiver
{
    self = [super init];
    if (self) {
        self.requestId = _requestId;
        self.sender = _sender;
        self.receiver = _receiver;
    }
    return self;
}

@end
