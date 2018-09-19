//
//  UpcomingScheduleViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/7/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "UpcomingScheduleViewController.h"

@interface UpcomingScheduleViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate,ScheduleDetailViewControllerDelegate>

@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) FSCalendarAppearance *appreance;
@property (strong, nonatomic) IBOutlet UITableView *tblvSchedule;
@property (strong, nonatomic) NSMutableArray *arrScheduleDates;
@property (strong, nonatomic) NSArray *arrUpcomingSchedule;

@property ACCScheduleCell *scheduleCell;
@end

@implementation UpcomingScheduleViewController
@synthesize calendar,appreance,tblvSchedule,arrScheduleDates,arrUpcomingSchedule,scheduleCell;

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
    
    tblvSchedule.alwaysBounceVertical = NO;
    tblvSchedule.separatorColor = [UIColor clearColor];
    
    arrScheduleDates = [[NSMutableArray alloc]init];
    [self setCalendarAppreance];
    
    //[self getUpcomingServiceList:[NSDate date]];
    [self getUpcomingServiceList:calendar.currentPage];
}

-(void)setCalendarAppreance
{
    [calendar setCurrentPage:[NSDate date] animated:YES];
   
    calendar.allowsMultipleSelection                = YES;
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    calendar.appearance.weekdayFont           = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
    
    calendar.appearance.subtitleFont          = [UIFont fontWithName:@"OpenSans-Regular" size:15.0f];
    
    UIButton *previousButton = [[UIButton alloc]init];
    
    previousButton.frame = CGRectMake(0, 10, 50, 20);
    previousButton.backgroundColor = [UIColor whiteColor];

    [previousButton setImage:[UIImage imageNamed:@"prevCal"] forState:UIControlStateNormal];
    
    [previousButton addTarget:self action:@selector(btnPreviousTap:) forControlEvents:UIControlEventTouchUpInside];
    [calendar addSubview:previousButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-50-5, 10, 50, 20);
    nextButton.backgroundColor = [UIColor whiteColor];
    
    [nextButton setImage:[UIImage imageNamed:@"nextCal"] forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(btnNextTap:) forControlEvents:UIControlEventTouchUpInside];
    [calendar addSubview:nextButton];
}

-(void)getServiceDates
{
    for (int i = 0; i< arrUpcomingSchedule.count; i++)
    {
        ACCSchedule *schedule = arrUpcomingSchedule[i];
        NSString * date = [NSString stringWithFormat:@"%@-%@-%@",schedule.scheduleYear,schedule.scheduleMonth,schedule.scheduleDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //yyyy-MM-dd
        
        NSDate *yourDate = [dateFormatter dateFromString:date];
        [arrScheduleDates addObject:yourDate];
        [calendar selectDate:yourDate];
    }
}

#pragma mark - WebService Methods
-(void)getUpcomingServiceList:(NSDate *)date
{
//    NSString *month = [NSString stringWithFormat:@"%ld",(long)[calendar monthOfDate:date]];
//    NSString *year  = [NSString stringWithFormat:@"%ld",(long)[calendar yearOfDate:date]];
    
    NSDictionary *serviceInfo = @{
                                    UKeyClientID         : ACCGlobalObject.user.ID,
//                                  SKeyMonth            : month,
//                                  SKeyYear             : year
                                 };
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getUpcomingScheduleList:serviceInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *serviceList)
         {
             arrUpcomingSchedule = serviceList.mutableCopy;
             
             if (response.code == RCodeSuccess)
             {
                 tblvSchedule.backgroundView = nil;
             }
             else if(response.code == RCodeNoData)
             {
                 tblvSchedule.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSchedule.height];
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
             
             [tblvSchedule reloadData];
             
             [SVProgressHUD dismiss];
         }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - CalendarDelegate Methods

-(BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    return NO;
}

-(void)calendarCurrentPageDidChange:(FSCalendar *)calendarL
{
    [self getUpcomingServiceList:calendar.currentPage];
}

-(BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date
{
    return NO;
}

-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate date];
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUpcomingSchedule.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    scheduleCell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell" forIndexPath:indexPath];
    scheduleCell.selectionStyle = UITableViewCellSelectionStyleNone;
    ACCSchedule *schedule = arrUpcomingSchedule[indexPath.row];
    [scheduleCell setCellData:schedule];
    return scheduleCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSchedule *schedule = arrUpcomingSchedule[indexPath.row];
    
    if ([schedule.scheduleStatus isEqualToString:@"Scheduled"])
    {
        ScheduleDetailViewController *sdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleDetailViewController"];
        sdvc.scheduleId = schedule.serviceID;
        sdvc.notificationId = @"";
        sdvc.delegate = self;
        [self.navigationController pushViewController:sdvc animated:YES];
    }
}

#pragma mark - Event Methods
- (IBAction)btnPreviousTap:(id)sender
{
    NSDate *currentDate = calendar.currentPage;
    NSDate *previousDate;
    
    previousDate   = [calendar dateBySubstractingMonths:1 fromDate:currentDate];
   
    [calendar setCurrentPage:previousDate animated:YES];
}

- (IBAction)btnNextTap:(id)sender
{
    NSDate *currentDate = calendar.currentPage;
    NSDate *previousDate;
    
    previousDate   = [calendar dateByAddingMonths:1 toDate:currentDate];
    
    [calendar setCurrentPage:previousDate animated:YES];
}

- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}

#pragma mark - ScheduleDetailViewControllerDelegate Method
-(void)rescheduleSuccess:(NSString *)message
{
    [self showAlertWithMessage:message];
}
@end
