//
//  ACCBilling.h
//  AircallClient
//
//  Created by Manali on 27/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BKeyTransactionID;
extern NSString *const BKeyTransactionDate;
extern NSString *const BKeyPurchasedAmount;
extern NSString *const BKeyServiceCaseNo;
extern NSString *const BKeyPartsHistory;
extern NSString *const BKeyBillingID;
extern NSString *const BKeyIsPaid;
extern NSString *const BKeyPaymentType;
extern NSString *const BKeyPaymentNumber;
extern NSString *const BKeyPaymentTermsURL;
extern NSString *const BKeyPaymentStatus;

@interface ACCBilling : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)billingInfo;

@property NSString * billingId;
@property NSString * transactionId;
@property NSString * transactionDate;
@property NSString * transactionTime;
@property float      purchasedAmount;
@property NSString * serviceCaseNo;
@property NSString * unitName;
@property NSString * planName;
@property NSMutableArray *partsList;
@property BOOL isPaid;
@property NSString *reason;
@property NSString *paymentMethod;
@property NSString *paymentNumber;
@property NSString *paymentStatus;
@property NSString *invoiceNumber;
@property NSString *orderNumber;
@property NSString *checkNumber;

@end
