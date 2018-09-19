//
//  PlanCoverageViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/11/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "PlanCoverageViewController.h"

@interface PlanCoverageViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collvPlan;
@property NSArray *arrPlanInfo;
@end

@implementation PlanCoverageViewController
@synthesize arrPlanInfo,collvPlan;

#pragma mark - ACCViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

   // arrPlanInfo = [[NSArray alloc]init];
   // arrPlanInfo = @[@"Residential Plan",@"Commercial Plan",@"Industrial Plan",@"Multi-family Plan"];
    [self getPlanList];
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
- (IBAction)planComparisonTap:(id)sender {
    TermsAndConditionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
    viewController.isfromPayment = YES;
    viewController.pageTitle = @"Plan Comparison";
    viewController.pdfURL = [NSString stringWithFormat:@"%@/uploads/plan/Aicall_Plan_v2.pdf",BaseUrlPath];
    viewController.isOpenPDF = YES;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UICollectionView DataSource & Delegate Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrPlanInfo.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACCPlanCell *planCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"clvPlanCell" forIndexPath:indexPath];
    ACCUnit *unit = arrPlanInfo[indexPath.item];
    [planCell setCellData:unit];
    return planCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collvPlan.width/2, collvPlan.height/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return insets;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlanDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanDetailViewController"];
    ACCUnit *plan = arrPlanInfo[indexPath.item];
    viewController.planId =[plan valueForKey:UKeyID];
    viewController.planName = [plan valueForKey:UKeyPlanName];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - WebService Method
-(void)getPlanList
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getPlanTypeWithcompletionHandler:^(ACCAPIResponse *response, NSMutableArray *planType)
        {
            if (response.code == RCodeSuccess)
            {
                arrPlanInfo= planType.mutableCopy;
                [collvPlan reloadData];
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
            
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

@end
