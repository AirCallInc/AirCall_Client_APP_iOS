//
//  BillingAddressViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingAddressViewController : ACCViewController

@property NSString *notificationId;
@property NSString *unitId;
@property BOOL isFromNoShow;
@property BOOL isPlanRenewal;
@property NSString *totalAmount;
@property NSString *noShowId;
@end
