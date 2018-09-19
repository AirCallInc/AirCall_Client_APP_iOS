//
//  ACCTextView.h
//  AircallClient
//
//  Created by ZWT112 on 6/3/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCTextView : UITextView

@property (strong, nonatomic) UIColor *borderColor;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, assign) CGFloat topOffset;
@property (nonatomic, assign) CGFloat bottomOffset;

@end
