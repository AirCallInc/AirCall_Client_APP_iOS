//
//  AAQNotification.h
//  AssetArbor
//
//  Created by Manali on 02/02/16.
//  Copyright © 2016 com.ztt.www. All rights reserved.
//

extern NSString *const NKeyNotificationId;
extern NSString *const NKeyId;
extern NSString *const NKeyServiceID;
extern NSString *const NKeyMessage;
extern NSString *const NKeyDate;
extern NSString *const NKeyNotifications;
extern NSString *const NKeyType;
extern NSString *const NKeyStartTime ;
extern NSString *const NKeyEndTime  ;
extern NSString *const NKeyMonth;
extern NSString *const NKeyDay;
extern NSString *const NKeyYear;
extern NSString *const NKeyServiceManImage;
extern NSString *const NKeyNotificationType;
extern NSString *const NKeyNotificationDateTime;
extern NSString *const NKeyNotificationCount;

typedef NS_ENUM(NSInteger, ACCNotificationState)
{
    ACCNotificationStatePending,
    ACCNotificationStateShown,
    ACCNotificationStateRedirected,
    ACCNotificationStateComplete,
};

typedef NS_ENUM(NSInteger,ACCNotificationType)
{
    ACCNotificationTypeServiceApproval      = 0,
    ACCNotificationTypeFriendlyReminder     = 1,
    ACCNotificationTypeNoShow               = 2,
    ACCNotificationTypePartPurchased        = 3,
    ACCNotificationTypeRateService          = 4,
    ACCNotificationTypeCreditCardExpiration = 5,
    ACCNotificationTypeAdmin                = 6,
    ACCNotificationTypePlanExpiration       = 7,
    ACCNotificationTypePlanRenewed          = 8,
    ACCNotificationTypeFailedPayment        = 9
};

@interface ACCNotification : NSObject

@property (nonatomic) ACCNotificationState status;
@property (nonatomic) NSString *notificationType;

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *serviceID;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *month;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *year;
@property (strong, nonatomic) NSURL    *serviceManImage;
@property (strong, nonatomic) NSString *notificatoinId;
@property (strong, nonatomic) NSString *notificationDateTime;
@property (strong, nonatomic) NSString *notificationStatus;


- (instancetype)initWithDictionary:(NSDictionary *)notificationInfo;

@end

#define ACCNotificationManagerObject [ACCNotificationManager notificationManager]

@interface ACCNotificationManager : NSObject

+ (ACCNotificationManager *)notificationManager;

- (void)addNotification:(NSDictionary *)payload;

- (void)clearAllNotifications;
@end
