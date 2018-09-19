//
//  ACCGlobal.h
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCUser.h"
#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ACCScreenSizeType)
{
    ACCScreenSizeTypeUndefined      = 0,
    ACCScreenSizeTypeiPhone4        = 1,
    ACCScreenSizeTypeiPhone5        = 2,
    ACCScreenSizeTypeiPhone6        = 3,
    ACCScreenSizeTypeiPhone6Plus    = 4
};

#define ACCGlobalObject [ACCGlobal global]

@interface ACCGlobal : NSObject

+ (ACCGlobal *)global;

@property (nonatomic)         ACCScreenSizeType screenSizeType               ;
@property (strong,nonatomic)  ACCUser           *user                        ;
@property (nonatomic, strong) UIStoryboard      *storyboardLoginSignupProfile;
@property (nonatomic, strong) UIStoryboard      *storyboardDashboard         ;
@property (nonatomic, strong) UIStoryboard      *storyboardMenuBar           ;
@property (strong, nonatomic) RootViewController *rootViewController         ;
@property (strong,nonatomic)  NSString *deviceToken;
@property (strong,nonatomic)  NSString  *accessToken;
@property (nonatomic)  NSInteger notificationCount;
@property (nonatomic)  BOOL isOnce;
@end
