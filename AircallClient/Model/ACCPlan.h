//
//  ACCPlan.h
//  AircallClient
//
//  Created by ZWT112 on 6/27/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *PKeyImage;
extern NSString *PKeyColor;
@interface ACCPlan : NSObject
@property UIImage *image;
@property NSString *color;
@property NSString *planDesc;
@property NSString *packageName;
-(instancetype)initWithDictionary:(NSDictionary*)dictPlan;
@end
