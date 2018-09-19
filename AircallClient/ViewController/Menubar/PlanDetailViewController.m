//
//  PlanDetailViewController.m
//  AircallClient
//
//  Created by ZWT112 on 6/28/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "PlanDetailViewController.h"

@interface PlanDetailViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webvPackage;
@property (strong, nonatomic) IBOutlet UIButton *btnPackageA;
@property (strong, nonatomic) IBOutlet UIButton *btnPackageB;
@property (strong, nonatomic) IBOutlet UIView *vwSelection;
@property NSMutableArray *arrPlanInfo;
@end

@implementation PlanDetailViewController
@synthesize planId,lblPlanHeader,planName,webvPackage,btnPackageA,btnPackageB,vwSelection,arrPlanInfo;

#pragma mark - ACCViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    webvPackage.scrollView.bounces = NO;
    lblPlanHeader.text = planName;
    [self getPlanDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Helper Methods
-(void)setPlanDetail
{
    ACCPlan *packageA = arrPlanInfo[0];
    ACCPlan *packageB = arrPlanInfo[1];
    [btnPackageA setTitle:packageA.packageName forState:UIControlStateNormal];
    [btnPackageB setTitle:packageB.packageName forState:UIControlStateNormal];
}
#pragma mark - WebService Methods
-(void)getPlanDetail
{
    if ([ACCUtil reachable])
    {        
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               //UKeyClientID : ACCGlobalObject.user.ID,
                               UKeyPlanId : planId
                               };
        [ACCWebServiceAPI getPlanDetail:dict completion:^(ACCAPIResponse *response, NSMutableArray *arrPlanDetail)
         {
            [SVProgressHUD dismiss];
             
            if (response.code == RCodeSuccess)
            {
                arrPlanInfo = arrPlanDetail;
                [self setPlanDetail];
                [self btnPackageTap:btnPackageA];
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
#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnPackageTap:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    ACCPlan *plans = arrPlanInfo[btn.tag];
    [webvPackage loadHTMLString:[plans.planDesc description] baseURL:nil];
    
    if (btn.tag == 0)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            vwSelection.frame = CGRectMake(btnPackageA.x, btnPackageA.y + btnPackageA.height -3, btnPackageA.width, vwSelection.height);
            [btnPackageA setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
            [btnPackageB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }];
        
    }
    else if (btn.tag == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            vwSelection.frame = CGRectMake(btnPackageB.x, btnPackageB.y + btnPackageB.height -3, btnPackageB.width, vwSelection.height);
            [btnPackageA setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnPackageB setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
        }];
    }
}

@end
