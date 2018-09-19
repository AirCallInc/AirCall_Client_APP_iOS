//
//  ACCPaymentCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCPaymentCell.h"

@implementation ACCPaymentCell
@synthesize lblName,lblCardNumber,lblExpiryYear,lblExpiryMonth;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)setCellData:(ACCCard *)card
{
    lblExpiryMonth.text = [NSString stringWithFormat:@"%@", card.expiryMonth];
    lblExpiryYear.text = [NSString stringWithFormat:@"%@",card.expiryYear];
    lblCardNumber.text = card.cardNumber;
    lblName.text = card.nameOnCard;
}
@end
