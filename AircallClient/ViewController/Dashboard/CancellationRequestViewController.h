//
//  CancellationRequestViewController.h
//  AircallClient
//
//  Created by ZWT112 on 6/1/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancellationRequestViewController : ACCViewController

@property NSString *serviceId;
@property NSString *notificationId;
@property NSString *selectedDate;
@property NSString *selectedTime;
@property NSInteger noOfUnits;
@property NSString *purposeOfVisit;
@end
