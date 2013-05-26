//
//  HomeScreenViewController.h
//  Digitz
//
//  Created by chuanhd on 4/21/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerManager.h"

@interface HomeScreenViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ServerManagerDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *bestEffortLocation;
@property (strong, nonatomic) NSMutableArray *friendsArray;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *digitzUsersTableView;
@property (weak, nonatomic) IBOutlet UIButton *btnVisible;

- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)findNearByUserBtnTapped:(id)sender;
- (IBAction)settingBtnTapped:(id)sender;
- (IBAction)friendBtnTapped:(id)sender;
- (IBAction)showRequestBtnTapped:(id)sender;
- (IBAction)recentBtnTapped:(id)sender;

@end
