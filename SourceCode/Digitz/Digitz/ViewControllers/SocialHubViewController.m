//
//  SocialHubViewController.m
//  Digitz
//
//  Created by chuanhd on 5/23/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "SocialHubViewController.h"

@interface SocialHubViewController ()
{
    DigitzInfoViewController *digitzInfo;
    SocialInfoViewController *facebookInfo;
    SocialInfoViewController *googlePlusInfo;
    SocialInfoViewController *twitterInfo;
    SocialInfoViewController *instagramInfo;
    SocialInfoViewController *linkedinInfo;
    UITabBar *tabBar;
}
@end

@implementation SocialHubViewController

@synthesize tabBarController = _tabBarController;
@synthesize user = _user;

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
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg-topbar.png"]forBarMetrics:UIBarMetricsDefault];
//    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(5, 6, 50, 30);
//    [backButton setImage:[UIImage imageNamed:@"btn-back-topbar.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backToPreviousVC:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    if (_user.name != nil && ![_user.name isEqual:[NSNull null]]) {
        self.lblUsername.text = _user.name;
    }else{
        if (_user.username != nil && ![_user.username isEqual:[NSNull null]]) {
            self.lblUsername.text = _user.username;
        }
    }
    
    NSLog(@"Before");
    
    digitzInfo = [[DigitzInfoViewController alloc] initWithNibName:@"DigitzInfoViewController" bundle:nil];
    digitzInfo.user = _user;
    digitzInfo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Digitz" image:[UIImage imageNamed:@"icon-social-profile-white.png"] tag:5];
    
    NSLog(@"1");
    
    facebookInfo = [[SocialInfoViewController alloc] initWithNibName:nil bundle:nil];
    facebookInfo.tag = @"facebook";
    facebookInfo.socialLink = _user.facebookUrl;
    facebookInfo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Facebook" image:[UIImage imageNamed:@"icon-social-fb-grey.png"] tag:5];
    
    NSLog(@"1");
    
    googlePlusInfo = [[SocialInfoViewController alloc] initWithNibName:nil bundle:nil];
    googlePlusInfo.tag = @"google";
    googlePlusInfo.socialLink = _user.googleUrl;
    //googlePlusInfo.socialLink = [NSString stringWithFormat:@"www.google.com/%@/about", _user.googleUrl];
    googlePlusInfo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Google" image:[UIImage imageNamed:@"icon-social-gg-grey.png"] tag:5];
    
    NSLog(@"2");
    
    twitterInfo = [[SocialInfoViewController alloc] initWithNibName:nil bundle:nil];
    twitterInfo.tag = @"twitter";
    twitterInfo.socialLink = [NSString stringWithFormat:@"https://twitter.com/%@", _user.twitterUrl];
    NSLog(@"twitter social link: %@", twitterInfo.socialLink);
    twitterInfo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Twitter" image:[UIImage imageNamed:@"icon-social-tw-grey.png"] tag:5];
    
    NSLog(@"3");
    
    instagramInfo = [[SocialInfoViewController alloc] initWithNibName:nil bundle:nil];
    instagramInfo.tag = @"instagram";
    instagramInfo.socialLink = _user.instagramUrl;
    instagramInfo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Instagram" image:[UIImage imageNamed:@"icon-social-ins-grey.png"] tag:5];
    
    NSLog(@"4");
    
    linkedinInfo = [[SocialInfoViewController alloc] initWithNibName:nil bundle:nil];
    linkedinInfo.tag = @"linkedin";
    linkedinInfo.socialLink = _user.linkedinUrl;
    linkedinInfo.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Linkedin" image:[UIImage imageNamed:@"icon-social-lnk-grey.png"] tag:5];

    NSLog(@"5");
    
    NSLog(@"After");

    NSArray *viewControllerArray = [NSArray arrayWithObjects:digitzInfo, facebookInfo, googlePlusInfo,twitterInfo,instagramInfo,linkedinInfo,nil];
    
    _tabBarController = [[CustomTabBarViewController alloc] init];
    [_tabBarController setViewControllers:viewControllerArray];
    _tabBarController.view.frame = CGRectMake(0, 44, 320, 416);
    
    UITabBarItem *second = [_tabBarController.tabBar.items objectAtIndex:1];
    second.image = [UIImage imageNamed:@"icon-social-fb-grey.png"];
    
    UITabBarItem *third = [_tabBarController.tabBar.items objectAtIndex:2];
    third.image = [UIImage imageNamed:@"icon-social-gg-grey.png"];
    
    UITabBarItem *forth = [_tabBarController.tabBar.items objectAtIndex:3];
    forth.image = [UIImage imageNamed:@"icon-social-tw-grey.png"];
    
    _tabBarController.moreNavigationController.navigationBar.hidden = YES;
//    _tabBarController.moreNavigationController.navigationBar.topItem.rightBarButtonItem

//    UITableView *moreTableView = (UITableView *) _tabBarController.moreNavigationController.topViewController.view;
//    moreTableView.dataSource = self;
//    moreTableView.delegate = self;
//    
    
//    UITabBarItem *fifth = [_tabBarController.tabBar.items objectAtIndex:4];
//    fifth.image = [UIImage imageNamed:@"icon-social-ins-grey.png"];
//    UITabBarItem *sixth = [_tabBarController.tabBar.items objectAtIndex:5];
//    sixth.image = [UIImage imageNamed:@"icon-social-lnk-grey.png"];
    _tabBarController.delegate = self;
    [self.view addSubview:_tabBarController.view];
}

-(IBAction) backToPreviousVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

    //[tabBar beginCustomizingItems:[NSArray arrayWithObjects:digitzInfo, facebookInfo, googlePlusInfo,twitterInfo,instagramInfo,linkedinInfo,nil]];
//    UITabBar *_tabBar = [_tabBarController.tabBar copy];
//    [_tabBar beginCustomizingItems:[NSArray arrayWithObjects:digitzInfo, facebookInfo, googlePlusInfo,twitterInfo,instagramInfo,linkedinInfo,nil]];
//    NSMutableArray *tabbarItemCopy = [_tabBarController.tabBar.items mutableCopy];
//    [_tabBarController.tabBar beginCustomizingItems:tabbarItemCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[SocialInfoViewController class]]) {
        __weak SocialInfoViewController *temp = (SocialInfoViewController *) viewController;
        if ([temp.socialLink isEqual:[NSNull null]] || temp.socialLink == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"This information is not shared for you" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}


@end
