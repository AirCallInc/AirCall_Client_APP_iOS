//
//  AddAddressViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()<ZWTTextboxToolbarHandlerDelegate,SelectCityStateViewControllerDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet ACCTextField *txtAddress;
@property (strong, nonatomic) IBOutlet ACCTextField *txtZipCode;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;

@property (strong, nonatomic) IBOutlet UIView *vwDefaultAddress;

@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;
@property (strong, nonatomic) IBOutlet UISwitch *swDefaultAddress;

@property NSString *stateId;
@property NSString *cityId;
@property NSMutableArray *addressList;
@property NSMutableArray * arrStates;
@end

@implementation AddAddressViewController
@synthesize txtCity,txtState,textboxHandler,arrTextBoxes,txtZipCode,scrlvAddress,stateId,cityId,addressList,lblTitle,btnAdd,vwDefaultAddress,swDefaultAddress,arrStates,txtAddress,isAllowDelete,addressCount;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    scrlvAddress.contentOffset = CGPointMake(0, 0);
//}

#pragma mark - Helper Methods
-(void)prepareView
{
    stateId = @"";
    cityId = @"";
    addressList = [[NSMutableArray alloc]init];
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtAddress,txtZipCode]];
    scrlvAddress.contentSize = CGSizeMake(scrlvAddress.width, txtZipCode.y + txtZipCode.height);
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvAddress];
    textboxHandler.delegate = self;
    
    if(self.isEditAddress)
    {
        [self prepareviewForEditAddress:self.isEditAddress];
        
        if (addressCount > 1)
        {
            vwDefaultAddress.hidden = NO;
        }
        else
        {
            vwDefaultAddress.hidden = YES;
        }
    }
    else
    {
        vwDefaultAddress.hidden = YES;
        [self getStates];
    }
}

-(BOOL)isValidateAddress
{
    NSString *rawString = [txtAddress text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0)
    {
        [self showErrorMessage:ACCBlankAddress belowView:txtAddress];
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
    
    result = [txtZipCode validate:ZWTValidationTypeNumber showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankZipcode belowView:txtZipCode];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACCInvalidZipcode belowView:txtZipCode];
        
        return NO;
    }
    else if(!(txtZipCode.text.length == 5))
    {
        [self showErrorMessage:ACCZipcodeFiveLetter belowView:txtZipCode];
        
        return NO;
    }
    
    return YES;
}
-(void)sendAddressList
{
    [self.delegate AddressList:addressList];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareviewForEditAddress:(BOOL)isEditable
{
    lblTitle.text = @"Edit Address";
    [btnAdd setTitle:@"Update" forState:UIControlStateNormal];
    
    txtAddress.text  =  self.address.address    ;
    txtState.text    =  self.address.stateName  ;
    txtCity.text     =  self.address.cityName   ;
    txtZipCode.text  =  self.address.zipcode    ;
    stateId          =  self.address.stateId    ;
    cityId           =  self.address.cityId     ;
    
    if (!isAllowDelete)
    {
        txtCity.userInteractionEnabled = NO;
        txtState.userInteractionEnabled = NO;
        txtZipCode.userInteractionEnabled = NO;
        txtCity.textColor = [UIColor grayColor];
        txtState.textColor = [UIColor grayColor];
        txtZipCode.textColor = [UIColor grayColor];
    }
    
    if (self.address.isDefaultAddress)
    {
        [swDefaultAddress setOn:YES];
    }
    else
    {
        [swDefaultAddress setOn:NO];
    }
}

-(void)setDefaultState
{
    if (arrStates.count > 0)
    {
        for (int i = 0; i < arrStates.count; i++)
        {
            BOOL isDefault = [[arrStates[i]valueForKey:GKeyStateDefault] boolValue];
            
            if (isDefault)
            {
                txtState.text = [arrStates[i]valueForKey:GKeyName];
                stateId = [[arrStates[i]valueForKey:GKeyId] stringValue];
            }
        }
    }
}

-(void)openStateCityViewControllerIsCity:(BOOL)ans
{
    SelectCityStateViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCityStateViewController"];
    
    viewController.delegate = self;
    viewController.isCity   = ans;
    viewController.selectedStateId  = stateId;
    viewController.selectedCityId   = cityId;
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark - webservice Method
-(void)sendAddress
{
    NSDictionary *dict = @{
                            AKeyClientId  : ACCGlobalObject.user.ID,
                            AKeyAddress   : [txtAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                            AKeyStateId   : @(stateId.intValue),
                            AKeyCityId    : @(cityId.intValue),
                            AKeyZipCode   : txtZipCode.text
                          };
    [SVProgressHUD show];
    
    [ACCWebServiceAPI addAddress:dict completioHandler:^(ACCAPIResponse *response, NSMutableArray *arrAddress)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
             addressList = arrAddress.mutableCopy;

             [self sendAddressList];
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

-(void)updateAddress
{
    NSDictionary *addressInfo = @{
                           AKeyAddressId : self.address.addressId,
                           AKeyAddress   : txtAddress.text,
                           AKeyStateId   : @(stateId.intValue),
                           AKeyCityId    : @(cityId.intValue),
                           AKeyZipCode   : txtZipCode.text
                           };
    [SVProgressHUD show];
    
    [ACCWebServiceAPI updateAddress:addressInfo completionHandler:^(ACCAPIResponse *response,NSMutableArray *arrAddress)
    {
        [SVProgressHUD dismiss];
        
        if (response.code == RCodeSuccess)
        {
            if (self.swDefaultAddress.isOn)
            {
                [self updateDefaultAddress:@"true"];
            }
            else
            {
                [self updateDefaultAddress:@"false"];
            }
            
            addressList = arrAddress.mutableCopy;
            
            [self sendAddressList];
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
-(void)updateDefaultAddress:(NSString*)string
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *updateInfo = @{
                                     AKeyAddressId : self.address.addressId,
                                     AKeyIsDefault : string
                                     };
        
        [ACCWebServiceAPI updateAddress:updateInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *arrAddresses)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
               //  arrAddress = arrAddresses.mutableCopy;
               //  [tblvAddress reloadData];
                // [self showAlertWithMessage:response.message];
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

-(void)getStates
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getAllStateList:^(ACCAPIResponse *response, NSMutableArray *arrState)
         {
             [SVProgressHUD dismiss];
             
             if(response.code == RCodeSuccess)
             {
                 arrStates = arrState.mutableCopy;
                 [self setDefaultState];
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

#pragma mark - Event Method
- (IBAction)btnCancelTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAddTap:(id)sender
{
    if([self isValidateAddress])
    {
        if([ACCUtil reachable])
        {
            if(self.isEditAddress)
            {
                [self updateAddress];
            }
            else
            {
                [self sendAddress];
            }
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
}
- (IBAction)segDefaultAddressTap:(id)sender
{
    UISwitch *switchDefault = (UISwitch*)sender;
    
    if (self.address.isDefaultAddress)
    {
        [switchDefault setOn:YES];
        [self showAlertWithMessage:ACCChooseAnotherAddress];
    }
}

#pragma mark - Selectionvalue Delegate Method
-(void)SelectionValue:(NSDictionary *)selectedDict isCity:(bool)ans
{
    if(ans)
    {
        txtCity.text = selectedDict[GKeyName];
        cityId = [selectedDict[GKeyId] stringValue];
        txtZipCode.text = @"";
    }
    else
    {
        txtState.text = selectedDict[GKeyName];
        stateId = [selectedDict[GKeyId] stringValue];
        txtCity.text = @"";
        cityId = @"";
    }
}

#pragma mark -ZWTTextboxToolbarHandlerDelegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtCity)
    {
//        [self.view endEditing:YES];
//        
//        [txtCity resignFirstResponder];
//        [txtAddress resignFirstResponder];
//        [txtZipCode resignFirstResponder];
        if(![stateId isEqualToString:@""] && stateId!= NULL)
        {
            [self openStateCityViewControllerIsCity:YES];
        }
        else
        {
            [self showAlertWithMessage:ACCBlankState];
        }
    }
    else if (textField == txtState)
    {
//        [self.view endEditing:YES];
//        [txtState resignFirstResponder];
//        [txtAddress resignFirstResponder];
//        [txtZipCode resignFirstResponder];
        [self openStateCityViewControllerIsCity:NO];
    }
    
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
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
