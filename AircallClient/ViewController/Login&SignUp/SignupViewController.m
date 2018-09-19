//
//  SignupViewController.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()<ZWTTextboxToolbarHandlerDelegate>
@property (strong, nonatomic) IBOutlet ACCTextField *txtFirstName;
@property (strong, nonatomic) IBOutlet ACCTextField *txtLastName;
@property (strong, nonatomic) IBOutlet ACCTextField *txtPhone;
@property (weak, nonatomic) IBOutlet ACCTextField  *txtEmail      ;
@property (weak, nonatomic) IBOutlet ACCTextField  *txtPassword   ;
@property (weak, nonatomic) IBOutlet ACCTextField  *txtRePassword ;
@property (weak, nonatomic) IBOutlet ACCTextField  *txtPartnerCode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrvSignup    ;
@property (strong, nonatomic) IBOutlet UIButton *btnHVACMore;
@property (weak, nonatomic) IBOutlet UIImageView *imgHVACMore;
@property (weak, nonatomic) IBOutlet UILabel *lblHVACMore;

@property (strong, nonatomic) IBOutlet UIButton *btnHVACLess;
@property (weak, nonatomic) IBOutlet UILabel *lblHVACLess;

@property (weak, nonatomic) IBOutlet UIImageView *imgHVACLess;
@property (strong, nonatomic) IBOutlet ACCTextField *txtCompanyName;

@property (strong, nonatomic) IBOutlet UIButton *btnHVACDontKnow;
@property (weak, nonatomic) IBOutlet UILabel *lblHVACDontKnow;
@property (weak, nonatomic) IBOutlet UIImageView *imgHVACDontKnow;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;


@property NSString *statusHVAC;

@property ZWTTextboxToolbarHandler *textboxHandler;
@end

@implementation SignupViewController
@synthesize txtEmail,txtPassword,txtRePassword,txtPartnerCode,scrvSignup,textboxHandler,txtFirstName,txtLastName,txtPhone,btnHVACMore,btnHVACLess,btnHVACDontKnow,imgHVACMore,imgHVACLess,imgHVACDontKnow,lblHVACMore,lblHVACLess,lblHVACDontKnow,statusHVAC,btnAgree,txtCompanyName;

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self btnHVACUnitTap:btnHVACDontKnow];
    
    lblHVACMore.text = @"My HVAC Unit is more than 10 years old";
    lblHVACLess.text = @"My HVAC Unit is less than 10 years old";
    lblHVACDontKnow.text = @"I don't know how old my HVAC Unit is";
    
    scrvSignup.contentSize = CGSizeMake(scrvSignup.width, btnAgree.y + btnAgree.height + 10);
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[txtFirstName,txtLastName,txtCompanyName,txtPhone,txtEmail, txtPassword, txtRePassword, txtPartnerCode]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:scrvSignup];
    textboxHandler.delegate = self;
}

- (BOOL)isSignupDetailValid
{
    ZWTValidationResult result;
    
    result = [txtFirstName validate:ZWTValidationTypeName showRedRect:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankFirstName belowView:txtFirstName];
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCInvalidFirstName belowView:txtFirstName];
        return NO;
    }
    
    result = [txtLastName validate:ZWTValidationTypeName showRedRect:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankLastName belowView:txtLastName];
        return NO;
    }
    else if ( result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCInvalidLastName belowView:txtLastName];
        return NO;
    }
    
    result = [txtPhone validate:ZWTValidationTypeBlank showRedRect:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankPhoneNumber belowView:txtPhone];
        return NO;
    }
    else if([txtPhone.text length] < ACCMobileNumberMinimumLengh)
    {
        [self showErrorMessage:ACCInvalidMobileNumber belowView:txtPhone];
        return NO;
    }
    
    result = [txtEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        
        [self showErrorMessage:ACCBlankEmail belowView:txtEmail];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACCInvalidEmail belowView:txtEmail];
        
        return NO;
    }
    
    result = [txtPassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankPassword belowView:txtPassword];
        
        return NO;
    }
    else if ([txtRePassword.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:ACCPasswordSpace belowView:txtPassword];
        
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCValidPassword belowView:txtPassword];
        
        return NO;
    }
    
    result = [txtRePassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCReBlankPassword belowView:txtRePassword];
        return NO;
    }
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCValidPassword belowView:txtRePassword];
        
        return NO;
    }
    else if ([txtRePassword.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:ACCPasswordSpace belowView:txtRePassword];
        
        return NO;
    }
    
    if(btnAgree.selected == NO)
    {
        [self showAlertWithMessage:ACCAgreeToTerms];
        return NO;
    }
    
    return YES;
}

#pragma mark - Webservice Methods
-(void)signup
{
    if (![txtPassword.text isEqualToString:txtRePassword.text])
    {
        txtRePassword.text = @"";
        [self showErrorMessage:ACCPasswordNoMatch belowView:txtRePassword];
    }
    else
    {
       // NSString *status =  [statusHVAC stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        NSDictionary *userDetail = @{
                                     UKeyFirstName   : txtFirstName.text,
                                     UKeyLastName    : txtLastName.text,
                                     UKeyCompany     : txtCompanyName.text,
                                     UKeyEmail       : [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                     UKeyPassword    : [ACCUtil MD5HashForString:txtPassword.text],
                                     UKeyMobileNumber : txtPhone.text,
                                     UKeyPartnerCode : txtPartnerCode.text,
                                     UKeyDeviceType  : @"iPhone",
                                     //UKeySendDisclosureEmail: btnSendEmail.selected ? @"true" : @"false",
                                     UKeyDeviceToken : ACCGlobalObject.deviceToken != nil ? ACCGlobalObject.deviceToken : @""
                                     };
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        [ACCWebServiceAPI signupWithUserDetail:userDetail completionHandler:^(ACCAPIResponse *response, ACCUser *user)
         {
              [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 ACCGlobalObject.user = user;
                 //ACCGlobalObject.isOnce = YES;
                 user.password = txtPassword.text;
                 [user login];
                 [SVProgressHUD dismiss];
                 [ACCUtil prepareDashboard];
                 
//                 [FIRAnalytics logEventWithName:kFIREventSignUp
//                                     parameters:@{
//                                                  kFIRParameterItemID:[NSString stringWithFormat:@"id-%@", self.title],
//                                                  kFIRParameterItemName:self.title,
//                                                  kFIRParameterContentType:@"image"
//                                                  }];
                 
                 [FIRAnalytics logEventWithName:kFIREventSignUp parameters:nil];
             }
             else
             {
                 [self showAlertWithMessage:response.message];  
             }
         }];
    }
}

#pragma mark - Event Methods
- (IBAction)btnSignupTap:(id)sender
{
    [FIRAnalytics logEventWithName:kFIREventSignUp parameters:nil];
    
    if ([self isSignupDetailValid])
    {
       // [textboxHandler btnDoneTap];
        
        if ([ACCUtil reachable])
        {
            NSDictionary *dict = @{
                                   UKeyEmail        : txtEmail.text,
                                   UKeyPassword     : txtPassword.text
                                   };
            [self savePasswordInUserDefault:dict];
            [self signup];
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
}
- (IBAction)btnLoginTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnHVACUnitTap:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        btnHVACMore.selected     = YES;
        btnHVACLess.selected     = NO ;
        btnHVACDontKnow.selected = NO ;
        
        imgHVACMore.image = [UIImage imageNamed:@"radiobuttonSelected"];
        imgHVACLess.image = [UIImage imageNamed:@"radiobutton"];
        imgHVACDontKnow.image = [UIImage imageNamed:@"radiobutton"];
        
        statusHVAC = lblHVACMore.text;
    }
    else if (sender.tag == 2)
    {
        btnHVACMore.selected     = NO ;
        btnHVACLess.selected     = YES;
        btnHVACDontKnow.selected = NO ;
        
        imgHVACMore.image = [UIImage imageNamed:@"radiobutton"];
        imgHVACLess.image = [UIImage imageNamed:@"radiobuttonSelected"];
        imgHVACDontKnow.image = [UIImage imageNamed:@"radiobutton"];
        
        statusHVAC = lblHVACLess.text;
    }
    else if (sender.tag == 3)
    {
        btnHVACMore.selected     = NO ;
        btnHVACLess.selected     = NO ;
        btnHVACDontKnow.selected = YES;
        
        imgHVACMore.image = [UIImage imageNamed:@"radiobutton"];
        imgHVACLess.image = [UIImage imageNamed:@"radiobutton"];
        imgHVACDontKnow.image = [UIImage imageNamed:@"radiobuttonSelected"];
        
        statusHVAC = lblHVACDontKnow.text;
    }
}
- (IBAction)btnTermsCheckBoxTap:(id)sender
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
    TermsAndConditionViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
    viewController.isfromPayment = YES;
    viewController.termsPageID = @"4";
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - ZWTTextboxHandler Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    
    if(textField == txtPhone)
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
-(void)doneTap
{
    
}
@end
