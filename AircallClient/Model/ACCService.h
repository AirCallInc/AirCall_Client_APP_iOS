//
//  ACCService.h
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SKeyID;
extern NSString *const SKeyUnitName;
extern NSString *const SKeyServiceCaseNo;
extern NSString *const SKeyDate;
extern NSString *const SKeyTime;
extern NSString *const SKeyServiceMan;
extern NSString *const SKeyVisitPurpose;
extern NSString *const SKeyWorkStartTime;
extern NSString *const SKeyWorkEndTime;
extern NSString *const SKeyWorkPerformed;
extern NSString *const SKeyRecommendations;
extern NSString *const SKeyRate;
extern NSString *const SKeyReview;
extern NSString *const SKeyIsCancelled;
extern NSString *const SKeyMessage;
extern NSString *const SKeyAsignedEndTime;
extern NSString *const SKeyExtraTime;
extern NSString *const SKeyTotalTiming;
extern NSString *const SKeyIsTimeDifferent;

extern NSString *const SKeyPurpose;
extern NSString *const SKeyTimeSlot1;
extern NSString *const SKeyTimeSlot2;
extern NSString *const SKeyPurposeOfVisit;
extern NSString *const SKeyRequestedTime;
extern NSString *const SKeyRequestedDate;
extern NSString *const SKeyRescheduleReason;
extern NSString *const SKeyNotes;
extern NSString *const SKeyAllowDelete;
extern NSString *const SKeyIsWorkDone;
extern NSString *const SKeyServices;
extern NSString *const SKeyEmployeeImage;
extern NSString *const SKeyRequestID;

extern NSString *const SKeyNoShowAmount;
extern NSString *const SKeyNoShowCollectPayment;
extern NSString *const SKeyUnitsSlot1;
extern NSString *const SKeyUnitsSlot2;
extern NSString *const SKeyUnitsCount;

extern NSString *const SKeyEmergencyTimeSlot1;
extern NSString *const SKeyEmergencyTimeSlot2;

extern NSString *const SKeyMaintenanceServicesWithinnDays;
extern NSString *const SKeyEmergencyAndOtherServiceWithinDays;

@interface ACCService : NSObject

@property NSString *planName;
@property NSString *unitName;
@property NSString *serviceCaseNo;
@property NSString *serviceDate;
@property NSString *serviceTime;
@property NSString *serviceMan;
@property NSString *visitPurpose;
@property NSString *workStartTime;
@property NSString *workEndTime;
@property NSString *workPerformed;
@property NSString *recommendations;
@property NSString *rate;
@property NSString *review;
@property NSString *message;
@property BOOL     isWorkNotDone;
@property NSURL    *imageURL;
@property NSString *assignedEndTime;
@property NSString *totalTimeAssigned;
@property NSString *extraTime;
@property BOOL      isTimeDifferent;
@property NSString *state;
@property NSString *city;
@property NSString *address;
@property NSString *zipcode;



-(instancetype)initWithDictionary:(NSDictionary*)service;
@end
