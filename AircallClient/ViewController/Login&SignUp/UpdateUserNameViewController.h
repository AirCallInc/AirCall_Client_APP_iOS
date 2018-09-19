//
//  UpdateUserNameViewController.h
//  AircallClient
//
//  Created by ZWT112 on 6/20/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UpdateUserNameViewControllerDelegate <NSObject>

-(void)userName:(NSString*)firstName lastName:(NSString*)lastName companyName:(NSString*)company;

@end

@interface UpdateUserNameViewController : ACCViewController

@property (strong, nonatomic) IBOutlet ACCTextField *txtFirstName;
@property (strong, nonatomic) IBOutlet ACCTextField *txtLastName;
@property (strong, nonatomic) IBOutlet ACCTextField *txtCompany;

@property NSString *strFirstName;
@property NSString *strLastName;
@property NSString *strCompanyName;

@property (strong,nonatomic) id <UpdateUserNameViewControllerDelegate> delegate;

@end
