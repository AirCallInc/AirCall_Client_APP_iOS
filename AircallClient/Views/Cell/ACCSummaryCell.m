//
//  ACCSummaryCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/26/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCSummaryCell.h"

@implementation ACCSummaryCell
@synthesize lblDesc,lblPrice,lblPlanName,lblRemove,lblPaymentMethod,lblUnitName,vwSeprator,vwUnitInfo;

- (void)awakeFromNib
{
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setCellData:(ACCUnit*)unitInfo
{
    CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.1 , FLT_MAX);
    lblUnitName.text = unitInfo.unitName;
    lblPlanName.text = unitInfo.planName;
    lblPrice.text = [NSString stringWithFormat:@"$%0.2f",unitInfo.planPrice];
    NSString *stringMeaage = unitInfo.planDescription;
    lblPaymentMethod.text = unitInfo.planPaymentType;
    if (![lblPaymentMethod.text isEqualToString: @"Recurring"])
    {
        lblPaymentMethod.textColor = [UIColor appGreenColor];
//        lblPaymentMethod.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:12.0];
    }
    else
    {
        lblPaymentMethod.textColor = [UIColor blackColor];
//        lblPaymentMethod.font = [UIFont fontWithName:@"OpenSans-Regular" size:12.0];
    }
    
    
    
    UIFont *font = [self setFontSize];
    
    CGSize size = [stringMeaage boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
    
    lblDesc.numberOfLines = 0;
    lblDesc.lineBreakMode = NSLineBreakByWordWrapping;
    lblDesc.text = stringMeaage;
    lblDesc.font = font;
    
    lblDesc.frame = CGRectMake(lblDesc.x, lblDesc.y, size.width, size.height);
    lblRemove.frame = CGRectMake(lblRemove.x, lblDesc.y + lblDesc.height + 10, lblRemove.width, lblRemove.height);
    vwSeprator.frame = CGRectMake(vwSeprator.x, lblRemove.y + lblRemove.height + 10, vwSeprator.width, vwSeprator.height);
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
        font = [UIFont systemFontOfSize:12.5];
    }
    else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
    {
        font = [UIFont systemFontOfSize:13.5];
    }
    else
    {
        font = [UIFont systemFontOfSize:14.5];
    }
    
    return font;
}
@end
