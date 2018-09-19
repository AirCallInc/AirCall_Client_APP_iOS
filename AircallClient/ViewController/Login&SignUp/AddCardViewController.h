//
//  AddCardViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//



@protocol AddCardViewControllerDelegate <NSObject>

-(void)cardInfo:(NSMutableArray*)arrInfo;

@end

@interface AddCardViewController : ACCViewController

@property NSString *cardId;
@property NSString *notificationId;
@property (strong,nonatomic) id <AddCardViewControllerDelegate> delegate;
@property ACCCard *cardInfo;
@property NSString *strHeader;

@end
