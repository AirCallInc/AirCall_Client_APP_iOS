//
//  ACCUnitCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCUnitCell.h"

@implementation ACCUnitCell
@synthesize lblPlan,lblUnit,lblStatus;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setCellData:(ACCUnit *)unitInfo
{
    lblPlan.text   = unitInfo.planName;
    lblStatus.text =  [NSString stringWithFormat:@"%@", unitInfo.statusDesc];//unitInfo.status;
    lblUnit.text   = unitInfo.unitName;
    
}
-(void)setReceiptData:(ACCUnit *)receiptInfo
{
    
}
@end
