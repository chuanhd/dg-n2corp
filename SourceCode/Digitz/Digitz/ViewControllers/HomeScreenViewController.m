//
//  HomeScreenViewController.m
//  Digitz
//
//  Created by chuanhd on 4/21/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "MBProgressHUD.h"
#import "UserCell.h"
#import "User.h"
#import "DigitzRequest.h"
#import "ProfileViewController.h"
#import "RequestDigitzViewController.h"
#import "ReceiveRequestViewController.h"
#import "DigitzUtils.h"
#import "FriendsListViewController.h"

@interface HomeScreenViewController ()
{
    NSArray *searchResults;
}

@end

@implementation HomeScreenViewController

@synthesize serverManager;
@synthesize locationManager;
@synthesize bestEffortLocation;
@synthesize friendsArray;
@synthesize secondArray;

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
    
    serverManager = [[ServerManager alloc] init];
    serverManager.delegate = self;
    
    self.digitzUsersTableView.dataSource = self;
    self.digitzUsersTableView.delegate = self;
    
    self.secondTableView.dataSource = self;
    self.secondTableView.delegate = self;
    
    self.searchDisplayController.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = 500;
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[locationManager startUpdatingLocation];
    //[locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Getting location"];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"lat: %f - lon: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    //NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    
//    if (locationAge > 5.0) {
//        return;
//    }
    
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    
    if (bestEffortLocation == nil || bestEffortLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        self.bestEffortLocation = newLocation;
        
        NSLog(@"lat: %f - lon: %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.bestEffortLocation.coordinate.longitude],kKey_UpdateLocationLong, [NSNumber numberWithLong:self.bestEffortLocation.coordinate.latitude], kKey_UpdateLocationLat, nil];
        [serverManager updateUserInformationWithParams:param];
        
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:error.localizedDescription];
    }
}

- (void) stopUpdatingLocation:(NSString *)state
{
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDigitzUsersTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopMonitoringSignificantLocationChanges];
    [locationManager stopUpdatingLocation];
}

- (IBAction)refreshButtonTapped:(id)sender {
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES withLabel:@"Finding nearby users"];
    [serverManager findNearByFriendsWithToken:auth_token];
}

- (IBAction)findNearByUserBtnTapped:(id)sender {
//    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
//    [serverManager findNearByFriendsWithToken:auth_token];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES withLabel:@"Getting your location (Temporary function in this build)"];
    [locationManager startUpdatingLocation];

}

- (void)findNearByFriendsSuccessWithArray:(NSArray *)users
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (users.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notificaiton" message:@"Can not find any user near you" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    self.friendsArray = [NSMutableArray arrayWithArray:users];
    [self.digitzUsersTableView reloadData];
}

- (void) findNearByFriendFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)updateUserInformationWithParamsSuccess:(User *)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"update Success");
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES withLabel:@"Finding nearby users"];
    [serverManager findNearByFriendsWithToken:auth_token];
}

- (void)updateUserInformationWithParamsFailedWithError:(NSError *)error
{
    NSLog(@"update fail: %@", error.description);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error occurred" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)settingBtnTapped:(id)sender {
    ProfileViewController *vc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)friendBtnTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Getting friends list"];
    [serverManager getAllFriendsOfUser];
}

- (void)getAllFriendSuccessWithArray:(NSArray *)friends
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (friends.count > 0) {
            [DigitzUtils showToast:@"Get friend list successful" inView:self.view];
            FriendsListViewController *vc = [[FriendsListViewController alloc] initWithNibName:nil bundle:nil];
            vc.friendsArray = [NSMutableArray arrayWithArray:friends];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [DigitzUtils showToast:@"You have no friend" inView:self.view];
        }
        
    });
}

- (void)getAllFriendFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)showRequestBtnTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Getting friends request"];
    [serverManager getAllFriendRequest];
}

- (void)getAllFriendRequestSuccessWithArray:(NSArray *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.secondArray = [request mutableCopy];
    self.popupView.hidden = NO;
    self.lblPopupView.text = @"Friend requests";
    [self.secondTableView reloadData];
}

- (void)getAllFriendRequestFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)recentBtnTapped:(id)sender {
}

- (IBAction)closeBtnTapped:(id)sender {
    self.popupView.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView != self.secondTableView) {
        
    }
    
    static NSString *cellIdentifier = @"UserCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    

    User *user;
    
    if (tableView != self.secondTableView) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            user = [searchResults objectAtIndex:indexPath.row];
        }else if(tableView == self.digitzUsersTableView){
            user = [self.friendsArray objectAtIndex:indexPath.row];
        }
    }else{
        __weak DigitzRequest *request = [self.secondArray objectAtIndex:indexPath.row];
        user = request.sender;
    }
    
    NSLog(@"cell for row: %d",  indexPath.row);
    
    NSLog(@"user %@", user.username);
    
    if (![user.name isEqual:[NSNull null]]) {
        cell.txtUsername.text = user.name;
    }else{
        cell.txtUsername.text = user.username;
    }
    cell.txtHometown.text = user.hometown;
    
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
    }else if (tableView == self.digitzUsersTableView){
        return self.friendsArray.count;
    }else{
        return self.secondArray.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.secondTableView) {
        RequestDigitzViewController *vc = [[RequestDigitzViewController alloc] initWithNibName:nil bundle:nil];
        vc.requestUser = [self.friendsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ReceiveRequestViewController *vc = [[ReceiveRequestViewController alloc] initWithNibName:nil bundle:nil];
        __weak DigitzRequest *request = [self.secondArray objectAtIndex:indexPath.row];
        vc.request = request;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
