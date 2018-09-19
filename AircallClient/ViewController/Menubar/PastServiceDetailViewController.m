//
//  PastServiceDetailViewController.m
//  AircallClient
//
//  Created by Manali on 01/04/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "PastServiceDetailViewController.h"

@interface PastServiceDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,ZWTTextboxToolbarHandlerDelegate>

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvService;
@property (strong, nonatomic) IBOutlet SAMTextView *txtvReview;
@property (strong, nonatomic) IBOutlet UILabel *lblCaseNo;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceMan;
@property (strong, nonatomic) IBOutlet UILabel *lblVisitPurpose;
@property (strong, nonatomic) IBOutlet UILabel *lblWorkStartTime;
@property (strong, nonatomic) IBOutlet UILabel *lblWorkEndTime;
@property (strong, nonatomic) IBOutlet UIImageView *imgvServiceMan;

@property (strong, nonatomic) IBOutlet UITextView *txtvWorkPerformed;
@property (strong, nonatomic) IBOutlet UITextView *txtvRecommendations;

@property (strong, nonatomic) IBOutlet UIView *vwGeneralInfo;
@property ZWTTextboxToolbarHandler *textboxHandler;
@property NSMutableArray *arrTextBoxes;
@property NSString *strRating;
@property (strong, nonatomic) IBOutlet UITableView *tblvUnits;
@property (strong, nonatomic) IBOutlet UILabel *lblRateNote;

@property (strong, nonatomic) IBOutlet UILabel *lblReview;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property BOOL isWorkNotDone;
@property NSMutableArray *unitList;
@property NSDictionary *dictDetail;
@property (strong, nonatomic) IBOutlet UIView *vwUnit;
@property (strong, nonatomic) IBOutlet UIView *vwTime;
@property (strong, nonatomic) IBOutlet UIView *vwWorkPerformed;
@property (strong, nonatomic) IBOutlet UIView *vwRateReview;
@property (strong, nonatomic) IBOutlet UIView *vwServiceCase;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAssignedTime;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignedEndTime;
@property (strong, nonatomic) IBOutlet UILabel *lblExtraTime;
@property (strong, nonatomic) IBOutlet UIView *vwExtraTime;
@property (strong, nonatomic) IBOutlet UIView *vwHideSameTime;
@property  BOOL isTimeDifferent;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;

@end

@implementation PastServiceDetailViewController
@synthesize ratingView,serviceId,scrlvService,txtvReview,lblCaseNo,lblDate,lblTime,lblServiceMan,lblVisitPurpose,lblWorkStartTime,lblWorkEndTime,txtvWorkPerformed,txtvRecommendations,strRating,vwGeneralInfo,textboxHandler,arrTextBoxes,tblvUnits,dictDetail,unitList,isWorkNotDone,lblRateNote,lblReview,btnSubmit,imgvServiceMan,vwUnit,vwTime,vwWorkPerformed,vwRateReview,vwServiceCase,notificationId,lblTotalAssignedTime,lblAssignedEndTime,lblExtraTime,vwExtraTime,vwHideSameTime,isTimeDifferent,lblAddress;

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
    if (notificationId == nil)
    {
        notificationId = @"";
    }
    
    tblvUnits.separatorColor = [UIColor clearColor];
    imgvServiceMan.layer.cornerRadius = imgvServiceMan.width/2;
    [imgvServiceMan setClipsToBounds:YES];
    
    ratingView.tintColor = [UIColor appGreenColor];
    [txtvReview setPlaceholder:@"Add Review"];
    [self getServiceData];
    
}
-(void)resizeFrames
{
    if (!isWorkNotDone)
    {
        vwUnit.hidden = NO;
        
        if (unitList.count == 0)
        {
            vwUnit.frame = CGRectMake(vwUnit.x, vwUnit.y, vwUnit.width, tblvUnits.height);
            tblvUnits.backgroundView = [ACCUtil viewNoDataWithMessage:@"No units Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnits.height];
        }
        else
        {
            tblvUnits.frame = CGRectMake(tblvUnits.x, tblvUnits.y, tblvUnits.width, tblvUnits.contentSize.height);
            vwUnit.frame = CGRectMake(vwUnit.x, vwUnit.y, vwUnit.width, tblvUnits.contentSize.height + 35);
        }
        
        vwGeneralInfo.frame = CGRectMake(vwGeneralInfo.x, vwUnit.y + vwUnit.height, vwGeneralInfo.width, vwGeneralInfo.height);
        vwTime.hidden = NO;
        
        if (isTimeDifferent == NO)
        {
            vwHideSameTime.hidden = YES;
            vwHideSameTime.frame = CGRectMake(vwHideSameTime.x, vwHideSameTime.y, vwHideSameTime.width, vwHideSameTime.height);
            vwTime.frame = CGRectMake(vwTime.x, vwGeneralInfo.y + vwGeneralInfo.height, vwTime.width, vwTime.height - vwHideSameTime.height);
            
        }
        else if ([lblExtraTime.text isEqualToString:@""])
        {
            vwExtraTime.hidden = YES;
            vwHideSameTime.frame = CGRectMake(vwHideSameTime.x, vwHideSameTime.y, vwHideSameTime.width, vwHideSameTime.height - vwExtraTime.height);
            vwTime.frame = CGRectMake(vwTime.x, vwGeneralInfo.y + vwGeneralInfo.height, vwTime.width, vwTime.height - vwExtraTime.height);
        }
        else
        {
             vwTime.frame = CGRectMake(vwTime.x, vwGeneralInfo.y + vwGeneralInfo.height, vwTime.width, vwTime.height);
        }
        
        vwWorkPerformed.frame = CGRectMake(vwWorkPerformed.x, vwTime.y + vwTime.height, vwWorkPerformed.width, vwWorkPerformed.height);
        vwRateReview.hidden = NO;
        vwRateReview.frame = CGRectMake(vwRateReview.x, vwWorkPerformed.y + vwWorkPerformed.height, vwRateReview.width, vwRateReview.height);
        
        scrlvService.contentSize = CGSizeMake(scrlvService.width, vwRateReview.y + vwRateReview.height);
    }
    else
    {
        vwUnit.hidden = NO;
        
        if (unitList.count == 0)
        {
            vwUnit.frame = CGRectMake(vwUnit.x, vwUnit.y, vwUnit.width, tblvUnits.height);
            tblvUnits.backgroundView = [ACCUtil viewNoDataWithMessage:@"No units Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnits.height];
        }
        else
        {
            tblvUnits.frame = CGRectMake(tblvUnits.x, tblvUnits.y, tblvUnits.width, tblvUnits.contentSize.height);
            vwUnit.frame = CGRectMake(vwUnit.x, vwUnit.y, vwUnit.width, tblvUnits.contentSize.height + 35);
        }
        
        vwGeneralInfo.frame = CGRectMake(vwGeneralInfo.x, vwUnit.y + vwUnit.height, vwGeneralInfo.width, vwGeneralInfo.height);
        
//        vwGeneralInfo.frame = CGRectMake(vwGeneralInfo.x, vwServiceCase.y + vwServiceCase.height, vwGeneralInfo.width, vwGeneralInfo.height);
        
        vwTime.hidden = YES;
        vwWorkPerformed.frame = CGRectMake(vwWorkPerformed.x, vwGeneralInfo.y + vwGeneralInfo.height, vwWorkPerformed.width, vwWorkPerformed.height);
        vwRateReview.hidden = YES;
        scrlvService.frame = CGRectMake(scrlvService.x, scrlvService.y, scrlvService.width, scrlvService.height + btnSubmit.height + 10);
        btnSubmit.hidden = YES;
        scrlvService.contentSize = CGSizeMake(scrlvService.width, vwWorkPerformed.y + vwWorkPerformed.height);
    }
    
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtvReview]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvService];
    textboxHandler.delegate = self;
}

-(void)setServiceData:(ACCService*)service
{
    lblCaseNo.text              = service.serviceCaseNo;
    lblAddress.text             = [NSString stringWithFormat:@"%@\n%@, %@ %@",service.address, service.city,service.state ,service.zipcode];
    lblDate.text                = service.serviceDate;
    lblTime.text                = service.serviceTime;
    lblServiceMan.text          = service.serviceMan;
    lblVisitPurpose.text        = service.visitPurpose;
    
    txtvWorkPerformed.text      = service.workPerformed;
    
    if ([service.recommendations isEqualToString:@""])
    {
        txtvRecommendations.text    = @"NA";
    }
    else
    {
        txtvRecommendations.text    = service.recommendations;
    }
    
    
    ratingView.value            = [service.rate floatValue];
    txtvReview.text             = service.review;
    lblAssignedEndTime.text     = service.assignedEndTime;
    lblTotalAssignedTime.text   = service.totalTimeAssigned;
    lblExtraTime.text           = @"";//service.extraTime;
    lblWorkStartTime.text       = service.workStartTime;
    lblWorkEndTime.text         = service.workEndTime;
    isTimeDifferent             = service.isTimeDifferent;
    
    
    [imgvServiceMan setImageWithURL:service.imageURL placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
    
    if (ratingView.value != 0)
    {
        ratingView.userInteractionEnabled = NO;
        txtvReview.userInteractionEnabled = YES;
        txtvReview.editable               = NO;
        txtvReview.selectable             = NO;
        lblRateNote.hidden                = YES;
        lblReview.hidden                  = NO;
        btnSubmit.hidden                  = YES;
        scrlvService.frame = CGRectMake(scrlvService.x, scrlvService.y, scrlvService.width, self.view.height - btnSubmit.height - 25);
    }
    else
    {
        lblReview.hidden   = YES;
        btnSubmit.hidden   = NO;
        lblRateNote.hidden = NO;
    }
    
    isWorkNotDone = service.isWorkNotDone;
    
    NSMutableArray *arrUnits = dictDetail[UKeyUnits];
    
    unitList = @[].mutableCopy;
    
    for (int i = 0; i < arrUnits.count; i++)
    {
        ACCUnit *unitDetail = [[ACCUnit alloc]iniWithDictionary:arrUnits[i]];
        [unitList addObject:unitDetail] ;
    }
    
    [tblvUnits reloadData];
    [self resizeFrames];
}
-(BOOL)isDetailValid
{
    if (strRating == nil)
    {
        [self showAlertWithMessage:ACCBlankRating];
        return NO;
    }
    
//    if ([txtvReview.text isEqualToString:@""])
//    {
//        txtvReview.layer.borderColor = [UIColor redColor].CGColor;
//        txtvReview.layer.borderWidth = 1.0;
//        [self showErrorMessage:ACCBlankReview belowView:txtvReview];
//        [txtvReview becomeFirstResponder];
//        return NO;
//    }
    
    return YES;
}
#pragma mark - Event Methods
- (IBAction)ratingValueChanged:(HCSStarRatingView *)sender
{
    strRating = [NSString stringWithFormat:@"%0.2f",sender.value];
}

- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitTap:(id)sender
{
    if ([self isDetailValid])
    {
        NSDictionary *dict =  @{
                                UKeyClientID : ACCGlobalObject.user.ID,
                                SKeyID       : serviceId,
                                SKeyRate     : strRating,
                                SKeyReview   : txtvReview.text,
                                NKeyNotificationId: notificationId != nil ? notificationId : @""
                                };
        
        [self sendRateReview:dict];
    }
}

#pragma mark - Webservice Methods
-(void)getServiceData
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               SKeyID: serviceId,
                               UKeyClientID : ACCGlobalObject.user.ID,
                               NKeyNotificationId : notificationId != nil ? notificationId : @""
                               };
        
        [ACCWebServiceAPI getServiceDetail:dict completionHandler:^(ACCAPIResponse *response, NSDictionary *services)
         {
             if (response.code == RCodeSuccess)
             {
                 dictDetail = services;
                 ACCService *service = [[ACCService alloc]initWithDictionary:services];
                 [self setServiceData:service];
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
    else
    {
        [self showAlertFromWithMessageWithSingleAction:ACCNoInternet andHandler:^(UIAlertAction * _Nullable action)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
        //[self showAlertWithMessage:ACCNoInternet];
    }
}
-(void)sendRateReview:(NSDictionary*)ratingInfo
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI sendRateAndReview:ratingInfo completionHandler:^(ACCAPIResponse *response)
        {
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
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return unitList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *unitCell = [tableView dequeueReusableCellWithIdentifier:@"unitCell" forIndexPath:indexPath];
    ACCUnit *unit = unitList[indexPath.row];
    unitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    unitCell.lblDesc.text = unit.unitName;
    unitCell.lblSubDesc.text = unit.planName;
    return unitCell;
}

#pragma mark - UITextView Delegate Method
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self removeErrorMessageBelowView:txtvReview];
    textView.layer.borderColor = [UIColor borderColor].CGColor;
    return YES;
}
-(void)doneTap
{
    
}
@end
