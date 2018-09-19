//
//  ACCCard.h
//  AircallClient
//
//  Created by ZWT112 on 6/24/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *CKeyCardNumber ;
extern NSString *CKeyExpiryYear ;
extern NSString *CKeyExpiryMonth;
extern NSString *CKeyCVV        ;
extern NSString *CKeyNameOnCard ;
extern NSString *CKeyCardType   ;
extern NSString *CKeyIsDefaultPayment;
extern NSString *CKeyStripeCardID;
extern NSString *CKeyStripeError;
extern NSString *CKeyID;

@interface ACCCard : NSObject

@property NSString *cardId;
@property NSString *cardNumber;
@property NSString *expiryYear;
@property NSString *expiryMonth;
@property NSString *cvv;
@property NSString *nameOnCard;
@property NSString *cardType;
@property BOOL isDefaultPayment;

-(instancetype)initWithDictionary:(NSDictionary*)dictCardInfo;
@end
