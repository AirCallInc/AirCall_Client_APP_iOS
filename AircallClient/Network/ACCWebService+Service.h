//
//  ACCWebService+Service.h
//  AircallClient
//
//  Created by ZWT112 on 5/16/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService.h"

@interface ACCWebService (Service)

//Dashboard
-(void)getDashboardData:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *dataList))completion;

//Unit
-(void)sendUnitData:(NSDictionary *)unitInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *unitInfo,NSString * unitInActiveMessage))completion;
-(void)getUnitDataByPlan:(NSDictionary*)planId completionHandler:(void (^)(ACCAPIResponse *response, ACCUnit *unit))completion;
-(void)getUnitList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *units, NSString *pageNumber,BOOL hasPaymentFailedUnits, BOOL hasProcessingUnits))completion;
-(void)getUnitListByPlan:(NSDictionary *)planInfo completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *units))completion;
-(void)RemoveUnit:(NSDictionary *)userInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *dict,NSString * unitInActiveMessage))completion;
-(void)getUnitDetail:(NSDictionary*)unitInfo completionHandler:(void (^)(ACCAPIResponse *response, ACCUnit *dict))completion;

// Service & Schedule
- (void) getUpcomingScheduleList:(NSDictionary *)serviceInfo completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *serviceList))completion;
-(void)getScheduleDetail:(NSDictionary *)scheduleId completionHandler:(void (^)(ACCAPIResponse *response, ACCSchedule *schedule))completion;
- (void) getPastServiceList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *serviceList, NSString *pageNumber))completion;
-(void)getServiceDetail:(NSDictionary *)serviceId completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *schedule))completion;
-(void)deleteRquest:(NSDictionary *)dictRequestInfo completionHandler:(void (^)(ACCAPIResponse * response, NSMutableArray * requests))completion;
-(void)cancelScheduledRequest:(NSDictionary *)deleteRequestInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)sendRateAndReview:(NSDictionary *)detail completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)getRequestList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse * response, NSMutableArray *requests))completion;
-(void)getRequestDetail:(NSDictionary *)requestInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *requestInfo))completion;
-(void)sendRequestData:(NSDictionary *)unitInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)sendRescheduleRequest:(NSDictionary*)rescheduleInfo isFromRequestList:(BOOL)valid completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)acceptScheduledService:(NSDictionary*)dict completionHandler:(void (^)(ACCAPIResponse *response))completion;

//Payment
-(void)doPayment:(NSDictionary*)dictInfo completionHandler:(void(^)(ACCAPIResponse *response))completion;
-(void)getPaymentStatus:(NSDictionary*)dictInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *status))completion;
-(void)deleteOldUnits:(NSDictionary *)deleteInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;
-(void)getFailedPaymentUnits:(NSDictionary *)clientInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *unitInfo,NSString * unitInActiveMessage))completion;
-(void)getBillingAddress:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *dataList))completion;
-(void)getSummaryData:(NSDictionary*)dict completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *unitInfo))completion;

- (void)updateUnitName:(NSDictionary*)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;
@end
