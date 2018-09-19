//
//  UpdateUnitNameViewController.h
//  AircallClient
//
//  Created by ZWT112 on 11/14/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UpdateUnitNameViewControllerDelegate<NSObject>
-(void)updateUnitName:(NSString*)strName;
@end
@interface UpdateUnitNameViewController : ACCViewController
@property id<UpdateUnitNameViewControllerDelegate> delegate;
@property NSString *unitId;
@property NSString *unitName;
@end
