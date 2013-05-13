//
//  PrivacySettingsViewController.m
//  Digitz
//
//  Created by chuanhd on 5/11/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "PrivacySettingsViewController.h"
#import "SocialShareCell.h"

@interface PrivacySettingsViewController ()

@end

@implementation PrivacySettingsViewController

@synthesize serverManager = _serverManager;

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
    
    self.privacySettingTable.delegate = self;
    self.privacySettingTable.dataSource = self;
    
    _serverManager = [[ServerManager alloc] init];
    _serverManager.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnTapped:(id)sender {
    
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Acquaintance";
        case 1:
            return @"Friends/Family";
        case 2:
            return @"Business";
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SocialShareCell";
    
    SocialShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"SocialShareCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    cell.parentVC = self;
    //cell.index = indexPath.row;
    switch (indexPath.row) {
        case 0:
            cell.lblSocialNetworkName.text = @"Facebook";
            cell.index = 0;
            break;
        case 1:
            cell.lblSocialNetworkName.text = @"Google+";
            cell.index = 1;
            break;
        case 2:
            cell.lblSocialNetworkName.text = @"Twitter";
            cell.index = 2;
            break;
        case 3:
            cell.lblSocialNetworkName.text = @"Instagram";
            cell.index = 3;
            break;
        case 4:
            cell.lblSocialNetworkName.text = @"Linkedin";
            cell.index = 4;
            break;
        default:
            break;
    }
    
    return cell;
}

@end
