//
//  InformationCell.m
//  Digitz
//
//  Created by chuanhd on 4/25/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

@synthesize parentVc;
@synthesize index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    switch (self.index) {
//        case 0:
//            self.txtInfo.text = @"Personal Information*";
//            break;
//        case 1:
//            self.txtInfo.text = @"Optional Information";
//            break;
//        case 2:
//            self.txtInfo.text = @"Privacy Settings*";
//            break;
//        case 3:
//            self.txtInfo.text = @"Terms & Conditions*";
//            break;
//        default:
//            break;
//    }

}

@end
