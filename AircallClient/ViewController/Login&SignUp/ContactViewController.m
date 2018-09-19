//
//  ContactViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()<ZWTTextboxToolbarHandlerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (strong, nonatomic) IBOutlet UITextField *txtOfficeNo;
@property (strong, nonatomic) IBOutlet UITextField *txtHomeNo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray * arrTextBoxes;

@end

@implementation ContactViewController
@synthesize txtMobileNo,txtOfficeNo,txtHomeNo,textboxHandler,arrTextBoxes,scrlv,accContactInfo,delegate;

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
    scrlv.contentSize = CGSizeMake(scrlv.width, txtHomeNo.y - 80);
    
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtMobileNo,txtOfficeNo,txtHomeNo]];

    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlv];
    textboxHandler.delegate = self;
    
    txtMobileNo.text = accContactInfo.mobileNumber;
    txtOfficeNo.text = accContactInfo.officeNumber;
    txtHomeNo.text   = accContactInfo.homeNumber;
}

-(BOOL)isContactInfoValidate
{
    ZWTValidationResult result;
    
    result = [txtMobileNo validate:ZWTValidationTypeNumber showRedRect:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankPhoneNumber belowView:txtMobileNo];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACCInvalidNumber belowView:txtMobileNo];
        return NO;
    }
    else if ([txtMobileNo.text length] < ACCMobileNumberMinimumLengh)
    {
        [self showErrorMessage:ACCInvalidMobileNumber belowView:txtMobileNo];
        txtMobileNo.layer.borderColor = [UIColor borderColor].CGColor;
        return NO;
    }
    
    result = [txtHomeNo validate:ZWTValidationTypeNumber showRedRect:YES];
    
    if([txtHomeNo.text length] > 0 && [txtHomeNo.text length] < ACCPhoneNumberMinimumLengh )
    {
        [self showErrorMessage:ACCInvalidPhoneNumber belowView:txtHomeNo];
        txtHomeNo.layer.borderColor = [UIColor redColor].CGColor;
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACCInvalidNumber belowView:txtHomeNo];
        return NO;
    }
    
    if([txtOfficeNo.text length] > 0 && [txtOfficeNo.text length] < ACCPhoneNumberMinimumLengh)
    {
        [self showErrorMessage:ACCInvalidPhoneNumber belowView:txtOfficeNo];
        txtOfficeNo.layer.borderColor = [UIColor borderColor].CGColor;
        return NO;
    }
    
    
    return YES;
}
-(void)saveInUserDefault
{
    ACCGlobalObject.user.mobileNumber = txtMobileNo.text;
    
    NSDictionary *dictUser = @{
                               UKeyID           : ACCGlobalObject.user.ID,
                               UKeyFirstName    : ACCGlobalObject.user.firstName,
                               UKeyLastName     : ACCGlobalObject.user.lastName,
                               UKeyEmail        : ACCGlobalObject.user.email,
                               UKeyPassword     : ACCGlobalObject.user.password,
                               UKeyMobileNumber : ACCGlobalObject.user.mobileNumber
                               };
    
    [ACCGlobalObject.user saveInUserDefaults:dictUser];
}
#pragma mark - WebService Methods
-(void)sendContactInfo :(NSDictionary*)contactInfo
{
//    NSDictionary * conatctInfo = @{
//                                    UKeyID           : ACCGlobalObject.user.ID,
//                                    UKeyMobileNumber : txtMobileNo.text,
//                                    UKeyHomeNumber   : txtHomeNo.text,
//                                    UKeyOfficeNumber : txtOfficeNo.text
//                                   };
    
    [SVProgressHUD show];
    
    [ACCWebServiceAPI updateContactInfo:contactInfo completionHandler:^(ACCAPIResponse *response)
    {
        [SVProgressHUD dismiss];
        
        if (response.code == RCodeSuccess)
        {
            ACCGlobalObject.user.mobileNumber = txtMobileNo.text;
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

#pragma mark - Event methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveTap:(id)sender
{
    if ([self isContactInfoValidate])
    {
        if ([ACCUtil reachable])
        {
            NSDictionary * conatctInfo = @{
                                           UKeyID           : ACCGlobalObject.user.ID,
                                           UKeyMobileNumber : txtMobileNo.text,
                                           UKeyHomeNumber   : txtHomeNo.text,
                                           UKeyOfficeNumber : txtOfficeNo.text
                                           };
            
            [self sendContactInfo:conatctInfo];
            [delegate contactNumbers:conatctInfo];
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
}

#pragma mark - ZWTTextboxToolbarHandlerDelegate Method
-(void)doneTap
{
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    
    if(textField == txtHomeNo || textField == txtOfficeNo || textField == txtMobileNo)
    {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSInteger length = [currentString length];
        
        if (length > 15)
        {
            return NO;
        }
    }
    
    return YES;
}
@end
