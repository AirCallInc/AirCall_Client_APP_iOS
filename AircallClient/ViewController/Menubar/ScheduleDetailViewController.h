//
//  ScheduleDetailViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScheduleDetailViewControllerDelegate<NSObject>
-(void)rescheduleSuccess:(NSString*)message;
@end
@interface ScheduleDetailViewController : ACCViewController

@property NSString *scheduleType;
@property NSString *scheduleId;
@property NSString *notificationId;
@property id<ScheduleDetailViewControllerDelegate> delegate;

@end
