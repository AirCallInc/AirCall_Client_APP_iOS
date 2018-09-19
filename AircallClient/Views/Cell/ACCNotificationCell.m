//
//  ACCNotificationCell.m
//  AircallClient
//
//  Created by ZWT112 on 6/8/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCNotificationCell.h"

@implementation ACCNotificationCell
@synthesize imgvServiceMan,lblMessage,lblTime,lblDate,lblYear,lblMonth;

- (void)awakeFromNib
{
    [super awakeFromNib];
   
}
-(void)setCellData:(ACCNotification *)notificationInfo isFromNotificationList:(BOOL)isFromList
{
    NSString *strMessage;
    CGSize constraint;
    
    imgvServiceMan.layer.cornerRadius = imgvServiceMan.height / 2;
    [imgvServiceMan setClipsToBounds:YES];
    
    if (notificationInfo.serviceManImage.absoluteString.length != 0)
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
        [imgvServiceMan setImageWithURL:notificationInfo.serviceManImage placeholderImage:nil];
        imgvServiceMan.hidden = NO;
    }
    else
    {
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.30 , FLT_MAX);
        imgvServiceMan.hidden = YES;
    }
    
    if (isFromList)
    {
        strMessage =[NSString stringWithFormat:@"%@\n\n%@",notificationInfo.message,notificationInfo.notificationDateTime];
        
        if (![notificationInfo.notificationStatus isEqualToString: @"Read"])
        {
            self.backgroundColor = [UIColor colorWithRed:0.91 green:0.93 blue:0.95 alpha:1.0];
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    else
    {
        if ([notificationInfo.notificationType isEqualToString:@"1"])
        {
            strMessage =[NSString stringWithFormat:@"%@",notificationInfo.message];
            lblDate.text = notificationInfo.day;
            lblMonth.text = notificationInfo.month;
            lblYear.text = notificationInfo.year;
            lblTime.text = [NSString stringWithFormat:@"%@ - %@",notificationInfo.startTime,notificationInfo.endTime];
        }
        else
        {
            [imgvServiceMan setImageWithURL:notificationInfo.serviceManImage placeholderImage:nil];
            strMessage =[NSString stringWithFormat:@"%@",notificationInfo.message];
        }
    }
    
    UIFont *font = [self setFontSize];
    
    CGSize size = [strMessage boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
    
    lblMessage.numberOfLines = 0;
    lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
    lblMessage.text = strMessage;
    lblMessage.font = font;
    
    lblMessage.frame = CGRectMake(lblMessage.x, lblMessage.y, size.width, size.height);
}

-(UIFont*)setFontSize
{
    UIFont *font;
    
    if(ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone4)
    {
        font = [UIFont systemFontOfSize:7];
    }
    else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone5)
    {
        font = [UIFont systemFontOfSize:13.5];
    }
    else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
    {
        font = [UIFont systemFontOfSize:14.5];
    }
    else
    {
        font = [UIFont systemFontOfSize:15.5];
    }
    
    return font;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
