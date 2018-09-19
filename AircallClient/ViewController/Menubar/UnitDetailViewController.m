//
//  UnitDetailViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/17/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "UnitDetailViewController.h"

@interface UnitDetailViewController ()<UpdateUnitNameViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblPlan;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitAge;
@property (strong, nonatomic) IBOutlet UILabel *lblLastService;
@property (strong, nonatomic) IBOutlet UILabel *lblUpcomingService;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceMan;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalService;
@property (strong, nonatomic) IBOutlet UILabel *lblRemainingService;

@end

@implementation UnitDetailViewController
@synthesize lblUnit,lblPlan,lblUnitAge,lblLastService,lblUpcomingService,lblServiceMan,lblTotalService,lblRemainingService,unitDetail,unitId;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
-(void) viewDidAppear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    [self getUnitDetail];
}
#pragma mark - helper Method 
-(void)setUnitData
{
    if ([ACCUtil reachable])
    {
        lblUnit.text             = unitDetail.unitName;
        lblPlan.text             = unitDetail.planName;
        lblUnitAge.text          = unitDetail.unitAge;
        
        if ([unitDetail.empFirstName isEqualToString:@"NA"] && [unitDetail.empLastName isEqualToString:@"NA"])
        {
            lblServiceMan.text       = @"NA";
        }
        else
        {
            lblServiceMan.text       = [NSString stringWithFormat:@"%@ %@",unitDetail.empFirstName,unitDetail.empLastName];
        }
        
        lblLastService.text      = unitDetail.lastService;
        lblUpcomingService.text  = unitDetail.upcomigService;
        lblTotalService.text     = unitDetail.totalService;
        lblRemainingService.text = unitDetail.remainingService;
    }
    else
    {
        [self showAlertFromWithMessageWithSingleAction:ACCNoInternet andHandler:^(UIAlertAction * _Nullable action)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    }

}
#pragma mark - WEbservice Method
-(void)getUnitDetail
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               UKeyUnitId: unitId
                               };
        [SVProgressHUD show];
        [ACCWebServiceAPI getUnitDetail:dict completionHandler:^(ACCAPIResponse *response, ACCUnit *dict)
         {
             if (response.code == RCodeSuccess)
             {
                 unitDetail = dict;
                 [self setUnitData];
             }
             [SVProgressHUD dismiss];
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
- (IBAction)btnUnitNameTap:(id)sender
{
    if ([ACCUtil reachable])
    {
        UpdateUnitNameViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UpdateUnitNameViewController"];
        viewController.providesPresentationContextTransitionStyle = YES;
        viewController.definesPresentationContext = YES;
        viewController.unitId   = unitDetail.unitID;
        viewController.unitName = unitDetail.unitName;
        viewController.delegate = self;
        [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.navigationController presentViewController:viewController animated:NO completion:nil];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
    
}
#pragma mark - UpdateUnitNameViewControllerDelegate Method
-(void)updateUnitName:(NSString *)strName
{
    lblUnit.text = strName;
    unitDetail.unitName = strName;
}
@end
