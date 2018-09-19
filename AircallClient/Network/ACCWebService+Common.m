//
//  ACCWebService+Common.m
//  AircallClient
//
//  Created by Manali on 17/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService+Common.h"

NSString *const CKeyEndPoint = @"common";
NSString *const CKeyLocationEndPoint = @"Location";

@implementation ACCWebService (Common)

//Plans & Parts
-(void)getPlanTypeWithcompletionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *planType))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/getallplantype",CKeyEndPoint];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
 
        ACCAPIResponse *response = [[ACCAPIResponse alloc]initWithCode:code Message:message Token:token];
        
        [ACCUtil updateAccessToken:token];
        
        if(code == RCodeSuccess)
        {
            NSArray *arrPlanInfo = responseObject[RKeyData];
            
            NSMutableArray *planInfo = @[].mutableCopy;
            
            [arrPlanInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull planType, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 [planInfo addObject:planType] ;
             }];
            
            completion(response,planInfo);
        }
        else
        {
            completion(response,nil);
        }
    }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"getallplantype Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil);
    }];
}

-(void)getPlanTypeByAddress:(NSString *)addressID completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *planInfo))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/GetAllPlanTypeFromAddressID?AddressId=%@",CKeyEndPoint,addressID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSMutableArray *planTypes = responseObject[RKeyData];
             completion(response,planTypes);
         }
         else
         {
             completion(response,nil);
         }
         
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError*  _Nonnull error)
     {
         DDLogError(@"GetAllPlanTypeFromAddressID Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)getPurposeAndTime:(NSDictionary *)planId completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *purposeInfo))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetScheduleTimeByPlanTypeServiceId",CKeyEndPoint];
    
    [self POST:resourceAddress parameters:planId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"GetScheduleTimeByPlanTypeServiceId Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)getPlanList:(void (^)(ACCAPIResponse *response, NSArray *arrPlans))completion
{
     NSString *resourseAddress = [NSString stringWithFormat:@"%@/GetPlanListing",URLKeyUserEndPoint];
    [self POST:resourseAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];

        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
        
        [ACCUtil updateAccessToken:token];
        
        if(code == RCodeSuccess)
        {
            NSArray *arrPlanInfo = responseObject[RKeyData];
            
            NSMutableArray *plans = @[].mutableCopy;
             __block ACCUnit *planInfo;
            [arrPlanInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull plan, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                planInfo = [[ACCUnit alloc]iniWithDictionary:plan];
                [plans addObject:planInfo];
             }];
            
            completion(response,plans);
        }
        else
        {
            completion(response,nil);
        }
 
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPlanListing Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)getPlanDetail:(NSDictionary*)dictPlanInfo completion:(void(^)(ACCAPIResponse *response, NSMutableArray *arrPlanDetail))completion
{
    NSString *resourseAddress = [NSString stringWithFormat:@"%@/GetPlanDetail",URLKeyUserEndPoint];
    [self POST:resourseAddress parameters:dictPlanInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
        [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrPlanInfo = responseObject[RKeyData];
             
             NSMutableArray *planInfo = @[].mutableCopy;
             
             [arrPlanInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull plan, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCPlan *plans = [[ACCPlan alloc]initWithDictionary:plan];
                  [planInfo addObject:plans] ;
              }];
             
             completion(response,planInfo);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPlanDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}

-(void)getPartListFromPartType:(NSDictionary *)partType completion:(void (^)(ACCAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetPartsByTypeForUnit",CKeyEndPoint];
    
    [self POST:resourceAddress parameters:partType progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrPartInfo = responseObject[RKeyData];
             
             NSMutableArray *partInfo = @[].mutableCopy;
             
             [arrPartInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull partdict, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCPart *part = [[ACCPart alloc]initWithDictionary:partdict];
                  
                  [partInfo addObject:part];
              }];
             
             completion(response,partInfo);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetPartsByTypeForUnit Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

//City & State
-(void)getAllStateList:(void (^)(ACCAPIResponse *, NSMutableArray *))completion
{
    NSString *resourseAddress = [NSString stringWithFormat:@"%@/GetAllState",CKeyLocationEndPoint];
    
    [self GET:resourseAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrStateInfo = responseObject[RKeyData];
             
             NSMutableArray *stateInfo = @[].mutableCopy;
             
             [arrStateInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull state, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  [stateInfo addObject:state] ;
              }];
             
             completion(response,stateInfo);
         }
         else
         {
             completion(response,nil);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"GetAllState Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil);
     }];
}

-(void)getCitiesFromState:(NSString *)stateId completion:(void (^)(ACCAPIResponse *, NSMutableArray *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetAllCityByStateId?StateId=%@",CKeyLocationEndPoint,stateId];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrCityInfo = responseObject[RKeyData];
             
             NSMutableArray *cityInfo = @[].mutableCopy;
             
             [arrCityInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull city, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  [cityInfo addObject:city] ;
              }];
             
             completion(response,cityInfo);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetAllCityByStateId Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

//CMS
-(void)getCMSContents:(NSDictionary*)pageId completion:(void(^)(ACCAPIResponse *response, ACCGeneral *general))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetCMSPages",CKeyEndPoint];
    
    [self POST:resourceAddress parameters:pageId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
 
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCGeneral *generalInfo = [[ACCGeneral alloc]initWithDictionary:responseObject[RKeyData]];
             completion(response,generalInfo);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetCMSPages Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)sendContactUsInfo:(NSDictionary*)dictInfo completion:(void(^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/ClientContactUs",URLKeyUserEndPoint];
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
         DDLogError(@"ClientContactUs Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)getNotificationList:(NSDictionary*)dictInfo completion:(void(^)(ACCAPIResponse *response, NSMutableArray *notification,NSString *pageNo))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/NotificationList",URLKeyUserEndPoint];
    [self POST:resourceAddress parameters:dictInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         NSString *pageNumber = [responseObject[GKeyPageNo] stringValue];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrNotificationInfo = responseObject[RKeyData];
             
             NSMutableArray *notificationInfo = @[].mutableCopy;
             
             [arrNotificationInfo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull notifications, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCNotification *notification = [[ACCNotification alloc]initWithDictionary:notifications];
                  [notificationInfo addObject:notification];
              }];
             
             completion(response,notificationInfo,pageNumber);
         }
         else
         {
             completion(response,nil,pageNumber);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"NotificationList Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil,nil);
     }];
}

-(void)getAccessToken:(NSDictionary*)dict completion:(void(^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientToken",URLKeyUserEndPoint];
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
         DDLogError(@"GetClientToken Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)sendEmailOfSales:(void (^)(ACCAPIResponse *))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/SendSalesAgreement?ClientId=%@",CKeyEndPoint,ACCGlobalObject.user.ID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"SendSalesAgreement Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

@end
