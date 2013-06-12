//
//  RootViewController.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "RootViewController.h"
#import "MainMenuViewController.h"
#import "SignUpViewController.h"
#import "ServerManager.h"
#import "HomeScreenViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken]) {
        HomeScreenViewController *vc = [[HomeScreenViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MainMenuViewController* vc = [[MainMenuViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
