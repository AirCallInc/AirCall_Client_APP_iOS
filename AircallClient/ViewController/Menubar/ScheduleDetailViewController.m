//
//  ScheduleDetailViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ScheduleDetailViewController.h"

@interface ScheduleDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvSchedule;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceMan;
@property (strong, nonatomic) IBOutlet UILabel *lblServiceCaseNo;
@property (strong, nonatomic) IBOutlet UILabel * lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UITableView *tblvSchedule;
@property (strong, nonatomic) IBOutlet UITextView *txtvComplaint;
@property (strong, nonatomic) IBOutlet UIView *vwComplaint;
@property (strong, nonatomic) IBOutlet UIImageView *imgvServiceMan;
@property (strong, nonatomic) IBOutlet UIButton *btnAccept;
@property (strong, nonatomic) IBOutlet UIButton *btnReschedule;
@property (strong, nonatomic) IBOutlet UIView *vwServiceApprovalbtn;
@property (weak, nonatomic) IBOutlet UIView *vwRescheduleBtn;
@property (weak, nonatomic) IBOutlet UIView *vwRqServiceApprovalBtn;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress;



@property NSMutableArray * arrUnits;
@property ACCSchedule *scheduleDetail;
@property BOOL isLateReschedule;
@property BOOL isRequested;

@end

@implementation ScheduleDetailViewController

@synthesize scheduleDetail,scrlvSchedule,lblServiceMan,lblServiceCaseNo,lblDate,lblTime,tblvSchedule,txtvComplaint,vwComplaint,imgvServiceMan,btnAccept,btnReschedule,arrUnits,scheduleType,scheduleId,vwServiceApprovalbtn,notificationId,isLateReschedule,delegate,lblAddress,vwRescheduleBtn,isRequested,vwRqServiceApprovalBtn;

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

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRescheduleTap:(id)sender
{
    if(!isLateReschedule) //[self allowReschedule]
    {
        [self openRescheduleScreen];
    }
    else
    {
        [ACCUtil showAlertFromControllerWithDoubleAction:self withMessage:scheduleDetail.rescheduleMessage andHandler:^(UIAlertAction * _Nullable action)
        {
            [self sendLateRescheduleRequest];
        }
        andNoHandler:^(UIAlertAction * _Nullable action)
        {
            
        }];
    }
}

- (IBAction)btnAcceptTap:(id)sender
{
    if ([ACCUtil reachable])
    {
        [self acceptSchedule];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

- (IBAction)btnCancelTap:(id)sender
{
    if(!isLateReschedule)
    {
        [self cancelScheduledRequest:NO];
    }
    else
    {
        [ACCUtil showAlertFromControllerWithDoubleAction:self withMessage:scheduleDetail.lateCancellationMessage andHandler:^(UIAlertAction * _Nullable action)
         {
             [self cancelScheduledRequest:YES];
         }
         andNoHandler:^(UIAlertAction * _Nullable action)
         {
             
         }];
    }
}

#pragma mark- Helper Methods
-(void)prepareView
{
    imgvServiceMan.layer.cornerRadius = imgvServiceMan.height/ 2;
    imgvServiceMan.clipsToBounds = YES;
    
   // [self setScheduleData];
    
    //[tblvSchedule reloadData];
    
    tblvSchedule.separatorColor = [UIColor clearColor];
    tblvSchedule.alwaysBounceVertical = NO;
    
    [self getScheduleDetail];
    [self setFrames];
}
-(void)setFrames
{
    tblvSchedule.frame = CGRectMake(tblvSchedule.x, tblvSchedule.y, tblvSchedule.width, tblvSchedule.contentSize.height);
    vwComplaint.frame = CGRectMake(vwComplaint.x, tblvSchedule.y + tblvSchedule.height + 15, vwComplaint.width, vwComplaint.height);
    
    if (vwComplaint.hidden)
    {
        scrlvSchedule.contentSize = CGSizeMake(scrlvSchedule.width, tblvSchedule.y + tblvSchedule.height + 15);
    }
    else
    {
        scrlvSchedule.contentSize = CGSizeMake(scrlvSchedule.width, vwComplaint.y + vwComplaint.height);
    }
}
-(void)setScheduleData
{
    lblServiceMan.text = [NSString stringWithFormat:@"%@ %@",scheduleDetail.empFirstName,scheduleDetail.empLastname];
    
    isLateReschedule = scheduleDetail.isLateReschedule;
    
    lblDate.text = scheduleDetail.scheduleDate;//[NSString stringWithFormat:@"%@ %@ %@",scheduleDetail.scheduleDay,scheduleDetail.monthName,scheduleDetail.scheduleYear];
    lblAddress.text = [NSString stringWithFormat:@"%@\n%@, %@ %@",scheduleDetail.address, scheduleDetail.city,scheduleDetail.state,scheduleDetail.zipcode];
    lblServiceCaseNo.text = scheduleDetail.serviceCaseNo;
    txtvComplaint.text = scheduleDetail.customerComplaints;
    
    if ([txtvComplaint.text isEqualToString:@""])
    {
        vwComplaint.hidden = YES;
    }
    else
    {
        vwComplaint.hidden = NO;
    }
    
    lblTime.text = [NSString stringWithFormat:@"%@ - %@",scheduleDetail.scheduleStartTime,scheduleDetail.scheduleEndTime];
    arrUnits = scheduleDetail.arrUnits;
    
    if (![scheduleDetail.empProfileImageURL.absoluteString isEqualToString:@""])
    {
        [ACCWebService downloadImageWithURL:scheduleDetail.empProfileImageURL complication:^(UIImage *image, NSError *error)
        {
            imgvServiceMan.image = image;
        }];
    }
    else
    {
        imgvServiceMan.image = [UIImage imageNamed:@"userPlaceHolder"];
    }
    
    isRequested = scheduleDetail.isRequested;
    
    if (isRequested && [scheduleType isEqualToString:@"ServiceApproval"])
    {
        vwRqServiceApprovalBtn.hidden = NO;
        vwServiceApprovalbtn.hidden   = YES;
        vwRescheduleBtn.hidden        = YES;
        btnReschedule.hidden          = YES;
        
        scrlvSchedule.frame = CGRectMake(scrlvSchedule.x, scrlvSchedule.y, scrlvSchedule.width, scrlvSchedule.height - 50);
    }
    else if(isRequested && ![scheduleType isEqualToString:@"ServiceApproval"])
    {
        vwRescheduleBtn.hidden        = NO;
        vwServiceApprovalbtn.hidden   = YES;
        vwRqServiceApprovalBtn.hidden = YES;
        btnReschedule.hidden          = YES;
    }
    else if(!isRequested && [scheduleType isEqualToString:@"ServiceApproval"])
    {
        vwServiceApprovalbtn.hidden   = NO;
        vwRqServiceApprovalBtn.hidden = YES;
        vwRescheduleBtn.hidden        = YES;
        btnReschedule.hidden          = YES;
    }
    else
    {
        vwServiceApprovalbtn.hidden = YES;
        vwRqServiceApprovalBtn.hidden = YES;
        vwRescheduleBtn.hidden = YES;
        btnReschedule.hidden = NO;
        scrlvSchedule.frame = CGRectMake(scrlvSchedule.x, scrlvSchedule.y, scrlvSchedule.width, scrlvSchedule.height + 50);
    }
    
    [tblvSchedule reloadData];
    [self setFrames];
}

-(BOOL)allowReschedule
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd YYYY"];
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([todayDate isEqualToString:lblDate.text])
    {
        return NO;
    }
    
    return YES;
}

-(void)openRescheduleScreen
{
    RescheduleRequestViewController *rrvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RescheduleRequestViewController"];
    rrvc.serviceId = scheduleDetail.serviceID;
    rrvc.isFromRequestList = NO;
    
    NSString *str = scheduleDetail.scheduleDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM dd, yyyy"];
    NSDate *dateFromString = [dateFormatter dateFromString:str];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];// here set format which you want...
    NSString *stringFromDate = [dateFormatter stringFromDate:dateFromString];
    rrvc.selectedDate = stringFromDate;
    rrvc.purposeOfVisit = scheduleDetail.purposeOfVisit;
    rrvc.selectedTimeSlot = scheduleDetail.scheduleTimeSlot;
    rrvc.noOfUnits = (NSInteger)scheduleDetail.arrUnits.count;
    [self.navigationController pushViewController:rrvc animated:YES];
}

#pragma mark - Webservice Method
-(void)getScheduleDetail
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               SKeyID : scheduleId,
                               NKeyNotificationId : notificationId != nil ? notificationId : @""
                              };
        
        [ACCWebServiceAPI getScheduleDetail:dict completionHandler:^(ACCAPIResponse *response, ACCSchedule *schedule)
        {
            if (response.code == RCodeSuccess)
            {
                scheduleDetail = schedule;
                [self setScheduleData];
                [self setFrames];
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

-(void)acceptSchedule
{
    NSDictionary *dict = @{
                           UKeyClientID : ACCGlobalObject.user.ID,
                           SKeyID : scheduleId,
                           NKeyNotificationId : notificationId != nil ? notificationId : @""
                          };
    
        [ACCWebServiceAPI acceptScheduledService:dict completionHandler:^(ACCAPIResponse *response)
        {
            if (response.code == RCodeSuccess)
            {
                [self.navigationController popViewControllerAnimated:YES];
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

-(void)sendLateRescheduleRequest
{
    NSDictionary *dictLateReschedule = @{
                                         UKeyClientID : ACCGlobalObject.user.ID,
                                         SKeyID : scheduleId,
                                         SKeyLateServiceReschedule : @"true",
                                        };
    
    if ([ACCUtil reachable])
    {
        [ACCWebServiceAPI sendRescheduleRequest:dictLateReschedule isFromRequestList:NO completionHandler:^(ACCAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 [self.navigationController popViewControllerAnimated:NO];
                 [delegate rescheduleSuccess:response.message];
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

-(void)cancelScheduledRequest:(BOOL)isLate
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dictCancelScheduledRequest = @{
                                                     UKeyClientID : ACCGlobalObject.user.ID,
                                                     SKeyID : scheduleId,
                                                     SKeyLateServiceReschedule : isLate ? @"true" : @"false",
                                                     };
        
       [SVProgressHUD show];
        
       [ACCWebServiceAPI cancelScheduledRequest:dictCancelScheduledRequest completionHandler:^(ACCAPIResponse *response)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                [self.navigationController popViewControllerAnimated:NO];
                [delegate rescheduleSuccess:response.message];
                
            }
            else if (response.code == RCodeInvalidRequest)
            {
                [self showAlertFromWithMessageWithSingleAction:ACCInvalidRequest andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [ACCUtil logoutTap];
                 }];
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

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUnits.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ACCUnit *unit = arrUnits[indexPath.row];
    cell.lblDesc.text = unit.unitName;
    
    return cell;
}
@end
