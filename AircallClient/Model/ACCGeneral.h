//
//  ACCGeneral.h
//  AircallClient
//
//  Created by ZWT111 on 17/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GKeyStateId;
extern NSString *const GKeyStateDefault;
extern NSString *const GKeyId;
extern NSString *const GKeyName;
extern NSString *const GKeyPlanName;
extern NSString *const GKeyBasic;
extern NSString *const GKeyIncrement;
extern NSString *const GKeyPageId;
extern NSString *const GKeyPageTitle;
extern NSString *const GKeyDescription;
extern NSString *const GKeyPhoneNumber;
extern NSString *const GKeyPageNo;

@interface ACCGeneral : NSObject
@property NSString *pageTitle;
@property NSString *description;
-(instancetype)initWithDictionary:(NSDictionary*)dictInfo;
@end
