//
//  PaymentViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/26/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()<PaymentMethodViewControllerDelegate,CardIOPaymentViewControllerDelegate,ZWTTextboxToolbarHandlerDelegate,SelectQuantityViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtNameOnCard;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNo;
@property (strong, nonatomic) IBOutlet UITextField *txtExpiryMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtExpiryYear;
@property (strong, nonatomic) IBOutlet UITextField *txtCVV;

@property (strong, nonatomic) IBOutlet UIImageView *imgvCard;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvPayment;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
@property NSString *cardType;
@property (strong, nonatomic) IBOutlet UIButton *btnVisa;
@property (strong, nonatomic) IBOutlet UIButton *btnMasterCard;
@property (strong, nonatomic) IBOutlet UIButton *btnDiscover;
@property (strong, nonatomic) IBOutlet UIButton *btnAmericanExpress;
@property (weak, nonatomic) IBOutlet UIButton *btnExpiryMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnExpityYear;
@property (weak, nonatomic) IBOutlet UIImageView *imgDAExMonth;
@property (weak, nonatomic) IBOutlet UIImageView *imgDAExpYear;
@property (weak, nonatomic) IBOutlet UIButton *btnSendEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnAgreeLink;

@property NSString * currentMonth;
@property NSString * currentYear;

@end

@implementation PaymentViewController
@synthesize imgvCard,scrlvPayment,txtNameOnCard,txtCardNo,txtExpiryMonth,txtExpiryYear,txtCVV,textboxHandler,arrTextBoxes,lblTotalAmount,totalAmount,btnAgree,dictBillingAddress,cardType,btnVisa,btnMasterCard,btnDiscover,btnAmericanExpress,currentMonth,currentYear,isFromNoShow,noShowId,isPlanRenewal,notificationId,btnExpiryMonth,btnExpityYear,imgDAExMonth,imgDAExpYear,termsPdfURL,btnSendEmail,btnAgreeLink;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, txtCVV.y + txtCVV.height + 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Helper Methods
-(void)prepareView
{
    btnAgree.selected = NO;
    lblTotalAmount.text = dictBillingAddress[UKeyTotalAmount];
    
    scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, txtExpiryMonth.y);
   
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtNameOnCard,txtCardNo,txtCVV]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvPayment];
    
    textboxHandler.delegate = self;
    
    [self getDefaultCardInfo];
    
    if ([termsPdfURL isEqualToString:@""])
    {
        btnAgreeLink.userInteractionEnabled = false;
        btnSendEmail.hidden = true;
    }
    else
    {
        btnAgreeLink.userInteractionEnabled = true;
        btnSendEmail.hidden = false;
    }
}

-(void)showCardScanner
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.suppressScanConfirmation = YES;
    scanViewController.hideCardIOLogo = YES;
    scanViewController.disableManualEntryButtons = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

-(void)selectCardType
{
    if ([cardType isEqualToString:ACCCardVisa])
    {
        [self btnPaymentTypeTap:btnVisa];
    }
    else if ([cardType isEqualToString:ACCCardMaster])
    {
        [self btnPaymentTypeTap:btnMasterCard];
    }
    else if ([cardType isEqualToString: ACCCardDiscover])
    {
        [self btnPaymentTypeTap:btnDiscover];
    }
    else
    {
        [self btnPaymentTypeTap:btnAmericanExpress];
    }
}
-(void)setCardData:(ACCCard*)cardInfo
{
    txtNameOnCard.text = cardInfo.nameOnCard;
    txtCardNo.text     = cardInfo.cardNumber;
    cardType           = cardInfo.cardType;
    
    txtExpiryYear.userInteractionEnabled = NO;
    txtExpiryMonth.userInteractionEnabled = NO;
    
    btnExpityYear.userInteractionEnabled = NO;
    btnExpiryMonth.userInteractionEnabled = NO;
    
    btnVisa.userInteractionEnabled            = NO;
    btnMasterCard.userInteractionEnabled      = NO;
    btnDiscover.userInteractionEnabled        = NO;
    btnAmericanExpress.userInteractionEnabled = NO;
    
    txtCardNo.userInteractionEnabled = NO;
    
    imgDAExMonth.hidden = YES;
    imgDAExpYear.hidden = YES;
    
    if (cardInfo.expiryYear != nil)
    {
        txtExpiryYear.text = cardInfo.expiryYear;
    }
    
    if (cardInfo.expiryMonth != nil)
    {
        txtExpiryMonth.text = cardInfo.expiryMonth;
    }
    
    [self selectCardType];
}

-(void)openChoosePopup:(NSString *)popFor withTextField:(UITextField *)tf
{
    SelectQuantityViewController *sqvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectQuantityViewController"];
    sqvc.popupFor = popFor;
    sqvc.providesPresentationContextTransitionStyle = YES;
    sqvc.definesPresentationContext = YES;
    [sqvc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    sqvc.txtSelected = tf;
    sqvc.tblvSelected = nil;
    sqvc.delegate = self;
    
    [self.navigationController presentViewController:sqvc animated:NO completion:nil];
}

-(void)getCurrentDateYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    currentYear = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    currentMonth = [formatter stringFromDate:[NSDate date]];
}

-(void)setEditableView
{
    [self getCurrentDateYear];
    
//    txtExpiryMonth.text = currentMonth;
//    txtExpiryYear.text  = currentYear;
    txtExpiryYear.userInteractionEnabled = YES;
    txtExpiryMonth.userInteractionEnabled = YES;
    
    btnExpityYear.userInteractionEnabled = YES;
    btnExpiryMonth.userInteractionEnabled = YES;
    
    btnVisa.userInteractionEnabled            = YES;
    btnMasterCard.userInteractionEnabled      = YES;
    btnDiscover.userInteractionEnabled        = YES;
    btnAmericanExpress.userInteractionEnabled = YES;
    
    txtCardNo.userInteractionEnabled = YES;
    
    imgDAExMonth.hidden = NO;
    imgDAExpYear.hidden = NO;
    
    [self btnPaymentTypeTap:btnVisa];
}

#pragma mark - SelectQuantityViewController Delegate Method
-(void)setQuantity:(NSString*)strQuantity inTextField:(UITextField *)txtField andReloadTable:(UITableView *)tblview
{
    txtField.text = strQuantity;
}

#pragma mark - Event Methods

- (IBAction)btnSendEmailTap:(id)sender
{
    [self sendTermsEmail];
}

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnTryAgainTap:(id)sender
{
    [self showCardScanner];
}

- (IBAction)btnDoneTap:(id)sender
{
    if ([self isCardDetailValid])
    {
        [self sendCardInfo];
    }
}

- (IBAction)btnListingTap:(id)sender
{
    PaymentMethodViewController *viewController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"PaymentMethodViewController"];
    viewController.hidePlusBtn = YES;
    viewController.delegate = self;
    txtExpiryMonth.layer.borderColor = [UIColor borderColor].CGColor;
    txtExpiryYear.layer.borderColor  = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:txtExpiryYear];
    [self removeErrorMessageBelowView:txtExpiryMonth];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnAgreeBoxTap:(id)sender
{
    if (btnAgree.selected == NO)
    {
        btnAgree.selected = YES;
    }
    else
    {
        btnAgree.selected = NO;
    }
}

- (IBAction)btnTermsAndConditionTap:(id)sender
{
        TermsAndConditionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
         viewController.isfromPayment = YES;
         viewController.pageTitle = @"Sales Agreement";
        //viewController.termsPageID = @"5";
        viewController.pdfURL = termsPdfURL;
        viewController.isOpenPDF = YES;
        [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)btnPaymentTypeTap:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if (btn.tag == 0)
    {
        btnVisa.selected            = YES;
        btnMasterCard.selected      = NO;
        btnDiscover.selected        = NO;
        btnAmericanExpress.selected = NO;
        cardType = ACCCardVisa;
    }
    else if(btn.tag == 1)
    {
        btnVisa.selected            = NO;
        btnMasterCard.selected      = YES;
        btnDiscover.selected        = NO;
        btnAmericanExpress.selected = NO;
        cardType = ACCCardMaster;
    }
    else if (btn.tag == 2)
    {
        btnVisa.selected            = NO;
        btnMasterCard.selected      = NO;
        btnDiscover.selected        = YES;
        btnAmericanExpress.selected = NO;
        cardType = ACCCardDiscover;
    }
    else
    {
        btnVisa.selected            = NO;
        btnMasterCard.selected      = NO;
        btnDiscover.selected        = NO;
        btnAmericanExpress.selected = YES;
        cardType = ACCCardAmerican;
    }
}

- (IBAction)btnExpiryMonthTap:(id)sender
{
    txtExpiryMonth.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:txtExpiryMonth];
    [self openChoosePopup:@"ExMonth" withTextField:txtExpiryMonth];
}

- (IBAction)btnExpiryYearTap:(id)sender
{
    [self openChoosePopup:@"ExYear" withTextField:txtExpiryYear];
}

#pragma mark - CardIO Delegate Methods
-(void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    txtCardNo.text = info.cardNumber;
//    txtExpiryYear.text =[NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear];
//    txtExpiryMonth.text = [NSString stringWithFormat:@"%lu", (unsigned long)info.expiryMonth];
    txtCVV.text = info.cvv;
    imgvCard.image = [CardIOCreditCardInfo logoForCardType:[info cardType]];
    cardType = [CardIOCreditCardInfo displayStringForCardType:[info cardType] usingLanguageOrLocale:nil];
    [self selectCardType];

    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PaymentMethodViewController Delegate Method
-(void)CardDetail:(NSDictionary *)dict
{
    [self getCurrentDateYear];
    txtExpiryYear.text = dict[CKeyExpiryYear];
    txtExpiryMonth.text = dict[CKeyExpiryMonth];
    txtNameOnCard.text = dict[CKeyNameOnCard];
    txtCardNo.text = dict[CKeyCardNumber];
    cardType = dict[CKeyCardType];
    [self selectCardType];
}

#pragma mark - WebService Method
-(void)sendCardInfo
{
    NSDictionary *dict = @{
                           CKeyNameOnCard     : txtNameOnCard.text,
                           CKeyExpiryMonth    : @([txtExpiryMonth.text integerValue]),
                           CKeyExpiryYear     : @([txtExpiryYear.text integerValue]),
                           CKeyCardNumber     : txtCardNo.text,
                           CKeyCVV            : txtCVV.text,
                           CKeyCardType       : cardType,
                           UKeyClientID       : ACCGlobalObject.user.ID,
                           CKeyStripeCardID   : @"",
                           SKeyID             : noShowId != nil ? noShowId : @"",
                           NKeyNotificationId : notificationId != nil ? notificationId : @""
                          };
    
    NSMutableDictionary * dictPurchaseInfo = [dict mutableCopy];
    
    [dictPurchaseInfo addEntriesFromDictionary:dictBillingAddress];
    
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI sendCardInfo:dictPurchaseInfo withIsNoShow:isFromNoShow andIsPlanRenewal:isPlanRenewal completionHandler:^(ACCAPIResponse *response, NSDictionary *dictReceiptInfo)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                if (isFromNoShow)
                {
                    NoShowReceiptViewController *viewController = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NoShowReceiptViewController"];
                    //viewController.total = totalAmount;
                    viewController.dictReceiptInfo = dictReceiptInfo;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                else
                {
                    ReceiptViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReceiptViewController"];
                    viewController.stripeCardId = dictReceiptInfo[CKeyStripeCardID];
                    viewController.dictReceipt = dictReceiptInfo;
                    viewController.isPlanRenewal = isPlanRenewal;
                    [self.navigationController pushViewController:viewController animated:YES];
                }
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

-(void)getDefaultCardInfo
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
                 for (int i = 0; i < cardList.count; i++)
                 {
                     ACCCard *card = cardList[i];
                     
                     if (card.isDefaultPayment)
                     {
                         [self setCardData:card];
                     }
                 }
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
             else if (response.code == RCodeNoData)
             {
                 if (![CardIOUtilities canReadCardWithCamera])
                 {
                     NSLog(@"Device not supported camera");
                 }
                 else
                 {
                     [CardIOUtilities preload];
                     [self showCardScanner];
                 }
                 
                 [self setEditableView];
                 
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)sendTermsEmail
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI sendEmailOfSales:^(ACCAPIResponse * response)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                [self showAlertWithMessage:response.message];
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
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - Validation Method
-(BOOL)isCardDetailValid
{
    ZWTValidationResult result;
    
    result = [txtNameOnCard validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankNameOnCard belowView:txtNameOnCard];
        
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCInvalidNameOnCard belowView:txtNameOnCard];
        
        return NO;
    }
    
    if ([cardType  isEqualToString:@""])
    {
        [self showAlertWithMessage:ACCBlankCardType];
    }
    
    result = [txtCardNo validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankCardNumber belowView:txtCardNo];
        
        return NO;
    }
    
    if ([txtCardNo.text length] > 16 || [txtCardNo.text length] < 13)
    {
        txtCardNo.layer.borderColor = [UIColor redColor].CGColor;
        txtCardNo.layer.borderWidth = 1.0;
        [txtCardNo becomeFirstResponder];
        [self showErrorMessage:ACCValidCardNumber belowView:txtCardNo];
        
        return NO;
    }
    
    result = [txtExpiryMonth validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankExpiryMonth belowView:txtExpiryMonth];
        
        return NO;
    }
    
    result = [txtExpiryYear validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankExpiryYear belowView:txtExpiryYear];
        
        return NO;
    }

    
    if ([txtExpiryMonth.text integerValue] < [currentMonth integerValue] && [txtExpiryYear.text isEqualToString:currentYear])
    {
        txtExpiryMonth.layer.borderColor = [UIColor redColor].CGColor;
        txtExpiryMonth.layer.borderWidth = 1.0;
        [txtExpiryMonth becomeFirstResponder];
        [txtExpiryMonth endEditing:YES];
        [self showErrorMessage:ACCValidExpiryMonth belowView:txtExpiryMonth];
        
        return NO;
    }
    
    result = [txtCVV validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankCVV belowView:txtCVV];
        
        return NO;
    }
    
    if ((([txtCVV.text length] > 4 || [txtCVV.text length] < 4 ) && [cardType isEqualToString:ACCCardAmerican]) || ((([txtCVV.text length] < 3 || [txtCVV.text length] >= 4)) && ![cardType isEqualToString:ACCCardAmerican]))
    {
        txtCVV.layer.borderColor = [UIColor redColor].CGColor;
        txtCVV.layer.borderWidth = 1.0;
        [txtCVV becomeFirstResponder];
        [self showErrorMessage:ACCValidCVV belowView:txtCVV];
        
        return NO;
    }
    
    if (btnAgree.selected == NO)
    {
        [self showAlertWithMessage:ACCAgreeToTerms];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - ZWTTextboxHandler Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    return YES;
}

-(void)doneTap
{
    scrlvPayment.contentSize = CGSizeMake(scrlvPayment.width, txtCVV.y + txtCVV.height + 20);
}
@end
