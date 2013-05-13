//
//  FriendsListViewController.h
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMultilineSegmentedControl.h"

@interface FriendsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UIMultilineSegmentedControl *friendsGroupSegment;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;

@property (strong, nonatomic) NSMutableArray *friendsArray;


@end
