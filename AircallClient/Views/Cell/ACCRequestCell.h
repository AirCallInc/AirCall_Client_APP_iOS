//
//  ACCRequestCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCRequestCell : UITableViewCell
-(void)setCellData:(ACCService*)service;
@property (strong, nonatomic) IBOutlet UIView *vwEdit;
@property (strong, nonatomic) IBOutlet UIView *vwEditDelete;
@property (strong, nonatomic) IBOutlet UILabel *lblUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblRequestInfo;
@end
