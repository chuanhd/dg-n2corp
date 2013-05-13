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

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *birthday;
@property NSInteger gender;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *hometown;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *facebookUrl;
@property (strong, nonatomic) NSString *googleUrl;
@property (strong, nonatomic) NSString *linkedinUrl;
@property (strong, nonatomic) NSString *twitterUrl;
@property (strong, nonatomic) NSString *instagramUrl;

@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *homepage;
@property (strong, nonatomic) NSString *emailHome;
@property (strong, nonatomic) NSString *emailWork;
@property (strong, nonatomic) NSString *cellPhone;
@property (strong, nonatomic) NSString *phoneHome;
@property (strong, nonatomic) NSString *phoneWork;
@property (strong, nonatomic) NSString *bio;


@end
