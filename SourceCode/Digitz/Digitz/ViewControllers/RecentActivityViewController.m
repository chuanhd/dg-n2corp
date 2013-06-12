//
//  RecentActivityViewController.m
//  Digitz
//
//  Created by chuanhd on 6/9/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "RecentActivityViewController.h"
#import "DigitzUtils.h"
#import "DigitzActivity.h"
#import "DigitzActivityCell.h"

@interface RecentActivityViewController ()

@end

@implementation RecentActivityViewController

@synthesize recentActivities;

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
    recentActivities = [[[DigitzUtils getRecentActivity] reverseObjectEnumerator] allObjects];
    NSLog(@"recentActivity: %d", recentActivities.count);
    
    self.tableRecentActivity.delegate = self;
    self.tableRecentActivity.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DigitzActivityCell";
    
    DigitzActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"DigitzActivityViewCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    
    DigitzActivity *activity = [self.recentActivities objectAtIndex:indexPath.row];
    
    if (activity) {
        cell.txtActivityDesc.text = activity.activityDesc;
        cell.txtActivityTime.text = [DigitzUtils getBeforeTimeOffsetString:activity.timeInSeconds];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return recentActivities.count;
}

@end
