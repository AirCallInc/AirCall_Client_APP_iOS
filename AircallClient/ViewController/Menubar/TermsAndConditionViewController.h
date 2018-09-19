//
//  TermsAndConditionViewController.h
//  AircallClient
//
//  Created by ZWT112 on 5/11/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndConditionViewController : ACCViewController
@property BOOL isfromPayment;
@property BOOL isOpenPDF;
@property NSString *termsPageID;
@property NSString *pdfURL;
@property NSString *pageTitle;
@end
