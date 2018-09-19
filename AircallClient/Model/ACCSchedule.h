//
//  ACCSchedule.h
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

extern NSString *const SKeyMonthName;
extern NSString *const SKeyScheduleMonth;
extern NSString *const SKeyMonth;
extern NSString *const SKeyYear;
extern NSString *const SKeyCustomerComplaints;
extern NSString *const SKeyEmpFirstName;
extern NSString *const SKeyEmpLastName;
extern NSString *const SKeyEmpProfileImage;
extern NSString *const SKeyEmpMessage;
extern NSString *const SKeyAppoinmentNo;
extern NSString *const SKeyIsLateReschedule;
extern NSString *const SKeyLateServiceReschedule;
extern NSString *const SKeyLateCancellationMessage;
extern NSString *const SKeyRescheduleMessage;
extern NSString *const SKeyAddress ;
extern NSString *const SKeyState ;
extern NSString *const SKeyCity ;
extern NSString *const SKeyZipCode ;
extern NSString *const SKeyIsRequested;

@interface ACCSchedule : NSObject

@property NSString * serviceID;
@property NSString *serviceCaseNo;
@property NSString * upcomingMsg;
@property NSString * monthName;
@property NSString * purposeOfVisit;
@property NSString * empFirstName;
@property NSString * empLastname;
@property NSURL    * empProfileImageURL;
@property NSString * customerComplaints;
@property NSString * scheduleDate;
@property NSString * scheduleDay;
@property NSString * scheduleMonth;
@property NSString * scheduleMonthName;
@property NSString * scheduleYear;
@property NSString *scheduleMonthInNumber;
@property NSString * scheduleEndTime;
@property NSString * scheduleStartTime;
@property NSMutableArray * arrUnits;
@property NSString *scheduleTimeSlot;
@property NSString *scheduleStatus;
@property NSString *appoinmentNo;
@property BOOL isLateReschedule;
@property NSString *rescheduleMessage;
@property NSString *address;
@property NSString *state;
@property NSString *city;
@property NSString *zipcode;
@property NSString *lateCancellationMessage;
@property BOOL isRequested;

-(instancetype)initWithServiceDictionary:(NSDictionary *)scheduleInfo;

@end
