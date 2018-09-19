//
//  LoginViewController.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet ACCTextField  *txtEmail   ;
@property (weak, nonatomic) IBOutlet ACCTextField  *txtPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrvLogin  ;
@property (strong, nonatomic) IBOutlet UIView *vwBottom;
@property (strong, nonatomic) IBOutlet UIImageView *imgvCheckbox;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *textboxHandler;
@property (strong, nonatomic) IBOutlet UIButton *btnSavePass;

@end

@implementation LoginViewController
@synthesize txtEmail,txtPassword,scrvLogin,textboxHandler,vwBottom,imgvCheckbox,btnSavePass;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = [userDefaults valueForKey:UKeySaveCurrentEmailPass];
   
    if (userInfo != nil)
    {
        txtEmail.text    = userInfo[UKeyEmail];
        txtPassword.text = userInfo[UKeyPassword];
        
        if (userInfo[UKeySavePassword])
        {
            imgvCheckbox.image = [UIImage imageNamed:@"ckeckboxSelected"];
            btnSavePass.selected = YES;
        }
        else
        {
            imgvCheckbox.image = [UIImage imageNamed:@"checkbox"];
            btnSavePass.selected = NO;
        }
    }
    
    [self prepareView];
}

-(void)viewDidAppear:(BOOL)animated
{
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    CGRect frameEmail = txtEmail.frame;
    CGRect framePassword = txtPassword.frame;
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[txtEmail, txtPassword]];
    
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:scrvLogin];
    textboxHandler.delegate = self;
    
    txtEmail.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, txtEmail.y, txtEmail.width, txtEmail.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        txtEmail.frame = CGRectMake(frameEmail.origin.x, frameEmail.origin.y, frameEmail.size.width, frameEmail.size.height);
    }];
    
    txtPassword.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, txtPassword.y, txtPassword.width, txtPassword.height);
    [UIView animateWithDuration:0.4 delay:0.1 options:0 animations:^{
        txtPassword.frame = CGRectMake(framePassword.origin.x, framePassword.origin.y, framePassword.size.width, framePassword.size.height);
    } completion:nil];
    
    vwBottom.alpha = 0;
    vwBottom.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.4 animations:^{
        vwBottom.transform = CGAffineTransformIdentity;
        vwBottom.alpha = 1;
    }];
}

- (BOOL)isSigninDetailValid
{
    ZWTValidationResult result;
    
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
    else if (result != ZWTValidationResultValid)
    {
        [self showErrorMessage:ACCValidPassword belowView:txtPassword];
        
        return NO;
    }
    else if ([txtPassword.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:ACCPasswordSpace belowView:txtPassword];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - Webservice Methods
- (void)signIn
{
    NSDictionary *userDetail = @{
                                 UKeyEmail       : [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                 UKeyPassword    : [ACCUtil MD5HashForString:txtPassword.text],
                                 UKeyDeviceType  : ACCDeviceType,
                                 UKeyDeviceToken : ACCGlobalObject.deviceToken != nil ? ACCGlobalObject.deviceToken : @""
                                 };
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [SVProgressHUD show];
    
    [ACCWebServiceAPI signinWithUserDetail:userDetail completionHandler:^(ACCAPIResponse *response, ACCUser *user)
    {
        if(response.code == RCodeSuccess)
        {
            if (btnSavePass.selected)
            {
                NSDictionary *dict = @{
                                       UKeyEmail        : [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                                       UKeyPassword     : txtPassword.text,
                                       UKeySavePassword : @YES
                                       };
                
                [self savePasswordInUserDefault:dict];
            }
            else
            {
                NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
                NSDictionary * dict = [defs dictionaryRepresentation];
                for (NSString *key in dict)
                {
                    if([key isEqualToString:UKeySaveCurrentEmailPass])
                        [defs removeObjectForKey:key];
                }
                [defs synchronize];
            }

            user.password = txtPassword.text;
            [user login];
            [ACCUtil prepareDashboard];
        }
        else if (response.code == RCodeNoData)
        {
            txtPassword.text = @"";
            [self showAlertWithMessage:response.message];
        }
        else
        {
            txtEmail.text = @"";
            txtPassword.text = @"";
            [self showAlertWithMessage:response.message];
        }
        
        [SVProgressHUD dismiss];
     }];
}

//-(void)openDashBoard
//{
//   
//    UINavigationController *rootController;
//    
//    rootController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"rootNavigationController"];
//   
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    
//    appDelegate.window.rootViewController = rootController;
//    
//    ACCGlobalObject.rootNavigationController = rootController;
//    
//}

#pragma mark - Event Methods
- (IBAction)btnLoginTap:(id)sender
{
    if ([self isSigninDetailValid])
    {
       // [textboxHandler btnDoneTap];
        
        if ([ACCUtil reachable])
        {
            [self signIn];
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
}

- (IBAction)btnSignupTap:(id)sender
{
    SignupViewController *viewController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"SignupViewController"];
    
    [ACCGlobalObject.rootViewController pushViewController:viewController animated:YES];
}
- (IBAction)btnForgotPasswordTap:(id)sender
{
    ForgotPasswordViewController *viewController  = [self.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:viewController animated:NO completion:nil];
}
- (IBAction)btnSavePasswordTap:(id)sender
{
    if (!btnSavePass.selected)
    {
        btnSavePass.selected = YES;
        imgvCheckbox.image = [UIImage imageNamed:@"ckeckboxSelected"];
    }
    else
    {
        imgvCheckbox.image = [UIImage imageNamed:@"checkbox"];
        btnSavePass.selected = NO;
    }
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
    
}
@end
