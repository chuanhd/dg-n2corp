//
//  ProfileViewController.m
//  Digitz
//
//  Created by chuanhd on 5/2/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "ProfileViewController.h"
#import "InformationCell.h"
#import "PersonalInformationViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GTLPlusConstants.h"
#import "GTLServicePlus.h"
#import "GTLQueryPlus.h"
#import "GTLPlusPerson.h"
#import "OptionalInfoViewController.h"
#import "AppDelegate.h"
#import "PrivacySettingsViewController.h"
#import "DigitzUtils.h"
#import "TnCViewController.h"
#import "DigitzActivity.h"

//NSString *const FBSessionStateChangedNotification = @"com.n2corp.digitz.login:FBSessionStateChangedNotification";


@interface ProfileViewController ()
{
    GPPSignIn *signIn;
    ACAccountStore *accountStore;
    OAuthLoginView *oauthLoginView;
    InstagramAuthViewController *instagramViewController;
}
@end

@implementation ProfileViewController

@synthesize serverManager = _serverManager;
@synthesize paramsDict = _paramsDict;
@synthesize personalInfoFilled = _personalInfoFilled;
@synthesize optionalInfoFilled = _optionalInfoFilled;
@synthesize privacySettingFilled = _privacySettingFilled;
@synthesize agreeTermAndCondition = _agreeTermAndCondition;


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
    
    self.infoTableView.dataSource = self;
    self.infoTableView.delegate = self;
    
    _paramsDict = [NSMutableDictionary dictionary];
    
    _serverManager = [[ServerManager alloc] init];
    _serverManager.delegate = self;
    
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:kKey_UserToken];
    [_serverManager getUserInfoWithToken:auth_token];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Fetching user information"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.paramsDict objectForKey:kKey_UpdateFirstName] && ![[self.paramsDict objectForKey:kKey_UpdateFirstName] isEqual:[NSNull null]]) {
        self.txtDigitzInfo.text = [NSString stringWithFormat:@"%@'s Digitz", [self.paramsDict objectForKey:kKey_UpdateFirstName]];
    }
    
//    if ([_paramsDict objectForKey:kKey_UpdateImageData] != nil) {
//        __weak UIImage *image = [_paramsDict objectForKey:kKey_UpdateImageData];
//        [_serverManager updateUserAvatarWithImage:image];
//    }
}

- (void)updateUserAvatarSuccessWithUser:(User *)user
{
    NSLog(@"Update user avatar success");
}

- (void)updateUserAvatarFailedWithError:(NSError *)error
{
    NSLog(@"Update user avatar fail %@", error);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signOutBtnTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKey_UserToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKey_DeviceToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kKey_UpdateAvailable];
    [[DigitzUtils getRecentActivity] removeAllObjects];
    /*
     [userDefault setObject:[result objectForKey:@"user"] forKey:@"username"];
     [userDefault setObject:[result objectForKey:@"available"] forKey:kKey_UpdateAvailable];
     */
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)facebookBtnTapped:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:FBSessionStateChangedNotification object:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Connecting to Facebook..."];
    });
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (void) receiveNotification:(NSNotification *)noti
{
    if ([noti.name isEqualToString:FBSessionStateChangedNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:FBSessionStateChangedNotification object:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if ([FBSession.activeSession isOpen]) {
            [self queryFBUserInfo];
        }
    }
}

- (IBAction)googleBtnTapped:(id)sender {
    
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGoogleUserID = YES;
    signIn.delegate = self;
    
    [signIn authenticate];
}

- (IBAction)instagramBtnTapped:(id)sender {
    instagramViewController = [[InstagramAuthViewController alloc] initWithNibName:nil bundle:nil];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(instagramOAuthViewDidFinish:)
                                                 name:@"instagramOAuthViewDidFinish"
                                               object:instagramViewController];
    
    if ([self respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [self presentModalViewController:instagramViewController animated:YES];
    }else{
        [self presentViewController:instagramViewController animated:YES completion:nil];
    }
}

- (IBAction)twitterBtnTapped:(id)sender {
    accountStore = [[ACAccountStore alloc] init];
    [self fetchTwitterUserInfo];
}

- (IBAction)linkedinBtnTapped:(id)sender {
    oauthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(linkedinLoginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oauthLoginView];
    
    if ([self respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [self presentModalViewController:oauthLoginView animated:YES];
    }else{
        [self presentViewController:oauthLoginView animated:YES completion:nil];
    }
}

- (IBAction)updateInfoBtnTapped:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Update user information..."];
    [_serverManager updateUserInformationWithParams:self.paramsDict];
}

- (void) showToast:(NSString *)message
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO];
    // Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
    
        hud.yOffset = 140.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2.0f];
    hud = nil;
}

- (void)updateUserInformationWithParamsSuccess:(User *)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    DigitzActivity *activity = [[DigitzActivity alloc] initWithDescription:@"Update your information"];
    [DigitzUtils addActivity:activity];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DigitzUtils showToast:@"Update successfully" inView:self.view];
    });
    
    
}

- (void)updateUserInformationWithParamsFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[DigitzUtils showToast:@"Update fail" inView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Update user information fail" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    });
}

#pragma mark ServerManager delegate
- (void)getUserInformationSuccessWithUser:(User *)user
{
    if (![user.firstName isEqual:[NSNull null]] && user.firstName != nil) {
        [_paramsDict setObject:user.firstName forKey:kKey_UpdateFirstName];
    }
    
    if (![user.lastName isEqual:[NSNull null]] && user.lastName != nil) {
        [_paramsDict setObject:user.lastName forKey:kKey_UpdateLastName];
    }
        
    self.txtDigitzInfo.text = [NSString stringWithFormat:@"%@'s Digitz",user.firstName];
    
    if (![user.email isEqual:[NSNull null]] && user.email != nil) {
        [_paramsDict setObject:user.email forKey:kKey_UpdateEmail];
    }
    
    if (user.gender == MALE) {
        [_paramsDict setObject:@"male" forKey:kKey_UpdateGender];
    }else{
        [_paramsDict setObject:@"female" forKey:kKey_UpdateGender];
    }
    
    if (![user.hometown isEqual:[NSNull null]] && user.hometown != nil) {
        [_paramsDict setObject:user.hometown forKey:kKey_UpdateHometown];
    }
    
    if (![user.state isEqual:[NSNull null]] && user.state != nil) {
        [_paramsDict setObject:user.state forKey:kKey_UpdateState];
    }
    if (![user.phoneNumber isEqual:[NSNull null]] && user.phoneNumber != nil) {
        [_paramsDict setObject:user.phoneNumber forKey:kKey_UpdatePhone];
    }
    if (![user.birthday isEqual:[NSNull null]] && user.birthday != nil) {
        [_paramsDict setObject:user.birthday forKey:kKey_UpdateBirthday];
    }
    if (![user.facebookUrl isEqual:[NSNull null]] && user.facebookUrl != nil) {
        [_paramsDict setObject:user.facebookUrl forKey:kKey_UpdateFacebookUrl];
    }
    if (![user.googleUrl isEqual:[NSNull null]] && user.googleUrl != nil) {
        [_paramsDict setObject:user.googleUrl forKey:kKey_UpdateGooglePlusUrl];
    }
    if (![user.twitterUrl isEqual:[NSNull null]] && user.twitterUrl != nil) {
        [_paramsDict setObject:user.twitterUrl forKey:kKey_UpdateTwitterUrl];
    }
    if (![user.linkedinUrl isEqual:[NSNull null]] && user.linkedinUrl != nil) {
        [_paramsDict setObject:user.linkedinUrl forKey:kKey_UpdateLinkedLnUrl];
    }
    if (![user.instagramUrl isEqual:[NSNull null]] && user.instagramUrl != nil) {
        [_paramsDict setObject:user.instagramUrl forKey:kKey_UpdateInstagramUrl];
    }
    
    if (![user.avatarUrl isEqual:[NSNull null]] && user.avatarUrl != nil) {
        [_paramsDict setObject:user.avatarUrl forKey:kKey_UpdateAvatar];
        _optionalInfoFilled = YES;
    }
    
    if (![user.company isEqual:[NSNull null]] && user.company != nil) {
        [_paramsDict setObject:user.company forKey:kKey_UpdateCompany];
        _optionalInfoFilled = YES;
    }
    
    if (![user.address isEqual:[NSNull null]] && user.address != nil) {
        [_paramsDict setObject:user.address forKey:kKey_UpdateAddress];
        _optionalInfoFilled = YES;
    }
    
    if (![user.homepage isEqual:[NSNull null]] && user.homepage != nil) {
        [_paramsDict setObject:user.homepage forKey:kKey_UpdateHomepage];
        _optionalInfoFilled = YES;
    }
    
    if (![user.emailHome isEqual:[NSNull null]] && user.emailHome != nil) {
        [_paramsDict setObject:user.emailHome forKey:kKey_UpdateAlterEmail];
        _optionalInfoFilled = YES;
    }
    
    if (![user.phoneHome isEqual:[NSNull null]] && user.phoneHome != nil) {
        [_paramsDict setObject:user.phoneHome forKey:kKey_UpdateAlterPhone];
        _optionalInfoFilled = YES;
    }
    
    if (![user.bio isEqual:[NSNull null]] && user.bio != nil) {
        [_paramsDict setObject:user.bio forKey:kKey_UpdatePersonalBio];
        _optionalInfoFilled = YES;
    }
    
    if (![user.facebookUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.facebookBtn setImage:[UIImage imageNamed:@"icon-fb-r-green.png"] forState:UIControlStateNormal];
        });
    }
    if (![user.googleUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.googleBtn setImage:[UIImage imageNamed:@"icon-gg-r-green.png"] forState:UIControlStateNormal];
        });
    }
    if (![user.twitterUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.twitterBtn setImage:[UIImage imageNamed:@"icon-tw-r-green.png"] forState:UIControlStateNormal];
        });
    }
    if (![user.linkedinUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.linkedlnBtn setImage:[UIImage imageNamed:@"icon-lnk-r-green.png"] forState:UIControlStateNormal];
        });
    }
    if (![user.instagramUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.instagramBtn setImage:[UIImage imageNamed:@"icon-ins-r-green.png"] forState:UIControlStateNormal];
        });
    }
    
    if (![user.priAcc isEqual:[NSNull null]]) {
        [self.paramsDict setObject:[DigitzUtils buildFieldsStringFromArray:user.priAcc] forKey:kKey_PrivacyAcc];
    }
    
    if (![user.priBus isEqual:[NSNull null]]) {
        [self.paramsDict setObject:[DigitzUtils buildFieldsStringFromArray:user.priBus] forKey:kKey_PrivacyBus];
    }
    
    if (![user.priFri isEqual:[NSNull null]]) {
        [self.paramsDict setObject:[DigitzUtils buildFieldsStringFromArray:user.priFri] forKey:kKey_PrivacyFri];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    _personalInfoFilled = YES;
    _privacySettingFilled = YES;
    [self.infoTableView reloadData];

}

- (void)getUserInformationFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    // Games
//    UIView *headerView;
//    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [headerView setBackgroundColor:[UIColor clearColor]];
//
//    UILabel* label;
//    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 44)];
//    label.font = [UIFont boldSystemFontOfSize:17];
//    [label setTextColor:[UIColor whiteColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//
//    [headerView addSubview:label];
//
//    switch (section) {
//        case 0:
//            label.text = @"__Info & Privacy________________";
//            break;
//        case 1:
//            label.text = @"__Socials______________________";
//            break;
//        default:
//            break;
//    }
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    static NSString *CellIdentifier = @"Cell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    
    static NSString *cellIdentifier = @"UserCell";
    
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    cell.index = indexPath.row;
    
    //    switch (indexPath.section) {
    //        case 0:
    //        {
    //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.txtInfo.text = @"Personal Information*";
            if (self.personalInfoFilled) {
                cell.imgCheckmark.hidden = NO;
            }else{
                cell.imgCheckmark.hidden = YES;
            }
            break;
        case 1:
            cell.txtInfo.text = @"Optional Information";
            if (self.optionalInfoFilled) {
                cell.imgCheckmark.hidden = NO;
            }else{
                cell.imgCheckmark.hidden = YES;
            }
            break;
        case 2:
            cell.txtInfo.text = @"Privacy Settings*";
            if (self.privacySettingFilled) {
                cell.imgCheckmark.hidden = NO;
            }else{
                cell.imgCheckmark.hidden = YES;
            }
            break;
        case 3:
            cell.txtInfo.text = @"Terms & Conditions*";
//            if (self.agreeTermAndCondition) {
                cell.imgCheckmark.hidden = NO;
//            }else{
//                cell.imgCheckmark.hidden = YES;
//            }
            break;
        default:
            break;
    }
    //    UIImage *image = [UIImage imageNamed:@"icon-arrow.png"];
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //    imageView.frame = CGRectMake(self.tableView.frame.size.width - image.size.width - 4, (cell.frame.size.height - image.size.height)/2, image.size.width, image.size.height);
    //    [cell addSubview:imageView];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            // personal information
            PersonalInformationViewController* vc = [[PersonalInformationViewController alloc] init];
            //PersonalInfo *vc = [[PersonalInfo alloc] init];
            vc.parentVC = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalInfoFilled:) name:@"personalInfoFilled" object:vc];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            // optional information
            OptionalInfoViewController *vc = [[OptionalInfoViewController alloc] init];
            vc.parentVC = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalInfoFilled:) name:@"personalInfoFilled" object:vc];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            // privacy settings
            PrivacySettingsViewController *vc = [[PrivacySettingsViewController alloc] init];
            vc.parentVC = self;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalInfoFilled:) name:@"personalInfoFilled" object:vc];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            // terms & conditions
            TnCViewController *vc = [[TnCViewController alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personalInfoFilled:) name:@"personalInfoFilled" object:vc];
            vc.parentVC = self;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

// Function to reload table view
-(void) personalInfoFilled:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.infoTableView reloadData];
}

#pragma mark Facebook functions

- (void) queryFBUserInfo
{
    //FBRequest *fbRequest = [FBRequest requestForMe];
    
    NSLog(@"Fetching user data");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Fetching user data"];
    
    //    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
    //                                                           id<FBGraphUser> user,
    //                                                           NSError *error){
    //        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //
    //        if (!error) {
    //            NSLog(@"user: %@", user);
    //        }else{
    //            NSLog(@"error: %@", error);
    //        }
    //    }];
    
    
    //FBRequest *fbRequest = [FBRequest requestWithGraphPath:@"me?fields=picture,email,hometown,first_name,last_name,location,gender,birthday,link" parameters:nil HTTPMethod:@"GET"];
    
    FBRequest *fbRequest = [FBRequest requestWithGraphPath:@"me?fields=link,picture.width(200).height(200)" parameters:nil HTTPMethod:@"GET"];
    
    
    [fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            NSLog(@"Query FB user info: %@", error);
        }else{
                        
            [self.paramsDict setObject:[result objectForKey:@"link"] forKey:kKey_UpdateFacebookUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //facebookLinked = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your Facebook account are linked" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                [self.facebookBtn setImage:[UIImage imageNamed:@"icon-fb-r-green.png"] forState:UIControlStateNormal];
            });
            
            NSMutableDictionary *avatarUrlData = [result objectForKey:@"picture"];
            avatarUrlData = [avatarUrlData objectForKey:@"data"];
            NSString *urlString = [avatarUrlData objectForKey:@"url"];
            [self.paramsDict setObject:urlString forKey:kKey_UpdateRemoteAvatar];
            
            NSLog(@"Query FB info successful with link: %@ - with avatarUrl: %@", [result objectForKey:@"link"], urlString);

            
            //            for (NSString *key in result) {
            //                NSLog(@"key: %@ -> value: %@", key, [result objectForKey:key]);
            //            }
            
            //            NSString *fullname = [NSString stringWithFormat:@"%@ %@", [result objectForKey:@"first_name"], [result objectForKey:@"last_name"]];
            //            [self.paramsDict setObject:[result objectForKey:@"email"] forKey:kKey_UpdateEmail];
            //            [self.paramsDict setObject:fullname forKey:kKey_UpdateName];
            //            [self.paramsDict setObject:[result objectForKey:@"link"] forKey:kKey_UpdateFacebookUrl];
            //            [self.paramsDict setObject:[result objectForKey:@"gender"] forKey:kKey_UpdateGender];
            //            NSMutableDictionary *avatarUrlData = [result objectForKey:@"picture"];
            //            avatarUrlData = [avatarUrlData objectForKey:@"data"];
            //            NSString *urlString = [avatarUrlData objectForKey:@"url"];
            //            [self.paramsDict setObject:urlString forKey:kKey_UpdateAvatar];
            //            avatarUrlData = [result objectForKey:@"location"];
            //            urlString = [avatarUrlData objectForKey:@"name"];
            //            [self.paramsDict setObject:urlString forKey:kKey_UpdateHometown];
            //
            //
            //            NSString *birthday = [result objectForKey:@"birthday"];
            //            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            //            [dateFormater setDateFormat:@"MM/dd/yyyy"];
            //            NSDate *date = [dateFormater dateFromString:birthday];
            //            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            //            NSLog(@"birthday: %@", [dateFormater stringFromDate:date]);
            //            [self.paramsDict setObject:[dateFormater stringFromDate:date] forKey:kKey_UpdateBirthday];
            
            //            NSString *facebookId = [result objectForKey:@"id"];
            //            NSString *facebookEmail = [result objectForKey:@"email"];
            //
            //            NSMutableDictionary *avatarUrlData = [result objectForKey:@"picture"];
            //            avatarUrlData = [avatarUrlData objectForKey:@"data"];
            //            NSString *urlString = [avatarUrlData objectForKey:@"url"];
            //
            //            NSLog(@"facebookId: %@ - facebookEmail: %@", facebookId, facebookEmail);
            //
            //            NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
            //
            //            [standard setObject:facebookId forKey:@"facebookId"];
            //            [standard setObject:facebookEmail forKey:@"facebookEmail"];
            //            [standard setObject:urlString forKey:@"facebookAvatarUrl"];
            //            
            //            [standard synchronize];
            
            //[[ServerManager sharedInstance] requestFacebookAuthenticationWithEmail:facebookEmail username:facebookEmail facebookAuth:FBSession.activeSession.accessTokenData.accessToken facebook_id:facebookId];
        }
        
    }];
    
}

#pragma mark Google Plus delegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error) {
        NSLog(@"Receive error %@ and auth object %@", error, auth);
    }else{
        NSLog(@"user email: %@", signIn.authentication.userEmail);
        [self.paramsDict setObject:signIn.authentication.userEmail forKey:kKey_UpdateEmail];
        GTLServicePlus *plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.auth = auth;
        plusService.authorizer = auth;
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        query.fields = @"id,image,name,displayName,birthday,currentLocation,gender,placesLived,aboutMe,url";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error){
                    if (error) {
                        NSLog(@"Query error: %@", error.description);
                    }else{
                        NSLog(@"Name: %@ %@", person.name.familyName, person.name.givenName);
                        NSLog(@"Avatar url: %@", person.image.url);
                        NSLog(@"Profile url: %@", person.url);
                        [self.paramsDict setObject:person.url forKey:kKey_UpdateGooglePlusUrl];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //googleLinked = YES;
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your google+ account are linked" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alert show];
                            
                            [self.googleBtn setImage:[UIImage imageNamed:@"icon-gg-r-green.png"] forState:UIControlStateNormal];
                        });
                    }
                }];
    }
}

//- (void) fetchGooglePlusUserProfile
//{
//    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
//    query.fields = @"id,email,image,name,displayName";
//
//}

#pragma mark Twitter
- (BOOL) userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) fetchTwitterUserInfo
{
    
    if ([self userHasAccessToTwitter]) {
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Fetching Twitter info"];
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if(granted) {
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                if ([accountsArray count] > 0) {
                    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                    NSLog(@"twitter username: %@",twitterAccount.username);
                    NSLog(@"twitter details: %@", twitterAccount);
                    NSString *userID = [[twitterAccount valueForKey:@"properties"] valueForKey:@"user_id"];
                    NSLog(@"twitter userId: %@", userID);
                    [self.paramsDict setObject:twitterAccount.username forKey:kKey_UpdateTwitterUrl];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"Your Twitter account is linked with username: %@", twitterAccount.username] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        //twitterLinked = YES;
                        [self.twitterBtn setImage:[UIImage imageNamed:@"icon-tw-r-green.png"] forState:UIControlStateNormal];
                    });
                    
                    /*
                     NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                     
                     NSDictionary *params = @{@"screen_name" : twitterAccount.username,
                     @"user_id" : userID,
                     @"include_entities" : @"false"};
                     
                     SLRequest *request =
                     [SLRequest requestForServiceType:SLServiceTypeTwitter
                     requestMethod:SLRequestMethodGET
                     URL:url
                     parameters:params];
                     
                     //  Attach an account to the request
                     [request setAccount:twitterAccount];
                     
                     //  Step 3:  Execute the request
                     [request performRequestWithHandler:^(NSData *responseData,
                     NSHTTPURLResponse *urlResponse,
                     NSError *error) {
                     if (responseData) {
                     if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                     NSError *jsonError;
                     NSDictionary *timelineData =
                     [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:NSJSONReadingAllowFragments error:&jsonError];
                     
                     if (timelineData) {
                     NSLog(@"Timeline Response: %@\n", timelineData);
                     }
                     else {
                     // Our JSON deserialization went awry
                     NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                     }
                     }
                     else {
                     // The server did not respond successfully... were we rate-limited?
                     NSLog(@"The response status code is %d", urlResponse.statusCode);
                     }
                     }
                     }];
                     */
                    
                }
                
                
                
            }else{
                NSLog(@"Error: %@", error.description);
                if (error.code == 6) {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Account not found. Please setup your account in setting app." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }else if (error.code == 7){
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Access denied." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }
            }
        }];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot connect to Twitter right now. Please check your Twitter account in Setting>Twitter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void) linkedinLoginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NSDictionary *profile = [notification userInfo];
    if ( profile )
    {
        if ([profile objectForKey:@"error"] != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[profile objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        NSLog(@"profile: %@", profile);
        
        NSDictionary *url = [profile objectForKey:@"siteStandardProfileRequest"];
        NSLog(@"url: %@", [url objectForKey:@"url"]);
        [self.paramsDict setObject:[url objectForKey:@"url"] forKey:kKey_UpdateLinkedLnUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"Your Linkedln account is linked with profile: %@", [url objectForKey:@"url"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            //linkedinLinked = YES;
            [self.linkedlnBtn setImage:[UIImage imageNamed:@"icon-lnk-r-green.png"] forState:UIControlStateNormal];
            
        });
        //        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
        //                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        //        headline.text = [profile objectForKey:@"headline"];
    }
}

- (void) instagramOAuthViewDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSDictionary *profile = [notification userInfo];
    if (profile) {
        NSLog(@"profile: %@", profile);
        
        NSDictionary *user = [profile objectForKey:@"user"];
        NSString *urlString = [NSString stringWithFormat:@"instagram.com/%@", [user objectForKey:@"username"]];
        
        NSLog(@"url: %@", urlString);
        
        
        [self.paramsDict setObject:urlString forKey:kKey_UpdateInstagramUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //instagramLinked = YES;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"Your Instagram account is linked with username: %@", urlString] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.instagramBtn setImage:[UIImage imageNamed:@"icon-ins-r-green.png"] forState:UIControlStateNormal];
            
        });
        
    }
}

@end
