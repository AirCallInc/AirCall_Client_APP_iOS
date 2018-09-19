//
//  BillingDetailViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "BillingDetailViewController.h"

@interface BillingDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblServiceCaseNo;
@property (weak, nonatomic) IBOutlet UILabel *lblCaseNoHeading;
@property (strong, nonatomic) IBOutlet UILabel *lblTransactionId;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitName;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UIView *vwUnitInfo;
@property (weak, nonatomic) IBOutlet UIView *vwPartInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;
@property (weak, nonatomic) IBOutlet UITableView *tblvParts;
@property (strong, nonatomic) IBOutlet UILabel *lblFailedReason;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentType;
@property (strong, nonatomic) IBOutlet UILabel *lblPaymentNumber;

@property ACCBilling *billingInfo;
@property NSString *billingType;
@property NSMutableArray *arrParts;

@end

@implementation BillingDetailViewController
@synthesize lblServiceCaseNo,lblTransactionId,lblDate,lblTime,lblUnitName,lblAmount,vwUnitInfo,vwPartInfo,scrlv,tblvParts,lblCaseNoHeading,lblFailedReason,lblPaymentType,lblPaymentNumber;
@synthesize billingType,billingInfo,arrParts,billingID;

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
    [self getBillingHistoryDetail];
    tblvParts.alwaysBounceVertical = NO;
}

-(void)setFrames
{
    lblCaseNoHeading.text = @"Order #";
    vwPartInfo.hidden = YES;
    vwUnitInfo.hidden = NO;
    scrlv.contentSize = CGSizeMake(scrlv.width,scrlv.height);
//    if ([billingType isEqualToString:@"Part Order"])
//    {
//        lblCaseNoHeading.text = @"Order #";
//        vwPartInfo.hidden = NO;
//        vwUnitInfo.hidden = YES;
//        vwPartInfo.height = tblvParts.y + tblvParts.contentSize.height;
//        tblvParts.height = tblvParts.contentSize.height;
//        scrlv.contentSize = CGSizeMake(scrlv.width, vwPartInfo.y + vwPartInfo.height);
//    }
//    else if ([billingType isEqualToString:@"No Show"])
//    {
//        lblCaseNoHeading.text = @"Service Case #";
//        vwPartInfo.hidden     = YES;
//        vwUnitInfo.hidden     = YES;
//        scrlv.contentSize = CGSizeMake(scrlv.width, scrlv.height);
//    }
//    else
//    {
//        lblCaseNoHeading.text = @"Order #";
//        vwPartInfo.hidden = YES;
//        vwUnitInfo.hidden = NO;
//        scrlv.contentSize = CGSizeMake(scrlv.width,scrlv.height);
//    }
}

-(void)setDetail
{
    //billingType           = billingInfo.planName;
    
    [self setFrames];
    
    lblServiceCaseNo.text = billingInfo.orderNumber;
    lblTransactionId.text = billingInfo.invoiceNumber;
    lblTime.text          = billingInfo.transactionTime;
    lblDate.text          = billingInfo.transactionDate;
    lblPaymentNumber.text = billingInfo.checkNumber;
    //lblUnitName.text      = billingInfo.unitName;
    lblAmount.text        = [NSString stringWithFormat:@"$ %0.2f",billingInfo.purchasedAmount];
//    arrParts              = billingInfo.partsList;
//    lblPaymentType.text   = billingInfo.paymentMethod;
//    lblPaymentNumber.text = billingInfo.paymentNumber;
    
    if (!billingInfo.isPaid)
    {
        lblFailedReason.text  = billingInfo.reason;
    }
    else
    {
        lblFailedReason.hidden = YES;
    }
    
//    if (arrParts.count > 0)
//    {
//        [tblvParts reloadData];
//        [self setFrames];
//    }
}

#pragma mark - WebService Methods
-(void)getBillingHistoryDetail
{
    NSDictionary *userBillingInfo = @{
                                       UKeyClientID       : ACCGlobalObject.user.ID,
                                       BKeyBillingID      : billingID
                                     };
    
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getBillingHistoryDetail:userBillingInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *billingDetail)
         {
             billingInfo = [[ACCBilling alloc]initWithDictionary:billingDetail];
             
             if (response.code == RCodeSuccess)
             {
                 [self setDetail];
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

#pragma mark - UITableView DataSource & Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrParts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ACCPartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ACCPart *partInfo = arrParts[indexPath.row];
    cell.lblPartName.text = [NSString stringWithFormat:@"%@ %@",partInfo.partName,partInfo.partSize];
    float perPieceAmount = partInfo.partAmount / [partInfo.partQty floatValue];
    cell.lblPartQty.text  = [NSString stringWithFormat:@"$%0.2f x %@",perPieceAmount,partInfo.partQty];
    cell.lblPartPrice.text = [NSString stringWithFormat:@"$%0.2f",partInfo.partAmount];
    
    return cell;
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
