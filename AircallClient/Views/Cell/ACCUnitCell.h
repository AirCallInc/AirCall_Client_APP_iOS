//
//  ACCUnitCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCUnitCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblPlan;

@property NSString *unitId;
-(void)setCellData:(ACCUnit *)unitInfo;
-(void)setReceiptData:(ACCUnit *)receiptInfo;
@end
