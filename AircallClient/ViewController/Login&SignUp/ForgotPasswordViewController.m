//
//  ForgotPasswordViewController.m
//  AircallClient
//
//  Created by ZWT112 on 3/28/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIView *vwForgotPassword;

@end

@implementation ForgotPasswordViewController
@synthesize txtEmail,vwForgotPassword;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [txtEmail becomeFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated
{
    vwForgotPassword.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwForgotPassword.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Webservice Methods
-(void)sendEmailAddress
{
    NSDictionary *emailAddress = @{UKeyEmail : [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]};
    
    [SVProgressHUD show];
    
    [ACCWebServiceAPI forgotPassword:emailAddress completionHandler:^(ACCAPIResponse *response)
     {
         if (response.code == RCodeSuccess)
         {
             [txtEmail resignFirstResponder];
             
             [self showAlertFromWithMessageWithSingleAction:response.message andHandler:^(UIAlertAction * _Nullable action)
              {
                  [self dismissViewControllerAnimated:YES completion:nil];
              }];
         }
         else
         {
             [self showAlertWithMessage:response.message];
         }
         [SVProgressHUD dismiss];
     }];
}

#pragma mark - Event Methods
- (IBAction)btnSubmitTap:(id)sender
{
    if ([self validateEmail])
    {
        if([ACCUtil reachable])
        {
            [self sendEmailAddress];
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
}
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [txtEmail resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Helper Method
-(BOOL)validateEmail
{
    ZWTValidationResult result;
    
//    NSString *email = [txtEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
//    txtEmail.text   = email;
    
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
    
    return YES;
}

@end
