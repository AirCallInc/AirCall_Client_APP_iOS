//
//  ACCMessageBar.m
//  AssetArbor
//
//  Created by Manali on 29/01/16.
//  Copyright © 2016 com.ztt.www. All rights reserved.
//

NSInteger const ACCValidationMsgHeight     = 15.0f;
NSInteger const ACCValidationMsgFontHeight = 10.0f;
NSString *const ACCValidationMsgFont       = @"Helvetica";

#import "ACCMessageBar.h"

@interface ACCMessageBar()

@property (strong, nonatomic) UILabel *lblMessage;
@property (strong, nonatomic) UIImageView *imgvIcon;

@end

@implementation ACCMessageBar

@synthesize lblMessage, message, imgvIcon;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self prepareView];
        [self prepareForError];
    }
    
    return self;
}

- (void)prepareView
{
    imgvIcon = [[UIImageView alloc] init];
    
    imgvIcon.frame            = CGRectMake(0, 0, 10, 10);
    imgvIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    imgvIcon.contentMode      = UIViewContentModeCenter;
    [self addSubview:imgvIcon];
    
    lblMessage                           = [[UILabel alloc] init];
    lblMessage.font                      = [UIFont fontWithName:ACCValidationMsgFont size:ACCValidationMsgFontHeight];
    lblMessage.frame                     = CGRectMake(17, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    lblMessage.minimumScaleFactor        = 0.5;
    lblMessage.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:lblMessage];
    self.clipsToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    super.frame = frame;
    
    lblMessage.frame = CGRectMake(17, 0, CGRectGetWidth(self.frame) - 17, CGRectGetHeight(self.frame));
}

- (void)setMessage:(NSString *)newMessage
{
    message = newMessage;
    
    lblMessage.text = message;
}

- (void)prepareForError
{
    lblMessage.textColor = [UIColor redColor];
    imgvIcon.image       = [UIImage imageNamed:@"Error"];
}

@end
