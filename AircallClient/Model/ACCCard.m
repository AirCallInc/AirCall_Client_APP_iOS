//
//  ACCCard.m
//  AircallClient
//
//  Created by ZWT112 on 6/24/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCCard.h"

NSString *CKeyCardNumber       = @"CardNumber";
NSString *CKeyExpiryYear       = @"ExpiryYear";
NSString *CKeyExpiryMonth      = @"ExpiryMonth";
NSString *CKeyCVV              = @"CVV";
NSString *CKeyNameOnCard       = @"NameOnCard";
NSString *CKeyCardType         = @"CardType";
NSString *CKeyIsDefaultPayment = @"IsDefaultPayment";
NSString *CKeyStripeCardID     = @"StripeCardId";
NSString *CKeyStripeError      = @"StripeError";
NSString *CKeyID               = @"CardId";

@implementation ACCCard

@synthesize nameOnCard,expiryYear,expiryMonth,cvv,cardNumber,cardType,isDefaultPayment,cardId;

-(instancetype)initWithDictionary:(NSDictionary*)dictCardInfo
{
    if(dictCardInfo.count == 0)
    {
        return nil;
    }
    
    if (self = [super init])
    {
        cardId           = dictCardInfo[UKeyID];
        nameOnCard       = dictCardInfo[CKeyNameOnCard];
        expiryMonth      = [NSString stringWithFormat:@"%@", dictCardInfo[CKeyExpiryMonth]];
        expiryYear       = [NSString stringWithFormat:@"%@", dictCardInfo[CKeyExpiryYear]];
        cardNumber       = dictCardInfo[CKeyCardNumber];
        cvv              = [NSString stringWithFormat:@"%@", dictCardInfo[CKeyCVV]];
        cardType         = dictCardInfo[CKeyCardType];
        isDefaultPayment = [dictCardInfo[CKeyIsDefaultPayment] boolValue];
    }
    return self;
}
@end
