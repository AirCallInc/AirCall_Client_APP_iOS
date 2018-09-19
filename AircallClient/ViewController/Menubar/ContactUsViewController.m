//
//  ContactUsViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/11/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController () <ZWTTextboxToolbarHandlerDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet ACCTextField *txtName;
@property (strong, nonatomic) IBOutlet ACCTextField *txtEmail;
@property (strong, nonatomic) IBOutlet ACCTextField *txtPhone;
@property (strong, nonatomic) IBOutlet ACCTextView *txtvMessage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvContactUs;
@property NSMutableArray *arrTextBoxes;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property CGSize scrollSize;
@end

@implementation ContactUsViewController

@synthesize txtName,txtEmail,txtPhone,txtvMessage,arrTextBoxes,textboxHandler,scrlvContactUs,scrollSize;

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

-(void)viewDidAppear:(BOOL)animated
{
    
}

#pragma mark - Helper Methods
-(void)prepareView
{
    scrollSize = scrlvContactUs.contentSize;
    scrlvContactUs.contentSize = CGSizeMake(scrlvContactUs.width, txtvMessage.y + txtvMessage.height);
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtName,txtEmail,txtPhone,txtvMessage]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:arrTextBoxes andScroll:scrlvContactUs];
    textboxHandler.delegate = self;
    [self setUserDetails];
}
-(void)setUserDetails
{
    txtName.text = [NSString stringWithFormat:@"%@ %@",ACCGlobalObject.user.firstName,ACCGlobalObject.user.lastName];
    txtEmail.text = ACCGlobalObject.user.email;
    txtPhone.text = ACCGlobalObject.user.mobileNumber;
}
-(BOOL)isDetailValid
{
    NSString *rawString = [txtvMessage text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    ZWTValidationResult result;
    
    result = [txtName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankNameOnCard belowView:txtName];
        
        return NO;
    }
    
    result = [txtPhone validate:ZWTValidationTypeBlank showRedRect:YES];
    
    if([txtPhone.text length] > 0 && [txtPhone.text length] < ACCPhoneNumberMinimumLengh )
    {
        [self showErrorMessage:ACCInvalidPhoneNumber belowView:txtPhone];
        txtPhone.layer.borderColor = [UIColor redColor].CGColor;
        return NO;
    }
    else if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankPhoneNumber belowView:txtPhone];
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
    else if ([trimmed length] == 0)
    {
        txtvMessage.layer.borderColor = [UIColor redColor].CGColor;
        txtvMessage.layer.borderWidth = 1.0;
        [self showErrorMessage:ACCBlankMessage belowView:txtvMessage];
        return NO;
    }
    return YES;
}

#pragma mark - Event Methods
- (IBAction)btnMenuTap:(id)sender
{
    [self.view endEditing:YES];
    scrlvContactUs.contentSize = scrollSize;
    [self openSideBar];
}
- (IBAction)btnSubmitTap:(id)sender
{
    if ([self isDetailValid])
    {
        [self sendContactUsInfo];
    }
}

#pragma mark - ZWTTextboxToolbarHandlerDelegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    return YES;
}
-(void)doneTap
{
    
}

#pragma mark - UITextViewDelegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self removeErrorMessageBelowView:txtvMessage];
    textView.layer.borderColor = [UIColor borderColor].CGColor;
    return YES;
}

#pragma mark - Webservice Methods
-(void)sendContactUsInfo
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyEmail:[txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],
                               UKeyName  :txtName.text,
                               GKeyPhoneNumber :txtPhone.text,
                               UKeyMessage :txtvMessage.text
                               };
        
        [ACCWebServiceAPI sendContactUsInfo:dict completion:^(ACCAPIResponse *response)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                [self showAlertFromWithMessageWithSingleAction:@"Your message sent successfully" andHandler:^(UIAlertAction * _Nullable action)
                {
                    [self setUserDetails];
                    txtvMessage.text = @"";
                }];
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
@end
