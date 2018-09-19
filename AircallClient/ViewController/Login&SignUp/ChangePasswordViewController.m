//
//  ChangePasswordViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/19/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<ZWTTextboxToolbarHandlerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtOldPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtRetypePwd;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvChangePwd;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;
@property (strong,nonatomic) NSMutableArray *arrTextBoxes;

@end

@implementation ChangePasswordViewController
@synthesize txtOldPwd,txtNewPwd,txtRetypePwd,scrlvChangePwd,arrTextBoxes,textboxHandler;

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
    scrlvChangePwd.contentSize = CGSizeMake(scrlvChangePwd.width,txtRetypePwd.y - 80);
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtOldPwd,txtNewPwd,txtRetypePwd]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvChangePwd];
    textboxHandler.delegate = self;
}

-(BOOL)isPasswordDetailValid
{
    ZWTValidationResult result;
    
    result = [txtOldPwd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankOldPassword belowView:txtOldPwd];
        
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCValidPassword belowView:txtOldPwd];
        
        return NO;
    }
    else if ([txtOldPwd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:ACCPasswordSpace belowView:txtOldPwd];
        
        return NO;
    }
    
    result = [txtNewPwd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankNewPassword belowView:txtNewPwd];
        
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCValidPassword belowView:txtNewPwd];
        
        return NO;
    }
    else if ([txtNewPwd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:ACCPasswordSpace belowView:txtNewPwd];
        
        return NO;
    }
    
    result = [txtRetypePwd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCReBlankPassword belowView:txtRetypePwd];
        
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCValidPassword belowView:txtRetypePwd];
        
        return NO;
    }
    else if ([txtRetypePwd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:ACCPasswordSpace belowView:txtRetypePwd];
        
        return NO;
    }
    
    return YES;
}
-(void)saveInUserDefault
{    
    ACCGlobalObject.user.password = txtNewPwd.text;
    
    NSDictionary *dictUser = @{
                               UKeyID           : ACCGlobalObject.user.ID,
                               UKeyFirstName    : ACCGlobalObject.user.firstName,
                               UKeyLastName     : ACCGlobalObject.user.lastName,
                               UKeyEmail        : ACCGlobalObject.user.email,
                               UKeyPassword     : txtNewPwd.text,
                               UKeyMobileNumber : ACCGlobalObject.user.mobileNumber
                               };
    
    [ACCGlobalObject.user saveInUserDefaults:dictUser];
}
#pragma mark - Webservice Methods
-(void)sendPassword
{
    if (![txtNewPwd.text isEqualToString:txtRetypePwd.text])
    {
        txtRetypePwd.text = @"";
        [self showErrorMessage:ACCPasswordNoMatch belowView:txtRetypePwd];
    }
    else
    {
        NSDictionary *userDetail = @{
                                      UKeyID          :ACCGlobalObject.user.ID,
                                      UKeyOldPassword :[ACCUtil MD5HashForString:txtOldPwd.text],
                                      UKeyNewPassword :[ACCUtil MD5HashForString:txtNewPwd.text]
                                    };
        [SVProgressHUD show];
        
        [ACCWebServiceAPI changePassword:userDetail completionHandler:^(ACCAPIResponse *response)
        {
            if (response.code == RCodeSuccess)
            {
                [self.navigationController popViewControllerAnimated:YES];
                [self saveInUserDefault];
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
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnResetTap:(id)sender
{
    if ([self isPasswordDetailValid])
    {
        if ([ACCUtil reachable])
        {
            [self sendPassword];
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
}
- (IBAction)btnCancelTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ZWTTextboxToolbarHandlerDelegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    return YES;
}
-(void)doneTap
{
    
}

@end
