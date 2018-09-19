//
//  UpdateUnitNameViewController.m
//  AircallClient
//
//  Created by ZWT112 on 11/14/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "UpdateUnitNameViewController.h"

@interface UpdateUnitNameViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet ACCTextField *txtUnitName;
@property (strong, nonatomic) IBOutlet UIView *vwName;

@end

@implementation UpdateUnitNameViewController
@synthesize txtUnitName,vwName,unitId,unitName,delegate;

#pragma mark - ACCViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
    [txtUnitName becomeFirstResponder];
    if (![unitName isEqualToString:@""])
    {
        txtUnitName.text = unitName;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    vwName.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwName.transform = CGAffineTransformIdentity;
                         vwName.hidden = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Handler Method
- (IBAction)btnUpdateTap:(id)sender
{
    if ([self isValidName])
    {
        [self updateUnitName];
    }
}
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Webservice Method
-(void)updateUnitName
{
    NSDictionary *dict = @{
                           UKeyClientID : ACCGlobalObject.user.ID,
                           UKeyUnitId : unitId,
                           UKeyUnitName : txtUnitName.text
                           };
    
    if ([ACCUtil reachable])
    {
        [ACCWebServiceAPI updateUnitName:dict completionHandler:^(ACCAPIResponse *response)
         {
             if (response.code == RCodeSuccess)
             {
                 [self zoomOutanimation];
                 [delegate updateUnitName:txtUnitName.text];
                 [self dismissViewControllerAnimated:NO completion:nil];
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

#pragma mark - Helper Method
-(BOOL) isValidName
{
    ZWTValidationResult result;
    
    result = [txtUnitName validate:ZWTValidationTypeBlank showRedRect:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankUnitName belowView:txtUnitName];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:textField];
    return YES;
}
@end
