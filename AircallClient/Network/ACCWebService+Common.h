//
//  ACCWebService+Common.h
//  AircallClient
//
//  Created by Manali on 17/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService.h"

extern NSString *const CKeyEndPoint;
extern NSString *const CKeyLocationEndPoint;

@interface ACCWebService (Common)

//Plans & Parts
- (void)getPlanTypeWithcompletionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *planType))completion;
- (void)getPlanList:(void (^)(ACCAPIResponse *response,NSArray *arrPlans))completion;
-(void)getPlanDetail:(NSDictionary*)dictPlanInfo completion:(void(^)(ACCAPIResponse *response, NSMutableArray *arrPlanDetail))completion;
-(void)getPartListFromPartType:(NSDictionary *)partType completion:(void(^)(ACCAPIResponse *response, NSMutableArray *arrPart))completion;
-(void)getPlanTypeByAddress:(NSString *)addressID completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *planInfo))completion;
-(void)getPurposeAndTime:(NSDictionary *)planId completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *purposeInfo))completion;

//City & State
-(void)getAllStateList:(void(^)(ACCAPIResponse *response,NSMutableArray *arrState))completion;
-(void)getCitiesFromState:(NSString *)stateId completion:(void(^)(ACCAPIResponse *response, NSMutableArray *arrCity))completion;

//CMS
-(void)getCMSContents:(NSDictionary*)pageId completion:(void(^)(ACCAPIResponse *response,ACCGeneral *general))completion;
-(void)sendContactUsInfo:(NSDictionary*)dictInfo completion:(void(^)(ACCAPIResponse *response))completion;
-(void)sendEmailOfSales:(void (^)(ACCAPIResponse *))completion;

//NotificationList
-(void)getNotificationList:(NSDictionary*)dictInfo completion:(void(^)(ACCAPIResponse *response, NSMutableArray *notification,NSString *pageNo))completion;

-(void)getAccessToken:(NSDictionary*)dict completion:(void(^)(ACCAPIResponse *response))completion;
@end
