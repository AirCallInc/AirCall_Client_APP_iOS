//
//  AboutUsViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/11/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webvAboutUs;
@property NSString *html;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;

@end

@implementation AboutUsViewController
@synthesize html,webvAboutUs,lblHeader;

#pragma mark - ACCViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];

    webvAboutUs.scrollView.alwaysBounceVertical = NO;
    [self getAboutUsContents];
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

#pragma mark - WebService Methods
-(void)getAboutUsContents
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                           GKeyPageId : @"1"
                           };
        
        [ACCWebServiceAPI getCMSContents:dict completion:^(ACCAPIResponse *response, ACCGeneral *general)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                lblHeader.text = general.pageTitle;
                html = general.description;
                [webvAboutUs loadHTMLString:[html description] baseURL:nil];
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
