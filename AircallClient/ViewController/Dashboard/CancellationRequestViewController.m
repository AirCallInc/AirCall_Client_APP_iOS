//
//  CancellationRequestViewController.m
//  AircallClient
//
//  Created by ZWT112 on 6/1/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "CancellationRequestViewController.h"

@interface CancellationRequestViewController ()<ChooseDateViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvCancellation;
@property (strong, nonatomic) IBOutlet UITextView *txtvReason;
@property (strong, nonatomic) IBOutlet UITextField *txtDate;
@property ZWTTextboxToolbarHandler *textboxHandler;

@property (strong, nonatomic) IBOutlet UIButton *btnFirstTimeSlot;
@property (strong, nonatomic) IBOutlet UIButton *btnSecondTimeSlot;
@property NSString *time;
@property NSInteger unitsSlot2;
@property NSInteger dayGapMaintenanceService;
@property NSInteger dayGapOtherServices;

@end

@implementation CancellationRequestViewController
@synthesize scrlvCancellation,txtvReason,txtDate,textboxHandler,btnFirstTimeSlot,btnSecondTimeSlot,time,serviceId,notificationId,selectedTime,selectedDate,unitsSlot2,noOfUnits,dayGapMaintenanceService,dayGapOtherServices,purposeOfVisit;

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
-(NSInteger)getDayGap:(NSString *)purpose
{
    if ([purpose isEqualToString:@"Emergency"] || [purpose isEqualToString:@"Continuing Previous Work"] || [purpose isEqualToString:@"Repairing"])
    {
        return dayGapOtherServices;
    }
    else
    {
        return dayGapMaintenanceService;
    }
}

-(void)prepareView
{
    scrlvCancellation.contentSize = CGSizeMake(scrlvCancellation.width, txtvReason.y + txtvReason.height);
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[txtvReason]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:scrlvCancellation];
    
    [self btnTimeSlotTap:btnFirstTimeSlot];
    
    if (selectedDate)
    {
        txtDate.text = selectedDate;
    }
    else
    {
        txtDate.text = [ACCUtil getDefaultDateWithoutWeekends:1 withAllowWeekends:NO];
    }
    
    [self getTimeSlot];
}

-(BOOL)isValidateCancelInfo
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
    
    return YES;
}


#pragma mark - WebService Methods
-(void)getTimeSlot
{
    NSDictionary *serviceInfo = @{
                                    SKeyID : serviceId
                                 };
    
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getPurposeAndTime:serviceInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *purposeInfo)
     {
         [SVProgressHUD dismiss];
         
         if (response.code == RCodeSuccess)
         {
             unitsSlot2 = [purposeInfo[SKeyUnitsSlot2] integerValue];
             
             [btnFirstTimeSlot setTitle:purposeInfo[SKeyTimeSlot1] forState:UIControlStateNormal];
             [btnSecondTimeSlot setTitle:purposeInfo[SKeyTimeSlot2] forState:UIControlStateNormal];
             
             dayGapMaintenanceService = [purposeInfo[SKeyMaintenanceServicesWithinnDays] integerValue];
             dayGapOtherServices      = [purposeInfo[SKeyEmergencyAndOtherServiceWithinDays] integerValue];
             
             if (noOfUnits > unitsSlot2)
             {
                 [btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                 time = purposeInfo[SKeyTimeSlot1];
             }
             
             if ([selectedTime isEqualToString:purposeInfo[SKeyTimeSlot1]])
             {
                 time = selectedTime;
                 [self btnTimeSlotTap:btnFirstTimeSlot];
             }
             else if([selectedTime isEqualToString:purposeInfo[SKeyTimeSlot2]])
             {
                 if (noOfUnits <= unitsSlot2)
                 {
                     time = selectedTime;
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

-(void)sendCancelRequest
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dictReschedule = @{
                                         UKeyClientID : ACCGlobalObject.user.ID,
                                         SKeyID : serviceId,
                                         SKeyRescheduleReason : txtvReason.text,
                                         SKeyRequestedTime : time,
                                         SKeyRequestedDate : txtDate.text,
                                         SKeyIsCancelled   : @"true",
                                         NKeyNotificationId : notificationId != nil ? notificationId : @""
                                         };
        
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
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - Event Methods
- (IBAction)btnTimeSlotTap:(UIButton *)button
{
//    if (button == btnFirstTimeSlot)
//    {
//        btnSecondTimeSlot.selected = NO;
//        btnFirstTimeSlot.selected  = YES;
//    
//        if (btnSecondTimeSlot.selected == YES)
//        {
//            btnSecondTimeSlot.userInteractionEnabled = NO;
//            btnFirstTimeSlot.userInteractionEnabled  = YES;
//        }
//        
//        time = btnSecondTimeSlot.titleLabel.text;
//    }
//    else
//    {
//        if (noOfUnits > unitsSlot2)
//        {
//            //            [btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            [self showAlertWithMessage:ACCUnitsLimit];
//            [self btnTimeSlotTap:btnFirstTimeSlot];
//        }
//        else
//        {
//            btnFirstTimeSlot.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
//            //btnSecondTimeSlot.backgroundColor = [UIColor appGreenColor];
//            btnSecondTimeSlot.selected = YES;
//            btnFirstTimeSlot.selected  = NO;
//        }
//        
//        if (btnFirstTimeSlot.selected == YES)
//        {
//            btnFirstTimeSlot.userInteractionEnabled  = NO;
//            btnSecondTimeSlot.userInteractionEnabled = YES;
//        }
//        
//        time = btnFirstTimeSlot.titleLabel.text;
//    }
    
    if (button.tag == 1)
    {
        if (noOfUnits > unitsSlot2)
        {
            //            [btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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

- (IBAction)btnSelectDateTap:(id)sender
{
    ChooseDateViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ChooseDateViewController"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    viewController.delegate = self;
    viewController.dayGap = [self getDayGap:purposeOfVisit];
    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}

- (IBAction)btnSubmitTap:(id)sender
{
    if ([self isValidateCancelInfo])
    {
        [self sendCancelRequest];
    }
}
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ChooseDateViewController Delegate Method
-(void)setDate:(NSString *)date
{
    txtDate.text = date;
}

@end
