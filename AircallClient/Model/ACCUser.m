//
//  ACCUser.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

NSString *const UKeyID              = @"Id";
NSString *const UKeyClientID        = @"ClientId";
NSString *const UKeyFirstName       = @"FirstName";
NSString *const UKeyLastName        = @"LastName";
NSString *const UKeyName            = @"Name";

NSString *const UKeyMobileNumber    = @"MobileNumber";
NSString *const UKeyHomeNumber      = @"HomeNumber";
NSString *const UKeyOfficeNumber    = @"OfficeNumber";

NSString *const UKeyEmail            = @"Email";
NSString *const UKeyPassword         = @"Password";
NSString *const UKeyProfileImage     = @"ProfileImage";
NSString *const UKeyImage            = @"Image";
NSString *const UKeyPartnerCode      = @"AffiliateId";
NSString *const UKeyHVAC             = @"HVACUnit";
NSString *const UKeyCurrentUser      = @"currentUser";
NSString *const UKeyCompany          = @"Company";

NSString *const UKeyDeviceToken     = @"DeviceToken";
NSString *const UKeyDeviceType      = @"DeviceType";
NSString *const UKeyDeviceTokenSent = @"DeviceTokenSent";

NSString *const UKeyOldPassword     = @"OldPassword";
NSString *const UKeyNewPassword     = @"NewPassword";

NSString *const UKeySavePassword    = @"SavePassword";

NSString *const UKeySaveCurrentEmailPass   = @"UsersInfo";

NSString *const UKeySendDisclosureEmail = @"SendDisclosureEmail";

@implementation ACCUser
@synthesize ID,firstName,lastName,email,password,profileImageURL,mobileNumber,officeNumber,homeNumber,companyName;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo
{
    if(userInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        ID                  = userInfo[UKeyID];
        firstName           = userInfo[UKeyFirstName];
        lastName            = userInfo[UKeyLastName];
        email               = userInfo[UKeyEmail];
        password            = userInfo[UKeyPassword];
        mobileNumber        = userInfo[UKeyMobileNumber];
        officeNumber        = userInfo[UKeyOfficeNumber];
        profileImageURL     = [NSURL URLWithString:userInfo[UKeyProfileImage]];
        homeNumber          = userInfo[UKeyHomeNumber];
        companyName         = userInfo[UKeyCompany];
    }
    
    return self;
}

#pragma mark - Helper Method
- (instancetype)initFromUserDefault
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [userDefaults valueForKey:UKeyCurrentUser];
    
    if (userInfo)
    {
        self = [[ACCUser alloc] initWithDictionary:userInfo];
    }
    else
    {
        return nil;
    }
    
    return self;
}

- (void)saveInUserDefaults:(NSDictionary*)dictUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:dictUser forKey:UKeyCurrentUser];
    
    [userDefaults synchronize];
}

- (NSDictionary *)getDictionary
{
    NSDictionary *userInfo = @{
                               UKeyID           : ID,
                               UKeyFirstName    : firstName,
                               UKeyLastName     : lastName,
                               UKeyEmail        : email,
                               UKeyPassword     : password,
                               UKeyMobileNumber : mobileNumber,
                               UKeyCompany      : companyName
                              };
    return userInfo;
}

- (void)login
{
    ACCGlobalObject.user = self;
    [self saveInUserDefaults:[self getDictionary]];
    [ACCUtil saveProfileImage:profileImageURL];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [ACCUtil registerForPushNotification];
}

-(void)resetUserDefaults
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    
    for (NSString *key in dict)
    {
        if(![key isEqualToString:UKeySaveCurrentEmailPass])
            [defs removeObjectForKey:key];
    }
    
    [defs synchronize];
}
- (void)logout
{
    ACCGlobalObject.user = nil;
    [self resetUserDefaults];
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    [userDefaults removePersistentDomainForName:appDomain];
    
    [ACCWebServiceAPI.requestSerializer clearAuthorizationHeader];
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
