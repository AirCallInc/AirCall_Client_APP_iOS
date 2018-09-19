//
//  ACCWebService+Account.h
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCWebService.h"

@interface ACCWebService (Account)

//Account Settings
- (void)getClientProfile:(NSString *)userId completionHandler:(void (^)(ACCAPIResponse *response, ACCUser *userInfo))completion;
- (void)updateUserProfile:(NSDictionary*)userInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;
- (void)updateContactInfo:(NSDictionary *)contactInfo completionHandler:(void (^)(ACCAPIResponse *response))completion;

//Credit Card & Billing
- (void)AddCardInfo:(NSDictionary *)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *arrCard))completion;
-(void)sendCardInfo:(NSDictionary*)dictCardInfo withIsNoShow:(BOOL)noShow andIsPlanRenewal:(BOOL)isPlanRenewal completionHandler:(void (^)(ACCAPIResponse *response, NSDictionary *dictReceiptInfo))completion;
- (void)updateCardInfo:(NSDictionary*)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response, NSMutableArray *arrCard))completion;
- (void) getCardList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *cardList))completion;
- (void)getCardDetail:(NSDictionary*)dictCardInfo completionHandler:(void (^)(ACCAPIResponse *response,ACCCard *card))completion;
- (void) getBillingList:(NSDictionary *)userId completionHandler:(void (^)(ACCAPIResponse *response,NSMutableArray *billingList))completion;
- (void) getBillingHistoryDetail:(NSDictionary *)billingInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *billingDetail))completion;
- (void)getNoShowDetail:(NSDictionary *)dictInfo completionHandler:(void (^)(ACCAPIResponse *response,NSDictionary *billingDetail))completion;
@end
