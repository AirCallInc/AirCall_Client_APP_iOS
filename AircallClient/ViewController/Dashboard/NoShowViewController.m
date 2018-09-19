//
//  NoShowViewController.m
//  AircallClient
//
//  Created by Manali on 15/07/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "NoShowViewController.h"

@interface NoShowViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblSubDetail;
@property (strong, nonatomic) IBOutlet UITextView *txtvDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnPay;
@property BOOL collectpayment;

@end

@implementation NoShowViewController
@synthesize lblPrice,lblSubDetail,txtvDetail,serviceId,notificationId,btnPay,collectpayment;
#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getNoShowDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPayTap:(id)sender
{
    BillingAddressViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"BillingAddressViewController"];
    viewController.isFromNoShow = YES;
    viewController.totalAmount  = lblPrice.text;
    viewController.noShowId = serviceId;
    viewController.notificationId = notificationId;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Helper Method
-(void)setNoShowData:(NSDictionary*)dictInfo
{
    lblPrice.text = [NSString stringWithFormat:@"$ %0.02f",[dictInfo[SKeyNoShowAmount] floatValue]];
    lblSubDetail.text = [NSString stringWithFormat:@"For service %@ performed on %@ by %@ %@",dictInfo[SKeyServiceCaseNo],dictInfo[SKeyDate],dictInfo[UKeyEmpFirstName],dictInfo[UKeyEmpLastName]];
    txtvDetail.text = [NSString stringWithFormat:@"%@ \n\n%@",dictInfo[SKeyRescheduleReason],dictInfo[SKeyMessage]];
    collectpayment  = [dictInfo[SKeyNoShowCollectPayment] boolValue];
    
    if(collectpayment == false)
    {
        txtvDetail.frame = CGRectMake(txtvDetail.x, txtvDetail.y, txtvDetail.width, txtvDetail.height + btnPay.height + 10);
        btnPay.hidden = YES;
    }
}

#pragma mark - WebService Method
-(void)getNoShowDetail
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dict = @{
                                NKeyNotificationId : notificationId != nil ? notificationId : @"",
                                SKeyID : serviceId,
                                UKeyClientID : ACCGlobalObject.user.ID
                              };
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getNoShowDetail:dict completionHandler:^(ACCAPIResponse *response, NSDictionary *billingDetail)
        {
            if (response.code == RCodeSuccess)
            {
                [self setNoShowData:billingDetail];
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
        [self showAlertFromWithMessageWithSingleAction:ACCNoInternet andHandler:^(UIAlertAction * _Nullable action)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
    }
}

@end
