//
//  RescheduleRequestViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RescheduleRequestViewController : ACCViewController
@property NSString *serviceId;
@property BOOL isFromRequestList;
@property NSString *selectedTimeSlot;
@property NSString *selectedDate;
@property NSInteger noOfUnits;
@property NSString *purposeOfVisit;

@end
