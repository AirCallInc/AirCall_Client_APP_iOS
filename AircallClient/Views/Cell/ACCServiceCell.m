//
//  ACCServiceCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCServiceCell.h"

@implementation ACCServiceCell
@synthesize lblPlanName,lblUnitName,lblServiceCaseNo,lblServiceInfo,isWorkNotDone;

- (void)awakeFromNib
{
     [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setCellData:(ACCService *)service
{
    lblPlanName.text      = service.planName;
    lblUnitName.text      = service.unitName;
    lblServiceInfo.text   = service.message;
    isWorkNotDone         = service.isWorkNotDone;
    
    if (isWorkNotDone)
    {
        lblServiceCaseNo.text = [NSString stringWithFormat:@"%@  (No Show)", service.serviceCaseNo];
    }
    else
    {
        lblServiceCaseNo.text = service.serviceCaseNo;
    }
}
@end
