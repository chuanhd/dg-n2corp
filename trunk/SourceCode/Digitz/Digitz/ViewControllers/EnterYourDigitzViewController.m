//
//  EnterYourDigitzViewController.m
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "EnterYourDigitzViewController.h"
#import "PersonalInformationViewController.h"
#import "SocialHubViewController.h"
#import "MBProgressHUD.h"
#import "HomeScreenViewController.h"

#define kGoogle @"google"
#define kFacebook @"facebook"
#define kTwitter @"twitter"
#define kInstagram @"instagram"
#define kLinkedIn @"linkedin"

NSString *const FBSessionStateChangedNotification = @"com.n2corp.digitz.login:FBSessionStateChangedNotification";

@interface EnterYourDigitzViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation EnterYourDigitzViewController

@synthesize personalInfoFilled;
@synthesize paramsDict;
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
    
    personalInfoFilled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.txtUsername.delegate = self;
    self.txtPassword.delegate = self;
    self.txtConfirmPwd.delegate = self;
    
    self.paramsDict = [[NSMutableDictionary alloc] init];
    
    serverManager = [[ServerManager alloc] init];
    serverManager.delegate = self;
    hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPwd:nil];
    [self setBtnFacebookTapped:nil];
    [self setBtnGoogleTapped:nil];
    [self setBtnInstagramTapped:nil];
    [self setBtnTwitterTapped:nil];
    [self setBtnLinkedInTapped:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    switch (indexPath.section) {
//        case 0:
//        {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Personal Information*";
                    break;
                case 1:
                    cell.textLabel.text = @"Optional Information";
                    break;
                case 2:
                    cell.textLabel.text = @"Privacy Settings*";
                    break;
                case 3:
                    cell.textLabel.text = @"Terms & Conditions*";
                    break;
                default:
                    break;
            }
    UIImage *image = [UIImage imageNamed:@"icon-arrow.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(self.tableView.frame.size.width - image.size.width - 4, 4, image.size.width, image.size.height);
    [cell addSubview:imageView];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
            switch (indexPath.row) {
                case 0:
                {
                    // personal information
                    PersonalInformationViewController* vc = [[PersonalInformationViewController alloc] init];
                    vc.parentVC = self;
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
     postNotificationName:FBSessionStateChangedNotification
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

- (IBAction)btnContinueTapped:(id)sender {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES cancelable:NO withLabel:@"Registering..."];
    
    if (!personalInfoFilled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must fill all required fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    hud.labelText = @"Registering...";
    hud.cancelable = NO;
    [hud show:YES];
    
    [self.paramsDict setObject:self.txtUsername.text forKey:kKey_UpdateUsername];
    [self.paramsDict setObject:self.txtPassword.text forKey:kKey_UpdatePassword];
    //[self.paramsDict setObject:@"" forKey:kKey_UpdateEmail];
    
    for (NSString *key in self.paramsDict) {
        NSLog(@"key %@ - value %@", key, [self.paramsDict objectForKey:key]);
    }
    
    [serverManager signUpwithParamsDict:self.paramsDict];
    //[serverManager signUpWithUsername:self.txtUsername.text andPassword:self.txtPassword.text andEmail:@""];
}

- (void)signUpSuccess
{
    //hud.labelText = @"Sending infomation...";
    //[serverManager updateUserInformationWithParams:paramsDict];
    [hud hide:YES];
    HomeScreenViewController *vc = [[HomeScreenViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) signUpFailedWithError:(NSError *)error
{
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Register failed with error %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)btnFacebookTapped:(id)sender {
    [self openSessionWithAllowLoginUI:YES];
}

- (IBAction)btnGoogleTapped:(id)sender {
}

- (IBAction)btnInstagramTapped:(id)sender {
}

- (IBAction)btnTwitterTapped:(id)sender {
}

- (IBAction)btnLinkedInTapped:(id)sender {
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    FBRequest *fbRequest = [FBRequest requestWithGraphPath:@"me?fields=picture,email,hometown,first_name,last_name,location,gender,birthday,link" parameters:nil HTTPMethod:@"GET"];
    
    [fbRequest startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary *result, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            NSLog(@"Query FB user info: %@", error);
        }else{
            
            for (NSString *key in result) {
                NSLog(@"key: %@ -> value: %@", key, [result objectForKey:key]);
            }
            
            NSString *fullname = [NSString stringWithFormat:@"%@ %@", [result objectForKey:@"first_name"], [result objectForKey:@"last_name"]];
            [self.paramsDict setObject:[result objectForKey:@"email"] forKey:kKey_UpdateEmail];
            [self.paramsDict setObject:fullname forKey:kKey_UpdateName];
            [self.paramsDict setObject:[result objectForKey:@"link"] forKey:kKey_UpdateFacebookUrl];
            [self.paramsDict setObject:[result objectForKey:@"gender"] forKey:kKey_UpdateGender];
            NSMutableDictionary *avatarUrlData = [result objectForKey:@"picture"];
            avatarUrlData = [avatarUrlData objectForKey:@"data"];
            NSString *urlString = [avatarUrlData objectForKey:@"url"];
            [self.paramsDict setObject:urlString forKey:kKey_UpdateAvatar];
            avatarUrlData = [result objectForKey:@"location"];
            urlString = [avatarUrlData objectForKey:@"name"];
            [self.paramsDict setObject:urlString forKey:kKey_UpdateHometown];

            
            NSString *birthday = [result objectForKey:@"birthday"];
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"MM/dd/yyyy"];
            NSDate *date = [dateFormater dateFromString:birthday];
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            NSLog(@"birthday: %@", [dateFormater stringFromDate:date]);
            [self.paramsDict setObject:[dateFormater stringFromDate:date] forKey:kKey_UpdateBirthday];
            
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

#pragma mark text field delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textField %f", textField.frame.origin.y);
    if (textField.superview.frame.origin.y > 180) {
		[UIView beginAnimations: @"moveField" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationDuration: 0.25f];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
		self.view.frame = CGRectMake(0, -textField.superview.frame.origin.y + 120, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.25f];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
	[self textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
