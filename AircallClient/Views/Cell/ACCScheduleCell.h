//
//  ACCScheduleCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCScheduleCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

-(void)setCellData:(ACCSchedule*)schedule;
@end
