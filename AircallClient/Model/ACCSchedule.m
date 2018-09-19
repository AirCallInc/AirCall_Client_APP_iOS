//
//  ACCSchedule.m
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCSchedule.h"

NSString *const SKeyMonthName     = @"MonthName";
NSString *const SKeyScheduleMonth = @"ScheduleMonth";
NSString *const SKeyMonth         = @"Month";
NSString *const SKeyYear          = @"Year";
NSString *const SKeyCustomerComplaints = @"CustomerComplaints";
NSString *const SKeyEmpFirstName = @"EMPFirstName";
NSString *const SKeyEmpLastName = @"EMPLastName";
NSString *const SKeyEmpProfileImage = @"EmpProfileImage";
NSString *const SKeyEmpMessage = @"EmpName";
NSString *const SKeyAppoinmentNo = @"Appoinment";
NSString *const SKeyIsLateReschedule= @"Is24HourLeft";
NSString *const SKeyLateServiceReschedule = @"IsLateReschedule";
NSString *const SKeyRescheduleMessage = @"LateRescheduleDisplayMessage";
NSString *const SKeyLateCancellationMessage = @"LateCancelDisplayMessage";
NSString *const SKeyAddress = @"Address";
NSString *const SKeyState = @"StateName";
NSString *const SKeyCity = @"CityName";
NSString *const SKeyZipCode= @"ZipCode";
NSString *const SKeyIsRequested = @"IsRequested";


@implementation ACCSchedule
@synthesize serviceID,upcomingMsg,purposeOfVisit,scheduleDay,scheduleYear,scheduleMonth,scheduleEndTime,scheduleStartTime,monthName,scheduleMonthName,empLastname,empFirstName,empProfileImageURL,customerComplaints,serviceCaseNo,arrUnits,scheduleDate,scheduleMonthInNumber,scheduleTimeSlot,scheduleStatus,appoinmentNo,isLateReschedule,rescheduleMessage,address,city,state,zipcode,isRequested,lateCancellationMessage;

-(instancetype)initWithServiceDictionary:(NSDictionary *)scheduleInfo
{
    if (scheduleInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        serviceID = scheduleInfo[UKeyID];
        serviceCaseNo = scheduleInfo[SKeyServiceCaseNo];
        upcomingMsg   = scheduleInfo[SKeyEmpMessage];
        monthName = scheduleInfo[SKeyMonthName];
        purposeOfVisit = [scheduleInfo[SKeyPurposeOfVisit] stringValue];
        scheduleDate   = scheduleInfo[SKeyDate];
        scheduleDay = [scheduleInfo[NKeyDay] stringValue];
        scheduleMonth = scheduleInfo[SKeyScheduleMonth];
        scheduleMonthName = scheduleInfo[SKeyMonthName];
        scheduleYear = [scheduleInfo[NKeyYear] stringValue];
        scheduleStartTime = scheduleInfo[NKeyStartTime];
        scheduleEndTime = scheduleInfo[NKeyEndTime];
        empFirstName = scheduleInfo[SKeyEmpFirstName];
        empLastname = scheduleInfo[SKeyEmpLastName];
        empProfileImageURL = [NSURL URLWithString:scheduleInfo[SKeyEmpProfileImage]];
        customerComplaints = scheduleInfo[SKeyCustomerComplaints];
        scheduleMonthInNumber = scheduleInfo[SKeyScheduleMonth];
        scheduleTimeSlot  = scheduleInfo[SKeyRequestedTime];
        scheduleStatus = scheduleInfo[UKeyStatus];
        appoinmentNo = scheduleInfo[SKeyAppoinmentNo];
        isLateReschedule  = [scheduleInfo[SKeyIsLateReschedule] boolValue];
        isRequested       = [scheduleInfo[SKeyIsRequested] boolValue];
        rescheduleMessage = scheduleInfo[SKeyRescheduleMessage];
        lateCancellationMessage = scheduleInfo[SKeyLateCancellationMessage];
        
        if ([scheduleInfo[SKeyAddress] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *addressInfo = scheduleInfo[SKeyAddress];
            address = addressInfo[SKeyAddress];
            zipcode = addressInfo[SKeyZipCode];
            city = addressInfo[SKeyCity];
            state = addressInfo[SKeyState];
        }
        
        NSArray *units = scheduleInfo[UKeyUnits];
        
        arrUnits = @[].mutableCopy;
        
        [units enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull unit, NSUInteger idx, BOOL*  _Nonnull stop)
         {
             ACCUnit *unitDetail = [[ACCUnit alloc]iniWithDictionary:unit];
             [arrUnits addObject:unitDetail] ;
         }];
    }
    
    return self;
}

@end
