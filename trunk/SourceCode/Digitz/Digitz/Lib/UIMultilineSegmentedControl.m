//
//  UIMultilineSegmentedControl.m
//  Digitz
//
//  Created by chuanhd on 5/12/13.
//  Copyright (c) 2013 N2Corp. All rights reserved.
//

#import "UIMultilineSegmentedControl.h"
#import "UIView+LayerShot.h"

@interface UIMultilineSegmentedControl ()

@property (strong, nonatomic) UILabel *theLabel;

@end

@implementation UIMultilineSegmentedControl

@synthesize theLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UILabel *) theLabel
{
    if (!self->theLabel) {
        self->theLabel = [[UILabel alloc] initWithFrame:self.frame];
        self->theLabel.textColor = [UIColor whiteColor];
        self->theLabel.backgroundColor = [UIColor clearColor];
        self->theLabel.font = [UIFont boldSystemFontOfSize:13];
        self->theLabel.textAlignment = UITextAlignmentCenter;
        self->theLabel.lineBreakMode = UILineBreakModeWordWrap;
        self->theLabel.shadowColor = [UIColor darkGrayColor];
        self->theLabel.numberOfLines = 9;
    }
    
    return self->theLabel;
}

- (void)setMultilineTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segmentIndex
{
    self.theLabel.text = title;
    [self.theLabel sizeToFit];
    self.theLabel.frame = CGRectMake(2, 2, 66, 40);
    
    [self setImage:self.theLabel.imageFromLayer forSegmentAtIndex:segmentIndex];
}

@end
