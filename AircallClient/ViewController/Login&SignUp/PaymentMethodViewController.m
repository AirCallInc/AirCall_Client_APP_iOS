//
//  PaymentMethodViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "PaymentMethodViewController.h"

@interface PaymentMethodViewController ()<UITableViewDataSource,UITableViewDelegate,AddCardViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblvPayment;
@property (strong, nonatomic) IBOutlet UIButton *btnPlus;
@property NSMutableArray *arrPayments;
@property NSInteger selectedIndex;
@property NSIndexPath *index;
@property ACCCard *card;
@property NSString *cardType;
@end

@implementation PaymentMethodViewController
@synthesize tblvPayment,arrPayments,btnPlus,hidePlusBtn,selectedIndex,index,cardType;

#pragma mark - ACCViewController Method
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
    arrPayments = [[NSMutableArray alloc]init];
    tblvPayment.alwaysBounceVertical = NO;

    [self getPaymentData];
}
#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    if(arrPayments.count == 1)
    {
        NSDictionary *dict = [[NSDictionary alloc]init];
        
        dict = @{
                 CKeyCardNumber : self.card.cardNumber,
                 CKeyExpiryMonth : self.card.expiryMonth,
                 CKeyExpiryYear : self.card.expiryYear,
                 CKeyNameOnCard: self.card.nameOnCard,
                 CKeyCardType : self.card.cardType,
                 };
        
        [self.delegate CardDetail:dict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddTap:(id)sender
{
    AddCardViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCardViewController"];
    viewController.delegate = self;
    viewController.strHeader = @"Add Card";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnEditTap:(UIButton*)sender
{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:tblvPayment];
    NSIndexPath *indexPath = [tblvPayment indexPathForRowAtPoint:rootViewPoint];
    self.card = arrPayments[indexPath.item];
    
    AddCardViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCardViewController"];
    viewController.cardId = self.card.cardId;
    viewController.notificationId = @"";
    viewController.delegate = self;
    viewController.strHeader = @"Edit Card";
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma maek - UITableView DataSource & Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPayments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paymentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.card = arrPayments[indexPath.item];
    
    cardType = self.card.cardType;
    [cell setCellData:self.card];

    if (self.card.isDefaultPayment)
    {
        selectedIndex             = indexPath.row;
        cell.imgvCheckmark.hidden = NO;
        cell.backgroundColor      = [UIColor selectedBackgroundColor];
    }
    else
    {
        cell.imgvCheckmark.hidden = YES;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.card = arrPayments[indexPath.item];
    
    ACCPaymentCell * cell = (ACCPaymentCell*)[tableView cellForRowAtIndexPath:indexPath];

    if (selectedIndex != indexPath.row)
    {
        cell.imgvCheckmark.hidden = NO;
        cell.backgroundColor = [UIColor selectedBackgroundColor];
        selectedIndex = indexPath.row;
    }
    
    if (hidePlusBtn)
    {
        NSDictionary *dict = [[NSDictionary alloc]init];
        
        dict = @{
                 CKeyCardNumber : self.card.cardNumber,
                 CKeyExpiryMonth : self.card.expiryMonth,
                 CKeyExpiryYear : self.card.expiryYear,
                 CKeyNameOnCard: self.card.nameOnCard,
                 CKeyCardType : self.card.cardType,
                };
        
        [self.delegate CardDetail:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.card = arrPayments[indexPath.row];
        [self updateCardData];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCPaymentCell *cell = (ACCPaymentCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgvCheckmark.hidden = YES;
}

#pragma mark - WebServiceMethod
-(void)getPaymentData
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *userInfo = @{
                                   UKeyClientID : ACCGlobalObject.user.ID
                                  };
        
        [ACCWebServiceAPI getCardList:userInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *cardList)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                arrPayments = cardList.mutableCopy;
                [tblvPayment reloadData];
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
                tblvPayment.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPayment.height];
            }
            
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)updateCardData
{
    NSDictionary *cardInfo = @{
                                UKeyClientID         : ACCGlobalObject.user.ID,
                                CKeyIsDefaultPayment : @"true",
                                UKeyID               : self.card.cardId
                              };
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI updateCardInfo:cardInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *cardList)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 arrPayments = cardList.mutableCopy;
                 [tblvPayment reloadData];
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

#pragma mark - AddCardViewControllerDelegate Method
-(void)cardInfo:(NSMutableArray *)arrInfo
{
    arrPayments = arrInfo;
    tblvPayment.backgroundView = nil;
    [tblvPayment reloadData];
}
@end
