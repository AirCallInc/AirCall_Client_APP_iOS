//
//  ACCReceipt.m
//  AircallClient
//
//  Created by ZWT112 on 6/24/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCReceiptCell.h"

@implementation ACCReceiptCell
@synthesize lblPlanName,lblPrice,lblUnitName,lblPaymentMethod,indicator,lblPaymentError,btnPaymentProcess;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setCellData:(ACCUnit*)unitInfo ansIsPlanRenewal:(BOOL)isPlanRenewal
{
    if (isPlanRenewal)
    {
        indicator.hidden = YES;
        btnPaymentProcess.hidden = YES;
        [indicator stopAnimating];
    }
    else
    {
        if ([unitInfo.paymentStatus isEqualToString:@"Received"])
        {
            indicator.hidden = YES;
            [indicator stopAnimating];
            
            [btnPaymentProcess setImage:nil forState:UIControlStateNormal];
            [btnPaymentProcess setTitle:@"" forState:UIControlStateNormal];
            [btnPaymentProcess setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
            [btnPaymentProcess setImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
            [btnPaymentProcess setTitle:unitInfo.paymentStatus forState:UIControlStateNormal];
        }
        else if ([unitInfo.paymentStatus isEqualToString:@"Processing"])
        {
            if (indicator.hidden == YES)
            {
                indicator.hidden = NO;
            }
           
            [btnPaymentProcess setImage:nil forState:UIControlStateNormal];
            [btnPaymentProcess setTitle:@"" forState:UIControlStateNormal];
            [btnPaymentProcess setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnPaymentProcess setTitle:unitInfo.paymentStatus forState:UIControlStateNormal];
            
            if (!indicator.isAnimating)
            {
                [indicator startAnimating];
            }
            
        }
        else
        {
            indicator.hidden = YES;
            [indicator stopAnimating];
            [btnPaymentProcess setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btnPaymentProcess setImage:[UIImage imageNamed:@"Error"] forState:UIControlStateNormal];
            [btnPaymentProcess setTitle:unitInfo.paymentStatus forState:UIControlStateNormal];
            
            if (unitInfo.paymentError == nil || [unitInfo.paymentError isEqualToString:@""])
            {
                lblPaymentError.text = @"";
            }
            else
            {
                lblPaymentError.text = [NSString stringWithFormat:@"* %@",unitInfo.paymentError];
            }
        }
    }
    lblUnitName.text = unitInfo.unitName;
    lblPlanName.text = unitInfo.planName;
    lblPrice.text    = [NSString stringWithFormat:@"$%0.2f",unitInfo.planPrice];
    lblPaymentMethod.text = [NSString stringWithFormat:@"(%@)", unitInfo.planPaymentType];
}
@end
