//
//  ACCWebService+User.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService+User.h"
NSString *const URLKeyUserEndPoint = @"profile";

@implementation ACCWebService (User)

-(void)signinWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(ACCAPIResponse *response, ACCUser *user))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/clientlogin",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCUser *user = [[ACCUser alloc]initWithDictionary:responseObject[RKeyData]];
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signinWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
-(void)signupWithUserDetail:(NSDictionary *)userInfo completionHandler:(void (^)(ACCAPIResponse *response, ACCUser *user))completion
{
   NSString *resourceAddress = [NSString stringWithFormat:@"%@/clientRegister",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCUser *user = [[ACCUser alloc]initWithDictionary:responseObject[RKeyData]];
             
             completion(response, user);
         }
         else
         {
             completion(response, nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"signupWithUserDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response, nil);
     }];

}
- (void)forgotPassword:(NSDictionary *)userEmail completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/clientForgotPassword",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userEmail progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
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
         DDLogError(@"ForgotPassword Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)changePassword:(NSDictionary *)passwordInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString * resourseAddress = [NSString stringWithFormat:@"%@/clientChangePassword",URLKeyUserEndPoint];
    
    [self POST:resourseAddress parameters:passwordInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
        DDLogError(@"changePassoword Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response);
    }];
}

-(void)logoutUser:(NSDictionary *)clientInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/clientlogout",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:clientInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"Logout Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)updateDeviceToken:(NSDictionary *)deviceTokenInfo completionHandler:(void(^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/clientUpdateToken",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:deviceTokenInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"Update Device Token Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];

}

-(void)addAddress:(NSDictionary *)address completioHandler:(void (^)(ACCAPIResponse *, NSMutableArray *))completion
{
     NSString * resourseAddress = [NSString stringWithFormat:@"%@/AddClientAddress",URLKeyUserEndPoint];
    
    [self POST:resourseAddress parameters:address progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
        
        [ACCUtil updateAccessToken:token];
        
        if(code == RCodeSuccess)
        {
            NSArray *arrAddress = responseObject[RKeyData];
            
            NSMutableArray *addressInfo = @[].mutableCopy;
            
            [arrAddress enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull address, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 ACCAddress *add = [[ACCAddress alloc]initWithDictionary:address];
                 
                 [addressInfo addObject:add];
             }];

            completion(response,addressInfo);
        }
        else
        {
            completion(response,nil);
        }
        
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        DDLogError(@"Add address Error : %@", error);
        
        [self requestFail:task withError:error];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
        
        completion(response,nil);
    }];
}

-(void) deleteAddressAtIndex:(NSDictionary *)addressId completionHandler:(void(^)(ACCAPIResponse *response,NSMutableArray *arrAddressInfo))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/DeleteClientAddress",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:addressId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSArray *arrAddress = responseObject[RKeyData];
             
             
             NSMutableArray *addressInfo = @[].mutableCopy;
             
             [arrAddress enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull address, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCAddress *add = [[ACCAddress alloc]initWithDictionary:address];
                  [addressInfo addObject:add];
              }];
             
             completion(response,addressInfo);
         }
         else
         {
             completion(response,nil);
         }
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError*  _Nonnull error)
     {
         DDLogError(@"DeleteClientAddress Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void) updateAddress:(NSDictionary *)addressInfo completionHandler:(void(^)(ACCAPIResponse *response,NSMutableArray *arrAddresses))completion
{
    NSString * resourseAddress = [NSString stringWithFormat:@"%@/UpdateClientAddress",URLKeyUserEndPoint];
    
    [self POST:resourseAddress parameters:addressInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         [ACCUtil updateAccessToken:token];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrAddress = responseObject[RKeyData];
             
             NSMutableArray *addressInfo = @[].mutableCopy;
             
             [arrAddress enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull address, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCAddress *add = [[ACCAddress alloc]initWithDictionary:address];
                  [addressInfo addObject:add];
              }];
             
             completion(response,addressInfo);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"UpdateAddress Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void) getAddressListWithcompletioHandler:(void(^)(ACCAPIResponse * response,NSMutableArray *addressList))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/GetClientAddress?ClientId=%@",URLKeyUserEndPoint,ACCGlobalObject.user.ID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         NSArray *arrAddressList = responseObject[RKeyData];
         
         NSMutableArray *addressList = @[].mutableCopy;
         
         if (code == RCodeSuccess)
         {
             [arrAddressList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull address, NSUInteger idx, BOOL*  _Nonnull stop)
              {
                  ACCAddress *add = [[ACCAddress alloc]initWithDictionary:address];
                  [addressList addObject:add] ;
              }];
             
             completion(response,addressList);
         }
         else
         {
             completion(response,addressList);
         }
         
     }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError*  _Nonnull error)
     {
         DDLogError(@"GetClientAddressListing Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void) validateBillingAddress:(NSDictionary *)addressInfo completionHandler:(void(^)(ACCAPIResponse *response))completion
{
    NSString * resourseAddress = [NSString stringWithFormat:@"%@/ValidateClientAddress",URLKeyUserEndPoint];
    
    [self POST:resourseAddress parameters:addressInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"UpdateAddress Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}


@end
