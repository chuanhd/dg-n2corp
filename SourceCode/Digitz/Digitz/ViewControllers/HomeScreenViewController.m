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
#import "RequestsViewController.h"
#import "DigitzActivity.h"
#import "RecentActivityViewController.h"

@interface HomeScreenViewController ()
{
    NSArray *searchResults;
    BOOL requestChangeVisible;
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
    //[locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Getting location"];
    
    NSNumber *available = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UpdateAvailable];
    NSLog(@"avail: %@", available);
    if ([available integerValue] == 1) {
        [self.btnVisible setImage:[UIImage imageNamed:@"btn-eye-on-topbar.png"] forState:UIControlStateNormal];
    }else{
        [self.btnVisible setImage:[UIImage imageNamed:@"btn-eye-topbar.png"] forState:UIControlStateNormal];
    }
    
    requestChangeVisible = NO;
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
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.bestEffortLocation.coordinate.longitude],kKey_UpdateLocationLong, [NSNumber numberWithFloat:self.bestEffortLocation.coordinate.latitude], kKey_UpdateLocationLat, nil];
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
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES];
    
    requestChangeVisible = YES;

    NSNumber *available = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UpdateAvailable];

    NSDictionary *params;
    
    if (available.integerValue == 1) {
         params = [NSDictionary dictionaryWithObjectsAndKeys:auth_token,kKey_UserToken,[NSNumber numberWithInteger:0], kKey_UpdateAvailable, nil];
    }else{
        params = [NSDictionary dictionaryWithObjectsAndKeys:auth_token,kKey_UserToken,[NSNumber numberWithInteger:1], kKey_UpdateAvailable, nil];
    }

    [serverManager updateUserInformationWithParams:params];
//    [serverManager findNearByFriendsWithToken:auth_token];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES withLabel:@"Getting your location (Temporary function in this build)"];
//    [locationManager startUpdatingLocation];
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
    if (requestChangeVisible) {
        
        requestChangeVisible = NO;
        NSLog(@"user avail: %d", user.available);
        
        if (user.available) {
            [self.btnVisible setImage:[UIImage imageNamed:@"btn-eye-on-topbar.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:kKey_UpdateAvailable];
            dispatch_async(dispatch_get_main_queue(), ^{
                [DigitzUtils showToast:@"You're visible to find" inView:self.view];
            });
        }else{
            [self.btnVisible setImage:[UIImage imageNamed:@"btn-eye-topbar.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:kKey_UpdateAvailable];
            dispatch_async(dispatch_get_main_queue(), ^{
                [DigitzUtils showToast:@"You're invisible" inView:self.view];
            });
        }
        
        DigitzActivity *activity = [[DigitzActivity alloc] initWithDescription:@"Change your visibility"];
        [DigitzUtils addActivity:activity];

    }else{
        NSLog(@"update Success");
        NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:YES withLabel:@"Finding nearby users"];
        [serverManager findNearByFriendsWithToken:auth_token];
    }
}

- (void)updateUserInformationWithParamsFailedWithError:(NSError *)error
{
    NSLog(@"update fail: %@", error.description);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Some error occurred: %@", error.description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

- (void)getAllFriendSuccessWithDict:(NSDictionary *)friends
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (friends.count > 0) {
            
            DigitzActivity *activity = [[DigitzActivity alloc] initWithDescription:@"Get your friends list"];
            [DigitzUtils addActivity:activity];
            
            [DigitzUtils showToast:@"Get friend list successful" inView:self.view];
            FriendsListViewController *vc = [[FriendsListViewController alloc] initWithNibName:nil bundle:nil];
            vc.friendsDict = friends;
            //vc.friendsArray = [NSMutableArray arrayWithArray:friends];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [DigitzUtils showToast:@"You have no friends" inView:self.view];
            });
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
    
    if (request.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DigitzUtils showToast:@"You have no request" inView:self.view];
        });
        return;
    }
    
    RequestsViewController *vc = [[RequestsViewController alloc] initWithNibName:nil bundle:nil];
    vc.requestArray = request;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getAllFriendRequestFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)recentBtnTapped:(id)sender {
    RecentActivityViewController *vc = [[RecentActivityViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
    }else if(tableView == self.digitzUsersTableView){
        user = [self.friendsArray objectAtIndex:indexPath.row];
    }
    
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
            cell.txtUsername.text = user.username;
        }
    }
    
    cell.txtHometown.text = user.hometown;
    if (![user.avatarUrl isEqual:[NSNull null]]) {
        cell.avatarUrlStr = user.avatarUrl;
        [cell loadAvatarFromUrlString];
    }
    
//    if (![user.avatarUrl isEqual:[NSNull null]]) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            
//            NSURL *imageUrl = [NSURL URLWithString:user.avatarUrl];
//            __block NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // update image
//                if (imageData != nil) {
//                    cell.imgAvatar.image = [UIImage imageWithData:imageData];
//                    imageData = nil;
//                }
//            });
//            
//            imageUrl = nil;
//        });
//    }
    
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestDigitzViewController *vc = [[RequestDigitzViewController alloc] initWithNibName:nil bundle:nil];
    vc.requestUser = [self.friendsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

    NSLog(@"select row: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
