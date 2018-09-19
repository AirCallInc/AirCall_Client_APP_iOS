//
//  ACCGeneral.m
//  AircallClient
//
//  Created by ZWT111 on 17/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCGeneral.h"

NSString *const GKeyStateId      = @"StateId";
NSString *const GKeyStateDefault = @"IsDefault";
NSString *const GKeyId           = @"Id";
NSString *const GKeyName         = @"Name";
NSString *const GKeyPlanName     = @"PlanName";
NSString *const GKeyBasic        = @"BasicFee";
NSString *const GKeyIncrement    = @"FeeIncrementString";
NSString *const GKeyPageId       = @"PageId";
NSString *const GKeyPageTitle    = @"PageTitle";
NSString *const GKeyDescription  = @"Description";
NSString *const GKeyPhoneNumber  = @"PhoneNumber";
NSString *const GKeyPageNo       = @"PageNumber";

@implementation ACCGeneral
@synthesize pageTitle,description;
-(instancetype)initWithDictionary:(NSDictionary*)dictInfo
{
    if (dictInfo.count == 0)
    {
        return nil;
    }
    if (self == [super init])
    {
        pageTitle = dictInfo[GKeyPageTitle];
        description = dictInfo[GKeyDescription];
    }
    return self;
}
@end
