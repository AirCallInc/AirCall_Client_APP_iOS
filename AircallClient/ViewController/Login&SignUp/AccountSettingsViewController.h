//
//  AccountSettingsViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AccountSettingsViewControllerDelegate<NSObject>
-(void)isFromAccountSettings;
@end
@interface AccountSettingsViewController : ACCViewController
@property id<AccountSettingsViewControllerDelegate> delegate;
@end
