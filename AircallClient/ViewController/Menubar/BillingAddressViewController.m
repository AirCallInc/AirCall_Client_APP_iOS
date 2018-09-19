//
//  BillingAddressViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "BillingAddressViewController.h"

@interface BillingAddressViewController ()<UITextFieldDelegate,SelectCityStateViewControllerDelegate,ZWTTextboxToolbarHandlerDelegate>

@property (strong, nonatomic) IBOutlet ACCTextField *txtFirstName;
@property (strong, nonatomic) IBOutlet ACCTextField *txtLastName;
@property (weak, nonatomic) IBOutlet ACCTextField *txtCompany;
@property (strong, nonatomic) IBOutlet ACCTextField *txtvAddress;
@property (strong, nonatomic) IBOutlet ACCTextField *txtCity;
@property (strong, nonatomic) IBOutlet ACCTextField *txtState;
@property (strong, nonatomic) IBOutlet ACCTextField *txtZipcode;
@property (strong, nonatomic) IBOutlet ACCTextField *txtPhone;
@property (strong, nonatomic) IBOutlet ACCTextField *txtMobile;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvAddress;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSString *termsPdfURL;

@property NSMutableArray *arrTextBoxes;
@property NSMutableArray *arrAddresses;
@property NSString *stateId;
@property NSString *cityId;

@end

@implementation BillingAddressViewController

@synthesize txtFirstName,txtLastName,txtvAddress,txtCity,txtState,txtZipcode,txtPhone,txtMobile,scrlvAddress,textboxHandler,arrTextBoxes,arrAddresses,stateId,cityId,totalAmount,isFromNoShow,noShowId,isPlanRenewal,unitId,notificationId,txtCompany,termsPdfURL;

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
    stateId = @"";
    cityId = @"";
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtFirstName,txtLastName,txtCompany,txtvAddress,txtZipcode,txtPhone,txtMobile]];
    scrlvAddress.contentSize = CGSizeMake(scrlvAddress.width, txtMobile.y + txtMobile.height + 30);
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvAddress];
    textboxHandler.delegate = self;
    
    txtFirstName.text = ACCGlobalObject.user.firstName;
    txtLastName.text  = ACCGlobalObject.user.lastName;
    txtCompany.text   = ACCGlobalObject.user.companyName;
    
    [self getBillingAddress];
}

-(void)openStateCityViewControllerIsCity:(BOOL)ans
{
    SelectCityStateViewController *viewController = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"SelectCityStateViewController"];
    
    viewController.delegate = self;
    viewController.isCity   = ans;
    viewController.selectedStateId  = stateId;
    viewController.selectedCityId   = cityId;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(BOOL)isValidateAddress
{
    NSString *rawString = [txtvAddress text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0)
    {
        txtvAddress.layer.borderColor = [UIColor redColor].CGColor;
        txtvAddress.layer.borderWidth = 1.0;
        [self showErrorMessage:ACCBlankAddress belowView:txtvAddress];
        return NO;
    }
    else if([stateId isEqualToString:@""])
    {
        [self showErrorMessage:ACCBlankState belowView:txtState];
        return NO;
    }
    else if ([cityId isEqualToString:@""])
    {
        [self showErrorMessage:ACCBlankCity belowView:txtCity];
        return NO;
    }
    
    ZWTValidationResult result;
    
    result = [txtZipcode validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankZipcode belowView:txtZipcode];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACCInvalidZipcode belowView:txtZipcode];
        
        return NO;
    }
    else if(!(txtZipcode.text.length == 5))
    {
        [self showErrorMessage:ACCZipcodeFiveLetter belowView:txtZipcode];
        
        return NO;
    }
    
    result = [txtMobile validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
       
        [self showErrorMessage:ACCBlankPhoneNumber belowView:txtMobile];
        return NO;
    }
    else if ([txtMobile.text length] < ACCMobileNumberMinimumLengh)
    {
        
        txtMobile.layer.borderWidth = 1;
        txtMobile.layer.borderColor = [UIColor redColor].CGColor;
        [txtMobile becomeFirstResponder];
        [self showErrorMessage:ACCInvalidMobileNumber belowView:txtMobile];
        return NO;
    }
    else if ([txtPhone.text length] > 0 && [txtPhone.text length] < ACCPhoneNumberMinimumLengh)
    {
        [self showErrorMessage:ACCInvalidPhoneNumber belowView:txtPhone];
        return NO;
    }
    
    return YES;
}

#pragma mark - Selectionvalue Delegate Method
-(void)SelectionValue:(NSDictionary *)selectedDict isCity:(bool)ans
{
    if(ans)
    {
        txtCity.text = selectedDict[GKeyName];
        cityId = [selectedDict[GKeyId] stringValue];
        txtZipcode.text = @"";
    }
    else
    {
        txtState.text = selectedDict[GKeyName];
        stateId = [selectedDict[GKeyId] stringValue];
        txtCity.text = @"";
        cityId = @"";
        txtZipcode.text = @"";
    }
}

#pragma mark - WebService Methods
-(void)getBillingAddress
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *userId = @{
                                 UKeyClientID : ACCGlobalObject.user.ID
                                };
        
        [ACCWebServiceAPI getBillingAddress:userId completionHandler:^(ACCAPIResponse *response, NSDictionary *dataList)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                txtvAddress.text = dataList[AKeyAddress];
                txtState.text    = dataList[AKeyStateName];
                txtCity.text     = dataList[AKeyCityName];
                txtZipcode.text  = dataList[AKeyZipCode];
                stateId          = [dataList[AKeyStateId] stringValue];
                cityId           = [dataList[AKeyCityId] stringValue];
                txtMobile.text   = dataList[UKeyMobileNumber];
                txtPhone.text    = dataList[UKeyHomeNumber];
                termsPdfURL      = dataList[BKeyPaymentTermsURL];
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

-(void)validateBillingAddress
{
    NSDictionary *billingAddress = @{
                                     AKeyClientId  : ACCGlobalObject.user.ID,
                                     AKeyAddress   : [txtvAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                     AKeyStateId   : @(stateId.intValue),
                                     AKeyCityId    : @(cityId.intValue),
                                     AKeyZipCode   : txtZipcode.text
                                     };
    
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI validateBillingAddress:billingAddress completionHandler:^(ACCAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 PaymentViewController *viewController= [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
                 
                 if (isFromNoShow)
                 {
                     viewController.isFromNoShow = YES;
                 }
                 
                 if (isPlanRenewal)
                 {
                     viewController.isPlanRenewal = YES;
                 }
                 
                 viewController.dictBillingAddress = [self sendBillingAddressWithTotal];
                 viewController.termsPdfURL = termsPdfURL;
                 viewController.noShowId = noShowId;
                 viewController.notificationId = notificationId;
                 [self.navigationController pushViewController:viewController animated:YES];
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

-(NSDictionary *)sendBillingAddressWithTotal
{
    NSDictionary * billingAddress = @{
                                      UKeyFirstName      : txtFirstName.text,
                                      UKeyLastName       : txtLastName.text,
                                      UKeyCompany        : txtCompany.text,
                                      AKeyAddress        : [txtvAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                      AKeyStateId        : stateId,
                                      AKeyCityId         : cityId,
                                      AKeyZipCode        : txtZipcode.text,
                                      UKeyMobileNumber   : txtMobile.text,
                                      UKeyHomeNumber     : txtPhone.text,
                                      UKeyTotalAmount    : totalAmount,
                                      UKeyUnitId         : unitId != nil ? unitId : @"",
                                      NKeyNotificationId : notificationId != nil ? notificationId : @"",
                                      };
    return billingAddress;
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPaymentTap:(id)sender
{
    if ([self isValidateAddress])
    {
        [self validateBillingAddress];
    }
}

#pragma mark - UITextField Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtCity)
    {
        if(![stateId isEqualToString:@""] && stateId!= NULL)
        {
            [self openStateCityViewControllerIsCity:YES];
        }
        else
        {
            [self showAlertWithMessage:ACCBlankState];
        }
        
        textField.layer.borderColor = [UIColor borderColor].CGColor;
        [self removeErrorMessageBelowView:textField];
    }
    else if (textField == txtState)
    {
        [self openStateCityViewControllerIsCity:NO];
        textField.layer.borderColor = [UIColor borderColor].CGColor;
        [self removeErrorMessageBelowView:textField];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    
    if(textField == txtPhone || textField == txtMobile)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 15)
        {
            return NO;
        }
    }
    else if (textField == txtZipcode)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if(length > 5)
        {
            return NO;
        }
    }
    
    return YES;
}
-(void)doneTap
{
    
}

#pragma mark - UITextview Delegate Method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    textView.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textView];
    
    return YES;
}

@end
