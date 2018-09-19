//
//  ACCPlanCell.h
//  AircallClient
//
//  Created by ZWT112 on 6/27/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCPlanCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblPlanName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imgvPlan;
@property (weak, nonatomic) IBOutlet UILabel *lblServiceInfo;

-(void)setCellData:(ACCUnit*)plan;

@end
