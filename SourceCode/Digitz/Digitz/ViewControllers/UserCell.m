//
//  UserCell.m
//  Digitz
//
//  Created by chuanhd on 4/22/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

@synthesize avatarUrlStr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self loadAvatarFromUrlString];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadAvatarFromUrlString
{
    if (![self.avatarUrlStr isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSURL *imageUrl = [NSURL URLWithString:self.avatarUrlStr];
            __block NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // update image
                if (imageData != nil) {
                    self.imgAvatar.image = [UIImage imageWithData:imageData];
                    imageData = nil;
                }
            });
            
            imageUrl = nil;
        });
    }
}

@end
