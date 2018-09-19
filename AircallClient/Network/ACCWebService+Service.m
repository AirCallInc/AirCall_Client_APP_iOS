//
//  ACCWebService+Service.m
//  AircallClient
//
//  Created by ZWT112 on 5/16/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService+Service.h"

@implementation ACCWebService (Service)

//Dashboard
-(void)getDashboardData:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *dataList))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/ClientDashboard",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSDictionary * dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"getDashboardData Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response
                    ,nil);
     }];
}

//Unit
-(void)getUnitDataByPlan: (NSDictionary*)planId completionHandler:(void (^)(ACCAPIResponse *response, ACCUnit *unit))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetSpecialRateByPlanType",CKeyEndPoint];
    [self POST:resourceAddress parameters:planId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCUnit *unit = [[ACCUnit alloc]iniWithDictionary:responseObject[RKeyData]];
             completion(response,unit);
         }
         else
         {
             completion(response,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetSpecialRateByPlanType Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}


-(void)sendUnitData:(NSDictionary *)unitInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *unitInfo,NSString * unitInActiveMessage))completion
{
    //    ACCWebService *copy =  [[ACCWebService APIClient] copy];
    //
    //    copy.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/addclientunit",URLKeyUserEndPoint];

    [self POST:resourceAddress parameters:unitInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             NSString     *message = responseObject[RKeyData][UKeyInactivePlanMessage];
             completion(response,dict,message);
         }
         else
         {
             completion(response,nil,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"addclientunit Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil,nil);
     }];
}

-(void)getUnitList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *units, NSString *pageNumber,BOOL hasPaymentFailedUnits, BOOL hasProcessingUnits))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientUnit",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         NSArray *arrUnitList = responseObject[RKeyData];
         NSString *pageNumber = [responseObject[GKeyPageNo] stringValue];
         BOOL hasPaymentFailedUnits = [responseObject[UKeyHasPaymentFailedUnits] boolValue];
         BOOL hasProcessingUnits    = [responseObject[UKeyHasPaymentProcessingUnits] boolValue];
         NSMutableArray *unitList = @[].mutableCopy;
         
         if (code == RCodeSuccess)
         {
             [arrUnitList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull unit, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCUnit *unitDetail = [[ACCUnit alloc]iniWithDictionary:unit];
                  [unitList addObject:unitDetail] ;
              }];
             
             completion(response,unitList,pageNumber,hasPaymentFailedUnits,hasProcessingUnits);
         }
         else
         {
             completion(response,nil,pageNumber,hasPaymentFailedUnits,hasProcessingUnits);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetClientUnit Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil,nil,0,0);
     }];
}

-(void)getUnitListByPlan:(NSDictionary *)planInfo completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *units))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientUnitByAddressIdPlanType",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:planInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         NSArray *arrUnitList = responseObject[RKeyData];
         
         NSMutableArray *unitList = @[].mutableCopy;
         
         if (code == RCodeSuccess)
         {
             [arrUnitList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull unit, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCUnit *unitDetail = [[ACCUnit alloc]iniWithDictionary:unit];
                  [unitList addObject:unitDetail] ;
              }];
             
             completion(response,unitList);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetClientUnitByAddressIdPlanType Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}


-(void)RemoveUnit:(NSDictionary *)userInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *dict,NSString * unitInActiveMessage))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/RemoveUnit",URLKeyUserEndPoint];
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             NSString     *message = responseObject[RKeyData][UKeyInactivePlanMessage];
             completion(response,dict,message);
         }
         else
         {
             completion(response,nil,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask  * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"RemoveUnit Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil,nil);
     }];
}

-(void)getUnitDetail:(NSDictionary*)unitInfo completionHandler:(void (^)(ACCAPIResponse *response, ACCUnit *dict))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientUnitDetail",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:unitInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCUnit *unitDetail = [[ACCUnit alloc]iniWithDictionary:responseObject[RKeyData]];
             completion(response,unitDetail);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"UpcomingServices Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

- (void) getUpcomingScheduleList:(NSDictionary *)serviceInfo completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *serviceList))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpcomingServices",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:serviceInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
        
        [ACCUtil updateAccessToken:token];
        
       // array = responseObject[RKeyData][URLKeyServices];
        
        if(code == RCodeSuccess)
        {
            NSArray *arrUpcomingList = responseObject[RKeyData];
            
            NSMutableArray *arrscheduleInfo = @[].mutableCopy;
            
            [arrUpcomingList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull schedule, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 ACCSchedule *scheduleInfo = [[ACCSchedule alloc]initWithServiceDictionary:schedule];
                 
                 [arrscheduleInfo addObject:scheduleInfo];
             }];
            
            completion(response,arrscheduleInfo);
        }
        else
        {
            completion(response,nil);
        }
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"UpcomingServices Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil);
    }];
}

-(void)getScheduleDetail:(NSDictionary *)scheduleId completionHandler:(void (^)(ACCAPIResponse *response, ACCSchedule *schedule))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/WaitingServiceDetail",URLKeyUserEndPoint] ;
    
    [self POST:resourceAddress parameters:scheduleId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString  *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
        
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             ACCSchedule *scheduleDetail = [[ACCSchedule alloc]initWithServiceDictionary:responseObject[RKeyData]];
             completion(response,scheduleDetail);
         }
         else
         {
             completion(response,nil);
         }
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"WaitingServiceDetail Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil);
    }];
}

- (void) getPastServiceList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *serviceList, NSString *pageNumber))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/PastServiceListing",URLKeyUserEndPoint];
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
        
        [ACCUtil updateAccessToken:token];
        
        NSArray *arrServiceInfo = responseObject[RKeyData];
        NSString *pageNo        = [responseObject[GKeyPageNo] stringValue];
        
        if(code == RCodeSuccess)
        {
            NSMutableArray *serviceInfo = @[].mutableCopy;
            
            __block ACCService *services;
            
            [arrServiceInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull service, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 services = [[ACCService alloc]initWithDictionary:service];
                 [serviceInfo addObject:service] ;
             }];
            
            completion(response,serviceInfo,pageNo);
        }
        else
        {
            completion(response,nil,pageNo);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"PastServiceListing Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil,nil);
    }];
}

-(void)getServiceDetail:(NSDictionary *)serviceInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *service))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/PastServiceListingDetail",URLKeyUserEndPoint];
    [self POST:resourceAddress parameters:serviceInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString  *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
         

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"PastServiceListingDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
    }];
}

-(void)sendRateAndReview:(NSDictionary *)detail completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ServiceRating",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:detail progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
         
         [SVProgressHUD dismiss];
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"ServiceRating Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)getRequestList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse * response, NSMutableArray *requests))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/RequestForServiceList",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrRequestInfo = responseObject[RKeyData];
             
             NSMutableArray *arrRequests = @[].mutableCopy;
             
             [arrRequestInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull requests, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  [arrRequests addObject:requests];
              }];
             
             completion(response,arrRequests);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask *  _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"RequestForServiceList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)getRequestDetail:(NSDictionary *)requestInfo completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *requestInfo))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/RequestForServiceDetail",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:requestInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"RequestForServiceDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)deleteRquest:(NSDictionary *)dictRequestInfo completionHandler:(void (^)(ACCAPIResponse * response, NSMutableArray * requests))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/DeleteRequestedService",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dictRequestInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSArray *arrRequestInfo = responseObject[RKeyData];
             
             NSMutableArray *arrRequests = @[].mutableCopy;
             
             if (arrRequestInfo.count > 0)
             {
                 [arrRequestInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull requests, NSUInteger idx, BOOL *  _Nonnull stop)
                  {
                      [arrRequests addObject:requests];
                  }];
                 
                 completion(response,arrRequests);
             }
             else
             {
                 completion(response,nil);
             }
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError*  _Nonnull error)
     {
         DDLogError(@"DeleteRequestedService Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)sendRequestData:(NSDictionary *)unitInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    ACCWebService *copy2 =  [[ACCWebService APIClient] copy];
    copy2.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/AddRequestForService",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:unitInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"AddRequestForService Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
-(void)sendRescheduleRequest:(NSDictionary *)rescheduleInfo isFromRequestList:(BOOL)valid completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress;
    
    if (valid)
    {
        resourceAddress = [NSString stringWithFormat:@"%@/EditRequestForService",URLKeyUserEndPoint];
    }
    else
    {
        resourceAddress = [NSString stringWithFormat:@"%@/ServiceRecheduleRequest",URLKeyUserEndPoint];
    }
   
    [self POST:resourceAddress parameters:rescheduleInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"ServiceRecheduleRequest Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)acceptScheduledService:(NSDictionary*)dict completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ApproveWaitingService",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"ApproveWaitingService Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)cancelScheduledRequest:(NSDictionary *)deleteRequestInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/CancelRequestedServices",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:deleteRequestInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"CancelScheduledRequest Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}


//Payment
-(void)doPayment:(NSDictionary*)dictInfo completionHandler:(void(^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/NewMyPayment",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dictInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"NewMyPayment Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)getBillingAddress:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *dataList))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/MyCart",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSDictionary * dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"MyCart Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)getPaymentStatus:(NSDictionary*)dictInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *status))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/CheckMyPaymentStatus",URLKeyUserEndPoint];

    [self POST:resourceAddress parameters:dictInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
     
         [ACCUtil updateAccessToken:token];
     
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
     
         if(code == RCodeSuccess)
         {
             NSDictionary *statusData = responseObject[RKeyData];
             completion(response,statusData);
         }
         else
         {
            completion(response,nil);
         }
 }
   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
 {
     DDLogError(@"CheckMyPaymentStatus Error : %@", error);
     
     [self requestFail:task withError:error];
     
     ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
     
     completion(response,nil);
 }];

}

-(void)deleteOldUnits:(NSDictionary *)deleteInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/DeleteOldData",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:deleteInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"DeleteOldData Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)getFailedPaymentUnits:(NSDictionary *)clientInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *unitInfo,NSString * unitInActiveMessage))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetPaymentFailedUnit",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:clientInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             NSString     *message = responseObject[RKeyData][UKeyInactivePlanMessage];
             completion(response,dict,message);
         }
         else
         {
             completion(response,nil,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPaymentFailedUnit Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil,nil);
     }];
}

-(void)getSummaryData:(NSDictionary*)dict completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *unitInfo))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetExpiredPlanUnitById",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *dict = responseObject[RKeyData];
             completion(response,dict);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetExpiredPlanUnitById Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

- (void)updateUnitName:(NSDictionary*)unitName completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpdateClientUnit",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:unitName progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             completion(response);
         }
         else
         {
             completion(response);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"updateUnitName Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}
@end
