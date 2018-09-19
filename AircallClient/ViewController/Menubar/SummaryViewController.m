//
//  SummaryViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/24/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tblvSummary;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvSummary;
@property (strong, nonatomic) IBOutlet UIView *vwTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property NSMutableArray *arrunitInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnAddAnotherUnit;
@property (strong, nonatomic) IBOutlet UIButton *btnRemove;
@property (strong, nonatomic) IBOutlet UIView *vwSeprator;


@end

@implementation SummaryViewController
@synthesize tblvSummary,scrlvSummary,vwTotal,dictUnitInfo,lblTotalAmount,lblMessage,arrunitInfo,unitId,notificationId,notificationType,btnBack,isFromNotificationList,btnAddAnotherUnit,isPlanRenewal,msgInactivePlan,vwSeprator,btnRemove;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    if (isFromNotificationList)
    {
        btnBack.hidden = NO;
    }
    else
    {
        btnBack.hidden = YES;
    }
    
    if (dictUnitInfo != nil)
    {
        [self getSummaryData];
    }
    else
    {
        if ([notificationType isEqualToString:@"FailedPayment"])
        {
            [self getFailedPaymentUnits];
            btnAddAnotherUnit.hidden = NO;
        }
        else
        {
            [self getSummaryInfo];
            btnAddAnotherUnit.hidden = YES;
            [self setFrames];
        }
    }
    
    tblvSummary.separatorColor = [UIColor clearColor];
    tblvSummary.alwaysBounceVertical = NO;
}

-(void)getSummaryData
{
    arrunitInfo = [dictUnitInfo[UKeyUnits] mutableCopy];
    lblTotalAmount.text = [NSString stringWithFormat:@"$%0.2f",[dictUnitInfo[UKeyTotalAmount]floatValue]];
    lblMessage.text     = [NSString stringWithFormat:@"%@", dictUnitInfo[UKeyMessage]];
    [tblvSummary reloadData];
}

-(void)setFrames
{
    tblvSummary.frame = CGRectMake(tblvSummary.x, tblvSummary.y, tblvSummary.width, tblvSummary.height + btnAddAnotherUnit.height);
    vwTotal.frame = CGRectMake(vwTotal.x, tblvSummary.y + tblvSummary.height, vwTotal.width, vwTotal.height);
}

#pragma mark - WebService Methods
-(void)removeUnit:(NSDictionary*)dictInfo
{
    if ([ACCUtil reachable])
    {
        [ACCWebServiceAPI RemoveUnit:dictInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *dict,NSString * unitInActiveMessage)
        {
            if (response.code == RCodeSuccess)
            {
                dictUnitInfo = dict;
                msgInactivePlan = unitInActiveMessage;
                [self getSummaryData];
                [tblvSummary reloadData];
                [self showAlertWithMessage:response.message];
            }
            else if(response.code == RCodeNoData)
            {
                AddUnitViewController *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUnitViewController"];
                auvc.strBlankSummary = @"BlankSummary";
                [self.navigationController pushViewController:auvc animated:YES];
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

-(void)getSummaryInfo
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               NKeyNotificationId :notificationId != nil ? notificationId : @"",
                               UKeyUnitId : unitId
                              };
        
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getSummaryData:dict completionHandler:^(ACCAPIResponse *response, NSDictionary *unitInfo)
        {
            if (response.code == RCodeSuccess)
            {
                dictUnitInfo = unitInfo;
                [self getSummaryData];
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

-(void)getFailedPaymentUnits
{
    NSDictionary *clientInfo = @{
                                 UKeyClientID : ACCGlobalObject.user.ID
                                };
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getFailedPaymentUnits:clientInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *unitInfo,NSString * unitInActiveMessage)
         {
             if (response.code == RCodeSuccess)
             {
                 dictUnitInfo = unitInfo;
                 msgInactivePlan = unitInActiveMessage;
                 [self getSummaryData];
             }
             else if (response.code == RCodeInvalidRequest)
             {
                 [self showAlertFromWithMessageWithSingleAction:ACCInvalidRequest andHandler:^(UIAlertAction * _Nullable action)
                  {
                      [ACCUtil logoutTap];
                  }];
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

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddUnitTap:(id)sender
{
    if (arrunitInfo.count < 10)
    {
        AddUnitViewController *auvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddUnitViewController"];
        auvc.allowQtyOfUnits = 10 - arrunitInfo.count;
        [self.navigationController pushViewController:auvc animated:YES];
    }
    else
    {
        [self showAlertWithMessage:ACCUnitLimit];
    }
}

- (IBAction)btnCheckoutTap:(id)sender
{
   
    if ([msgInactivePlan  isEqual: @""])
    {
        BillingAddressViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BillingAddressViewController"];
        viewController.totalAmount = lblTotalAmount.text;
        viewController.unitId = unitId;
        viewController.notificationId = notificationId;
        
        if (isPlanRenewal)
        {
            viewController.isPlanRenewal = isPlanRenewal;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        [self showAlertWithMessage:msgInactivePlan];
    }
    
}

- (IBAction)btnRemoveTap:(id)sender
{
    [self showAlertFromWithMessage:ACCDeleteConformation andHandler:^(UIAlertAction * _Nullable action)
    {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblvSummary];
        NSIndexPath *indexPath = [tblvSummary indexPathForRowAtPoint:buttonPosition];
        
        NSMutableDictionary *dictUnit = arrunitInfo[indexPath.item];
        
        NSDictionary *dict = @{
                               AKeyClientId : ACCGlobalObject.user.ID,
                               UKeyUnitId   : dictUnit[GKeyId]
                               };
        [arrunitInfo removeObjectAtIndex:indexPath.item];
        
        [self removeUnit:dict];
    }];
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrunitInfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSummaryCell *summaryCell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell" forIndexPath:indexPath];
    summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ACCUnit *unit = [[ACCUnit alloc]iniWithDictionary:arrunitInfo[indexPath.item]];
   [summaryCell setCellData:unit];
    return summaryCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < arrunitInfo.count)
    {
        ACCUnit *unitInfo =[[ACCUnit alloc]iniWithDictionary:arrunitInfo[indexPath.item]];
            
        NSString *str = unitInfo.planDescription;
        
        CGSize constraint;
        
        constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.1 , FLT_MAX);
        
        UIFont *font;
        
        if(ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone4)
        {
            font = [UIFont systemFontOfSize:7];
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone5)
        {
            font = [UIFont systemFontOfSize:12.5];//12
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
        {
            font = [UIFont systemFontOfSize:13.5];//13.5
        }
        else
        {
            font = [UIFont systemFontOfSize:14.5];//14.7
        }
        
        CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
        return size.height + 115 ;
    }
    
    return 0;
}
@end
