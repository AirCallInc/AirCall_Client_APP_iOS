//
//  AddCardViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()<CardIOPaymentViewControllerDelegate,ZWTTextboxToolbarHandlerDelegate,SelectQuantityViewControllerDelegate>

@property (strong, nonatomic) IBOutlet ACCTextField *txtNameOnCard;
@property (strong, nonatomic) IBOutlet ACCTextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet ACCTextField *txtExpiryMonth;
@property (strong, nonatomic) IBOutlet ACCTextField *txtExpiryYear;
@property (strong, nonatomic) IBOutlet ACCTextField *txtCVV;
@property NSString *cardType;
@property (strong, nonatomic) IBOutlet UIImageView *imgvCardType;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvCard;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;
@property (strong, nonatomic) IBOutlet UIButton *btnScanCard;

@property (strong, nonatomic) IBOutlet UIButton *btnVisa;
@property (strong, nonatomic) IBOutlet UIButton *btnMasterCard;
@property (strong, nonatomic) IBOutlet UIButton *btnDiscover;
@property (strong, nonatomic) IBOutlet UIButton *btnAmericanExpress;

@property NSString * currentMonth;
@property NSString * currentYear;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property BOOL isDefaultPayment;
@end

@implementation AddCardViewController
@synthesize txtNameOnCard,txtCardNumber,txtExpiryMonth,txtExpiryYear,txtCVV,imgvCardType,textboxHandler,arrTextBoxes,scrlvCard,cardType,delegate,btnVisa,btnMasterCard,btnDiscover,btnAmericanExpress,currentMonth,currentYear,cardInfo,btnScanCard,btnUpdate,btnAdd,lblHeader,isDefaultPayment,cardId,strHeader,notificationId;

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
    scrlvCard.contentSize = CGSizeMake(scrlvCard.width, txtCVV.y + txtCVV.height + 20);
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtNameOnCard,txtCardNumber,txtCVV]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvCard];
    textboxHandler.delegate = self;
    [self getCurrentDateYear];
    
    if ([strHeader isEqualToString:@"Add Card"])
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
        
        [self btnPaymentTypeTap:btnVisa];
        
        btnUpdate.hidden = YES;
        btnAdd.hidden    = NO;
//        txtExpiryYear.text = currentYear;
//        txtExpiryMonth.text = currentMonth;
    }
    else
    {
        if (cardId != nil)
        {
            [self getCardDetail];
        }

        btnScanCard.hidden = YES;
        btnUpdate.hidden   = NO;
        btnAdd.hidden      = YES;
        txtCardNumber.userInteractionEnabled = false;
        btnVisa.userInteractionEnabled = false;
        btnMasterCard.userInteractionEnabled = false;
        btnDiscover.userInteractionEnabled = false;
        btnAmericanExpress.userInteractionEnabled = false;
        scrlvCard.frame = CGRectMake(scrlvCard.x, scrlvCard.y, scrlvCard.width, scrlvCard.height + btnScanCard.height);
    }
    
   lblHeader.text = strHeader;
}

-(void)showCardScanner
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.disableManualEntryButtons = YES;
    scanViewController.suppressScanConfirmation  = YES;
    scanViewController.hideCardIOLogo = YES;
    
    [self presentViewController:scanViewController animated:YES completion:nil];
}

-(void)getCurrentDateYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    currentYear = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    currentMonth = [formatter stringFromDate:[NSDate date]];
}

-(void)openChoosePopup:(NSString *)popFor withTextField:(UITextField *)tf
{
    SelectQuantityViewController *sqvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SelectQuantityViewController"];
    sqvc.popupFor = popFor;
    sqvc.providesPresentationContextTransitionStyle = YES;
    sqvc.definesPresentationContext = YES;
    [sqvc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    sqvc.txtSelected = tf;
    sqvc.tblvSelected = nil;
    sqvc.delegate = self;
    
    [self.navigationController presentViewController:sqvc animated:NO completion:nil];
}

-(void)setCardType
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

-(void)setCardInfo
{
    txtCardNumber.text = cardInfo.cardNumber;
    txtExpiryYear.text = cardInfo.expiryYear;
    txtExpiryMonth.text = cardInfo.expiryMonth;
    txtNameOnCard.text = cardInfo.nameOnCard;
    cardType = cardInfo.cardType;
    isDefaultPayment = cardInfo.isDefaultPayment;
    [self setCardType];
}

#pragma mark - SelectQuantityViewController Delegate
-(void)setQuantity:(NSString*)strQuantity inTextField:(UITextField *)txtField andReloadTable:(UITableView *)tblview
{
    txtField.text = strQuantity;
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAddTap:(id)sender
{
    if ([ACCUtil reachable])
    {
        if ([self isCardDetailValid])
        {
             [self sendCardInfo];
        }
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
    
}
- (IBAction)btnSacnTap:(id)sender
{
    [self showCardScanner];
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
- (IBAction)btnUpdateTap:(id)sender
{
    if ([ACCUtil reachable])
    {
        if ([self isCardDetailValid])
        {
            [self updateCardInfo];
        }
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - CardIO Delegate Method
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    txtCardNumber.text = info.cardNumber;
//    txtExpiryYear.text = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear];
//    txtExpiryMonth.text = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryMonth];
    imgvCardType.image = [CardIOCreditCardInfo logoForCardType:[info cardType]];
    cardType = [CardIOCreditCardInfo displayStringForCardType:[info cardType] usingLanguageOrLocale:nil];
    [self setCardType];
    txtCVV.text = info.cvv;
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WebService Methods
-(void)sendCardInfo
{
    [SVProgressHUD show];
    
    NSDictionary *dictCardInfo = @{
                                    UKeyClientID : ACCGlobalObject.user.ID,
                                    CKeyCardNumber:txtCardNumber.text,
                                    CKeyExpiryYear:@([txtExpiryYear.text integerValue]) ,
                                    CKeyExpiryMonth:@([txtExpiryMonth.text integerValue]) ,
                                    CKeyCVV:txtCVV.text,
                                    CKeyNameOnCard:txtNameOnCard.text,
                                    CKeyCardType : cardType
                                  };
    
    [ACCWebServiceAPI AddCardInfo:dictCardInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *arrCard)
    {
        [SVProgressHUD dismiss];
        
        if (response.code == RCodeSuccess)
        {
            [delegate cardInfo:arrCard];
            [self.navigationController popViewControllerAnimated:YES];
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

-(void)getCardDetail
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               CKeyID : cardId,
                               NKeyNotificationId: notificationId != nil ? notificationId : @""
                               };
        
        [ACCWebServiceAPI getCardDetail:dict completionHandler:^(ACCAPIResponse *response, ACCCard *card)
        {
            if (response.code == RCodeSuccess)
            {
                cardInfo = card;
                [self setCardInfo];
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
-(void)updateCardInfo
{
    [SVProgressHUD show];
    
    NSString *isDefault;
    
    if (isDefaultPayment)
    {
        isDefault = @"true";
    }
    else
    {
        isDefault = @"false";
    }
    
    NSDictionary *dictCardInfo = @{
                                   UKeyID       : cardInfo.cardId,
                                   UKeyClientID : ACCGlobalObject.user.ID,
                                   CKeyCardNumber:txtCardNumber.text,
                                   CKeyExpiryYear:@([txtExpiryYear.text integerValue]) ,
                                   CKeyExpiryMonth:@([txtExpiryMonth.text integerValue]) ,
                                   CKeyCVV:txtCVV.text,
                                   CKeyNameOnCard:txtNameOnCard.text,
                                   CKeyCardType : cardType,
                                   CKeyIsDefaultPayment : isDefault,
                                   NKeyNotificationId : notificationId != nil ? notificationId : @""
                                  };
    
    [ACCWebServiceAPI updateCardInfo:dictCardInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *arrCard)
    {
        [SVProgressHUD show];
        
        if (response.code == RCodeSuccess)
        {
            [delegate cardInfo:arrCard];
            [self.navigationController popViewControllerAnimated:YES];
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
        return NO;
    }
    
    result = [txtCardNumber validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankCardNumber belowView:txtCardNumber];
        
        return NO;
    }
    
    if ([txtCardNumber.text length] > 16 || [txtCardNumber.text length] < 13)
    {
        txtCardNumber.layer.borderColor = [UIColor redColor].CGColor;
        txtCardNumber.layer.borderWidth = 1.0;
        [txtCardNumber becomeFirstResponder];
        [self showErrorMessage:ACCValidCardNumber belowView:txtCardNumber];
        
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

    return YES;
}

#pragma mark - ZWTTextboxHandler Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    
    if (textField == txtCardNumber)
    {
       NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
       NSInteger length = [currentString length];
        
       if (length > 16)
        {
            return NO;
        }
    }
    return YES;
}
-(void)doneTap
{
    scrlvCard.contentSize = CGSizeMake(scrlvCard.width, txtCVV.y + txtCVV.height);
}
@end
