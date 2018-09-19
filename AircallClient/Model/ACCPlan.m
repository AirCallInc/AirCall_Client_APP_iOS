//
//  ACCPlan.m
//  AircallClient
//
//  Created by ZWT112 on 6/27/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCPlan.h"
NSString *PKeyImage = @"";
NSString *PKeyColor = @"";

@implementation ACCPlan
@synthesize color,image,planDesc,packageName;
-(instancetype)initWithDictionary:(NSDictionary *)dictPlan
{
    if (dictPlan.count == 0)
    {
        return nil;
    }
    if (self = [super init])
    {
        color = dictPlan[PKeyColor];
        image = dictPlan[PKeyImage];
        planDesc = dictPlan[GKeyDescription];
        packageName = dictPlan[GKeyName];
    }
    return self;

}
@end
