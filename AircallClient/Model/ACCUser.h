//
//  ACCUser.h
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

extern NSString *const UKeyID;
extern NSString *const UKeyClientID;
extern NSString *const UKeyFirstName    ;
extern NSString *const UKeyLastName     ;
extern NSString *const UKeyName         ;
extern NSString *const UKeyMobileNumber ;
extern NSString *const UKeyHomeNumber   ;
extern NSString *const UKeyOfficeNumber ;

extern NSString *const UKeyEmail        ;
extern NSString *const UKeyPassword     ;
extern NSString *const UKeyProfileImage ;
extern NSString *const UKeyImage        ;
extern NSString *const UKeyPartnerCode  ;
extern NSString *const UKeyHVAC         ;
extern NSString *const UKeyCurrentUser  ;
extern NSString *const UKeyCompany      ;

extern NSString *const UKeyDeviceToken  ;
extern NSString *const UKeyDeviceType   ;

extern NSString *const UKeyDeviceTokenSent;

extern NSString *const UKeySavePassword;

//Account Settings
extern NSString *const UKeyOldPassword;
extern NSString *const UKeyNewPassword;

extern NSString *const UKeySaveCurrentEmailPass;

extern NSString *const UKeySendDisclosureEmail;

@interface ACCUser : NSObject

@property (strong,nonatomic) NSString * ID       ;
@property (strong,nonatomic) NSString * firstName;
@property (strong,nonatomic) NSString * lastName ;
@property (strong,nonatomic) NSString * email    ;
@property (strong,nonatomic) NSString * password ;
@property (strong,nonatomic) NSURL    * profileImageURL;
@property (strong,nonatomic) NSString * mobileNumber;
@property (strong,nonatomic) NSString * officeNumber;
@property (strong,nonatomic) NSString * homeNumber;
@property (strong,nonatomic) NSString *companyName;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo;
- (void)saveInUserDefaults:(NSDictionary*)dictUser;

- (instancetype)initFromUserDefault;
- (void)login;
- (void)logout;
@end
