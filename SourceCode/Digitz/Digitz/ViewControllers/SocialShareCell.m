//
//  SocialShareCell.m
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "SocialShareCell.h"
#import "ReceiveRequestViewController.h"
#import "PrivacySettingsViewController.h"

#define fGoogle @"google_plus_url"
#define fFacebook @"facebook_url"
#define fTwitter @"twitter_url"
#define fInstagram @"instagram_url"
#define fLinkedIn @"linkedin_url"

@implementation SocialShareCell

@synthesize parentVC;
@synthesize index;
@synthesize section;

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
}

- (IBAction)shareSwitched:(id)sender {
    if (self.switchShare.isOn) {
        NSLog(@"isOn");
        
        if ([parentVC isKindOfClass:[ReceiveRequestViewController class]]) {
            ReceiveRequestViewController *temp = (ReceiveRequestViewController *) parentVC;
            switch (self.index) {
                case 0:
                    [temp addFieldToArray:fFacebook];
                    break;
                case 1:
                    [temp addFieldToArray:fGoogle];
                    break;
                case 2:
                    [temp addFieldToArray:fTwitter];
                    break;
                case 3:
                    [temp addFieldToArray:fInstagram];
                    break;
                case 4:
                    [temp addFieldToArray:fLinkedIn];
                    break;
                default:
                    break;
            }
        }else if ([parentVC isKindOfClass:[PrivacySettingsViewController class]]){
            PrivacySettingsViewController *temp = (PrivacySettingsViewController *) parentVC;
            switch (self.index) {
                case 0:
                {
                    [temp addFieldToArrayType:self.section withField:fFacebook];
                }
                    break;
                case 1:
                {
                    [temp addFieldToArrayType:self.section withField:fGoogle];
                }
                    break;
                case 2:
                {
                    [temp addFieldToArrayType:self.section withField:fTwitter];
                }
                    break;
                case 3:
                {
                    [temp addFieldToArrayType:self.section withField:fInstagram];
                }
                    break;
                case 4:
                {
                    [temp addFieldToArrayType:self.section withField:fLinkedIn];
                }
                    break;
                default:
                    break;
            }
        }
        
    }else{
        NSLog(@"isOff");
        if ([parentVC isKindOfClass:[ReceiveRequestViewController class]]) {
            ReceiveRequestViewController *temp = (ReceiveRequestViewController *) parentVC;
            switch (self.index) {
                case 0:
                    [temp removeFieldFromArray:fFacebook];
                    break;
                case 1:
                    [temp removeFieldFromArray:fGoogle];
                    break;
                case 2:
                    [temp removeFieldFromArray:fTwitter];
                    break;
                case 3:
                    [temp removeFieldFromArray:fInstagram];
                    break;
                case 4:
                    [temp removeFieldFromArray:fLinkedIn];
                    break;
                default:
                    break;
            }
        }else if ([parentVC isKindOfClass:[PrivacySettingsViewController class]]){
            PrivacySettingsViewController *temp = (PrivacySettingsViewController *) parentVC;
            switch (self.index) {
                case 0:
                {
                    [temp removeFieldFromArrayType:self.section withField:fFacebook];
                }
                    break;
                case 1:
                {
                    [temp removeFieldFromArrayType:self.section withField:fGoogle];
                }
                    break;
                case 2:
                {
                    [temp removeFieldFromArrayType:self.section withField:fTwitter];
                }
                    break;
                case 3:
                {
                    [temp removeFieldFromArrayType:self.section withField:fInstagram];
                }
                    break;
                case 4:
                {
                    [temp removeFieldFromArrayType:self.section withField:fLinkedIn];
                }
                    break;
                default:
                    break;
            }
        }
    }
}


@end
