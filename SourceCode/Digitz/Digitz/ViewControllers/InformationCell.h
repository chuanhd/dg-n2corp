//
//  InformationCell.h
//  Digitz
//
//  Created by chuanhd on 4/25/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterYourDigitzViewController.h"

@interface InformationCell : UITableViewCell

@property EnterYourDigitzViewController *parentVc;
@property (weak, nonatomic) IBOutlet UILabel *txtInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheckmark;
@property NSInteger index;

@end
