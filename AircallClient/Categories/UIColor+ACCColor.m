//
//  UIColor+ACCColor.m
//  AircallClient
//
//  Created by Manali on 02/04/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

@implementation UIColor (ACCColor)
+(UIColor *)borderColor
{
    return [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
}
+(UIColor*)placeholderColor
{
    return [UIColor lightGrayColor];
}
+(UIColor*)appGreenColor
{
    return [UIColor colorWithRed:0.023 green:0.76 blue:0.80 alpha:1.0];
}
+(UIColor*)selectedBackgroundColor
{
    return [UIColor colorWithRed:0.91 green:0.92 blue:0.95 alpha:1.0];
}
@end
