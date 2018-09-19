//
//  ACCRequestCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCRequestCell.h"

@implementation ACCRequestCell
@synthesize lblUnit,lblRequestInfo;

- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setCellData:(ACCService*)service
{
    lblUnit.text = service.unitName;
    lblRequestInfo.text = [NSString stringWithFormat:@"Requested service on %@ at %@ for %@",service.serviceDate,service.serviceTime,service.visitPurpose];
}
@end
