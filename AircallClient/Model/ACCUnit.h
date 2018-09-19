//
//  ACCUnit.h
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *UKeyUnits                ;
extern NSString *UKeyUnitId               ;
extern NSString *UKeyStatus               ;
extern NSString *UKeyStatusDesc           ;
extern NSString *UKeyUnitName             ;
extern NSString *UKeyManufactureDay       ;
extern NSString *UKeyUnitTon              ;
extern NSString *UkeyUnitAutoRenewal      ;
extern NSString *UKeyPlanId               ;
extern NSString *UKeyLastService          ;
extern NSString *UKeyUpcomingService      ;
extern NSString *UKeyTotalService         ;
extern NSString *UKeyRemainingService     ;
extern NSString *UKeyUnitAge              ;
extern NSString *UKeyUnitTypeId           ;
extern NSString *UKeyAddressId            ;
extern NSString *UKeySpecialText          ;
extern NSString *UKeyplanPrice            ;
extern NSString *UKeyplanPricePerMonth    ;
extern NSString *UKeySpecialTextDisplay   ;
extern NSString *UKeyAutoRenewal          ;
extern NSString *UkeyUnitSpecialOffer     ;
extern NSString *UKeyQuantityOfUnits      ;
extern NSString *UKeyVisitPerYear         ;

extern NSString *UKeyOptionalInformation  ;
extern NSString *UKeySplitType            ;
extern NSString *UKeyModelNumber          ;
extern NSString *UKeySerialNumber         ;
extern NSString *UKeyQuantityOfFilter     ;
extern NSString *UKeyFilters              ;
extern NSString *UKeyFilterSize           ;
extern NSString *UKeyFilterLocation       ;
extern NSString *UKeyQuantityOfFuses      ;
extern NSString *UKeyFuses                ;
extern NSString *UKeyFuseType             ;
extern NSString *UKeyBooster              ;
extern NSString *UKeyPlanDesc             ;
extern NSString *UKeyPlanPaymentType      ;
extern NSString *UKeyTotalAmount          ;
extern NSString *UKeyMessage              ;
extern NSString *UKeyPlanName             ;
extern NSString *UKeyDeleteOldSummary     ;
extern NSString *UKeyHasPaymentFailedUnits;
extern NSString *UKeyHasPaymentProcessingUnits;
extern NSString *UKeyRed                  ;
extern NSString *UKeyGreen                ;
extern NSString *UKeyBlue                 ;
extern NSString *UKeyEmpFirstName         ;
extern NSString *UKeyEmpLastName          ;
extern NSString *UKeyPlanDuration         ;
extern NSString *UKeyNoOfService          ;
extern NSString *UKeyDurationInMonth      ;
extern NSString *UKeyBasicFee             ;
extern NSString *UKeyFeeIncrement         ;
extern NSString *UKeyInactivePlanMessage  ;
extern NSString *UKeySpecialPrice         ;
extern NSString *UKeyDiscountedPrice      ;

@interface ACCUnit : NSObject

@property NSString *unitID;
@property NSString *status;
@property NSString *statusDesc;
@property NSString *unitAge;
@property NSString *visitPerYear;
@property NSString *lastService;
@property NSString *upcomigService;
@property NSString *totalService;
@property NSString *remainingService;
@property NSString *serviceMan;
@property NSString *unitName;
@property NSString *planName;
@property float     planPrice;
@property float     planPricePerMonth;
@property float     basicFee;
@property NSString  *feeIncrement;
@property NSString *specialOfferText;
@property NSString *planDescription;
@property NSString *planPaymentType;
@property float     totalAmount;
@property NSString *message;
@property BOOL     isSpecialOfferDisplay;
@property BOOL     isAutoRenewalDisplay;
@property NSURL    *planImageURL;
@property NSInteger red;
@property NSInteger green;
@property NSInteger blue;
@property NSString *planId;
@property NSString *paymentStatus;
@property NSString *paymentError;
@property NSString *empFirstName;
@property NSString *empLastName;
@property NSString *planDuartion;
@property NSString *totalNoOfService;
@property NSString *durationInMonth;
@property NSString *unitsId;
@property float     specialPrice;
@property float     discountPrice;

-(instancetype)iniWithDictionary:(NSDictionary*)unitInfo;

@end
