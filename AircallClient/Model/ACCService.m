//
//  ACCService.m
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCService.h"

NSString *const SKeyID              = @"ServiceId";
NSString *const SKeyUnitName        = @"";
NSString *const SKeyServiceCaseNo   = @"ServiceCaseNumber";
NSString *const SKeyDate            = @"ScheduleDate";
NSString *const SKeyTime            = @"ScheduleStartTime";
NSString *const SKeyServiceMan      = @"";
NSString *const SKeyVisitPurpose    = @"PurposeOfVisit";
NSString *const SKeyWorkStartTime   = @"WorkStartedTime";
NSString *const SKeyWorkEndTime     = @"WorkCompletedTime";
NSString *const SKeyWorkPerformed   = @"WorkPerformed";
NSString *const SKeyRecommendations = @"Recommendations";
NSString *const SKeyRate            = @"Rate";
NSString *const SKeyReview          = @"Review";
NSString *const SKeyIsCancelled     = @"IsCancelled";
NSString *const SKeyMessage         = @"Message";
NSString *const SKeyTotalTiming     = @"AssignedTotalTime";
NSString *const SKeyAsignedEndTime  = @"ScheduleEndTime";
NSString *const SKeyExtraTime       = @"ExtraTime";
NSString *const SKeyIsTimeDifferent = @"IsDifferentTime";


NSString *const SKeyPurpose          = @"Purpose";
NSString *const SKeyTimeSlot1        = @"TimeSlot1";
NSString *const SKeyTimeSlot2        = @"TimeSlot2";
NSString *const SKeyPurposeOfVisit   = @"PurposeOfVisit";
NSString *const SKeyRequestedTime    = @"ServiceRequestedTime";
NSString *const SKeyRequestedDate    = @"ServiceRequestedOn";
NSString *const SKeyRescheduleReason = @"Reason";
NSString *const SKeyNotes            = @"Notes";
NSString *const SKeyAllowDelete      = @"AllowDelete";
NSString *const SKeyServices         = @"Services";
NSString *const SKeyIsWorkDone       = @"IsNoShow";
NSString *const SKeyEmployeeImage    = @"EmpProfileImage";
NSString *const SKeyRequestID        = @"RequestedServiceId";

NSString *const SKeyNoShowAmount     = @"NoShowAmount";
NSString *const SKeyNoShowCollectPayment = @"CollectPayment";

NSString *const SKeyUnitsSlot1  = @"TotalUnitSlot1";
NSString *const SKeyUnitsSlot2  = @"TotalUnitSlot2";
NSString *const SKeyUnitsCount  = @"UnitCount";

NSString *const SKeyEmergencyTimeSlot1 = @"EmergencyServiceSlot1";
NSString *const SKeyEmergencyTimeSlot2 = @"EmergencyServiceSlot2";

NSString *const SKeyMaintenanceServicesWithinnDays = @"MaintenanceServicesWithinDays";
NSString *const SKeyEmergencyAndOtherServiceWithinDays = @"EmergencyAndOtherServiceWithinDays";

@implementation ACCService
@synthesize planName,unitName,serviceDate,serviceCaseNo,serviceMan,serviceTime,workEndTime,workStartTime,recommendations,rate,review,visitPurpose,workPerformed,message,isWorkNotDone,imageURL,assignedEndTime,totalTimeAssigned,extraTime,isTimeDifferent,state,city,zipcode,address;

-(instancetype)initWithDictionary:(NSDictionary*)service
{
    if (service.count == 0)
    {
        return nil;
    }
    if (self == [super init])
    {
        planName          = service[UKeyPlanName];
        unitName          = service[UKeyUnitName];
        serviceDate       = service[SKeyDate];
        serviceCaseNo     = service[SKeyServiceCaseNo];
        serviceTime       = service[SKeyTime];
        serviceMan        = [NSString stringWithFormat:@"%@ %@",service[UKeyFirstName],service[UKeyLastName]];
        visitPurpose      = service[SKeyVisitPurpose];
        workStartTime     = service[SKeyWorkStartTime];
        workEndTime       = service[SKeyWorkEndTime];
        workPerformed     = service[SKeyWorkPerformed];
        recommendations   = service[SKeyRecommendations];
        rate              = service[SKeyRate];
        review            = service[SKeyReview];
        message           = service[UKeyMessage];
        isWorkNotDone     = [service[SKeyIsWorkDone] boolValue];
        imageURL          = [NSURL URLWithString:service[SKeyEmployeeImage]];
        extraTime         = service[SKeyExtraTime];
        totalTimeAssigned = service[SKeyTotalTiming];
        assignedEndTime   = service[SKeyAsignedEndTime];
        isTimeDifferent   = [service[SKeyIsTimeDifferent] boolValue];
        
        if ([service[SKeyAddress] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *addressInfo  = service [SKeyAddress];
            address = addressInfo[SKeyAddress];
            city    = addressInfo[SKeyCity];
            state   = addressInfo[SKeyState];
            zipcode = addressInfo[SKeyZipCode];
        }
    }
    return self;
}

@end
