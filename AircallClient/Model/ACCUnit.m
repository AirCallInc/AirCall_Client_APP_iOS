//
//  ACCUnit.m
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCUnit.h"
NSString *UKeyUnits                     = @"Units";
NSString *UKeyUnitId                    = @"UnitId";
NSString *UKeyStatus                    = @"Status";
NSString *UKeyStatusDesc                = @"StatusDesc";
NSString *UKeyUnitName                  = @"UnitName";
NSString *UKeyManufactureDay            = @"ManufactureDate";
NSString *UKeyUnitTon                   = @"UnitTon";
NSString *UkeyUnitAutoRenewal           = @"AutoRenewal";
NSString *UkeyUnitSpecialOffer          = @"SpecialOffer";
NSString *UKeyPlanId                    = @"PlanTypeId";
NSString *UKeyLastService               = @"LastService";
NSString *UKeyUpcomingService           = @"UpcomingService";
NSString *UKeyTotalService              = @"TotalService";
NSString *UKeyRemainingService          = @"RemainingService";
NSString *UKeyUnitAge                   = @"UnitAge";
NSString *UKeyUnitTypeId                = @"UnitTypeId";
NSString *UKeyAddressId                 = @"AddressId";
NSString *UKeySpecialText               = @"SpecialText";
NSString *UKeyplanPrice                 = @"Price";
NSString *UKeyplanPricePerMonth         = @"PricePerMonth";
NSString *UKeySpecialTextDisplay        = @"Display";
NSString *UKeyAutoRenewal               = @"ShowAutoRenewal";
NSString *UKeyPlanDuration              = @"DurationInMonth";
NSString *UKeyQuantityOfUnits           = @"Qty";
NSString *UKeyVisitPerYear              = @"VisitPerYear";
NSString *UKeyBasicFee                  = @"BasicFee";
NSString *UKeyFeeIncrement              = @"FeeIncrementString";

NSString *UKeyOptionalInformation       = @"OptionalInformation";
NSString *UKeySplitType                 = @"SplitType";
NSString *UKeyModelNumber               = @"ModelNumber";
NSString *UKeySerialNumber              = @"SerialNumber";
NSString *UKeyQuantityOfFilter          = @"QuantityOfFilter";
NSString *UKeyFilters                   = @"Filters";
NSString *UKeyFilterSize                = @"size";
NSString *UKeyFilterLocation            = @"LocationOfPart";
NSString *UKeyQuantityOfFuses           = @"QuantityOfFuses";
NSString *UKeyFuses                     = @"FuseTypes";
NSString *UKeyFuseType                  = @"FuseType";
NSString *UKeyBooster                   = @"ThermostatTypes";
NSString *UKeyPlanDesc                  = @"Description";
NSString *UKeyPlanPaymentType           = @"PlanType";
NSString *UKeyTotalAmount               = @"Total";
NSString *UKeyMessage                   = @"Message";
NSString *UKeyPlanName                  = @"PlanName";
NSString *UKeyDeleteOldSummary          = @"DeleteOldData";
NSString *UKeyHasPaymentFailedUnits     = @"HasPaymentFailedUnit";
NSString *UKeyHasPaymentProcessingUnits = @"HasPaymentProcessingUnits";

NSString *UKeyRed                   = @"R";
NSString *UKeyGreen                 = @"G";
NSString *UKeyBlue                  = @"B";

NSString *UKeyEmpFirstName          = @"EmpFirstName";
NSString *UKeyEmpLastName           = @"EmpLastName";

NSString *UKeyNoOfService           = @"NumberOfService";
NSString *UKeyDurationInMonth       = @"DurationInMonth";

NSString *UKeyInactivePlanMessage   = @"ErrMessage";
NSString *UKeySpecialPrice          = @"SpecialPrice";
NSString *UKeyDiscountedPrice       = @"DiscountPrice";

@implementation ACCUnit
@synthesize status,statusDesc,unitAge,visitPerYear,upcomigService,basicFee,feeIncrement,lastService,totalService,remainingService,unitName,planName,serviceMan,specialOfferText,isSpecialOfferDisplay,planPrice,planPricePerMonth,unitID,isAutoRenewalDisplay,planDescription,planPaymentType,totalAmount,message,red,green,blue,planId,planImageURL,paymentStatus,paymentError,empLastName,empFirstName,planDuartion,totalNoOfService,durationInMonth,unitsId,specialPrice,discountPrice;

-(instancetype)iniWithDictionary:(NSDictionary*)unitInfo
{
    if (unitInfo.count == 0)
    {
        return nil;
    }
    if (self == [super init])
    {
        unitID                = unitInfo[GKeyId];
        unitName              = unitInfo[UKeyUnitName];
        planId                = unitInfo[UKeyPlanId];
        planName              = unitInfo[UKeyPlanName];
        red                   = [unitInfo[UKeyRed] integerValue];
        green                 = [unitInfo[UKeyGreen] integerValue];
        blue                  = [unitInfo[UKeyBlue] integerValue];
        status                = unitInfo[UKeyStatus];
        statusDesc            = unitInfo[UKeyStatusDesc];
        lastService           = unitInfo[UKeyLastService];
        upcomigService        = unitInfo[UKeyUpcomingService];
        serviceMan            = unitInfo[SKeyServiceMan];
        totalService          = [unitInfo[UKeyTotalService] stringValue];
        remainingService      = [unitInfo[UKeyRemainingService] stringValue];
        specialOfferText      = unitInfo[UKeySpecialText];
        isSpecialOfferDisplay = [unitInfo[UKeySpecialTextDisplay]boolValue];
        isAutoRenewalDisplay  = [unitInfo[UKeyAutoRenewal]boolValue];
        planPrice             = [unitInfo[UKeyplanPrice] floatValue];
        planPricePerMonth     = [unitInfo[UKeyplanPricePerMonth] floatValue];
        planDescription       = unitInfo[UKeyPlanDesc];
        planPaymentType       = unitInfo[UKeyPlanPaymentType];
        totalAmount           = [unitInfo[UKeyTotalAmount] floatValue];
        message               = unitInfo[UKeyMessage];
        planImageURL          = [NSURL URLWithString:unitInfo[UKeyImage]];
        paymentStatus         = unitInfo[UKeyStatus];
        paymentError          = unitInfo[CKeyStripeError];
        empFirstName          = unitInfo[UKeyEmpFirstName];
        empLastName           = unitInfo[UKeyEmpLastName];
        unitAge               = unitInfo[UKeyUnitAge];
        planDuartion          = [unitInfo[UKeyPlanDuration] stringValue];
        totalNoOfService      = unitInfo[UKeyNoOfService];
        durationInMonth       = unitInfo[UKeyDurationInMonth];
        unitsId               = unitInfo[UKeyUnitId];
        specialPrice          = [unitInfo[UKeySpecialPrice] floatValue];
        discountPrice         = [unitInfo[UKeyDiscountedPrice] floatValue];
        visitPerYear          = unitInfo[UKeyVisitPerYear];
        basicFee              = [unitInfo[UKeyBasicFee] floatValue];
        feeIncrement          = unitInfo[UKeyFeeIncrement];
    }
    return self;
}
@end
