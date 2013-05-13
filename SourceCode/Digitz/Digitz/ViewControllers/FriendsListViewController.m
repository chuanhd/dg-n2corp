//
//  FriendsListViewController.m
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "FriendsListViewController.h"
#import "UserCell.h"
#import "User.h"

@interface FriendsListViewController ()
{
    NSArray *searchResults;
}

@end

@implementation FriendsListViewController

@synthesize friendsGroupSegment = _friendsGroupSegment;
@synthesize friendsArray = _friendList;

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
    
//    self.friendsGroupSegment = [[UIMultilineSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil]];
//    self.friendsGroupSegment.segmentedControlStyle = UISegmentedControlStyleBar;
//    self.friendsGroupSegment.frame = CGRectMake(10, 46, 300, 44);
//    
//    [self.friendsGroupSegment setMultilineTitle:@"All" forSegmentAtIndex:0];
//    [self.friendsGroupSegment setMultilineTitle:@"Friends\nFamily" forSegmentAtIndex:1];
//    [self.friendsGroupSegment setMultilineTitle:@"Business" forSegmentAtIndex:2];
//    [self.friendsGroupSegment setMultilineTitle:@"Acq." forSegmentAtIndex:3];
//    
//    [self.view addSubview:self.friendsGroupSegment];
    
    UIMultilineSegmentedControl *segment = [[UIMultilineSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil]];
    
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    segment.frame = CGRectMake(10, 46, 300, 44);
    
    [segment setMultilineTitle:@"All" forSegmentAtIndex:0];
    [segment setMultilineTitle:@"Friends/\nFamily" forSegmentAtIndex:1];
    [segment setMultilineTitle:@"Business" forSegmentAtIndex:2];
    [segment setMultilineTitle:@"Acq." forSegmentAtIndex:3];
    
    segment.selectedSegmentIndex = 0;
    
    [segment addTarget:self action:@selector(didChangeSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segment];
    
    //_friendList = [NSMutableArray array];
    
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didChangeSegmentedControl:(UIMultilineSegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0) {
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Coming soon!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark table view delegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    @autoreleasepool {
//        UIImage *header = [UIImage imageNamed:@"bg-box-head.png"];
//        return [[UIImageView alloc] initWithImage:header];
//    }
//
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    @autoreleasepool {
//        UIImage *header = [UIImage imageNamed:@"bg-box-foot.png"];
//        return [[UIImageView alloc] initWithImage:header];
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"UserCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    
    User *user;
    
//    if (tableView != self.secondTableView) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            user = [searchResults objectAtIndex:indexPath.row];
        }else if(tableView == self.friendsTableView){
            user = [self.friendsArray objectAtIndex:indexPath.row];
        }
//    }else{
//        __weak DigitzRequest *request = [self.secondArray objectAtIndex:indexPath.row];
//        user = request.sender;
//    }
    
    NSLog(@"cell for row: %d",  indexPath.row);
    
    NSLog(@"user %@", user.username);
    
    if (![user.name isEqual:[NSNull null]]) {
        cell.txtUsername.text = user.name;
    }else if(![user.username isEqual:[NSNull null]]){
        cell.txtUsername.text = user.username;
    }else{
        cell.txtUsername.text = @"Error";
    }
    
    if (![user.hometown isEqual:[NSNull null]]) {
        cell.txtHometown.text = user.hometown;
    }else{
        cell.txtHometown.text = @"Error";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }else{
        return self.friendsArray.count;
    }
//    else{
//        return self.secondArray.count;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"select row: %d", indexPath.row);
    
}

- (void) filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.username CONTAINS %@", searchText];
    searchResults = [self.friendsArray filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

@end
