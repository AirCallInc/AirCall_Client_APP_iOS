//
//  NSString+ACCString.m
//  AircallClient
//
//  Created by ZWT111 on 20/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "NSString+ACCString.h"

@implementation NSString (ACCString)

- (instancetype)initWithJSONObject:(id)jsonObject
{
    self = [self init];
    
    if(self)
    {
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&error];
        
        if (!jsonData)
        {
            DDLogError(@"Got an error: %@", error);
            
            return Nil;
        }
        else
        {
            self = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return self;
        }
    }
    
    return self;
}

- (id)jsonObject
{
    NSError *error;
    
    id JSON = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingMutableContainers
                                                error:&error];
    return JSON;
}


@end
