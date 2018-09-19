//
//  PaymentMethodViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PaymentMethodViewControllerDelegate <NSObject>

- (void)CardDetail:(NSDictionary*)dict;

@end

@interface PaymentMethodViewController : ACCViewController
@property BOOL hidePlusBtn;
@property (weak, nonatomic) id<PaymentMethodViewControllerDelegate> delegate;
@end
