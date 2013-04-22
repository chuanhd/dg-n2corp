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

@interface HomeScreenViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ServerManagerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) ServerManager *serverManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *bestEffortLocation;
@property (strong, nonatomic) NSMutableArray *friendsArray;

@property (weak, nonatomic) IBOutlet UITableView *digitzUsersTableView;
- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)findNearByUserBtnTapped:(id)sender;
- (IBAction)settingBtnTapped:(id)sender;

@end
