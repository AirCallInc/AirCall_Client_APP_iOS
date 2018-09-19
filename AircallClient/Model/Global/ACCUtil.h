//
//  ACCUtil.h
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//


extern NSString *const UKeyHTTPHeader   ;
extern NSString *const UKeyCurrentToken ;
extern NSString *const UKeyTokenType    ;

@interface ACCUtil : NSObject
+ (void)prepareApplication;
+ (BOOL)reachable;
+ (void)showAlertFromController:(UIViewController * _Nullable)controller withMessage:(NSString * _Nullable)message;
+ (void)showAlertFromController:(UIViewController * _Nullable)controller
                    withMessage:(NSString * _Nullable)message
                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action))handler;
+ (void)showAlertFromControllerWithSingleAction:(UIViewController * _Nullable)controller
                                    withMessage:(NSString * _Nullable)message
                                     andHandler:(void (^__nullable)(UIAlertAction * _Nullable action))handler;
+(void)showAlertFromControllerWithDoubleAction:(UIViewController * _Nullable)controller withMessage:(NSString * _Nullable)message andHandler:(void (^ _Nullable)(UIAlertAction * _Nullable))handler andNoHandler:(void (^ _Nullable)(UIAlertAction * _Nullable))noHadler;

+ (void)prepareDashboard;
+ (UIView * _Nullable)viewNoDataWithMessage:(NSString * _Nullable)message andImage:(UIImage * _Nullable)imgNoData withFontColor:(UIColor * _Nullable)color withHeight:(CGFloat)height;
+(void)sendUpdatedDeviceToken;
+(void)registerForPushNotification;
+(void)logoutTap;
+(void)saveProfileImage:(NSURL * _Nullable)profileImage;
+ (void)prepareUser;
+ (NSString * _Nullable) MD5HashForString:(NSString * _Nullable)normalString;
+ (void)updateAccessToken:(NSString * _Nullable)updatedToken;
+(NSString * _Nullable)convertDate:(NSString * _Nullable)strDate;
+(NSString * _Nullable)convertTime:(NSString * _Nullable)strDate;
+(NSString * _Nullable)getCurrentDate;
+(NSString * _Nullable)getDefaultDateWithoutWeekends:(NSInteger)dayGap withAllowWeekends:(BOOL)allow;
+(BOOL)isWeekEnds:(NSString * _Nullable)selectedDate;
+(void)openControllerOnNotification:(NSString * _Nullable)notificationType withSericeId:(NSString * _Nullable)serviceId andNotificationId:(NSString * _Nullable)notiId;
+(void)getAccessToken;
@end
