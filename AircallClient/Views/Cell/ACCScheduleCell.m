//
//  ACCScheduleCell.m
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCScheduleCell.h"

@implementation ACCScheduleCell

@synthesize lblDay,lblTime,lblMessage;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setCellData:(ACCSchedule *)scheduleInfo
{
    //lblDay.text = scheduleInfo.scheduleDate;
    //lblMonth.text = scheduleInfo.scheduleMonthName;
   //lblYear.text = scheduleInfo.scheduleYear;
    
    if ([scheduleInfo.scheduleStatus isEqualToString:@"Scheduled"])
    {
        lblTime.text = scheduleInfo.scheduleDate;
        lblDay.text = [NSString stringWithFormat:@"%@ - %@",scheduleInfo.scheduleStartTime,scheduleInfo.scheduleEndTime];//scheduleInfo.scheduleDate;
        lblTime.backgroundColor = [UIColor whiteColor];
        lblDay.backgroundColor  = [UIColor whiteColor];
        lblTime.textColor       = [UIColor appGreenColor];
        lblDay.textColor        = [UIColor appGreenColor];
    }
    else
    {
        lblTime.text = scheduleInfo.appoinmentNo;
        lblDay.text = scheduleInfo.scheduleDate;
        lblTime.backgroundColor = [UIColor colorWithRed:242.0/255 green:245.0/255 blue:250.0/255 alpha:1.0];
        lblDay.backgroundColor  = [UIColor colorWithRed:242.0/255 green:245.0/255 blue:250.0/255 alpha:1.0];
        lblTime.textColor       = [UIColor blackColor];
        lblDay.textColor        = [UIColor blackColor];
    }
    
    lblMessage.text = scheduleInfo.upcomingMsg;
    
}
@end
