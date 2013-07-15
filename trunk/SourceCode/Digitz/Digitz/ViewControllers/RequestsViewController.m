//
//  RequestsViewController.m
//  Digitz
//
//  Created by chuanhd on 5/19/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "RequestsViewController.h"
#import "DigitzRequest.h"
#import "ReceiveRequestViewController.h"
#import "UserCell.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController

@synthesize requestArray;

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
    self.requestTableView.delegate = self;
    self.requestTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.requestArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UserCell";
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *itemArray = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
        cell = [itemArray objectAtIndex:0];
    }
    
    __weak DigitzRequest *request = [self.requestArray objectAtIndex:indexPath.row];
    __weak User *sender = request.sender;

    NSLog(@"user %@", sender.username);
    
    if (![sender.firstName isEqual:[NSNull null]]) {
        
        NSMutableString *fullName = [NSMutableString stringWithString:sender.firstName];
        
        if (![sender.lastName isEqual:[NSNull null]]) {
            [fullName appendFormat:@" %@", sender.lastName];
        }
        
        cell.txtUsername.text = fullName;
    }else{
        if (![sender.lastName isEqual:[NSNull null]]) {
            cell.txtUsername.text = sender.lastName;
        }else{
            if(![sender.username isEqual:[NSNull null]]){
                cell.txtUsername.text = sender.username;
            }else{
                cell.txtUsername.text = @"Error";
            }
        }
    }

    if (![sender.hometown isEqual:[NSNull null]]) {
        cell.txtHometown.text = sender.hometown;
    }else{
        cell.txtHometown.text = @"Error";
    }

    if (![sender.avatarUrl isEqual:[NSNull null]]) {
        cell.avatarUrlStr = sender.avatarUrl;
        [cell loadAvatarFromUrlString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveRequestViewController *vc = [[ReceiveRequestViewController alloc] initWithNibName:nil bundle:nil];
    __weak DigitzRequest *request = [self.requestArray objectAtIndex:indexPath.row];
    vc.request = request;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
