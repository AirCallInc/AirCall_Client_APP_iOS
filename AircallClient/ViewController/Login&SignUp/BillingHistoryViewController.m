//
//  BillingHistoryViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "BillingHistoryViewController.h"

@interface BillingHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblvBilling;
@property NSMutableArray *arrBillings;

@end


@implementation BillingHistoryViewController
@synthesize tblvBilling,arrBillings;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    arrBillings = [[NSMutableArray alloc]init];
    tblvBilling.separatorColor = [UIColor clearColor];
    
    [self getBillingData];
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource & Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrBillings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCBillingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billingCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ACCBilling *billing = arrBillings[indexPath.row];
    
    cell.lblPlan.text  = billing.paymentStatus;
    cell.lblDate.text  = billing.transactionDate;
    cell.lblTime.text  = billing.transactionTime;
    cell.lblPrice.text = [NSString stringWithFormat:@"$%0.2f",billing.purchasedAmount];
    
    if (!billing.isPaid)
    {
        cell.lblPlan.textColor  = [UIColor redColor];
        cell.lblDate.textColor  = [UIColor redColor];
        cell.lblTime.textColor  = [UIColor redColor];
        cell.lblPrice.textColor = [UIColor redColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCBilling *billing = arrBillings[indexPath.row];
    BillingDetailViewController *bdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BillingDetailViewController"];
    bdvc.billingID = billing.billingId;
    [self.navigationController pushViewController:bdvc animated:YES];
}

#pragma mark - WebServiceMethod
-(void)getBillingData
{
    if ([ACCUtil reachable])
    {
        NSDictionary *userInfo = @{
                                   UKeyClientID : ACCGlobalObject.user.ID
                                  };
        
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getBillingList:userInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *billingList)
        {
            [SVProgressHUD dismiss];
            
            arrBillings = billingList.mutableCopy;
            
            if (response.code == RCodeSuccess)
            {
                
            }
            else if (response.code == RCodeNoData)
            {
                tblvBilling.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvBilling.height];
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
                tblvBilling.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvBilling.height];
            }
            
            [tblvBilling reloadData];
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

@end
