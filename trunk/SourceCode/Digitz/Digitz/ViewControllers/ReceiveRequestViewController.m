//
//  ReceiveRequestViewController.m
//  Digitz
//
//  Created by chuanhd on 5/5/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "ReceiveRequestViewController.h"
#import "DigitzUtils.h"
#import "SocialShareCell.h"
#import "EnterYourDigitzViewController.h"
#import "DigitzActivity.h"


@interface ReceiveRequestViewController ()
{

}

@end

@implementation ReceiveRequestViewController

@synthesize request = _request;
@synthesize serverManager;
@synthesize fields = _fields;

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
    
    self.tableSocialShare.delegate = self;
    self.tableSocialShare.dataSource = self;
    
    serverManager = [[ServerManager alloc] init];
    serverManager.delegate = self;
    
    if (_request.sender.name != nil && ![_request.sender.name isEqual:[NSNull null]]) {
        self.lblUsername.text = _request.sender.name;
    }else{
        self.lblUsername.text = _request.sender.username;
    }
    
    self.lblAddress.text = _request.sender.hometown;
    
    _fields = [NSMutableArray arrayWithObjects:@"username", @"email", @"name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar", @"facebook_url", @"google_plus_url", @"twitter_url", @"linkedin_url", @"instagram_url", @"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
}

- (NSString *) buildFieldsString
{
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < _fields.count; i++) {
        if (i == _fields.count - 1) {
            [result appendString:[_fields objectAtIndex:i]];
        }else{
            [result appendFormat:@"%@,",[_fields objectAtIndex:i]];
        }
    }
    return result;
}

- (void)addFieldToArray:(NSString *)field
{
    if (![_fields containsObject:field]) {
        [_fields addObject:field];
    }
}

- (void) removeFieldFromArray:(NSString *)field
{
    [_fields removeObject:field];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)settingBtnTapped:(id)sender {
}

- (IBAction)acceptBtnTapped:(id)sender {
    
    NSLog(@"fields: %@", [self buildFieldsString]);
        
    [serverManager acceptFriendRequestWithFriendUsername:self.request.sender.username withFields:[self buildFieldsString] withType:kKey_FamilyType];
}

- (void)acceptFriendSuccessful
{
    DigitzActivity *activity = [[DigitzActivity alloc] initWithDescription:[NSString stringWithFormat:@"Accept %@ friend request.", self.request.sender.username]];
    [DigitzUtils addActivity:activity];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DigitzUtils showToast:@"Friend request was accepted" inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)acceptFriendFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Accept friend failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)declineBtnTapped:(id)sender {
    [serverManager declineFriendRequestWithRequestId:_request.requestId];
}

- (void)declineFriendSuccessful
{
    
    DigitzActivity *activity = [[DigitzActivity alloc] initWithDescription:[NSString stringWithFormat:@"Decline %@ friend request.", self.request.sender.username]];
    [DigitzUtils addActivity:activity];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DigitzUtils showToast:@"Friend request was declined" inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    });}

- (void)declineFriendFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Decline friend request failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SocialShareCell";
    
    SocialShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"SocialShareCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    cell.parentVC = self;
    //cell.index = indexPath.row;
    switch (indexPath.row) {
        case 0:
            cell.lblSocialNetworkName.text = @"Facebook";
            cell.index = 0;
            break;
        case 1:
            cell.lblSocialNetworkName.text = @"Google+";
            cell.index = 1;
            break;
        case 2:
            cell.lblSocialNetworkName.text = @"Twitter";
            cell.index = 2;
            break;
        case 3:
            cell.lblSocialNetworkName.text = @"Instagram";
            cell.index = 3;
            break;
        case 4:
            cell.lblSocialNetworkName.text = @"Linkedin";
            cell.index = 4;
            break;
        default:
            break;
    }
    
    return cell;
}

@end

