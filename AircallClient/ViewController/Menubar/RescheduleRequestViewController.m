//
//  RescheduleRequestViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "RescheduleRequestViewController.h"

@interface RescheduleRequestViewController ()<ChooseDateViewControllerDelegate,UITextViewDelegate,ZWTTextboxToolbarHandlerDelegate>

@property (strong, nonatomic) IBOutlet ACCTextField *txtDate;
@property (strong, nonatomic) IBOutlet ACCTextView *txtvReason;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvReschedule;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property (strong, nonatomic) IBOutlet UIButton *btnFirstTimeSlot;
@property (strong, nonatomic) IBOutlet UIButton *btnSecondTimeSlot;
@property NSString *time;
@property NSInteger unitsSlot2;
@property NSInteger dayGapMaintenanceService;
@property NSInteger dayGapOtherServices;
@property NSString *emergencyTime1;
@property NSString *emergencyTime2;
@property NSString *time1;
@property NSString *time2;
@property BOOL isAllowWeekends;

@end

@implementation RescheduleRequestViewController
@synthesize txtDate,txtvReason,scrlvReschedule,textboxHandler,btnFirstTimeSlot,btnSecondTimeSlot,time,serviceId,isFromRequestList,selectedTimeSlot,selectedDate,noOfUnits,unitsSlot2,purposeOfVisit,dayGapMaintenanceService,dayGapOtherServices,emergencyTime1,emergencyTime2,time1,time2,isAllowWeekends;

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
    scrlvReschedule.contentSize = CGSizeMake(scrlvReschedule.width, txtvReason.y + txtvReason.height);
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[txtvReason]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:scrlvReschedule];
    textboxHandler.delegate = self;
    
    btnFirstTimeSlot.selected  = YES;
    btnSecondTimeSlot.selected = NO;
    
    [self btnTimeSlotTap:btnFirstTimeSlot];
    
    if (selectedDate)
    {
        txtDate.text = selectedDate;
    }
//    else
//    {
//        if ([purposeOfVisit isEqualToString:@"1"])
//        {
//            txtDate.text = [ACCUtil getCurrentDate];
//        }
//        else
//        {
//            txtDate.text = [ACCUtil getDefaultDateWithoutWeekends:[self getDayGap:purposeOfVisit] withAllowWeekends:NO];
//        }
//    }
    
    if ([purposeOfVisit isEqualToString:@"1"])
    {
        isAllowWeekends = YES;
    }
    else
    {
        isAllowWeekends = NO;
    }
    
    [self getTimeSlot];
}

-(BOOL)isValidateRescheduleInfo
{
    NSString *rawString = [txtvReason text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([txtDate.text isEqualToString:@""])
    {
        txtDate.layer.borderColor = [UIColor redColor].CGColor;
        txtDate.layer.borderWidth = 1.0;
        [self showErrorMessage:ACCBlankDate belowView:txtDate];
        return NO;
    }
    else if ([trimmed length] == 0)
    {
        txtvReason.layer.borderColor = [UIColor redColor].CGColor;
        txtvReason.layer.borderWidth = 1.0;
        [self showErrorMessage:ACCBlankReason belowView:txtvReason];
        return NO;
    }
    else if(![purposeOfVisit isEqualToString:@"1"] && [ACCUtil isWeekEnds:txtDate.text])
    {
        [self showAlertWithMessage:ACCNotAllowWeekends];
        return NO;
    }
    
    return YES;
}

-(NSInteger)getDayGap:(NSString *)purposeID
{
    if ([purposeID isEqualToString:@"1"] || [purposeID isEqualToString:@"2"] || [purposeID isEqualToString:@"0"])
    {
        return dayGapOtherServices;
    }
    else
    {
        return dayGapMaintenanceService;
    }
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    if (isFromRequestList)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
       // [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)btnSelectDateTap:(id)sender
{
    [self removeErrorMessageBelowView:txtDate];
    txtDate.layer.borderColor = [UIColor borderColor].CGColor;
    ChooseDateViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseDateViewController"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    viewController.delegate = self;
    viewController.selectedDate = txtDate.text;
    viewController.dayGap = [self getDayGap:purposeOfVisit];
    viewController.isAllowWeekEnds = isAllowWeekends;
    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}
- (IBAction)btnSubmitTap:(id)sender
{
    if ([self isValidateRescheduleInfo])
    {
         [self sendRescheduleRequest];
    }
}

- (IBAction)btnTimeSlotTap:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button.tag == 1)
    {
        if (noOfUnits > unitsSlot2)
        {
            //[btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self showAlertWithMessage:ACCUnitsLimit];
            [self btnTimeSlotTap:btnFirstTimeSlot];
            time = btnFirstTimeSlot.titleLabel.text;
        }
        else
        {
            btnFirstTimeSlot.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
            btnSecondTimeSlot.backgroundColor = [UIColor appGreenColor];
            btnSecondTimeSlot.selected = YES;
            btnFirstTimeSlot.selected  = NO;
            time = btnSecondTimeSlot.titleLabel.text;
        }
        
        if (btnSecondTimeSlot.selected == YES)
        {
            btnSecondTimeSlot.userInteractionEnabled = NO;
            btnFirstTimeSlot.userInteractionEnabled  = YES;
            time = btnSecondTimeSlot.titleLabel.text;
        }
    }
    else
    {
        btnSecondTimeSlot.selected = NO;
        btnFirstTimeSlot.selected  = YES;
        
        if (btnFirstTimeSlot.selected == YES)
        {
            btnFirstTimeSlot.userInteractionEnabled  = NO;
            btnSecondTimeSlot.userInteractionEnabled = YES;
        }
        
        btnFirstTimeSlot.backgroundColor = [UIColor appGreenColor];
        btnSecondTimeSlot.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        time = btnFirstTimeSlot.titleLabel.text;
    }
}

#pragma mark - ChooseDateViewController Delegate Method

-(void)setDate:(NSString *)date
{
    txtDate.text = date;
}

#pragma mark - WebAPIs Methods

-(void)getTimeSlot
{
    NSDictionary *serviceInfo;
    
    if (isFromRequestList)
    {
        serviceInfo = @{
                         SKeyRequestID : serviceId
                       };
    }
    else
    {
        serviceInfo = @{
                         SKeyID : serviceId
                       };
    }
    
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getPurposeAndTime:serviceInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *purposeInfo)
     {
         [SVProgressHUD dismiss];
         
         if (response.code == RCodeSuccess)
         {
             unitsSlot2 = [purposeInfo[SKeyUnitsSlot2] integerValue];
             
             emergencyTime1 = purposeInfo[SKeyEmergencyTimeSlot1];
             emergencyTime2 = purposeInfo[SKeyEmergencyTimeSlot2];
             
             time1 = purposeInfo[SKeyTimeSlot1];
             time2 = purposeInfo[SKeyTimeSlot2];
             
             if ([purposeOfVisit isEqualToString:@"1"] && [ACCUtil isWeekEnds:txtDate.text])
             {
                 [btnFirstTimeSlot setTitle:emergencyTime1 forState:UIControlStateNormal];
                 [btnSecondTimeSlot setTitle:emergencyTime2 forState:UIControlStateNormal];
             }
             else
             {
                 [btnFirstTimeSlot setTitle:time1 forState:UIControlStateNormal];
                 [btnSecondTimeSlot setTitle:time2 forState:UIControlStateNormal];
             }
             
             dayGapMaintenanceService = [purposeInfo[SKeyMaintenanceServicesWithinnDays] integerValue];
             dayGapOtherServices      = [purposeInfo[SKeyEmergencyAndOtherServiceWithinDays] integerValue];
             
             if (noOfUnits > unitsSlot2)
             {
                 [btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                  time = purposeInfo[SKeyTimeSlot1];
             }
             
             if ([selectedTimeSlot isEqualToString:purposeInfo[SKeyTimeSlot1]])
             {
                 time = selectedTimeSlot;
                 [self btnTimeSlotTap:btnFirstTimeSlot];
             }
             else if([selectedTimeSlot isEqualToString:purposeInfo[SKeyTimeSlot2]])
             {
                 if (noOfUnits <= unitsSlot2)
                 {
                     time = selectedTimeSlot;
                     [self btnTimeSlotTap:btnSecondTimeSlot];
                 }
             }
             else
             {
                 time = purposeInfo[SKeyTimeSlot1];
                 [self btnTimeSlotTap:btnFirstTimeSlot];
             }
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
-(void)sendRescheduleRequest
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dictReschedule = @{
                                         UKeyClientID : ACCGlobalObject.user.ID,
                                         SKeyID : serviceId,
                                         SKeyRescheduleReason : txtvReason.text,
                                         SKeyRequestedTime : time,
                                         SKeyRequestedDate : txtDate.text
                                         };
        if (isFromRequestList)
        {
            [ACCWebServiceAPI sendRescheduleRequest:dictReschedule isFromRequestList:YES completionHandler:^(ACCAPIResponse *response)
             {
                 [SVProgressHUD dismiss];
                 
                 if (response.code == RCodeSuccess)
                 {
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
        else
        {
            [ACCWebServiceAPI sendRescheduleRequest:dictReschedule isFromRequestList:NO completionHandler:^(ACCAPIResponse *response)
             {
                 [SVProgressHUD dismiss];
                 
                 if (response.code == RCodeSuccess)
                 {
                     [self.navigationController popToRootViewControllerAnimated:YES];
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
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - UITextView Delegate Method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    txtvReason.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:txtvReason];
    return YES;
}
-(void)doneTap
{
    
}
@end
