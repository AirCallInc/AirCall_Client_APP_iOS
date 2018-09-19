//
//  ACCTextField.m
//  AircallClient
//
//  Created by ZWT112 on 6/3/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCTextField.h"

@implementation ACCTextField
@synthesize rightOffset,leftOffset,borderColor;
- (void)awakeFromNib
{
    rightOffset = 15;
    leftOffset  = 15;
    
    borderColor = [UIColor borderColor];
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0;
    
    self.font = [UIFont fontWithName:@"OpenSans-Light" size:15];
    UIColor *color = [UIColor placeholderColor];
    if (self.placeholder != nil)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    UIEdgeInsets insets = {0, rightOffset, 0, leftOffset};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, rightOffset, 0, leftOffset);
    
    return UIEdgeInsetsInsetRect(rect, insets);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect rect = [super editingRectForBounds:bounds];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, rightOffset, 0, leftOffset);
    UIColor *color = [UIColor placeholderColor];
    if (self.placeholder != nil)
    {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
    return UIEdgeInsetsInsetRect(rect, insets);
}
@end
