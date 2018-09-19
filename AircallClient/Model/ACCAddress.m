//
//  ACCAddress.m
//  AircallClient
//
//  Created by ZWT111 on 18/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCAddress.h"

NSString *const AKeyAddressId    = @"Id";
NSString *const AKeyClientId     = @"ClientId";
NSString *const AKeyAddress      = @"Address";
NSString *const AKeyStateId      = @"State";
NSString *const AKeyStateName    = @"StateName";
NSString *const AKeyCityId       = @"City";
NSString *const AKeyCityName     = @"CityName";
NSString *const AKeyZipCode      = @"ZipCode";
NSString *const AKeyIsDefault    = @"IsDefaultAddress";
NSString *const AKeyShowAddress  = @"ShowAddressInApp";
NSString *const AKeyDefaultAddressId = @"DefaultAddressId";
NSString *const AKeyDefaultAddress   = @"DefaultAddress";

@implementation ACCAddress
@synthesize addressId,address,stateName,cityName,zipcode,stateId,cityId,
  isDefaultAddress,isAllowDelete,isShowAddress,mobileNumber,homeNumber;

-(instancetype)initWithDictionary:(NSDictionary *)addressInfo
{
    if(addressInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        addressId          = [addressInfo[AKeyAddressId] stringValue];
        address            = addressInfo[AKeyAddress];
        stateId            = [addressInfo[AKeyStateId] stringValue];
        stateName          = addressInfo[AKeyStateName];
        cityId             = [addressInfo[AKeyCityId] stringValue];
        cityName           = addressInfo[AKeyCityName];
        zipcode            = addressInfo[AKeyZipCode];
        isDefaultAddress   = [addressInfo[AKeyIsDefault] boolValue];
        isAllowDelete      = [addressInfo[SKeyAllowDelete] boolValue];
        isShowAddress      = [addressInfo[AKeyShowAddress] boolValue];
        mobileNumber       = addressInfo[UKeyMobileNumber];
        homeNumber         = addressInfo[UKeyHomeNumber];
    }
    
    return self;
}
@end
