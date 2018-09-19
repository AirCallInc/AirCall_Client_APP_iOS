//
//  ACCFilterCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCFilterCell : UITableViewCell
@property (strong, nonatomic) IBOutlet ACCTextField *txtFilterSize;
@property (strong, nonatomic) IBOutlet ACCTextField *txtSplitFilterSize;
@property (strong, nonatomic) IBOutlet UIButton *btnInsideEquipment;
@property (strong, nonatomic) IBOutlet UIButton *btnInsideSpace;
@property (strong, nonatomic) IBOutlet UILabel *lblFilterLocation;

@end
