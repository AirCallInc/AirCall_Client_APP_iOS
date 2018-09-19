//
//  ACCUtil.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

NSString *const UKeyHTTPHeader      = @"Authorization";
NSString *const UKeyTokenType       = @"bearer";
NSString *const UKeyCurrentToken    = @"currentToken";

@implementation ACCUtil

#pragma mark - Helper Method
+ (void)prepareApplication
{
    [ACCUtil setupLogging];
    //[self getAccessToken];
    [self prepareUser];
    [ACCUtil registerForPushNotification];
}

+ (void)setupLogging
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    
    fileLogger.rollingFrequency = 60 * 60 * 24;// roll every day
    fileLogger.maximumFileSize  = 1024 * 1024 * 2;// max 2mb file size
    
    (fileLogger.logFileManager).maximumNumberOfLogFiles = 7;
    
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.000 green:0.322 blue:0.608 alpha:1.000]
                                     backgroundColor:[UIColor colorWithRed:0.741 green:0.898 blue:0.973 alpha:1.000]
                                             forFlag:DDLogFlagInfo];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:0.847 green:0.000 blue:0.047 alpha:1.000]
                                     backgroundColor:[UIColor colorWithRed:1.000 green:0.729 blue:0.729 alpha:1.000]
                                             forFlag:DDLogFlagError];
    
    [DDLog addLogger:fileLogger];
    
  //  DDLogVerbose(@"Logging is setup (\"%@\")", [fileLogger.logFileManager logsDirectory]);
}
+ (UIView *)viewNoDataWithMessage:(NSString *)message andImage:(UIImage *)imgNoData withFontColor:(UIColor *)color withHeight:(CGFloat)height
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIView *viewNoData      = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenSize.width, height)];
    UIImageView *imgvNoData = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UILabel *lblNoData      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    imgvNoData.image           = imgNoData;
    imgvNoData.backgroundColor = [UIColor clearColor];
    imgvNoData.frame           = CGRectMake((height / 9), (height / 9), 500, 500);
    
    NSString *labelText        = message;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    lblNoData.textColor       = color;
    lblNoData.backgroundColor = [UIColor clearColor];
    lblNoData.attributedText  = attributedString;
    lblNoData.numberOfLines   = 2;
    lblNoData.frame           = CGRectMake(0, 0 , screenSize.width-15, height);
    lblNoData.textAlignment   = NSTextAlignmentCenter;
    
    [lblNoData setFont:[UIFont fontWithName:@"OpenSans" size:18]];
    
    [viewNoData addSubview:imgvNoData];
    [viewNoData addSubview:lblNoData];
    
    return viewNoData;
}
+ (void)prepareUser
{
    ACCGlobalObject.user = [[ACCUser alloc] initFromUserDefault];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    ACCGlobalObject.accessToken = [userDefaults valueForKey:UKeyCurrentToken];
    
    [ACCUtil prepareInitialStoryboard];
    
    //[self getAccessToken];

    if(ACCGlobalObject.accessToken)
    {
        [ACCWebServiceAPI.requestSerializer setValue:ACCGlobalObject.accessToken forHTTPHeaderField:UKeyHTTPHeader];
    }
}

+(void)logoutTap
{
    if ([ACCUtil reachable])
    {
        NSDictionary *clientInfo = @{
                                     UKeyClientID : ACCGlobalObject.user.ID
                                    };
        
        [ACCWebServiceAPI logoutUser:clientInfo completionHandler:^(ACCAPIResponse *response)
        {
            if (response.code == RCodeSuccess)
            {
                [ACCGlobalObject.user logout];
                
                RootViewController *rootController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateInitialViewController];
                
                ACCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                
                appDelegate.window.rootViewController = rootController;
                
                ACCGlobalObject.rootViewController = rootController;
            }
            else
            {
                [self showAlertFromController:nil withMessage:response.message];
            }
        }];
    }
    else
    {
        [self showAlertFromController:nil withMessage:ACCNoInternet];
    }
    
}

+(void)saveProfileImage:(NSURL*)profileImage
{
    if (profileImage != nil)
    {
        [ACCWebService downloadImageWithURL:profileImage complication:^(UIImage *image, NSError *error)
         {
             if (image)
             {
                 [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:UKeyProfileImage];
             }
         }];
    }
}

#pragma mark - Reachability
+ (BOOL)reachable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus  = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Alert Methods
+ (void)showAlertFromController:(UIViewController *)controller withMessage:(NSString *)message
{
    if(message == nil)
    {
        return;
    }
    else if (controller == nil)
    {
        ACCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        controller = appDelegate.window.rootViewController;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:ACCTextOk style:UIAlertActionStyleDefault handler:nil]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertFromController:(UIViewController *)controller
                    withMessage:(NSString *)message
                     andHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:ACCTextYes style:UIAlertActionStyleDefault handler:handler]];
    [alert addAction:[UIAlertAction actionWithTitle:ACCTextNo style:UIAlertActionStyleCancel handler:nil]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertFromControllerWithSingleAction:(UIViewController * _Nullable)controller
                                    withMessage:(NSString * _Nullable)message
                                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:ACCTextOk style:UIAlertActionStyleDefault handler:handler]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

+(void)showAlertFromControllerWithDoubleAction:(UIViewController *)controller withMessage:(NSString *)message andHandler:(void (^)(UIAlertAction * _Nullable))handler andNoHandler:(void (^ _Nullable)(UIAlertAction * _Nullable))noHadler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:ACCTextNo style:UIAlertActionStyleDefault handler:noHadler]];
    [alert addAction:[UIAlertAction actionWithTitle:ACCTextYes style:UIAlertActionStyleDefault handler:handler]];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Storyboard Method
+ (void)prepareInitialStoryboard
{
    RootViewController *rootController;
    
    if(ACCGlobalObject.user)
    {
        rootController = [ACCGlobalObject.storyboardDashboard instantiateInitialViewController];
    }
    else
    {
        rootController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateInitialViewController];
    }
    
    ACCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = rootController;
    
    ACCGlobalObject.rootViewController = rootController;
}

+ (void)prepareDashboard
{
    RootViewController *rootController;
    
    rootController = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"rootViewController"];
    
    ACCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    appDelegate.window.rootViewController = rootController;
    
    ACCGlobalObject.rootViewController = rootController;
}

+(void)sendUpdatedDeviceToken
{
    if (ACCGlobalObject.user && ACCGlobalObject.deviceToken)
    {
        NSDictionary *deviceTokenInfo = @{
                                           UKeyDeviceToken : ACCGlobalObject.deviceToken,
                                           UKeyClientID    : ACCGlobalObject.user.ID,
                                           UKeyDeviceType  : ACCDeviceType
                                         };
        
        [ACCWebServiceAPI updateDeviceToken:deviceTokenInfo completionHandler:^(ACCAPIResponse *response)
         {

         }];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

+(void)registerForPushNotification
{
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

#pragma mark - MD5
+ (NSString *) MD5HashForString:(NSString *)normalString
{
    const char *str = [normalString UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (int)strlen(str), result);
    
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [md5 appendFormat:@"%02x",result[i]];
    }
    
    return md5;
}

#pragma mark - Refresh Token
+ (void)updateAccessToken:(NSString *)updatedToken
{
//    NSLog(@"API name %@ - UserdefaultToken %@",apiName,ACCGlobalObject.accessToken);
//    NSLog(@"API name %@ - GivenToken %@",apiName,updatedToken);
    
    if (![updatedToken isKindOfClass:[NSNull class]])
    {
        if(![updatedToken isEqualToString:@""] && updatedToken != NULL)
        {
//             NSLog(@"API name %@ - Out side update Token %@",apiName,updatedToken);
//            NSLog(@"========Updated Token=======\n %@",updatedToken);
        
            ACCGlobalObject.accessToken = [NSString stringWithFormat:@"%@ %@",UKeyTokenType,updatedToken];
        
            [ACCWebServiceAPI.requestSerializer setValue:ACCGlobalObject.accessToken forHTTPHeaderField:UKeyHTTPHeader];
        
            // Update new token in userdefault
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setValue:ACCGlobalObject.accessToken forKey:UKeyCurrentToken];
            
            [userDefaults synchronize];
        }
    }
}

#pragma mark - Access Token Method
+(void)getAccessToken
{
    if (ACCGlobalObject.user)
    {
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID
                               };
        [ACCWebServiceAPI getAccessToken:dict completion:^(ACCAPIResponse *response)
         {
             if (response.code == RCodeSuccess)
             {
                 [ACCUtil prepareInitialStoryboard];
             }
         }];
    }
    else
    {
        [ACCUtil prepareInitialStoryboard];
    }
}

#pragma mark - Date Formation Methods
+(NSString *)convertDate:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    
    //[dateFormatter setDateFormat:@"MMM dd, yyyy h:mm a"];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSString * convertedString = [dateFormatter stringFromDate:dateFromString];
    
    return convertedString;
}

+(NSString *)convertTime:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.S";
    
    NSDate *dateFromString = [dateFormatter dateFromString:strDate];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    
    NSString * convertedString = [dateFormatter stringFromDate:dateFromString];
    
    return convertedString;
}

+(NSString *)getCurrentDate
{
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *convertedDateString = [dateFormatter stringFromDate:todayDate];
    
    return convertedDateString;
}

+(NSString *)getDefaultDateWithoutWeekends:(NSInteger)dayGap withAllowWeekends:(BOOL)allow
{
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *pickedDate = [todayDate dateByAddingTimeInterval:dayGap * 24 * 60 * 60];
    
    if (!allow)
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:pickedDate];
        NSInteger weekday = [weekdayComponents weekday];
        
        if (weekday == 1 || weekday == 7)
        {
            // Sunday or Saturday
            
            NSDate *nextMonday = nil;
            
            if (weekday == 1)
            {
                nextMonday = [pickedDate dateByAddingTimeInterval:24 * 60 * 60]; // Add 24 hours
            }
            else
            {
                nextMonday = [pickedDate dateByAddingTimeInterval:2 * 24 * 60 * 60]; // Add two daysc
            }
            
            pickedDate = nextMonday;
        }
    }
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"]; //@"yyyy-MM-dd"
    
    NSString *convertedDateString = [dateFormatter stringFromDate:pickedDate];
    return convertedDateString;
}

+(BOOL)isWeekEnds:(NSString *)selectedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    
    NSDate *pickedDate = [dateFormatter dateFromString:selectedDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:pickedDate];
    NSInteger weekday = [weekdayComponents weekday];
        
    if (weekday == 1 || weekday == 7)
    {
        // Sunday or Saturday
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Notification Method
+(void)openControllerOnNotification:(NSString * _Nullable)notificationType withSericeId:(NSString * _Nullable)serviceId andNotificationId:(NSString *)notiId
{
    DashboardViewController *dbvc = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    
    if ([notificationType isEqualToString:@"1"] || [notificationType isEqualToString:@"10"]|| [notificationType isEqualToString:@"16"]) // Approval, Service Scheduled, Periodic Reminder
    {
        ScheduleDetailViewController *sdvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ScheduleDetailViewController"];
        
        if ([notificationType isEqualToString:@"1"])
        {
            sdvc.scheduleType = @"ServiceApproval";
        }
        
        sdvc.notificationId = notiId;
        sdvc.scheduleId = serviceId;
        [ACCGlobalObject.rootViewController setViewControllers:@[dbvc, sdvc]];
    }
    else if([notificationType isEqualToString:@"3"]|| [notificationType isEqualToString:@"21"]) // No Show Detail with payment, Late Cancelled
    {
        NoShowViewController *nsvc = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NoShowViewController"];
        nsvc.serviceId = serviceId;
        nsvc.notificationId = notiId;
        [ACCGlobalObject.rootViewController setViewControllers:@[dbvc,nsvc]];
    }
    else if ([notificationType isEqualToString:@"4"]) // Part Purchased
    {
        BillingDetailViewController *bdvc = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"BillingDetailViewController"];
        bdvc.billingID = serviceId;
        [ACCGlobalObject.rootViewController setViewControllers:@[dbvc,bdvc]];
    }
    else if([notificationType isEqualToString:@"5"]) // Rate Service
    {
        PastServiceDetailViewController *udvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"PastServiceDetailViewController"];
        udvc.serviceId = serviceId;
        udvc.notificationId = notiId;
        [ACCGlobalObject.rootViewController pushViewController:udvc animated:YES];
    }
    else if([notificationType isEqualToString:@"6"]) // Expiration Of Card
    {
        AddCardViewController *acvc = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"AddCardViewController"];
        acvc.cardId = serviceId;
        acvc.notificationId = notiId;
        acvc.strHeader = @"Edit Card";
        [ACCGlobalObject.rootViewController setViewControllers:@[dbvc, acvc]];
    }
    else if([notificationType isEqualToString:@"8"] || [notificationType isEqualToString:@"11"]) //Plan Expiration, Failed Payment
    {
        SummaryViewController *svc  = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SummaryViewController"];
        svc.isFromNotificationList = YES;
        svc.notificationId = notiId;
        svc.unitId = serviceId;
        
        if ([notificationType isEqualToString:@"11"]) // Failed Payment
        {
           svc.notificationType = @"FailedPayment";
        }
        else
        {
            svc.isPlanRenewal = YES;
        }
        
        [ACCGlobalObject.rootViewController setViewControllers:@[dbvc,svc]];
    }
    else if ([notificationType isEqualToString:@"17"])// invoice failed
    {
        BillingDetailViewController *bdvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"BillingDetailViewController"];
        bdvc.billingID = serviceId;
        [ACCGlobalObject.rootViewController setViewControllers:@[bdvc]];
    }
    else
    {
        NotificationListViewController *nlvc = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
        [ACCGlobalObject.rootViewController setViewControllers:@[dbvc,nlvc]];
    }
    
    /* Friendly Reminders
     2 - Admin / Friendly Notifications
     9 - Plan Renew
     */
    
    ACCGlobalObject.notificationCount = ACCGlobalObject.notificationCount - 1;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:ACCGlobalObject.notificationCount];
}
@end
