//
//  NotificationListViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "NotificationListViewController.h"

@interface NotificationListViewController ()<UITableViewDataSource,UITableViewDelegate,ScheduleDetailViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvNotification;
@property NSMutableArray *arrNotifications;
@property (strong, nonatomic) ACCLoadMoreCell *loadMoreCell;
@property (nonatomic) NSString *pageNumber;
@end

@implementation NotificationListViewController
@synthesize tblvNotification,arrNotifications,loadMoreCell,pageNumber;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [self prepareView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Helper Method
-(void)prepareView
{
    tblvNotification.separatorColor = [UIColor clearColor];
    [tblvNotification setAlwaysBounceVertical:NO];
    pageNumber = @"1";
    arrNotifications = [[NSMutableArray alloc]init];
    [self getNotificationList];
}

-(void)openControllerOnNotification:(NSString * _Nullable)notificationType withSericeId:(NSString * _Nullable)serviceId andNotificationId:(NSString *)notiId
{
    if ([notificationType isEqualToString:@"1"] || [notificationType isEqualToString:@"10"]|| [notificationType isEqualToString:@"16"]) // Approval, Service Scheduled, Periodic Reminder
    {
        ScheduleDetailViewController *sdvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ScheduleDetailViewController"];
        
        if ([notificationType isEqualToString:@"1"])
        {
            sdvc.scheduleType = @"ServiceApproval";
        }
        
        sdvc.notificationId = notiId;
        sdvc.scheduleId = serviceId;
        sdvc.delegate = self;
        [self.navigationController pushViewController:sdvc animated:YES];
    }
    else if([notificationType isEqualToString:@"3"] || [notificationType isEqualToString:@"21"]) // No Show Detail with payment, Late Cancelled
    {
        NoShowViewController *nsvc = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NoShowViewController"];
        nsvc.serviceId = serviceId;
        nsvc.notificationId = notiId;
        [self.navigationController pushViewController:nsvc animated:YES];
    }
    else if ([notificationType isEqualToString:@"4"]) // Part Purchased
    {
        BillingDetailViewController *bdvc = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"BillingDetailViewController"];
        bdvc.billingID = serviceId;
        [self.navigationController pushViewController:bdvc animated:YES];
    }
    else if([notificationType isEqualToString:@"5"]) // Rate Service
    {
        PastServiceDetailViewController *udvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"PastServiceDetailViewController"];
        udvc.serviceId = serviceId;
        udvc.notificationId = notiId;
        [self.navigationController pushViewController:udvc animated:YES];
    }
    else if([notificationType isEqualToString:@"6"]) // Expiration Of Card
    {
        AddCardViewController *acvc = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"AddCardViewController"];
        acvc.cardId = serviceId;
        acvc.notificationId = notiId;
        acvc.strHeader = @"Edit Card";
        [self.navigationController pushViewController:acvc animated:YES];
    }
    else if([notificationType isEqualToString:@"8"] || [notificationType isEqualToString:@"11"]) //Plan Expiration, Failed Payment
    {
        SummaryViewController *svc  = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SummaryViewController"];
        svc.isFromNotificationList = YES;
        svc.notificationId = notiId;
        svc.unitId = serviceId;
        
        if ([notificationType isEqualToString:@"11"]) // Failed Payment
        {
            svc.notificationType = @"FailedPayment";
        }
        else
        {
            svc.isPlanRenewal = YES;
        }
        
        [self.navigationController pushViewController:svc animated:YES];
    }
    else if ([notificationType isEqualToString:@"17"])// invoice failed
    {
        BillingDetailViewController *viewController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"BillingDetailViewController"];
        viewController.billingID = serviceId;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
//        NotificationListViewController *nlvc = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
//        [self.navigationController pushViewController:nlvc animated:YES];
    }
    
    /* Friendly Reminders
     2 - Admin / Friendly Notifications
     9 - Plan Renew
     */
}

#pragma mark - WebService Methods
-(void)getNotificationList
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               GKeyPageNo    : pageNumber
                               };
        if ([pageNumber isEqualToString:@"1"])
        {
            [SVProgressHUD show];
        }
        
        [ACCWebServiceAPI getNotificationList:dict completion:^(ACCAPIResponse *response, NSMutableArray *notification, NSString *pageNo)
        {
            if (response.code == RCodeSuccess)
            {
                if(notification.count == 0)
                {
                    arrNotifications = notification.mutableCopy;
                }
                else
                {
                    [arrNotifications addObjectsFromArray:notification];
                }
                
                [tblvNotification reloadData];
                
                loadMoreCell.hidden = YES;
                pageNumber = pageNo;
            }
            else if (response.code == RCodeNoData)
            {
                if(arrNotifications.count == 0)
                {
                    arrNotifications = notification.mutableCopy;
                    tblvNotification.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvNotification.height];
                    [tblvNotification reloadData];
                }
                else
                {
                    loadMoreCell.indicator.hidden = YES;
                    loadMoreCell.lblTitle.text = ACCTextNoMoreData;
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
                loadMoreCell.hidden = YES;
                tblvNotification.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvNotification.height];
            }
            
            [loadMoreCell.indicator stopAnimating];
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}
#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource & Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = arrNotifications.count;
    
    if(numberOfRows > 0)
    {
        numberOfRows = arrNotifications.count + 1;
    }
    
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrNotifications.count)
    {
          ACCNotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
            notificationCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ACCNotification *notification = arrNotifications[indexPath.item];
            
            [notificationCell setCellData:notification isFromNotificationList:YES];
            
            UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
            [notificationCell.contentView addSubview:lineView];

        return notificationCell;
    }
    else
    {
        if(!loadMoreCell)
        {
            loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell" forIndexPath:indexPath];
        }
        return loadMoreCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item < arrNotifications.count)
    {
        ACCNotification *notification = arrNotifications[indexPath.item];
       
        NSString *str =[NSString stringWithFormat:@"%@\n\n%@", notification.message,notification.notificationDateTime];

        CGSize constraint;
        
        if (notification.serviceManImage.absoluteString.length != 0)
        {
            constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.5 , FLT_MAX);
        }
        else
        {
            constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.30 , FLT_MAX);
        }
        
        UIFont *font;
        
        if(ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone4)
        {
            font = [UIFont systemFontOfSize:7];
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone5)
        {
            font = [UIFont systemFontOfSize:13.5];//12
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
        {
            font = [UIFont systemFontOfSize:14.5];//13.5
        }
        else
        {
            font = [UIFont systemFontOfSize:15.5];//14.7
        }
        
        CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
        return size.height + 30;
    }
    else if (indexPath.item == arrNotifications.count)
    {
        ACCLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        return cell.bounds.size.height;
    }
   
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < arrNotifications.count)
    {
        ACCNotification *notification = arrNotifications[indexPath.item];
        if ((![notification.serviceID isEqualToString:@"0"] && ![notification.notificationType isEqualToString:@"9"]) || [notification.notificationType isEqualToString:@"11"])
        {
            [self openControllerOnNotification:notification.notificationType withSericeId:notification.serviceID andNotificationId:notification.ID];
//             [ACCUtil openControllerOnNotification:notification.notificationType withSericeId:notification.serviceID andNotificationId:notification.ID];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell isKindOfClass:[ACCLoadMoreCell class]])
    {
        loadMoreCell.lblTitle.text = ACCTextLoading;
        
        loadMoreCell.hidden = NO;
        loadMoreCell.indicator.hidden = NO;
        
        [loadMoreCell.indicator startAnimating];
        
        [self performSelector:@selector(getNotificationList) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - ScheduleDetailViewControllerDelegate Method
-(void)rescheduleSuccess:(NSString *)message
{
    [self showAlertWithMessage:message];
}
@end
