//
//  ServiceRequestViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ServiceRequestViewController.h"

@interface ServiceRequestViewController ()<ChooseDateViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZWTTextboxToolbarHandlerDelegate>


@property (weak, nonatomic) IBOutlet UIView *vwAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblvAddress;

@property (weak, nonatomic) IBOutlet UIView *vwUnit;
@property (weak, nonatomic) IBOutlet UITableView *tblvUnit;

@property (strong, nonatomic) IBOutlet UIView *vwRequestInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvRequest;
@property (weak, nonatomic) IBOutlet UIView *vwVisitPurpose;
@property (weak, nonatomic) IBOutlet UIView *vwPlanType;
@property (weak, nonatomic) IBOutlet UITableView *tblvPlanType;
@property (strong, nonatomic) IBOutlet UITableView *tblvVisitPurpose;
@property (strong, nonatomic) IBOutlet SAMTextView *txtvNotes;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property (strong, nonatomic) IBOutlet UIButton *btnFirstTimeSlot;
@property (strong, nonatomic) IBOutlet UIButton *btnSecondTimeSlot;
@property (strong, nonatomic) IBOutlet UIView *vwNotes;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblNoAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblNoPlanType;
@property (strong, nonatomic) IBOutlet UILabel *lblNoUnit;

@property ACCUnit *unit;
@property NSMutableArray *arrSelectedIndexPaths;
@property NSMutableArray *arrUnits;
@property NSMutableArray *arrAddresses;
@property NSMutableArray *arrPlanTypes;
@property NSMutableArray *arrPurpose;
@property NSString *addressId;
@property NSInteger selectedAddressIndex;
@property NSMutableArray *arrSelectedUnits;
@property NSString *selectedTime;
@property NSInteger selectedPurposeIndex;
@property NSInteger selectedPlanIndex;
@property CGRect OriginalTableFrame;
@property NSString *planId;
@property NSInteger unitsSlot1;
@property NSInteger unitsSlot2;
@property NSInteger dayGapMaintenanceService;
@property NSInteger dayGapOtherServices;
@property BOOL isAllowWeekEnds;
@property NSString *emergencyTime1;
@property NSString *emergencyTime2;
@property NSString *timeSlot1;
@property NSString *timeSlot2;

@property NSString *selectedPurposeID;
@property NSString *selectedPurposeAlertMessage;

@end

@implementation ServiceRequestViewController
@synthesize scrlvRequest,vwRequestInfo,tblvUnit,txtvNotes,textboxHandler,btnFirstTimeSlot,btnSecondTimeSlot,tblvVisitPurpose,lblDate,lblAddress,vwNotes,vwAddress,arrSelectedIndexPaths,tblvAddress,vwUnit,vwVisitPurpose,arrUnits,lblNoUnit,lblNoAddress,arrSelectedUnits,unit,vwPlanType,lblNoPlanType,tblvPlanType,arrPlanTypes,planId,unitsSlot1,unitsSlot2,dayGapMaintenanceService,dayGapOtherServices;

@synthesize arrAddresses,addressId,selectedAddressIndex,arrPurpose,selectedTime,selectedPurposeIndex,selectedPlanIndex,OriginalTableFrame,isAllowWeekEnds,emergencyTime1,emergencyTime2,timeSlot1,timeSlot2,selectedPurposeID,selectedPurposeAlertMessage;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    [self btnTimeSlotTap:btnFirstTimeSlot];
    [btnSecondTimeSlot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    OriginalTableFrame = tblvUnit.frame;
    arrSelectedIndexPaths = nil;
    txtvNotes.text = nil;
    selectedPurposeIndex = 0;
    selectedPlanIndex = 0;
    
    arrUnits = [[NSMutableArray alloc]init];
    arrSelectedIndexPaths = [[NSMutableArray alloc]init];
    arrSelectedUnits      = [[NSMutableArray alloc]init];
    arrAddresses          = [[NSMutableArray alloc]init];
    arrPurpose            = [[NSMutableArray alloc]init];
    arrPlanTypes          = [[NSMutableArray alloc]init];
    
    if ([lblAddress.text isEqualToString:@"Select Address"])
    {
        [lblAddress setFont:[UIFont fontWithName:@"OpenSans" size:20]];
    }
    
    [txtvNotes setPlaceholder:@"Add Notes"];
    
    tblvAddress.separatorColor = [UIColor clearColor];
    tblvUnit.separatorColor = [UIColor clearColor];
    tblvVisitPurpose.separatorColor =[UIColor clearColor];
    tblvPlanType.separatorColor = [UIColor clearColor];
    
    [self setViewFrames];
    [self getAddressList];
    
    [tblvAddress reloadData];
    [tblvUnit reloadData];
    [tblvPlanType reloadData];
    [tblvVisitPurpose reloadData];
}

-(void)setViewFrames
{
    if (arrAddresses.count == 0)
    {
        tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.height);
        vwAddress.frame   = CGRectMake(vwAddress.x, vwAddress.y, vwAddress.width, tblvAddress.height + 50);
    }
    else
    {
        tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.contentSize.height);
        vwAddress.frame   = CGRectMake(vwAddress.x, vwAddress.y, vwAddress.width, tblvAddress.contentSize.height + 50);
    }
    
    if (arrPlanTypes.count == 0)
    {
        tblvPlanType.frame = CGRectMake(tblvPlanType.x, tblvPlanType.y, tblvPlanType.width, OriginalTableFrame.size.height);
        vwPlanType.frame = CGRectMake(vwPlanType.x, vwAddress.y + vwAddress.height, vwPlanType.width, OriginalTableFrame.size.height + 45);
    }
    else
    {
        tblvPlanType.frame = CGRectMake(tblvPlanType.x, tblvPlanType.y, tblvPlanType.width, tblvPlanType.contentSize.height);
        vwPlanType.frame = CGRectMake(vwPlanType.x, vwAddress.y + vwAddress.height, vwPlanType.width, tblvPlanType.height + 45);
    }
    
    if (arrUnits.count == 0)
    {
        lblNoUnit.hidden = NO;
        tblvUnit.frame = CGRectMake(tblvUnit.x, tblvUnit.y , tblvUnit.width, OriginalTableFrame.size.height);
        vwUnit.frame   = CGRectMake(vwUnit.x, vwPlanType.y + vwPlanType.height , vwUnit.width,OriginalTableFrame.size.height + 45);
    }
    else
    {
        lblNoUnit.hidden = YES;
        tblvUnit.frame = CGRectMake(tblvUnit.x, tblvUnit.y , tblvUnit.width, tblvUnit.contentSize.height);
        vwUnit.frame   = CGRectMake(vwUnit.x, vwPlanType.y + vwPlanType.height , vwUnit.width,tblvUnit.contentSize.height + 50);
    }
    
    tblvVisitPurpose.frame = CGRectMake(tblvVisitPurpose.x, tblvVisitPurpose.y, tblvVisitPurpose.width, tblvVisitPurpose.contentSize.height);

    vwVisitPurpose.frame = CGRectMake(vwVisitPurpose.x,vwUnit.y + vwUnit.height, vwVisitPurpose.width, tblvVisitPurpose.contentSize.height + 40);
    
    vwRequestInfo.frame = CGRectMake(vwRequestInfo.x, vwVisitPurpose.y + vwVisitPurpose.height + 20, vwRequestInfo.width, vwRequestInfo.height);
    
//    vwRequestInfo.frame = CGRectMake(vwRequestInfo.x, vwUnit.y + vwUnit.height, vwRequestInfo.width, vwRequestInfo.height);
//    
//    tblvVisitPurpose.frame = CGRectMake(tblvVisitPurpose.x, tblvVisitPurpose.y, tblvVisitPurpose.width, tblvVisitPurpose.contentSize.height);
//    vwVisitPurpose.frame = CGRectMake(vwVisitPurpose.x,vwRequestInfo.y + vwRequestInfo.height , vwVisitPurpose.width, tblvVisitPurpose.contentSize.height + 40);
    
    vwNotes.frame = CGRectMake(vwNotes.x, vwRequestInfo.y + vwRequestInfo.height , vwNotes.width, vwNotes.height);
    
    scrlvRequest.contentSize = CGSizeMake(scrlvRequest.width,vwNotes.y + vwNotes.height + 20);
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[txtvNotes]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arr andScroll:scrlvRequest];
    textboxHandler.delegate = self;
    textboxHandler.showNextPrevious = NO;
}

-(NSMutableArray *)getValidAddresses:(NSMutableArray *)addressList
{
    NSMutableArray *arrAddressList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < addressList.count; i++)
    {
        ACCAddress *address = addressList[i];
        
        if (address.isShowAddress)
        {
            [arrAddressList addObject:address];
        }
    }
    
    return arrAddressList;
}

-(BOOL)validateData
{
//    NSString *rawString = [txtvNotes text];
//    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if (addressId == nil)
    {
        [self showAlertWithMessage:ACCNoAddreess];
        return NO;
    }
    else if (arrSelectedUnits.count == 0)
    {
        [self showAlertWithMessage:ACCNoUnitsSelected];
        return NO;
    }
    else if(![selectedPurposeID isEqualToString:@"1"] && [ACCUtil isWeekEnds:lblDate.text])
    {
        [self showAlertWithMessage:ACCNotAllowWeekends];
        return NO;
    }
//    else if ([trimmed length] == 0)
//    {
//        txtvNotes.layer.borderColor = [UIColor redColor].CGColor;
//        txtvNotes.layer.borderWidth = 1.0;
//        [self showErrorMessage:ACCBlankNotes belowView:txtvNotes];
//        [txtvNotes becomeFirstResponder];
//        return NO;
//    }
//    else if ([txtvNotes.text isEqualToString:@""])
//    {
//        txtvNotes.layer.borderColor = [UIColor redColor].CGColor;
//        txtvNotes.layer.borderWidth = 1.0;
//        [self showErrorMessage:ACCBlankNotes belowView:txtvNotes];
//        [txtvNotes becomeFirstResponder];
//        return NO;
//    }
    return YES;
}

-(NSString *)roundOffTimeBy15Min
{
    NSDateComponents *time = [[NSCalendar currentCalendar]
                              components:NSCalendarUnitHour | NSCalendarUnitMinute
                              fromDate:[NSDate date]];
    
    NSInteger minutes  = [time minute];
    float minuteUnit   = ceil((float) minutes / 15.0);
    minutes            = minuteUnit * 15.0;
    [time setMinute: minutes];
    NSDate *curDate    = [[NSCalendar currentCalendar] dateFromComponents:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString * strCurrentTime = [dateFormatter stringFromDate:curDate];
    
    return strCurrentTime;
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

#pragma mark - Webservice Methods
-(void)getAddressList
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getAddressListWithcompletioHandler:^(ACCAPIResponse *response, NSMutableArray *addressList)
         {
             if (response.code == RCodeSuccess)
             {
                 arrAddresses = [self getValidAddresses:addressList].mutableCopy;
                 lblNoAddress.hidden = YES;
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
                 lblNoAddress.hidden = NO;
                 [SVProgressHUD dismiss];
             }
             
             [SVProgressHUD dismiss];
             [tblvAddress reloadData];
             [self setViewFrames];
             
         }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)getPlanTypeList:(NSString *)addressID
{
    if ([ACCUtil reachable])
    {
        [ACCWebServiceAPI getPlanTypeByAddress:addressID completionHandler:^(ACCAPIResponse *response, NSMutableArray *planInfo)
        {
            if (response.code == RCodeSuccess)
            {
                lblNoPlanType.hidden = YES;
                arrPlanTypes = planInfo.mutableCopy;
                arrSelectedUnits = [[NSMutableArray alloc]init];
                                    
                if (selectedPlanIndex < arrPlanTypes.count)
                {
                    planId = [arrPlanTypes[selectedPlanIndex]valueForKey:GKeyId];
                }
                else
                {
                    selectedPlanIndex = 0;
                    planId = [arrPlanTypes[selectedPlanIndex]valueForKey:GKeyId];
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
                arrPlanTypes = nil;
                arrUnits = nil;
                lblNoPlanType.hidden = NO;
                lblNoPlanType.text = response.message;
                [tblvUnit reloadData];
            }
            
            [SVProgressHUD popActivity];
            [tblvPlanType reloadData];
            [self setViewFrames];
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)getUnitList
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dict = @{
                                 UKeyClientID  : ACCGlobalObject.user.ID,
                                 UKeyAddressId : addressId,
                                 UKeyPlanId    : planId
                              };
        
        [ACCWebServiceAPI getUnitListByPlan:dict completionHandler:^(ACCAPIResponse *response, NSMutableArray *UnitList)
         {
             if (response.code == RCodeSuccess)
             {
                 arrUnits = UnitList.mutableCopy;
                 arrSelectedUnits = [[NSMutableArray alloc]init];
                 //[tblvUnit reloadData];
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
                 arrUnits = nil;
                 // tblvUnit.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:self.view.size.height / 1.9];
             }
             
             [tblvUnit reloadData];
             [self setViewFrames];
             [SVProgressHUD popActivity];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)getPurposeAndTime
{
    NSDictionary *userId = @{
                              UKeyPlanId : planId
                            };

    [SVProgressHUD show];
    
    [ACCWebServiceAPI getPurposeAndTime:userId completionHandler:^(ACCAPIResponse *response, NSDictionary *purposeInfo)
    {
        if (response.code == RCodeSuccess)
        {
            unitsSlot1 = [purposeInfo[SKeyUnitsSlot1] integerValue];
            unitsSlot2 = [purposeInfo[SKeyUnitsSlot2] integerValue];
            
            emergencyTime1 = purposeInfo[SKeyEmergencyTimeSlot1];
            emergencyTime2 = purposeInfo[SKeyEmergencyTimeSlot2];
            
            dayGapMaintenanceService = [purposeInfo[SKeyMaintenanceServicesWithinnDays] integerValue];
            dayGapOtherServices      = [purposeInfo[SKeyEmergencyAndOtherServiceWithinDays] integerValue];
            
            btnFirstTimeSlot.hidden = NO;
            btnSecondTimeSlot.hidden = NO;
            
            timeSlot1 = purposeInfo[SKeyTimeSlot1];
            timeSlot2 = purposeInfo[SKeyTimeSlot2];
            
            [btnFirstTimeSlot setTitle:timeSlot1 forState:UIControlStateNormal];
            [btnSecondTimeSlot setTitle:timeSlot2 forState:UIControlStateNormal];
            
            //selectedTime = btnFirstTimeSlot.titleLabel.text;
            
            [self btnTimeSlotTap:btnFirstTimeSlot];
            
            arrPurpose = purposeInfo[SKeyPurpose];
            
            selectedPurposeID = [[arrPurpose[0] valueForKey:GKeyId] stringValue];
            
            selectedPurposeAlertMessage = [arrPurpose[0] valueForKey:RKeyMessage];
            
            lblDate.text = [ACCUtil getDefaultDateWithoutWeekends:[self getDayGap:selectedPurposeID] withAllowWeekends:NO];
            isAllowWeekEnds = NO;
            //lblDate.text = [ACCUtil getDefaultDateWithoutWeekends:[self getDayGap:arrPurpose[selectedPurposeIndex]]];
            [tblvVisitPurpose reloadData];
            [self setViewFrames];
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

-(void)sendRequestData
{
    NSString *notes = txtvNotes.text;
    
    NSDictionary *requestData = @{
                                  UKeyClientID       : ACCGlobalObject.user.ID,
                                  UKeyAddressId      : addressId,
                                  SKeyPurposeOfVisit : selectedPurposeID,
                                  SKeyRequestedDate  : lblDate.text,
                                  SKeyRequestedTime  : selectedTime,
                                  SKeyNotes          : notes,
                                  UKeyUnits          : arrSelectedUnits
                                 };
    
    [SVProgressHUD show];
    
    if ([ACCUtil reachable])
    {
        [ACCWebServiceAPI sendRequestData:requestData completionHandler:^(ACCAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 RequestListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestListViewController"];
//                 viewController.addressID = addressId.integerValue;
//                 viewController.isFromRequestForm = YES;
                 [self.navigationController pushViewController:viewController animated:YES];
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
- (IBAction)btnMenuTap:(id)sender
{
    [self.view endEditing:YES];
    [self openSideBar];
}

- (IBAction)btnListTap:(id)sender
{
    [self.view endEditing:YES];
    RequestListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestListViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnTimeSlotTap:(UIButton *)button
{
    if (button == btnSecondTimeSlot)
    {
        if ((NSInteger)arrSelectedUnits.count > unitsSlot2)
        {
            [self showAlertWithMessage:ACCUnitsLimit];
            selectedTime = btnFirstTimeSlot.titleLabel.text;
            [self btnTimeSlotTap:btnFirstTimeSlot];
        }
        else
        {
            btnSecondTimeSlot.selected = YES;
            btnFirstTimeSlot.selected  = NO;
            selectedTime = btnSecondTimeSlot.titleLabel.text;
        }
        
        if (btnSecondTimeSlot.selected == YES)
        {
            btnSecondTimeSlot.userInteractionEnabled = NO;
            btnFirstTimeSlot.userInteractionEnabled  = YES;
            selectedTime = btnSecondTimeSlot.titleLabel.text;
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
        
        selectedTime = btnFirstTimeSlot.titleLabel.text;
    }
}

- (IBAction)btnSelectDateTap:(id)sender
{
    ChooseDateViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseDateViewController"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    viewController.delegate = self;
    viewController.selectedDate = lblDate.text;
    viewController.dayGap = [self getDayGap:selectedPurposeID];
    viewController.isAllowWeekEnds = isAllowWeekEnds;
    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}

//- (IBAction)btnSelectTimeTap:(id)sender
//{
//    ChooseTimeViewController *ctvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseTimeViewController"];
//    ctvc.providesPresentationContextTransitionStyle = YES;
//    ctvc.definesPresentationContext = YES;
//    [ctvc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    ctvc.delegate = self;
//    ctvc.selectedTime = [btnEmergencyTime titleLabel].text;
//    
//    selectedTime = [NSString stringWithFormat:@"%@ - 11:55 PM",[btnEmergencyTime titleLabel].text];
//    
//    [self.navigationController presentViewController:ctvc animated:NO completion:nil];
//}

- (IBAction)btnSubmitTap:(id)sender
{
    if ([self validateData])
    {
        if ([selectedPurposeID isEqualToString:@"1"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:AppName
                                                                           message:selectedPurposeAlertMessage
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:ACCTextNotAgree style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  
                              }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:ACCTextAgree style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  [self sendRequestData];
                              }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [ACCUtil showAlertFromControllerWithDoubleAction:self withMessage:selectedPurposeAlertMessage andHandler:^(UIAlertAction * _Nullable action)
             {
                 [self sendRequestData];
             }
             andNoHandler:^(UIAlertAction * _Nullable action)
             {
                 
                 
             }];
            //[self sendRequestData];
        }
    }
}

#pragma mark - ChooseDateViewController Delegate Methods
-(void)setDate:(NSString *)date
{
    lblDate.text = date;
    
    if (![ACCUtil isWeekEnds:date] && [selectedPurposeID isEqualToString:@"1"])
    {
        [btnFirstTimeSlot setTitle:emergencyTime1 forState:UIControlStateNormal];
        [btnSecondTimeSlot setTitle:emergencyTime2 forState:UIControlStateNormal];
    }
    else
    {
        [btnFirstTimeSlot setTitle:timeSlot1 forState:UIControlStateNormal];
        [btnSecondTimeSlot setTitle:timeSlot2 forState:UIControlStateNormal];
    }
}

//-(void)setTime:(NSString *)time
//{
//    [btnEmergencyTime setTitle:time forState:UIControlStateNormal];
//    selectedTime = [NSString stringWithFormat:@"%@ - 11:55 PM",time];
//}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblvAddress)
    {
        return arrAddresses.count;
    }
    else if (tableView == tblvUnit)
    {
        return arrUnits.count;
    }
    else if (tableView == tblvPlanType)
    {
        return arrPlanTypes.count;
    }
    else if (tableView == tblvVisitPurpose)
    {
        return arrPurpose.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell;
    
    if (tableView == tblvAddress)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
        
        ACCAddress *add = arrAddresses[indexPath.row];
        
        cell.lblDesc.text = [NSString stringWithFormat:@"%@\n%@, %@ %@",add.address,add.cityName,add.stateName,add.zipcode];
    
        if (add.isDefaultAddress)
        {
            addressId = add.addressId;
            selectedAddressIndex = indexPath.row;
            [self getPlanTypeList:addressId];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
        }
        else
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
    }
    else if (tableView == tblvPlanType)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"planTypeCell" forIndexPath:indexPath];

        if (indexPath.row == selectedPlanIndex)
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
            [self getUnitList];
            [self getPurposeAndTime];
        }
        else
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell.lblDesc.text = [arrPlanTypes[indexPath.item]valueForKey:GKeyPlanName];
    }
    else if (tableView == tblvUnit)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell" forIndexPath:indexPath];
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1)];
       lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        [cell.contentView addSubview:lineView];
        unit = arrUnits[indexPath.item];
        cell.lblDesc.text = unit.unitName;
        cell.imgvCheckmark.image = [UIImage imageNamed:@"checkboxWhiteBack"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"visitPurposeCell" forIndexPath:indexPath];
        
        if ([[[arrPurpose[indexPath.row]valueForKey:GKeyId] stringValue] isEqualToString:selectedPurposeID])
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
        }
        else
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell.lblDesc.text = [arrPurpose[indexPath.row]valueForKey:GKeyName];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell;
    
    if (tableView == tblvAddress)
    {
        [self.view endEditing:YES];
        
        if (selectedAddressIndex != indexPath.row)
        {
            NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
            cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell  = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        addressId = [arrAddresses[indexPath.row] addressId];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
        
        [self getPlanTypeList:addressId];
        
        [self btnTimeSlotTap:btnFirstTimeSlot];
    }
    else if (tableView == tblvPlanType)
    {
        if (selectedPlanIndex != indexPath.row)
        {
            NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedPlanIndex inSection:0];
            cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell = (ACCSelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
        selectedPlanIndex = indexPath.row;
        planId = [arrPlanTypes[indexPath.item] valueForKey:GKeyId];
        
        [self getUnitList];
        [self getPurposeAndTime];
    }
    else if(tableView == tblvVisitPurpose)
    {
        if (selectedPurposeID != [arrPurpose[indexPath.row]valueForKey:GKeyId])
        {
            NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedPurposeIndex inSection:0];
            cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell = (ACCSelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
        selectedPurposeID = [[arrPurpose[indexPath.row] valueForKey:GKeyId] stringValue];
        selectedPurposeAlertMessage = [arrPurpose[indexPath.row] valueForKey:RKeyMessage];
        
        if ([selectedPurposeID isEqualToString:@"1"])
        {
            isAllowWeekEnds = YES;
            
            lblDate.text = [ACCUtil getCurrentDate];
            
            if ([ACCUtil isWeekEnds:lblDate.text])
            {
                [btnFirstTimeSlot setTitle:timeSlot1 forState:UIControlStateNormal];
                [btnSecondTimeSlot setTitle:timeSlot2 forState:UIControlStateNormal];
            }
            else
            {
                [btnFirstTimeSlot setTitle:emergencyTime1 forState:UIControlStateNormal];
                [btnSecondTimeSlot setTitle:emergencyTime2 forState:UIControlStateNormal];
            }
        }
        else
        {
            isAllowWeekEnds = NO;
            
            lblDate.text = [ACCUtil getDefaultDateWithoutWeekends:[self getDayGap:selectedPurposeID] withAllowWeekends:NO];
            
            [btnFirstTimeSlot setTitle:timeSlot1 forState:UIControlStateNormal];
            [btnSecondTimeSlot setTitle:timeSlot2 forState:UIControlStateNormal];
        }
        
        [self btnTimeSlotTap:btnFirstTimeSlot];
        
        //lblDate.text = [ACCUtil getDefaultDateWithoutWeekends:[self getDayGap:arrPurpose[selectedPurposeIndex]]];
    }
    else if (tableView == tblvUnit)
    {
        cell = (ACCSelectionCell *)[tableView cellForRowAtIndexPath:indexPath];
        unit = arrUnits[indexPath.item];
        
        if (![arrSelectedIndexPaths containsObject:indexPath])
        {
            [arrSelectedUnits addObject:unit.unitID];
            [arrSelectedIndexPaths addObject:indexPath];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"checkboxWhiteBackSelected"];
            
//            if (btnFirstTimeSlot.selected)
//            {
//                if (selectedUnitsCount > unitsSlot1 && selectedUnitsCount > unitsSlot2)
//                {
//                    [self showAlertWithMessage: [NSString stringWithFormat:@"You can not select more than %ld units for a single request. Please submit other units using another request.",(long)unitsSlot1]];
//                    btnSecondTimeSlot.userInteractionEnabled = NO;
//                }
//            }

                if ((NSInteger)arrSelectedUnits.count > unitsSlot2)
                {
                    if (btnSecondTimeSlot.selected)
                    {
                        [self showAlertWithMessage:ACCUnitsLimit];
                    }
                    
                    [self btnTimeSlotTap:btnFirstTimeSlot];
                    [btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
        }
        else
        {
            [arrSelectedUnits removeObject:unit.unitID];
            [arrSelectedIndexPaths removeObject:indexPath];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"checkboxWhiteBack"];
            
//            if (btnFirstTimeSlot.selected)
//            {
//                if (selectedUnitsCount > unitsSlot1 && selectedUnitsCount > unitsSlot2)
//                {
//                    [self showAlertWithMessage: [NSString stringWithFormat:@"You can not select more than %ld units for a single request. Please submit other units using another request.",(long)unitsSlot1]];
//                    btnSecondTimeSlot.userInteractionEnabled = NO;
//                }
//            }

                if ((NSInteger)arrSelectedUnits.count > unitsSlot2)
                {
                    if (btnSecondTimeSlot.selected)
                    {
                        [self showAlertWithMessage:ACCUnitsLimit];
                    }
                    [btnSecondTimeSlot setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [btnSecondTimeSlot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btnSecondTimeSlot.userInteractionEnabled = YES;
                }
        }
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell;
    
    if (tableView == tblvAddress || tableView == tblvVisitPurpose || tableView == tblvPlanType)
    {
        cell  = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
    }
}

#pragma mark - ZWTTextboxToolbarHandler Delegate Methods
-(void)doneTap
{
    [self setViewFrames];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    txtvNotes.layer.borderColor = [UIColor borderColor].CGColor;
    [self removeErrorMessageBelowView:txtvNotes];
    return YES;
}
@end
