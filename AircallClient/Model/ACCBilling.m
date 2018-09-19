//
//  ACCBilling.m
//  AircallClient
//
//  Created by Manali on 27/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCBilling.h"

NSString *const BKeyTransactionID   = @"TransactionId";
NSString *const BKeyTransactionDate = @"TransactionDate";
NSString *const BKeyPurchasedAmount = @"PurchasedAmount";
NSString *const BKeyServiceCaseNo   = @"ServiceCaseNumber";
NSString *const BKeyPartsHistory    = @"PartsHistory";
NSString *const BKeyBillingID       = @"BillingId";
NSString *const BKeyIsPaid          = @"IsPaid";
NSString *const BKeyPaymentType     = @"ChargeBy";
NSString *const BKeyPaymentNumber   = @"CardNumber" ;
NSString *const BKeyPaymentTermsURL = @"PDFUrl";
NSString *const BKeyInvoiceNumber   = @"InvoiceNumber";
NSString *const BKeyOrderNumber     = @"OrderNumber";
NSString *const BKeyCheckNumber     = @"CheckNumbers";
NSString *const BKeyPaymentStatus   = @"Reason";


@implementation ACCBilling
@synthesize billingId,paymentStatus,transactionId,invoiceNumber,orderNumber,checkNumber,transactionDate,transactionTime,purchasedAmount,serviceCaseNo,unitName,planName,partsList,isPaid,reason,paymentMethod,paymentNumber;

-(instancetype)initWithDictionary:(NSDictionary *)billingInfo
{
    if (billingInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        if ([billingInfo isKindOfClass:[NSDictionary class]])
        {
            billingId       = [billingInfo[UKeyID] stringValue];
            transactionId   = billingInfo[BKeyTransactionID];
            serviceCaseNo   = billingInfo[BKeyServiceCaseNo];
            transactionDate = [ACCUtil convertDate:billingInfo[BKeyTransactionDate]];
            transactionTime = [ACCUtil convertTime:billingInfo[BKeyTransactionDate]];
            unitName        = billingInfo[UKeyUnitName];
            purchasedAmount = [billingInfo[BKeyPurchasedAmount] floatValue];
            planName        = billingInfo[UKeyPlanName];
            isPaid          = [billingInfo[BKeyIsPaid] boolValue];
            reason          = billingInfo[SKeyRescheduleReason];
            paymentNumber   = billingInfo[BKeyPaymentNumber];
            paymentMethod   = billingInfo[BKeyPaymentType];
            paymentStatus   = billingInfo[BKeyPaymentStatus];
            
            NSArray *arrParts = billingInfo[BKeyPartsHistory];
            partsList = @[].mutableCopy;
            
            [arrParts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull part, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 ACCPart *partInfo = [[ACCPart alloc]initWithDictionary:part];
                 [partsList addObject:partInfo];
             }];

            
        }else{
            @try {
                //billingId       = [[billingInfo valueForKey:UKeyID] objectAtIndex:0];
                transactionId   = [[billingInfo valueForKey:BKeyTransactionID] objectAtIndex:0];
                //serviceCaseNo   = [[billingInfo valueForKey:BKeyServiceCaseNo] objectAtIndex:0];
                transactionDate = [ACCUtil convertDate:[[billingInfo valueForKey:BKeyTransactionDate] objectAtIndex:0]];
                transactionTime = [ACCUtil convertTime:[[billingInfo valueForKey:BKeyTransactionDate] objectAtIndex:0]];
               
                //unitName        = [[billingInfo valueForKey:UKeyUnitName] objectAtIndex:0];
                purchasedAmount = [[[billingInfo valueForKey:BKeyPurchasedAmount] objectAtIndex:0] floatValue];
               
                //planName        = [[billingInfo valueForKey:UKeyPlanName] objectAtIndex:0];
                isPaid          = [[[billingInfo valueForKey:BKeyIsPaid] objectAtIndex:0] boolValue];
                reason          = [[billingInfo valueForKey:SKeyRescheduleReason] objectAtIndex:0];
                //paymentNumber   = [[billingInfo valueForKey:BKeyPaymentNumber] objectAtIndex:0];
                //paymentMethod   = [[billingInfo valueForKey:BKeyPaymentType] objectAtIndex:0];
                //paymentStatus   = [[billingInfo valueForKey:BKeyPaymentStatus] objectAtIndex:0];
                invoiceNumber   = [[billingInfo valueForKey:BKeyInvoiceNumber] objectAtIndex:0];
                orderNumber     = [[billingInfo valueForKey:BKeyOrderNumber] objectAtIndex:0];
                checkNumber     = [[billingInfo valueForKey:BKeyCheckNumber] objectAtIndex:0];
                
//                NSArray *arrParts = [[billingInfo valueForKey:BKeyPartsHistory] objectAtIndex:0];
//                
//                partsList = @[].mutableCopy;
//                
//                [arrParts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull part, NSUInteger idx, BOOL * _Nonnull stop)
//                 {
//                     ACCPart *partInfo = [[ACCPart alloc]initWithDictionary:part];
//                     [partsList addObject:partInfo];
//                 }];
                
            }@catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
        }
           }
    
    return self;
}

@end
