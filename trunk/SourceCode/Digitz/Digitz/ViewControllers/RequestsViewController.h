//
//  RequestsViewController.h
//  Digitz
//
//  Created by chuanhd on 5/19/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *requestTableView;
- (IBAction)btnBackTapped:(id)sender;

@property (strong, nonatomic) NSArray *requestArray;

@end
