//
//  ACCGlobal.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCGlobal.h"

@implementation ACCGlobal
@synthesize screenSizeType,storyboardLoginSignupProfile,rootViewController,storyboardDashboard,storyboardMenuBar,user,notificationCount;

+ (ACCGlobal *)global
{
    static ACCGlobal *global = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      global = [[ACCGlobal alloc] init];
                  });
    
    return global;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        screenSizeType = [self identifyDeviceType];
    }
    
    return self;
}

- (ACCScreenSizeType)identifyDeviceType
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if(screenSize.height == 480)
    {
        return ACCScreenSizeTypeiPhone4;
    }
    else if(screenSize.height == 568)
    {
        return ACCScreenSizeTypeiPhone5;
    }
    else if(screenSize.height == 667)
    {
        return ACCScreenSizeTypeiPhone6;
    }
    else if(screenSize.height == 736)
    {
        return ACCScreenSizeTypeiPhone6Plus;
    }
    
    return ACCScreenSizeTypeUndefined;
}

#pragma mark - UIStroryboard Methods
- (UIStoryboard *)storyboardLoginSignupProfile
{
    if(!storyboardLoginSignupProfile)
    {
        storyboardLoginSignupProfile = [UIStoryboard storyboardWithName:@"LoginSignupProfile" bundle:nil];
    }
    return storyboardLoginSignupProfile;
}

- (UIStoryboard *)storyboardDashboard
{
    if(!storyboardDashboard)
    {
        storyboardDashboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    }
    return storyboardDashboard;
}

- (UIStoryboard *)storyboardMenuBar
{
    if(!storyboardMenuBar)
    {
        storyboardMenuBar = [UIStoryboard storyboardWithName:@"MenuBar" bundle:nil];
    }
    return storyboardMenuBar;
}

@end
