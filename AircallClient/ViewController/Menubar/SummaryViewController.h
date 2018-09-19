//
//  SummaryViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/24/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryViewController : ACCViewController
@property BOOL isFromNotificationList;
@property BOOL isPlanRenewal;
@property NSDictionary *dictUnitInfo;
@property NSString *unitId;
@property NSString *notificationId;
@property NSString *notificationType;
@property NSString *msgInactivePlan;
@end
