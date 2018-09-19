//
//  UpdateUserNameViewController.m
//  AircallClient
//
//  Created by ZWT112 on 6/20/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "UpdateUserNameViewController.h"

@interface UpdateUserNameViewController ()<ZWTTextboxToolbarHandlerDelegate>


@property (strong, nonatomic) IBOutlet UIView *vwUsername;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvUsername;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;
@end

@implementation UpdateUserNameViewController
@synthesize delegate,txtFirstName,txtLastName,textboxHandler,arrTextBoxes,scrlvUsername,vwUsername,strFirstName,strLastName,txtCompany,strCompanyName;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}
-(void)viewDidAppear:(BOOL)animated
{
    vwUsername.transform = CGAffineTransformMakeScale(0.0, 0.0);
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwUsername.transform = CGAffineTransformIdentity;
                         vwUsername.hidden = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    vwUsername.hidden = YES;
    txtFirstName.text = strFirstName;
    txtLastName.text  = strLastName;
    txtCompany.text   = strCompanyName;
    arrTextBoxes      = [[NSMutableArray alloc]initWithArray:@[txtFirstName,txtLastName,txtCompany]];
    textboxHandler    = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvUsername];
    
    textboxHandler.delegate = self;
}
-(BOOL)isValidDetail
{
    ZWTValidationResult result;
    
    result = [txtFirstName validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
    
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
    
    result = [txtLastName validate:ZWTValidationTypeName showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:ACCBlankLastName belowView:txtLastName];
        
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:ACCInvalidLastName belowView:txtLastName];
        
        return NO;
    }
    return YES;
}

#pragma mark - Event Methods
- (IBAction)btnDoneTap:(id)sender
{
    if ([self isValidDetail])
    {
        [self zoomOutanimation];
        [delegate userName:txtFirstName.text lastName:txtLastName.text companyName:txtCompany.text];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - ZWTTextboxToolbarHandlerDelegate Method
-(void)doneTap
{
    
}
@end
