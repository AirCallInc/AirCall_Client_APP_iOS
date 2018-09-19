//
//  ACCFuseCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/27/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCFuseCell.h"

@implementation ACCFuseCell
@synthesize txtFuseSize,txtSplitFuseSize;

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
    txtSplitFuseSize.placeholder = nil;
    txtFuseSize.placeholder = nil;
    txtFuseSize.text = nil;
    txtSplitFuseSize.text = nil;
}
@end
