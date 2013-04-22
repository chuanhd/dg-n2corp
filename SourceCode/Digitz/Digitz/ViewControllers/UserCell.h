//
//  UserCell.h
//  Digitz
//
//  Created by chuanhd on 4/22/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *txtUsername;
@property (weak, nonatomic) IBOutlet UILabel *txtHometown;

@end
