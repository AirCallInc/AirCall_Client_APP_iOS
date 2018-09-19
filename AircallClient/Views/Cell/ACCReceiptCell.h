//
//  ACCReceipt.h
//  AircallClient
//
//  Created by ZWT112 on 6/24/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCReceiptCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPlanName;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentMethod;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentError;
@property (weak, nonatomic) IBOutlet UIButton *btnPaymentProcess;


-(void)setCellData:(ACCUnit*)unitInfo ansIsPlanRenewal:(BOOL)isPlanRenewal;

@end
