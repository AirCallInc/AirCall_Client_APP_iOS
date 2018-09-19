//
//  UIImage+ACCImageOperations.h
//  AircallClient
//
//  Created by ZWT112 on 7/14/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ACCImageOperations)
- (UIImage *)cropedImagewithCropRect:(CGRect)cropRect;

- (UIImage *)fixOrientation;

- (UIImage *)resizedImageForProfile;

@end
