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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)facebookBtnTapped:(id)sender {
    [self openSessionWithAllowLoginUI:YES];
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
}

- (IBAction)twitterBtnTapped:(id)sender {
    accountStore = [[ACAccountStore alloc] init];
    [self fetchTwitterUserInfo];
}

- (IBAction)linkedinBtnTapped:(id)sender {
}

#pragma mark ServerManager delegate
- (void)getUserInformationSuccessWithUser:(User *)user
{
    if (![user.name isEqual:[NSNull null]] && user.name != nil) {
        [_paramsDict setObject:user.name forKey:kKey_UpdateName];
    }
    
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
    
    
    if (![user.facebookUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.facebookBtn setImage:[UIImage imageNamed:@"icon-fb-r-green"] forState:UIControlStateNormal];
        });
    }else if (![user.googleUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.googleBtn setImage:[UIImage imageNamed:@"icon-gg-r-green"] forState:UIControlStateNormal];
        });
    }else if (![user.twitterUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.twitterBtn setImage:[UIImage imageNamed:@"icon-tw-r-green"] forState:UIControlStateNormal];
        });
    }else if (![user.linkedinUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.linkedlnBtn setImage:[UIImage imageNamed:@"icon-lnk-r-green"] forState:UIControlStateNormal];
        });
    }else if (![user.instagramUrl isEqual:[NSNull null]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.instagramBtn setImage:[UIImage imageNamed:@"icon-ins-r-green"] forState:UIControlStateNormal];
        });
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    _personalInfoFilled = YES;
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
            break;
        case 2:
            cell.txtInfo.text = @"Privacy Settings*";
            break;
        case 3:
            cell.txtInfo.text = @"Terms & Conditions*";
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
        }
            break;
        case 2:
        {
            // privacy settings
        }
            break;
        case 3:
        {
            // terms & conditions
        }
            break;
        default:
            break;
    }
}

// Function to reload table view
-(void) personalInfoFilled:(NSNotification*)notification
{
    [self.infoTableView reloadData];
}

#pragma mark Facebook functions
/*
 *  Callback for session changes
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found: %@", session.accessTokenData.expirationDate);
                //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self queryFBUserInfo];
                //});
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"com.n2corp.digitz.login:FBSessionStateChangedNotification"
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    //NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", nil];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"email, user_location, user_birthday", nil];
    
    //    return [FBSession openActiveSessionWithPublishPermissions:permissions
    //                                              defaultAudience:FBSessionDefaultAudienceFriends
    //                                                 allowLoginUI:allowLoginUI
    //                                            completionHandler:^(FBSession *session,
    //                                                                FBSessionState status,
    //                                                                NSError *error){
    //                                                [self sessionStateChanged:session state:status error:error];
    //                                            }];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error){
                                             [self sessionStateChanged:session state:status error:error];
                                         }];
}


- (void) queryFBUserInfo
{
    //FBRequest *fbRequest = [FBRequest requestForMe];
    
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
    
    FBRequest *fbRequest = [FBRequest requestWithGraphPath:@"me?fields=link" parameters:nil HTTPMethod:@"GET"];
    
    
    [fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            NSLog(@"Query FB user info: %@", error);
        }else{
            
            [self.paramsDict setObject:[result objectForKey:@"link"] forKey:kKey_UpdateFacebookUrl];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your Facebook account are linked" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            dispatch_async(dispatch_get_main_queue(), ^{
                //facebookLinked = YES;
                [self.facebookBtn setImage:[UIImage imageNamed:@"icon-fb-r-green"] forState:UIControlStateNormal];
            });
            
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
                        [self.paramsDict setObject:kKey_UpdateGooglePlusUrl forKey:person.url];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your google+ account are linked" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //googleLinked = YES;
                            [self.googleBtn setImage:[UIImage imageNamed:@"icon-gg-r-green"] forState:UIControlStateNormal];
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
        
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
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
                        //twitterLinked = YES;
                        [self.twitterBtn setImage:[UIImage imageNamed:@"icon-tw-r-green"] forState:UIControlStateNormal];
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
            }
        }];
        
    }
    
}

@end
