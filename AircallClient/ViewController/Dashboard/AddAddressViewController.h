//
//  AddAddressViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAddressViewControllerDelegate <NSObject>

-(void)AddressList:(NSMutableArray *)addressList;

@end

@interface AddAddressViewController : ACCViewController

@property (nonatomic,strong) id<AddAddressViewControllerDelegate> delegate;

@property (nonatomic, strong) ACCAddress *address   ;
@property  bool  isEditAddress   ;
@property BOOL isAllowDelete;
@property NSInteger addressCount;

@end
