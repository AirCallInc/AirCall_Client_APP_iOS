//
//  ContactViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContactViewControllerDelegate <NSObject>
-(void)contactNumbers:(NSDictionary*)dictNumbers;
@end
@interface ContactViewController : ACCViewController

@property ACCUser * accContactInfo;
@property id <ContactViewControllerDelegate> delegate;
@end
