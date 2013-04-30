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
    
    self.searchDisplayController.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = 500;
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    
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
    [locationManager stopMonitoringSignificantLocationChanges];
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
}

- (IBAction)findNearByUserBtnTapped:(id)sender {
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
    [serverManager findNearByFriendsWithToken:auth_token];
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
}

- (void)updateUserInformationWithParamsFailedWithError:(NSError *)error
{
    NSLog(@"update fail: %@", error.description);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Some error occurred" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)settingBtnTapped:(id)sender {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    User *user;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = [searchResults objectAtIndex:indexPath.row];
    }else{
        user = [self.friendsArray objectAtIndex:indexPath.row];
    }
    if (user.name && user.name.length > 0) {
        cell.txtUsername.text = user.name;
    }else{
        cell.txtUsername.text = user.username;
    }
    cell.txtHometown.text = user.hometown;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    return self.friendsArray.count;
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
