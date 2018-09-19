//
//  ReceiptViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/26/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ReceiptViewController.h"

@interface ReceiptViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tblvReceipt;
@property (strong, nonatomic) IBOutlet UIView *vwTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPackage;
@property (strong, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UIButton *btnRetry;
@property (weak, nonatomic) IBOutlet UIButton *btnGoToDashboard;

@property NSMutableArray *arrUnits;
@property NSTimer *timer;
@property int unitCount;
@property float totalAmount;

@end

@implementation ReceiptViewController
@synthesize tblvReceipt,vwTotal,dictReceipt,arrUnits,lblTotal,lblTotalPackage,lblName,lblEmail,timer,unitCount,totalAmount,stripeCardId,btnRetry,btnGoToDashboard,isPlanRenewal;

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
    unitCount = 0;
    totalAmount = 0.0;
    tblvReceipt.alwaysBounceVertical = NO;
    tblvReceipt.separatorColor = [UIColor clearColor];
    btnRetry.hidden = YES;
    btnGoToDashboard.userInteractionEnabled = false;
    arrUnits = [[NSMutableArray alloc]init];
    
    for(NSDictionary *dict  in dictReceipt[UKeyUnits])
    {
        ACCUnit *unit = [[ACCUnit alloc]iniWithDictionary:dict];
        unit.paymentStatus = @"Received";
        [arrUnits addObject:unit];
    }
    
    [self setReceiptData];
    [tblvReceipt reloadData];
    
//    if (!isPlanRenewal)
//    {
//        [self getPaymentStatus];
//    }
//    else
//    {
//        [tblvReceipt reloadData];
//    }
}

-(void)setReceiptData
{
    lblName.text = [NSString stringWithFormat:@"%@ %@",dictReceipt[UKeyFirstName],dictReceipt[UKeyLastName]];
    lblEmail.text = dictReceipt[UKeyEmail];
    lblTotalPackage.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)arrUnits.count];
    lblTotal.text = [NSString stringWithFormat:@"$%0.02f",[dictReceipt[UKeyTotalAmount] floatValue]];
    btnGoToDashboard.userInteractionEnabled = YES;
    
//    if (isPlanRenewal)
//    {
//        CGFloat total = [dictReceipt[UKeyTotalAmount] floatValue];
//        lblTotal.text = [NSString stringWithFormat:@"$%0.02f",total];
//        btnGoToDashboard.userInteractionEnabled = YES;
//    }
    
}

#pragma mark - WebService Methods
-(void)getFailedPaymentUnits
{
    NSDictionary *clientInfo = @{
                                 UKeyClientID : ACCGlobalObject.user.ID
                                };
    
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getFailedPaymentUnits:clientInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *unitInfo,NSString * unitInActiveMessage)
    {
        if (response.code == RCodeSuccess)
        {
            SummaryViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
            svc.dictUnitInfo = unitInfo;
            svc.msgInactivePlan = unitInActiveMessage;
            [self.navigationController pushViewController:svc animated:YES];
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

-(void)getPaymentStatus
{
    if (unitCount < arrUnits.count)
    {
        ACCUnit *unit = arrUnits[unitCount];
        
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               UKeyUnitId : unit.unitID,
                               CKeyStripeCardID : stripeCardId
                              };
        
        [ACCWebServiceAPI getPaymentStatus:dict completionHandler:^(ACCAPIResponse *response, NSDictionary *statusData)
         {
             if (response.code == RCodeSuccess)
             {
                 unit.paymentStatus = statusData[UKeyStatus];
                 unit.paymentError = statusData[CKeyStripeError];
                 
                 [arrUnits replaceObjectAtIndex:unitCount withObject:unit];
                 
                 if (![unit.paymentStatus isEqualToString:@"Processing"])
                 {
                     if ([unit.paymentStatus isEqualToString:@"Received"])
                     {
                         totalAmount += unit.planPrice;
                         lblTotal.text = [NSString stringWithFormat:@"$%0.2f",totalAmount];
                     }
                     else
                     {
                         btnRetry.hidden = NO;
                         btnRetry.userInteractionEnabled = false;
                     }
                     
                     unitCount++;
                     [tblvReceipt reloadData];
                 }

                 [self getPaymentStatus];
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
         }];
    }
    else
    {
        btnRetry.userInteractionEnabled = true;
        btnGoToDashboard.userInteractionEnabled = true;
    }
}

#pragma mark - Event Methods
- (IBAction)btnDashboardTap:(id)sender
{
    DashboardViewController *viewController = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [FIRAnalytics logEventWithName:@"plan_creation"
                        parameters:@{
                                     @"Amount": lblTotal.text,
                                     }];
}

- (IBAction)btnRetryTap:(id)sender
{
    if ([ACCUtil reachable])
    {
        [self getFailedPaymentUnits];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUnits.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCReceiptCell *receiptCell = [tableView dequeueReusableCellWithIdentifier:@"receiptCell"];
    receiptCell.selectionStyle = UITableViewCellSelectionStyleNone;
    ACCUnit *unit = arrUnits[indexPath.item];
    [receiptCell setCellData:unit ansIsPlanRenewal:isPlanRenewal];
    return receiptCell;
}

@end
