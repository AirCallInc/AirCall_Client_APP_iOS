//
//  SelectAddressViewController.h
//  AircallClient
//
//  Created by Manali on 28/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAddressViewControllerDelegate <NSObject>
-(void)SelectionValue:(NSString*)selectedId;
@end

@interface SelectAddressViewController : ACCViewController

@property (nonatomic,strong) id<SelectAddressViewControllerDelegate> delegate;

@property NSString * selectedAddressId;

@end
