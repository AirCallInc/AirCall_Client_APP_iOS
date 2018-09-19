//
//  ChooseMonthYearViewController.h
//  AircallClient
//
//  Created by ZWT112 on 10/14/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseMonthYearViewControllerDelegate <NSObject>

- (void)setMonthYear:(NSString*)date;

@end
@interface ChooseMonthYearViewController : ACCViewController
@property (weak, nonatomic) id<ChooseMonthYearViewControllerDelegate> delegate;
@end
