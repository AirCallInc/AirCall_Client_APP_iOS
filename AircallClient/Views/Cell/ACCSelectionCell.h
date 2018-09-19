//
//  ACCAddressCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCSelectionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblSubDesc;

@property (strong, nonatomic) IBOutlet UIImageView *imgvCheckmark;
//used for 2nd line of address list and Search Part for size
@property (strong, nonatomic) IBOutlet UILabel *lblsubtitle;
@property (strong, nonatomic) IBOutlet UIView *vwEditDelete;
@property (strong, nonatomic) IBOutlet UIView *vwEdit;

@end
