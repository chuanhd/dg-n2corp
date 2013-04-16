//
//  User.h
//  Digitz
//
//  Created by chuanhd on 4/17/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MALE 1
#define FEMALE 0

@interface User : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property NSInteger age;
@property NSInteger gender;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *hometown;

@end
