//
//  AAQNotification.m
//  AssetArbor
//
//  Created by Manali on 02/02/16.
//  Copyright © 2016 com.ztt.www. All rights reserved.
//

#import "ACCNotification.h"
NSString *const NKeyNotificationId= @"NotificationId";
NSString *const NKeyId            = @"NId";
//NSString *const NKeyServiceID     = @"SId";
NSString *const NKeyServiceID     = @"CommonId";
NSString *const NKeyMessage       = @"Message";
NSString *const NKeyNotificationType = @"NotificationType";
NSString *const NKeyType          = @"NType";
NSString *const NKeyDate          = @"ScheduleDate";
NSString *const NKeyNotifications = @"Notifications";
NSString *const NKeyStartTime     = @"ScheduleStartTime";
NSString *const NKeyEndTime       = @"ScheduleEndTime";
NSString *const NKeyMonth         = @"ScheduleMonth";
NSString *const NKeyDay           = @"ScheduleDay";
NSString *const NKeyYear          = @"ScheduleYear";
NSString *const NKeyServiceManImage = @"ProfileImage";
NSString *const NKeyNotificationDateTime = @"DateTime";
NSString *const NKeyNotificationCount = @"NotificationCount";

@implementation ACCNotification

@synthesize ID,message,status,serviceID,date,notificationType,startTime,endTime,day,month,year,serviceManImage,notificatoinId,notificationDateTime,notificationStatus;

- (instancetype)initWithDictionary:(NSDictionary *)notificationInfo
{
    if (self = [super init])
    {
        ID               = notificationInfo[NKeyNotificationId];
        message          = notificationInfo[NKeyMessage];
        notificationType = [notificationInfo[NKeyNotificationType] stringValue];;
        serviceID        = [notificationInfo[NKeyServiceID] stringValue];
        serviceManImage  = [NSURL URLWithString:notificationInfo[NKeyServiceManImage]];
        notificationDateTime = notificationInfo[NKeyNotificationDateTime];
        notificationStatus   = notificationInfo[UKeyStatus];
//      date = notificationInfo [NKeyDate];
        startTime = notificationInfo[NKeyStartTime];
        endTime = notificationInfo[NKeyEndTime];
        day  = notificationInfo[NKeyDay] ;
        month = notificationInfo[NKeyMonth] ;
        year = notificationInfo[NKeyYear] ;
    }
    
    return self;
}


@end

@interface ACCNotificationManager()

@property (strong, nonatomic) NSMutableArray *notifications;

@end

@implementation ACCNotificationManager

@synthesize notifications;

+ (ACCNotificationManager *)notificationManager
{
    static ACCNotificationManager *notificationManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      notificationManager = [[ACCNotificationManager alloc] init];
                  });
    
    return notificationManager;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        notifications = @[].mutableCopy;
    }
    
    return self;
}

- (void)addNotification:(NSDictionary *)payload
{
    if(payload)
    {
        ACCNotification *notification = [[ACCNotification alloc] init];
        
        notification.message          = payload [@"aps"][@"alert"];
        notification.notificationType = [payload[NKeyType] stringValue];
        notification.status           = ACCNotificationStatePending;
        notification.serviceID        = [payload[NKeyServiceID] stringValue];
        notification.ID               = [payload[NKeyId] stringValue];
        
        ACCGlobalObject.notificationCount = [payload[@"aps"][@"badge"] integerValue];
        
        [notifications addObject:notification];
        
        [self processPendingNotifications];
    }
}

- (void)processPendingNotifications
{
    if(!ACCGlobalObject.user)
    {
        notifications = @[].mutableCopy;
        
        return;
    }
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [notifications enumerateObjectsUsingBlock:^(ACCNotification * _Nonnull notification, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (notification.status == ACCNotificationStatePending)
             {
                 [self showAlertForNotification:notification];
             }
         }];
    }
    else
    {
        [notifications enumerateObjectsUsingBlock:^(ACCNotification * _Nonnull notification, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (notification.status == ACCNotificationStatePending)
             {
                 [self navigateForNotification:notification];
             }
         }];
    }
}

- (void)showAlertForNotification:(ACCNotification *)notification
{
    ACCAppDelegate *delegate = (ACCAppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *controller = delegate.window.rootViewController;
    
    if (controller.presentedViewController)
    {
        controller = controller.presentedViewController;
    }
    
//    if (notification.serviceID != nil)
//    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                       message:notification.message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:ACCTextShowDetail style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [self navigateForNotification:notification];
                          }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:ACCTextCancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              [[NSNotificationCenter defaultCenter]
                               postNotificationName:@"getDashboardData"
                               object:nil];
                              [notifications removeObject:notification];
                              
                              [self processPendingNotifications];
                          }]];
        
        [controller presentViewController:alert animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
//                                                                       message:notification.message
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:ACCTextOk style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                          {
//                              [[NSNotificationCenter defaultCenter]
//                               postNotificationName:@"getDashboardData"
//                               object:nil];
//
//                              [notifications removeObject:notification];
//                              
//                              [self processPendingNotifications];
//                          }]];
//        
//        [controller presentViewController:alert animated:YES completion:nil];
//    }
    
    notification.status = ACCNotificationStateShown;
}

- (void)navigateForNotification:(ACCNotification *)notification
{
    [ACCUtil openControllerOnNotification:notification.notificationType withSericeId:notification.serviceID andNotificationId:notification.ID];
    
    notification.status = ACCNotificationStateComplete;
}

- (void)clearAllNotifications
{
    notifications = @[].mutableCopy;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self processPendingNotifications];
}


@end
