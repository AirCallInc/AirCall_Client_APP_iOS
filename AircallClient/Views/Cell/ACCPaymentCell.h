//
//  ACCPaymentCell.h
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCPaymentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgvCheckmark;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCardNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblExpiryMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblExpiryYear;

-(void)setCellData:(ACCCard*)card;
@end
