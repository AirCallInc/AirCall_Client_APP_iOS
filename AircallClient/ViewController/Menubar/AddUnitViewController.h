//
//  AddUnitViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const UnitTypePackaged ;
extern NSString *const UnitTypeHeating  ;
extern NSString *const UnitTypeSplit    ;
extern NSString *const UnitTypeCooling  ;
extern NSString *const UnittypeHeating  ;

@interface AddUnitViewController : ACCViewController

@property NSString * strBlankSummary;
@property NSInteger allowQtyOfUnits;
@property NSInteger allowVisitPerYear;

@end
