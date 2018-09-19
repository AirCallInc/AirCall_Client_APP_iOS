//
//  ReceiptViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/26/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptViewController : ACCViewController

@property NSString *stripeCardId;
@property NSDictionary *dictReceipt;
@property BOOL isPlanRenewal;

@end
