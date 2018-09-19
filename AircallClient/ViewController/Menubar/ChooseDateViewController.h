//
//  ChooseDateViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/30/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseDateViewControllerDelegate <NSObject>

- (void)setDate:(NSString*)date;

@end
@interface ChooseDateViewController : ACCViewController
@property (weak, nonatomic) id<ChooseDateViewControllerDelegate> delegate;
@property NSString *selectedDate;
@property NSInteger dayGap;
@property BOOL isAllowWeekEnds;
@end
