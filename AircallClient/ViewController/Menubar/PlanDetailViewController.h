//
//  PlanDetailViewController.h
//  AircallClient
//
//  Created by ZWT112 on 6/28/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanDetailViewController : ACCViewController
@property (strong, nonatomic) IBOutlet UILabel *lblPlanHeader;
@property NSString *planId;
@property NSString *planName;
@end
