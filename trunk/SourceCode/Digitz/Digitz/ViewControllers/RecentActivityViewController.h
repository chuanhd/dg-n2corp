//
//  RecentActivityViewController.h
//  Digitz
//
//  Created by chuanhd on 6/9/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentActivityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSArray *recentActivities;
@property (weak, nonatomic) IBOutlet UITableView *tableRecentActivity;
- (IBAction)backBtnTapped:(id)sender;

@end
