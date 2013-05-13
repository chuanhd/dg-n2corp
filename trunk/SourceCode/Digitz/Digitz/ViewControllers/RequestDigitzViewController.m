//
//  RequestDigitzViewController.m
//  Digitz
//
//  Created by chuanhd on 5/2/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "RequestDigitzViewController.h"
#import "MBProgressHUD.h"
#import "DigitzUtils.h"

@interface RequestDigitzViewController ()

@end

@implementation RequestDigitzViewController

@synthesize requestUser;
@synthesize serverManager;

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
    
    if (requestUser.name != nil && ![requestUser.name isEqual:[NSNull null]]) {
        self.txtUsername.text = requestUser.name;
    }else{
        self.txtUsername.text = requestUser.username;
    }
    
    self.txtLocation.text = requestUser.hometown;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAcqAddTapped:(id)sender {
    [serverManager sendFriendRequestWithUserId:requestUser.userId];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Sending request"];
}

- (IBAction)btnBusiAddTapped:(id)sender {
}

- (IBAction)btnFriendAddTapped:(id)sender {
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendFriendReqSuscess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [DigitzUtils showToast:@"Request sent succesfully" inView:self.view];
}

- (void) sendFriendReqFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Send request fail!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
