//
//  ACCFilterCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCFilterCell.h"

@implementation ACCFilterCell
@synthesize txtSplitFilterSize,txtFilterSize,btnInsideSpace,btnInsideEquipment;
- (void)awakeFromNib
{
   [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    btnInsideEquipment.selected = NO;
    btnInsideSpace.selected= NO;
    txtFilterSize.placeholder = nil;
    txtSplitFilterSize.placeholder = nil;
    txtFilterSize.text = nil;
    txtSplitFilterSize.text = nil;
}
@end
