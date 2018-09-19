//
//  PaymentViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/26/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : ACCViewController
@property BOOL isFromNoShow;
@property BOOL isPlanRenewal;
@property NSString *totalAmount;
@property NSDictionary *dictBillingAddress;
@property NSString *noShowId;
@property NSString *notificationId;
@property NSString *termsPdfURL;
@end
