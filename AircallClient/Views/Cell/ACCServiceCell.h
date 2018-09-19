//
//  ACCServiceCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCServiceCell : UITableViewCell

@property NSString *serviceId;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UILabel *lblPlanName;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceCaseNo;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceInfo;
@property BOOL isWorkNotDone;
-(void)setCellData:(ACCService *)service;
@end
