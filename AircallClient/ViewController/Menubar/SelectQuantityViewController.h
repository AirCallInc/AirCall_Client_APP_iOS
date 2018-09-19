//
//  SelectQuantityViewController.h
//  AircallClient
//
//  Created by ZWT112 on 6/1/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectQuantityViewControllerDelegate <NSObject>
-(void)setQuantity:(NSString*)strQuantity inTextField:(UITextField*)txtField andReloadTable:(UITableView*)tblview;
@end
@interface SelectQuantityViewController : ACCViewController
@property UITextField *txtSelected;
@property UITableView *tblvSelected;
@property NSString * popupFor;
@property (nonatomic,weak) id<SelectQuantityViewControllerDelegate> delegate;
@end
