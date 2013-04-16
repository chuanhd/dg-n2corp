//
//  EnterYourDigitzViewController.h
//  Digitz
//
//  Created by TRAN NGUYEN LE on 4/15/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"

@interface EnterYourDigitzViewController : UIViewController <ServerManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
