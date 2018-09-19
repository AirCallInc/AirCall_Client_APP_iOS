//
//  ACCPart.m
//  AircallClient
//
//  Created by ZWT111 on 21/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCPart.h"

NSString *const PKeyId          = @"Id";
NSString *const PKeyPartName    = @"PartName";
NSString *const PKeySize        = @"Size";
NSString *const PKeyAmount      = @"Amount";
NSString *const PKeyQuantity    = @"Quantity";
@implementation ACCPart

@synthesize partId,partName,partSize,partQty,partAmount;

-(instancetype)initWithDictionary:(NSDictionary *)partInfo
{
    if(partInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        partId      = [partInfo[PKeyId]stringValue];
        partName    = partInfo[PKeyPartName];
        partSize    = partInfo[PKeySize];
        partAmount  = [partInfo[PKeyAmount] floatValue];
        partQty     = [partInfo[PKeyQuantity] stringValue];
    }
    
    return self;
}
@end
