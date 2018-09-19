//
//  TermsAndConditionViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/11/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "TermsAndConditionViewController.h"

@interface TermsAndConditionViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIWebView *webvTerms;
@property NSString *html;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;

@end

@implementation TermsAndConditionViewController
@synthesize isfromPayment,btnCancel,btnMenu,webvTerms,html,lblHeader,termsPageID,isOpenPDF,pdfURL,pageTitle;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (isfromPayment)
    {
        btnMenu.hidden = YES;
        btnCancel.hidden = NO;
    }
    else
    {
        btnCancel.hidden = YES;
        btnMenu.hidden = NO;
    }
    
    if (pdfURL)
    {
        lblHeader.text = pageTitle;//@"Sales Agreement";
        NSURL *targetURL = [NSURL URLWithString:pdfURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        webvTerms.scalesPageToFit = true;
        [webvTerms loadRequest:request];
    }
    else
    {
       [self getTermsAndConditionContents];
    }
    
    webvTerms.scrollView.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Methods
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WebService Methods
-(void)getTermsAndConditionContents
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               GKeyPageId : termsPageID ? termsPageID : @"3"
                              };
        
        [ACCWebServiceAPI getCMSContents:dict completion:^(ACCAPIResponse *response, ACCGeneral *general)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 lblHeader.text = general.pageTitle;
                 html = general.description;
                 [webvTerms loadHTMLString:[html description] baseURL:nil];
             }
             else if (response.code == RCodeInvalidRequest)
             {
                 [self showAlertFromWithMessageWithSingleAction:ACCInvalidRequest andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACCUtil logoutTap];
                  }];
             }
             else if (response.code == RCodeUnAuthorized)
             {
                 [self showAlertWithMessage:response.message];
             }
             else
             {
                 [self showAlertWithMessage:response.message];
             }
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

@end
