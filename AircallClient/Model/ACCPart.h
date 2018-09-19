//
//  ACCPart.h
//  AircallClient
//
//  Created by ZWT111 on 21/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PKeyId          ;
extern NSString *const PKeyPartName    ;
extern NSString *const PKeySize        ;
extern NSString *const PKeyAmount      ;
extern NSString *const PKeyQuantity    ;


@interface ACCPart : NSObject

@property NSString *partId      ;
@property NSString *partName    ;
@property NSString *partSize    ;
@property float     partAmount  ;
@property NSString *partQty     ;

-(instancetype)initWithDictionary:(NSDictionary *)partInfo;

@end
