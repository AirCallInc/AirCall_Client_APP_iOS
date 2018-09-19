//
//  NSString+ACCString.h
//  AircallClient
//
//  Created by ZWT111 on 20/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ACCString)

@property (NS_NONATOMIC_IOSONLY, readonly, strong) id jsonObject;

- (instancetype)initWithJSONObject:(id)jsonObject;

@end
