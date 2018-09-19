//
//  ACCNotificationCell.h
//  AircallClient
//
//  Created by ZWT112 on 6/8/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACCNotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIImageView *imgvServiceMan;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblYear;

-(void)setCellData:(ACCNotification*)notificationInfo isFromNotificationList:(BOOL)isFromList;

@end
