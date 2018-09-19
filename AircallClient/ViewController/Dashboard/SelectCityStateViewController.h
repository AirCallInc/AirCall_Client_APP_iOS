//
//  SelectCityStateViewController.h
//  AircallClient
//
//  Created by ZWT112 on 6/6/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCityStateViewControllerDelegate <NSObject>
-(void)SelectionValue:(NSDictionary*)selectedDict isCity:(bool)ans;
@end

@interface SelectCityStateViewController : ACCViewController


@property BOOL isCity;

@property NSString *selectedStateId;
@property NSString *selectedCityId;

@property (nonatomic,strong) id<SelectCityStateViewControllerDelegate> delegate;
@end
