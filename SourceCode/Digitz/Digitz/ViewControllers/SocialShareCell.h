//
//  SocialShareCell.h
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialShareCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSocialNetworkName;
@property (weak, nonatomic) IBOutlet UISwitch *switchShare;

- (IBAction)shareSwitched:(id)sender;
@end
