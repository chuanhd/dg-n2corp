//
//  PrivacySettingsViewController.m
//  Digitz
//
//  Created by chuanhd on 5/11/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "PrivacySettingsViewController.h"
#import "SocialShareCell.h"
#import "ProfileViewController.h"
#import "EnterYourDigitzViewController.h"
#import "DigitzUtils.h"

@interface PrivacySettingsViewController ()

@end

@implementation PrivacySettingsViewController

@synthesize parentVC = _parentVC;
@synthesize serverManager = _serverManager;
@synthesize privacyFieldsFri = _privacyFieldsFri;
@synthesize privacyFieldsAcc = _privacyFieldsAcc;
@synthesize privacyFieldsBus = _privacyFieldsBus;

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
    
    self.privacySettingTable.delegate = self;
    self.privacySettingTable.dataSource = self;
    
    _serverManager = [[ServerManager alloc] init];
    _serverManager.delegate = self;

    if ([_parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        EnterYourDigitzViewController *temp = (EnterYourDigitzViewController *) _parentVC;
        
        NSString *tempStr = [temp.paramsDict objectForKey:kKey_PrivacyAcc];
        
        _privacyFieldsAcc = [DigitzUtils splitString:tempStr withSeparator:@","];
        
        if (_privacyFieldsAcc == nil || _privacyFieldsAcc.count == 0) {
            _privacyFieldsAcc = [NSMutableArray arrayWithObjects:@"username", @"email", @"first_name", @"last_name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar",@"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
        }
        
        tempStr = [temp.paramsDict objectForKey:kKey_PrivacyBus];
        
        _privacyFieldsBus = [DigitzUtils splitString:tempStr withSeparator:@","];
        
        if (_privacyFieldsBus == nil || _privacyFieldsBus.count == 0) {
            _privacyFieldsBus = [NSMutableArray arrayWithObjects:@"username", @"email", @"first_name", @"last_name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar",@"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
        }
        
        tempStr = [temp.paramsDict objectForKey:kKey_PrivacyFri];
        
        _privacyFieldsFri = [DigitzUtils splitString:tempStr withSeparator:@","];
        
        if (_privacyFieldsFri == nil || _privacyFieldsFri.count == 0) {
            _privacyFieldsFri = [NSMutableArray arrayWithObjects:@"username", @"email", @"first_name", @"last_name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar",@"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
        }
    }else if ([_parentVC isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *temp = (ProfileViewController *) _parentVC;
        NSString *tempStr = [temp.paramsDict objectForKey:kKey_PrivacyAcc];
        
        _privacyFieldsAcc = [DigitzUtils splitString:tempStr withSeparator:@","];
        
        if (_privacyFieldsAcc == nil || _privacyFieldsAcc.count == 0) {
            _privacyFieldsAcc = [NSMutableArray arrayWithObjects:@"username", @"email", @"first_name", @"last_name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar",@"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
        }
        
        tempStr = [temp.paramsDict objectForKey:kKey_PrivacyBus];
        
        _privacyFieldsBus = [DigitzUtils splitString:tempStr withSeparator:@","];
        
        if (_privacyFieldsBus == nil || _privacyFieldsBus.count == 0) {
            _privacyFieldsBus = [NSMutableArray arrayWithObjects:@"username", @"email", @"first_name", @"last_name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar",@"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
        }
        
        tempStr = [temp.paramsDict objectForKey:kKey_PrivacyFri];
        
        _privacyFieldsFri = [DigitzUtils splitString:tempStr withSeparator:@","];
        
        if (_privacyFieldsFri == nil || _privacyFieldsFri.count == 0) {
            _privacyFieldsFri = [NSMutableArray arrayWithObjects:@"username", @"email", @"first_name", @"last_name", @"age", @"gender", @"phone_number",@"hometown", @"birthday", @"blog_url", @"notes", @"avatar",@"company", @"address", @"homepage", @"email_home", @"email_work", @"cell_phone" ,@"home_phone", @"work_phone", @"bio", nil];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) buildFieldsStringFromArray:(NSMutableArray *)array
{
    NSMutableString *result = [NSMutableString string];
    for (NSInteger i = 0; i < array.count; i++) {
        if (i == array.count - 1) {
            [result appendString:[array objectAtIndex:i]];
        }else{
            [result appendFormat:@"%@,",[array objectAtIndex:i]];
        }
    }
    return result;
}

- (void) addFieldToArrayType:(NSInteger)type withField:(NSString *)field
{
    switch (type) {
        case 0:
        {
            if (![_privacyFieldsAcc containsObject:field]) {
                [_privacyFieldsAcc addObject:field];
            }
        }
            break;
        case 1:
        {
            if (![_privacyFieldsFri containsObject:field]) {
                [_privacyFieldsFri addObject:field];
            }
        }
            break;
        case 2:
        {
            if (![_privacyFieldsBus containsObject:field]) {
                [_privacyFieldsBus addObject:field];
            }
        }
            break;
        default:
            break;
    }
}

- (void) removeFieldFromArrayType:(NSInteger)type withField:(NSString *)field
{
    switch (type) {
        case 0:
        {
            [_privacyFieldsAcc removeObject:field];
        }
            break;
        case 1:
        {
            [_privacyFieldsFri removeObject:field];
        }
            break;
        case 2:
        {
            [_privacyFieldsBus removeObject:field];
        }
            break;
        default:
            break;
    }
}

- (IBAction)backBtnTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveBtnTapped:(id)sender {
    
    NSLog(@"acc: %@", [self buildFieldsStringFromArray:_privacyFieldsAcc]);
    NSLog(@"fri: %@", [self buildFieldsStringFromArray:_privacyFieldsFri]);
    NSLog(@"bus: %@", [self buildFieldsStringFromArray:_privacyFieldsBus]);
    
    if ([_parentVC isKindOfClass:[EnterYourDigitzViewController class]]) {
        EnterYourDigitzViewController *temp = (EnterYourDigitzViewController *) _parentVC;
        
        [temp.paramsDict setObject:[self buildFieldsStringFromArray:_privacyFieldsAcc] forKey:kKey_PrivacyAcc];
        [temp.paramsDict setObject:[self buildFieldsStringFromArray:_privacyFieldsBus] forKey:kKey_PrivacyBus];
        [temp.paramsDict setObject:[self buildFieldsStringFromArray:_privacyFieldsFri] forKey:kKey_PrivacyFri];
        
        temp.privacySettingFilled = YES;
    }else if ([_parentVC isKindOfClass:[ProfileViewController class]]){
        ProfileViewController *temp = (ProfileViewController *) _parentVC;
        
        [temp.paramsDict setObject:[self buildFieldsStringFromArray:_privacyFieldsAcc] forKey:kKey_PrivacyAcc];
        [temp.paramsDict setObject:[self buildFieldsStringFromArray:_privacyFieldsBus] forKey:kKey_PrivacyBus];
        [temp.paramsDict setObject:[self buildFieldsStringFromArray:_privacyFieldsFri] forKey:kKey_PrivacyFri];
        temp.privacySettingFilled = YES;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"personalInfoFilled" object:self userInfo:nil];

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Acquaintance";
        case 1:
            return @"Friends/Family";
        case 2:
            return @"Business";
        default:
            return @"";
    }
}

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
    
    // @"facebook_url", @"google_plus_url", @"twitter_url", @"linkedin_url", @"instagram_url", 
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.lblSocialNetworkName.text = @"Facebook";
                    cell.index = 0;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsAcc containsObject:@"facebook_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 1:
                    cell.lblSocialNetworkName.text = @"Google+";
                    cell.index = 1;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsAcc containsObject:@"google_plus_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 2:
                    cell.lblSocialNetworkName.text = @"Twitter";
                    cell.index = 2;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsAcc containsObject:@"twitter_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 3:
                    cell.lblSocialNetworkName.text = @"Instagram";
                    cell.index = 3;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsAcc containsObject:@"instagram_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 4:
                    cell.lblSocialNetworkName.text = @"Linkedin";
                    cell.index = 4;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsAcc containsObject:@"linkedin_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    cell.lblSocialNetworkName.text = @"Facebook";
                    cell.index = 0;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsFri containsObject:@"facebook_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 1:
                    cell.lblSocialNetworkName.text = @"Google+";
                    cell.index = 1;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsFri containsObject:@"google_plus_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 2:
                    cell.lblSocialNetworkName.text = @"Twitter";
                    cell.index = 2;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsFri containsObject:@"twitter_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 3:
                    cell.lblSocialNetworkName.text = @"Instagram";
                    cell.index = 3;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsFri containsObject:@"instagram_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 4:
                    cell.lblSocialNetworkName.text = @"Linkedin";
                    cell.index = 4;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsFri containsObject:@"linkedin_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    cell.lblSocialNetworkName.text = @"Facebook";
                    cell.index = 0;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsBus containsObject:@"facebook_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 1:
                    cell.lblSocialNetworkName.text = @"Google+";
                    cell.index = 1;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsBus containsObject:@"google_plus_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 2:
                    cell.lblSocialNetworkName.text = @"Twitter";
                    cell.index = 2;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsBus containsObject:@"twitter_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 3:
                    cell.lblSocialNetworkName.text = @"Instagram";
                    cell.index = 3;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsBus containsObject:@"instagram_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                case 4:
                    cell.lblSocialNetworkName.text = @"Linkedin";
                    cell.index = 4;
                    cell.section = indexPath.section;
                    if ([_privacyFieldsBus containsObject:@"linkedin_url"]) {
                        [cell.switchShare setOn:YES animated:NO];
                    }else{
                        [cell.switchShare setOn:NO animated:NO];
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
//    switch (indexPath.row) {
//        case 0:
//            cell.lblSocialNetworkName.text = @"Facebook";
//            cell.index = 0;
//            cell.section = indexPath.section;
//            break;
//        case 1:
//            cell.lblSocialNetworkName.text = @"Google+";
//            cell.index = 1;
//            cell.section = indexPath.section;
//            break;
//        case 2:
//            cell.lblSocialNetworkName.text = @"Twitter";
//            cell.index = 2;
//            cell.section = indexPath.section;
//            break;
//        case 3:
//            cell.lblSocialNetworkName.text = @"Instagram";
//            cell.index = 3;
//            cell.section = indexPath.section;
//            break;
//        case 4:
//            cell.lblSocialNetworkName.text = @"Linkedin";
//            cell.index = 4;
//            cell.section = indexPath.section;
//            break;
//        default:
//            break;
//    }
//    
    return cell;
}

@end
