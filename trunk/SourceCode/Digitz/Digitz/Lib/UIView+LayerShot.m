//
//  UIView+LayerShot.m
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "UIView+LayerShot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (LayerShot)

- (UIImage *)imageFromLayer
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
