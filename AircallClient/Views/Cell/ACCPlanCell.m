//
//  ACCPlanCell.m
//  AircallClient
//
//  Created by ZWT112 on 6/27/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCPlanCell.h"
@implementation ACCPlanCell
@synthesize lblPlanName,imgvPlan,lblPrice,lblServiceInfo;

-(void)setCellData:(ACCUnit*)plan
{
    lblPlanName.text = [plan valueForKey:UKeyPlanName];
    lblPrice.text = [NSString stringWithFormat:@"Basic Fee $%0.2f/Year/Visit",[[plan valueForKey:UKeyBasicFee] floatValue]];
    lblServiceInfo.text = [NSString stringWithFormat:@"FeeIncrement $%@/Year/Visit",[plan valueForKey:UKeyFeeIncrement]];
    
//    if (plan.planImageURL != nil)
//    {
//        [self displayPlanIcon:plan];
//        
////        [imgvPlan setImageWithURL:plan.planImageURL];
////        [ACCWebService downloadImageWithURL:plan.planImageURL complication:^(UIImage *image, NSError *error)
////         {
////             if (image)
////             {
////                 imgvPlan.image = image;
////             }
////         }];
//    }
//    self.layer.backgroundColor = [UIColor colorWithRed:plan.red/255.0 green:plan.green/255.0 blue:plan.blue/255.0 alpha:1.0].CGColor;
    
    self.layer.backgroundColor = [self getUIColorObjectFromHexString:[plan valueForKey:@"BackgroundColor"] alpha:1.0].CGColor;
}

- (void)displayPlanIcon:(ACCUnit *)plan
{
    imgvPlan.alpha = 0.0;
    
    [imgvPlan setImageWithURLRequest:[NSURLRequest requestWithURL:plan.planImageURL]
                        placeholderImage:[UIImage imageNamed:@""]
                                 success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)
     {
         imgvPlan.image = image;
         
         [self showImageView:(response ? YES : NO)];
     }
                                 failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)
     {
         [self showImageView:YES];
     }];
}
- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

- (void)showImageView:(BOOL)animated
{
    if(animated)
    {
        [UIView animateWithDuration:1.0 animations:^{ imgvPlan.alpha = 1.0; }];
    }
    else
    {
        imgvPlan.alpha = 1.0;
    }
}


@end
