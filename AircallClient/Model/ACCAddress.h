//
//  ACCAddress.h
//  AircallClient
//
//  Created by ZWT111 on 18/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AKeyClientId     ;
extern NSString *const AKeyAddressId    ;
extern NSString *const AKeyAddress      ;
extern NSString *const AKeyStateId      ;
extern NSString *const AKeyStateName    ;
extern NSString *const AKeyCityId       ;
extern NSString *const AKeyCityName     ;
extern NSString *const AKeyZipCode      ;
extern NSString *const AKeyIsDefault    ;
extern NSString *const AKeyShowAddress  ;
extern NSString *const AKeyDefaultAddressId;
extern NSString *const AKeyDefaultAddress;

@interface ACCAddress : NSObject

@property NSString *addressId;
@property NSString *stateId;
@property NSString *cityId;
@property NSString *address;
@property NSString *stateName;
@property NSString *cityName;
@property NSString *zipcode;
@property NSString *mobileNumber;
@property NSString *homeNumber;
@property BOOL     isDefaultAddress;
@property BOOL     isAllowDelete;
@property BOOL     isShowAddress;


-(instancetype)initWithDictionary:(NSDictionary *)addressInfo;
@end
