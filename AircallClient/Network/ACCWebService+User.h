//
//  ACCWebService+User.h
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService.h"
extern NSString *const URLKeyUserEndPoint;

@interface ACCWebService (User)

//User
- (void)signinWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(ACCAPIResponse *response, ACCUser *user))completion;
-(void)signupWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(ACCAPIResponse *response, ACCUser *user))completion;
- (void)forgotPassword:(NSDictionary *)userEmail completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)changePassword:(NSDictionary *)passwordInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)logoutUser:(NSDictionary *)clientInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;

-(void)updateDeviceToken:(NSDictionary *)deviceTokenInfo completionHandler:(void(^)(ACCAPIResponse *response))completion;

// Address
-(void) addAddress:(NSDictionary *)address completioHandler :(void(^)(ACCAPIResponse *response, NSMutableArray *arrAddress))completion;
-(void) updateAddress:(NSDictionary *)addressInfo completionHandler:(void(^)(ACCAPIResponse *response,NSMutableArray *arrAddresses))completion;
-(void) deleteAddressAtIndex:(NSDictionary *)addressId completionHandler:(void(^)(ACCAPIResponse *response,NSMutableArray *arrAddressInfo))completion;
-(void) getAddressListWithcompletioHandler :(void(^)(ACCAPIResponse *response, NSMutableArray *addressList))completion;
-(void) validateBillingAddress:(NSDictionary *)addressInfo completionHandler:(void(^)(ACCAPIResponse *response))completion;
@end
