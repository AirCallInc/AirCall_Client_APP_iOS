//
//  ACCSummaryCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/26/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCSummaryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblPlanName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMethod;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UIButton *lblRemove;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UIView *vwSeprator;
@property (strong, nonatomic) IBOutlet UIView *vwUnitInfo;

-(void)setCellData:(ACCUnit*)unitInfo;

@end
