 //
//  ACCWebService+Account.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService+Account.h"

@implementation ACCWebService (Account)

//Account Settings

-(void)getClientProfile:(NSString *)userId completionHandler:(void (^)(ACCAPIResponse *response, ACCUser *userInfo))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/GetClientProfile?ClientId=%@",URLKeyUserEndPoint,ACCGlobalObject.user.ID];
    
    [self GET:resourceAddress parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCUser *user = [[ACCUser alloc]initWithDictionary:responseObject[RKeyData]];
             completion(response,user);
         }
         else
         {
             completion(response,nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetClientProfile Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)updateUserProfile:(NSDictionary*)userInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString *resourceAddress = [NSString stringWithFormat:@"%@/UpdateClientProfile",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         UIImage *image = userInfo[UKeyImage];
         NSData *imageAsData = UIImageJPEGRepresentation(image, 0.7);
         
         [formData appendPartWithFileData:imageAsData name:UKeyImage fileName:UKeyImage mimeType:@"image/png"];
     }
      progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"UpdateClientProfile Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

-(void)updateContactInfo:(NSDictionary *)contactInfo completionHandler:(void (^)(ACCAPIResponse *response))completion
{
    NSString * resourceAddress = [NSString stringWithFormat:@"%@/UpdateClientContactInfo",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:contactInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
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
         DDLogError(@"UpdateClientContactInfo Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response);
     }];
}

//Credit Card & Billing
-(void)AddCardInfo:(NSDictionary *)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *arrCard))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/AddCreditCard",URLKeyUserEndPoint];
    [self POST:resourceAddress parameters:dictCardInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
        
        [ACCUtil updateAccessToken:token];
        
        if (code == RCodeSuccess)
        {
            NSArray *arrCard = responseObject[RKeyData];
            
            NSMutableArray *cardInfo = @[].mutableCopy;
            
            [arrCard enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull cards, NSUInteger idx, BOOL*  _Nonnull stop)
             {
                 ACCCard *card = [[ACCCard alloc]initWithDictionary:cards];
                 
                 [cardInfo addObject:card];
             }];
    
            completion(response,cardInfo);
        }
        else
        {
            completion(response,nil);
        }

    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"AddCreditCard Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)sendCardInfo:(NSDictionary*)dictCardInfo withIsNoShow:(BOOL)noShow andIsPlanRenewal:(BOOL)isPlanRenewal completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *dictReceiptInfo))completion
{
    NSString *resourceAddress;
    
    if (noShow)
    {
        resourceAddress = [NSString stringWithFormat:@"%@/NoShowPayment",URLKeyUserEndPoint];
    }
    else if (isPlanRenewal)
    {
        
        resourceAddress = [NSString stringWithFormat:@"%@/CollectPaymentForRenew",URLKeyUserEndPoint];
    }
    else
    {
        resourceAddress = [NSString stringWithFormat:@"%@/ValidateCreditCard",URLKeyUserEndPoint];
    }
    
    [self POST:resourceAddress parameters:dictCardInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSInteger code    = [responseObject[RKeyCode] integerValue];
        NSString *message = responseObject[RKeyMessage];
        NSString *token   = responseObject[RKeyToken];
        
        ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
        
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
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"ValidateCreditCard Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

-(void)updateCardInfo:(NSDictionary*)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *arrCard))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/UpdateCreditCard",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dictCardInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if (code == RCodeSuccess)
         {
             NSArray *arrCards = responseObject[RKeyData];
             
             NSMutableArray *cardInfo = @[].mutableCopy;
             
             [arrCards enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull card, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  ACCCard *cardDetail = [[ACCCard alloc]initWithDictionary:card];
                  [cardInfo addObject:cardDetail];
              }];
             
             completion(response,cardInfo);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"UpdateCreditCard Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

- (void) getCardList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *cardList))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/GetCreditCard",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrCards = responseObject[RKeyData];
             
             NSMutableArray *cardInfo = @[].mutableCopy;
             
             [arrCards enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull card, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  ACCCard *cardDetail = [[ACCCard alloc]initWithDictionary:card];
                  [cardInfo addObject:cardDetail];
              }];
             
             completion(response,cardInfo);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetCreditCard Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}
-(void)getCardDetail:(NSDictionary*)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response,ACCCard *card))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/GetExpiredCreditCardById",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dictCardInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
    
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             ACCCard *cardDetail = [[ACCCard alloc]initWithDictionary:responseObject[RKeyData]];
             completion(response,cardDetail);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetExpiredCreditCardById Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}
- (void) getBillingList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *billingList))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/GetBillingHistory",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:userId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSArray *arrBilling = responseObject[RKeyData];
             
             NSMutableArray *billingInfo = @[].mutableCopy;
             
             [arrBilling enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull billing, NSUInteger idx, BOOL * _Nonnull stop)
              {
                  ACCBilling *bill = [[ACCBilling alloc]initWithDictionary:billing];
                  [billingInfo addObject:bill];
              }];
             
             completion(response,billingInfo);
         }
         else
         {
             completion(response,nil);
         }
         
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetBillingHistory Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];
}

- (void) getBillingHistoryDetail:(NSDictionary *)billingInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *billingDetail))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/GetBillingHistoryDetail",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:billingInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];

         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *billingDetail = responseObject[RKeyData];
             completion(response,billingDetail);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"GetBillingHistoryDetail Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];  
}

-(void)getNoShowDetail:(NSDictionary *)dictInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *billingDetail))completion
{
    NSString *resourceAddress = [NSString  stringWithFormat:@"%@/NoShowServiceDetails",URLKeyUserEndPoint];
    
    [self POST:resourceAddress parameters:dictInfo progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSInteger code    = [responseObject[RKeyCode] integerValue];
         NSString *message = responseObject[RKeyMessage];
         NSString *token   = responseObject[RKeyToken];
        
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:code Message:message Token:token];
         
         [ACCUtil updateAccessToken:token];
         
         if(code == RCodeSuccess)
         {
             NSDictionary *noShowDetail = responseObject[RKeyData];
             completion(response,noShowDetail);
         }
         else
         {
             completion(response,nil);
         }
     }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         DDLogError(@"NoShowServiceDetails Error : %@", error);
         
         [self requestFail:task withError:error];
         
         ACCAPIResponse *response = [[ACCAPIResponse alloc] initWithCode:RCodeRequestFail andError:error];
         
         completion(response,nil);
     }];

}

@end
