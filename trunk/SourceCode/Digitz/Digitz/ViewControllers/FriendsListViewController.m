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
#import "ServerManager.h"
#import "SocialHubViewController.h"
#import "DigitzActivity.h"
#import "DigitzUtils.h"

@interface FriendsListViewController ()
{
    UIMultilineSegmentedControl *segment;
    NSArray *searchResults;
}

@end

@implementation FriendsListViewController

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
    
//    UIMultilineSegmentedControl *segment = [[UIMultilineSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil]];
    
    segment = [[UIMultilineSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", nil]];

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
    
    self.friendsArray = [self.friendsDict objectForKey:@"all"];
    self.accFriendArray = [self.friendsDict objectForKey:kKey_Accquaintance];
    self.busFriendArray = [self.friendsDict objectForKey:kKey_BusinessType];
    self.friFriendArray = [self.friendsDict objectForKey:kKey_FamilyType];
    
    NSLog(@"all: %d", self.friendsArray.count);
    NSLog(@"acc: %d", self.accFriendArray.count);
    NSLog(@"bus: %d", self.busFriendArray.count);
    NSLog(@"fri: %d", self.friendsArray.count);

    
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
        [self.friendsTableView reloadData];
    }else{
        [self.friendsTableView reloadData];
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

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (segment.selectedSegmentIndex == 0) {
//        switch (section) {
//            case 0:
//                
//                break;
//                
//            default:
//                break;
//        }
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
            switch (segment.selectedSegmentIndex) {
                case 0:
                    user = [self.friendsArray objectAtIndex:indexPath.row];
                    break;
                case 1:
                    user = [self.friFriendArray objectAtIndex:indexPath.row];
                    break;
                case 2:
                    user = [self.busFriendArray objectAtIndex:indexPath.row];
                    break;
                case 3:
                    user = [self.accFriendArray objectAtIndex:indexPath.row];
                    break;
                default:
                    user = [self.friendsArray objectAtIndex:indexPath.row];
                    break;
            }
        }
//    }else{
//        __weak DigitzRequest *request = [self.secondArray objectAtIndex:indexPath.row];
//        user = request.sender;
//    }
    
    NSLog(@"cell for row: %d",  indexPath.row);
    
    NSLog(@"user %@", user.username);
    
    if (![user.firstName isEqual:[NSNull null]]) {
        
        NSMutableString *fullName = [NSMutableString stringWithString:user.firstName];
        
        if (![user.lastName isEqual:[NSNull null]]) {
            [fullName appendFormat:@" %@", user.lastName];
        }
        
        cell.txtUsername.text = fullName;
    }else{
        if (![user.lastName isEqual:[NSNull null]]) {
            cell.txtUsername.text = user.lastName;
        }else{
            if(![user.username isEqual:[NSNull null]]){
                cell.txtUsername.text = user.username;
            }else{
                cell.txtUsername.text = @"Error";
            }
        }
    }
        
    if (![user.hometown isEqual:[NSNull null]]) {
        cell.txtHometown.text = user.hometown;
    }else{
        cell.txtHometown.text = @"Error";
    }
    
    NSLog(@"user avatar: %@", user.avatarUrl);
    
    if (![user.avatarUrl isEqual:[NSNull null]]) {
        cell.avatarUrlStr = user.avatarUrl;
        [cell loadAvatarFromUrlString];
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
        switch (segment.selectedSegmentIndex) {
            case 0:
                return self.friendsArray.count;
            case 1:
                return self.friFriendArray.count;
            case 2:
                return self.busFriendArray.count;
            case 3:
                return self.accFriendArray.count;
            default:
                return self.friendsArray.count;
        }
    }
//    else{
//        return self.secondArray.count;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"select row: %d", indexPath.row);
    
    User *user;
    
    //    if (tableView != self.secondTableView) {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = [searchResults objectAtIndex:indexPath.row];
    }else if(tableView == self.friendsTableView){
        switch (segment.selectedSegmentIndex) {
            case 0:
                user = [self.friendsArray objectAtIndex:indexPath.row];
                break;
            case 1:
                user = [self.friFriendArray objectAtIndex:indexPath.row];
                break;
            case 2:
                user = [self.busFriendArray objectAtIndex:indexPath.row];
                break;
            case 3:
                user = [self.accFriendArray objectAtIndex:indexPath.row];
                break;
            default:
                user = [self.friendsArray objectAtIndex:indexPath.row];
                break;
        }
    }
    
    DigitzActivity *activity = [[DigitzActivity alloc] initWithDescription:[NSString stringWithFormat:@"View %@ information", user.username]];
    [DigitzUtils addActivity:activity];
    
    SocialHubViewController *vc = [[SocialHubViewController alloc] initWithNibName:nil bundle:nil];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
    
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

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
