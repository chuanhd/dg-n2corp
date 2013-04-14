//
//  EnterYourDigitzViewController.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "EnterYourDigitzViewController.h"
#import "PersonalInformationViewController.h"
#import "SocialHubViewController.h"
#define kGoogle @"google"
#define kFacebook @"facebook"
#define kTwitter @"twitter"
#define kInstagram @"instagram"
#define kLinkedIn @"linkedin"

@interface EnterYourDigitzViewController ()

@end

@implementation EnterYourDigitzViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Games
    UIView *headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel* label;
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 44)];
    label.font = [UIFont boldSystemFontOfSize:17];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    [headerView addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"__Info & Privacy________________";
            break;
        case 1:
            label.text = @"__Socials______________________";
            break;
        default:
            break;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Personal Information*";
                    break;
                case 1:
                    cell.textLabel.text = @"Other Information (optional)";
                    break;
                case 2:
                    cell.textLabel.text = @"Privacy Settings*";
                    break;
                case 3:
                    cell.textLabel.text = @"Terms & Conditions*";
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            switch (indexPath.row) {
                case 0:
                {
                    cell.imageView.image = [UIImage imageNamed:@"bg-icon-google"];
                    cell.textLabel.text = @"Google+";
                    
                }
                    break;
                case 1:
                {
                    cell.imageView.image = [UIImage imageNamed:@"bg-icon-fb"];
                    cell.textLabel.text = @"Facebook";
                }
                    break;
                case 2:
                {
                    cell.imageView.image = [UIImage imageNamed:@"bg-icon-tw"];
                    cell.textLabel.text = @"Twitter";
                }
                    break;
                case 3:
                {
                    cell.imageView.image = [UIImage imageNamed:@"bg-icon-ins"];
                    cell.textLabel.text = @"Instagram";
                }
                    break;
                case 4:
                {
                    cell.imageView.image = [UIImage imageNamed:@"bg-icon-lnk"];
                    cell.textLabel.text = @"Linked In";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    // personal information
                    PersonalInformationViewController* vc = [[PersonalInformationViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    // optional information
                }
                    break;
                case 2:
                {
                    // privacy settings
                }
                    break;
                case 3:
                {
                    // terms & conditions
                }
                    break;
                default:
                    break;
            }
            break;
        case 1:
        {
            SocialHubViewController* vc = [[SocialHubViewController alloc] init];
            switch (indexPath.row) {
                case 0:
                    vc.socialName = kGoogle;
                    break;
                case 1:
                    vc.socialName = kFacebook;
                    break;
                case 2:
                    vc.socialName = kTwitter;
                    break;
                case 3:
                    vc.socialName = kInstagram;
                    break;
                case 4:
                    vc.socialName = kLinkedIn;
                    break;
                default:
                    break;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;            
        default:
            break;
    }
}

@end
