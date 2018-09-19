//
//  ChooseTimeViewController.h
//  AircallClient
//
//  Created by Manali Shah on 14/02/17.
//  Copyright © 2017 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseTimeViewControllerDelegate <NSObject>

- (void)setTime:(NSString*)time;

@end


@interface ChooseTimeViewController : ACCViewController
@property (weak, nonatomic) id<ChooseTimeViewControllerDelegate> delegate;
@property NSString *selectedTime;
@end
