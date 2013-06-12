//
//  TnCViewController.h
//  Digitz
//
//  Created by chuanhd on 6/9/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TnCViewController : UIViewController <UIWebViewDelegate>

@property UIViewController *parentVC;

@property (weak, nonatomic) IBOutlet UIWebView *webTnC;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)acceptBtnTapped:(id)sender;
@end
