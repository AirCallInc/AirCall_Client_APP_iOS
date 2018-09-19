//
//  ACCPartCell.h
//  AircallClient
//
//  Created by Manali on 03/08/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCPartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblPartName;
@property (weak, nonatomic) IBOutlet UILabel *lblPartQty;
@property (weak, nonatomic) IBOutlet UILabel *lblPartPrice;
@end
