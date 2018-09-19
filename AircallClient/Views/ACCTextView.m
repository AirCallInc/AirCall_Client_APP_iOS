//
//  ACCTextView.m
//  AircallClient
//
//  Created by ZWT112 on 6/3/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCTextView.h"

@implementation ACCTextView
@synthesize rightOffset,leftOffset,borderColor,topOffset,bottomOffset;

- (void)awakeFromNib
{
    rightOffset  = 10;
    leftOffset   = 10;
    bottomOffset = 5;
    topOffset    = 5;
    
    borderColor = [UIColor borderColor];
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0;
    
    self.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    
    
}
- (void)drawRect:(CGRect)rect
{
    [self setTextContainerInset:UIEdgeInsetsMake(bottomOffset, rightOffset, topOffset, leftOffset)];
}



@end
