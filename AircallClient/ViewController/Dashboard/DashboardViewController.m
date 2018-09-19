 //
//  DashboardViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/7/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()<PagedFlowViewDelegate,PagedFlowViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet PagedFlowView *vwFlow;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property CGFloat height;
@property CGFloat width;
@property (strong, nonatomic) IBOutlet UITableView *tblvNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIView *vwNoData;
@property (weak, nonatomic) IBOutlet UILabel *lblNoDataName;

@property (weak, nonatomic) IBOutlet UILabel *lblUnitAddress;

@property (strong, nonatomic) IBOutlet UIView *vwWithData;
@property (strong, nonatomic) IBOutlet UIButton *btnBadge;

@property (strong, nonatomic) IBOutlet UILabel *lblNoNotification;
@property (strong, nonatomic) IBOutlet UIScrollView *scrlvDashboard;
@property NSMutableArray *arrUnitData;
@property NSMutableArray *arrNotoficationData;
@property BOOL isOldUnitsAvailable;
@property BOOL isProcessingUnitsAvailable;
@property BOOL isFromAccountSettings;
@property NSString *defAddress;
@end

@implementation DashboardViewController
@synthesize vwFlow,pageControl,height,width,tblvNotification,lblName,vwNoData,vwWithData,arrUnitData,arrNotoficationData,scrlvDashboard,isOldUnitsAvailable,lblNoDataName,isProcessingUnitsAvailable,btnBadge,lblNoNotification,isFromAccountSettings,defAddress,lblUnitAddress;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getData)
                                                 name:@"getDashboardData"
                                               object:nil];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self prepareView];
    [tblvNotification reloadData];
    //tblvNotification.backgroundView = [ACCUtil viewNoDataWithMessage:@"No Notifications" andImage:nil withFontColor:[UIColor lightGrayColor] withHeight:100];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
//    if (ACCGlobalObject.isOnce)
//    {
//        ACCGlobalObject.isOnce = NO;
//        [self showAlertWithMessage:ACCThankYou];
//        
////        WelcomeViewController *viewController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
////        viewController.providesPresentationContextTransitionStyle = YES;
////        viewController.definesPresentationContext = YES;
////        [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
////        [self.navigationController presentViewController:viewController animated:NO completion:nil];
//        
//    }
    
    if (isFromAccountSettings)
    {
        [self openSideBar];
    }
    
    arrUnitData = nil;
    arrUnitData = [[NSMutableArray alloc]init];
    
    [self getData];

    lblName.text = [NSString stringWithFormat:@"Hello %@",ACCGlobalObject.user.firstName];
    
    lblNoDataName.text = [NSString stringWithFormat:@"Hello %@",ACCGlobalObject.user.firstName];
    
    tblvNotification.alwaysBounceVertical = NO;
    
    self.vwFlow.delegate = self;
    self.vwFlow.dataSource = self;
    self.vwFlow.pageControl = self.pageControl;
//    self.vwFlow.minimumPageAlpha = 0;
//    self.vwFlow.minimumPageScale = 0.9;
    
    tblvNotification.separatorColor = [UIColor clearColor];
}
-(void)resizeFrames
{
    tblvNotification.frame = CGRectMake(tblvNotification.x, tblvNotification.y, tblvNotification.width, tblvNotification.contentSize.height);
    scrlvDashboard.contentSize = CGSizeMake(scrlvDashboard.width, tblvNotification.y + tblvNotification.contentSize.height);
}

-(void)setBadgeCount:(NSDictionary*)dict
{
    ACCGlobalObject.notificationCount = [dict[NKeyNotificationCount] integerValue];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:ACCGlobalObject.notificationCount];
    
    NSString *badgeValue = [@(ACCGlobalObject.notificationCount) stringValue];
   
    btnBadge.badgeValue   = [dict[NKeyNotificationCount] stringValue];
    if ([badgeValue isEqualToString:@"0"])
    {
        btnBadge.badgeValue = @"";
    }
    btnBadge.badgeOriginX = (CGRectGetWidth(btnBadge.frame) / 2);
    btnBadge.badgeOriginY = -10;
    btnBadge.badgeBGColor = [UIColor appGreenColor];
    btnBadge.badgeFont    = [UIFont fontWithName:@"OpenSans" size:12];
    btnBadge.badgeMinSize = 8;
    btnBadge.shouldHideBadgeAtZero = YES;
}
#pragma mark - WebService Methods
-(void)getData
{
    if ([ACCUtil reachable])
    {
        NSDictionary * userId = @{
                                    UKeyClientID  : ACCGlobalObject.user.ID
                                 };
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getDashboardData:userId completionHandler:^(ACCAPIResponse *response, NSDictionary *dataList)
         {
             if (response.code == RCodeSuccess)
             {
                [self setBadgeCount:dataList];
                 
                 NSArray *arrUnits = dataList[UKeyUnits];
                 arrUnitData = @[].mutableCopy;
                 
                 isOldUnitsAvailable = [dataList[UKeyHasPaymentFailedUnits] boolValue];
                 
                 isProcessingUnitsAvailable = [dataList[UKeyHasPaymentProcessingUnits] boolValue];
                 
                 defAddress = dataList [AKeyDefaultAddress];
                 
                 [arrUnits enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull units, NSUInteger idx, BOOL*  _Nonnull stop)
                  {
                      ACCUnit *unit = [[ACCUnit alloc]iniWithDictionary:units];
                      [arrUnitData addObject:unit] ;
                      [vwFlow reloadData];
                      [SVProgressHUD dismiss];
                  }];
                 
                 if (arrUnitData.count > 0)
                 {
                     vwNoData.hidden   = YES;
                     scrlvDashboard.hidden = NO;
                     lblUnitAddress.text = [NSString stringWithFormat:@"Your Units @ %@",defAddress];
                 }
                 else
                 {
                     scrlvDashboard.hidden = YES;
                     vwNoData.hidden   = NO;
                     [SVProgressHUD dismiss];
                 }
                 
                 NSArray *arrNotifications = dataList[NKeyNotifications];
                 arrNotoficationData = @[].mutableCopy;
                 
                 for (int i = 0; i < arrNotifications.count; i++)
                 {
                     ACCNotification *notification = [[ACCNotification alloc]initWithDictionary:arrNotifications[i]];
                     [arrNotoficationData addObject:notification];
                 }
                 
                 if (arrNotoficationData.count == 0)
                 {
                    lblNoNotification.hidden = NO;
                    tblvNotification.backgroundView = [ACCUtil viewNoDataWithMessage:@"No recent notifications" andImage:nil withFontColor:[UIColor lightGrayColor] withHeight:300];
                 }
                 
                 [tblvNotification reloadData];
                 [self resizeFrames];

//                 else
//                 {
//                     [tblvNotification reloadData];
//                     [self resizeFrames];
//                 }
             }
             else if(response.code == RCodeNoData)
             {
                 tblvNotification.backgroundView = [ACCUtil viewNoDataWithMessage:@"No recent notifications" andImage:nil withFontColor:[UIColor lightGrayColor] withHeight:40];
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
                 if (response.message)
                 {
                     [self showAlertWithMessage:response.message];
                 }
                 else
                 {
                     [self showAlertWithMessage:response.error.localizedDescription];
                 }
             }
             
              [SVProgressHUD dismiss];
         }];
       
    }
    else
    {
        [vwFlow reloadData];
        [tblvNotification reloadData];
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)getFailedPaymentUnits
{
    NSDictionary *clientInfo = @{
                                 UKeyClientID : ACCGlobalObject.user.ID
                                 };
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getFailedPaymentUnits:clientInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *unitInfo,NSString * unitInActiveMessage)
         {
             if (response.code == RCodeSuccess)
             {
                 SummaryViewController *svc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SummaryViewController"];
                 svc.dictUnitInfo = unitInfo;
                 svc.msgInactivePlan = unitInActiveMessage;
                 [self.navigationController pushViewController:svc animated:YES];
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
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)deleteOldUnits
{
    NSDictionary *deleteInfo = @{
                                 UKeyClientID : ACCGlobalObject.user.ID
                                };
    
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI deleteOldUnits:deleteInfo completionHandler:^(ACCAPIResponse *response)
         {
             if (response.code == RCodeSuccess)
             {
                 AddUnitViewController *auvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitViewController"];
                 [self.navigationController pushViewController:auvc animated:YES];
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
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - Event Methods
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}

- (IBAction)btnNotificationTap:(id)sender
{
    NotificationListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationListViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnAddressTap:(id)sender
{
    AddressListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnAddUnitTap:(id)sender
{
    if ([ACCUtil reachable])
    {
        if (isProcessingUnitsAvailable)
        {
            [self showAlertFromWithMessageWithSingleAction:ACCProcessingUnitsAvailable andHandler:^(UIAlertAction * _Nullable action)
             {
                 [self getData];
                 
             }];
        }
//        else if (isOldUnitsAvailable)
//        {
//            [ACCUtil showAlertFromControllerWithDoubleAction:self withMessage:ACCOldUnitsAvailable andHandler:^(UIAlertAction * _Nullable action)
//             {
//                 [self getFailedPaymentUnits];
//             }
//             andNoHandler:^(UIAlertAction * _Nullable action)
//             {
//                 [self deleteOldUnits];
//             }];
//        }
        else
        {
            AddUnitViewController *auvc = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AddUnitViewController"];
            [self.navigationController pushViewController:auvc animated:YES];
        }
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}
- (IBAction)btnSeeAllTap:(id)sender
{
    MyUnitViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"MyUnitViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;
{
    height = [UIScreen mainScreen].bounds.size.width / 1.4;
    width  = [UIScreen mainScreen].bounds.size.width / 1.9;
    return CGSizeMake(floor(width) ,floor(height));
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index
{
    //  NSLog(@"Scrolled to page # %ld", (long)index);
}

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index
{
   // NSLog(@"Tapped on page # %ld", (long)index);
    if (arrUnitData.count > 0)
    {
        ACCUnit *unit = arrUnitData[index];
        UnitDetailViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UnitDetailViewController"];
        viewController.unitId = unit.unitsId;
        viewController.isFromDashboard = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark PagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    return arrUnitData.count;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    ACCUnit *unit = arrUnitData[index];
    UIImageView *imgvBackground = (UIImageView *)[flowView dequeueReusableCell];
    UIImageView *imgvStatus;
    UILabel *lblUnit;
    UILabel *lblStatus;
    
//    if (!imgvBackground)
//    {
        imgvBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imgvBackground.contentMode = UIViewContentModeScaleAspectFill;
        imgvBackground.layer.masksToBounds = YES;
        imgvStatus = [[UIImageView alloc]init];
        lblUnit = [[UILabel alloc]init];
        lblStatus =[[UILabel alloc]init];
        imgvBackground.image = [UIImage imageNamed:@"unitBackground"];
        imgvStatus.frame = CGRectMake(width / 2.3, height / 1.95, 25, 25);
        imgvStatus.layer.cornerRadius = imgvStatus.height / 2;
        lblUnit.frame = CGRectMake(3, height / 1.5, width - 4, 40);
        lblStatus.frame = CGRectMake(0, height / 1.25, width, 35);
        lblUnit.textColor = [UIColor blackColor];
        lblStatus.textColor = [UIColor blackColor];
        [lblUnit setFont:[UIFont fontWithName:@"OpenSans" size: width / 7]];
        [lblStatus setFont:[UIFont fontWithName:@"OpenSans" size: width / 14]];
        lblUnit.textAlignment = NSTextAlignmentCenter;
        lblStatus.textAlignment = NSTextAlignmentCenter;
        
        [imgvBackground addSubview:imgvStatus];
        [imgvBackground addSubview:lblUnit];
        [imgvBackground addSubview:lblStatus];

  //  }
    
    lblUnit.text = unit.unitName;
    lblStatus.text = unit.status;
    if([unit.status isEqualToString:@"Service Soon"])
    {
        imgvStatus.image = [UIImage imageNamed:@"serviceUnit"];
    }
    else if ([unit.status isEqualToString:@"Serviced"])
    {
        imgvStatus.image = [UIImage imageNamed:@"workingUnit"];
    }
    else if ([unit.status isEqualToString:@"Need Repair"])
    {
        imgvStatus.image = [UIImage imageNamed:@"brokenUnit"];
    }

    return imgvBackground;
    
}

- (IBAction)pageControlValueDidChange:(id)sender
{
    pageControl = sender;
    [self.vwFlow scrollToPage:pageControl.currentPage];
    [self.vwFlow scrollToPage:pageControl.currentPage];
}


#pragma mark - UITableView DataSource & Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNotoficationData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCNotificationCell *notificationcell;
    
    ACCNotification *notification = arrNotoficationData[indexPath.item];
    
    if ([notification.notificationType isEqualToString:@"1"])
    {
        notificationcell = [tableView dequeueReusableCellWithIdentifier:@"upcomingNotificationCell" forIndexPath:indexPath];
    }
    else
    {
        notificationcell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        [notificationcell.contentView addSubview:lineView];
    }
    
    [notificationcell setCellData:notification isFromNotificationList:NO];
        
    notificationcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return notificationcell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCNotification *notification = arrNotoficationData[indexPath.item];
    
    if(![notification.notificationType isEqualToString:@"1"])
    {
        NSString *str =[NSString stringWithFormat:@"%@", notification.message];
        
        CGSize constraint;
        
        if (notification.serviceManImage.absoluteString.length != 0)
        {
            constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width/1.45 , FLT_MAX);
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
            font = [UIFont systemFontOfSize:13.5];
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
        {
            font = [UIFont systemFontOfSize:14.5];
        }
        else
        {
            font = [UIFont systemFontOfSize:15.5];
        }
        
    
    CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil].size;
    return size.height + 40;
    }
    else
    {
        UITableViewCell *cell =[tblvNotification dequeueReusableCellWithIdentifier:@"upcomingNotificationCell"];
        return cell.bounds.size.height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < arrNotoficationData.count)
    {
        ACCNotification *notification = arrNotoficationData[indexPath.item];
        if ((![notification.serviceID isEqualToString:@"0"] && ![notification.notificationType isEqualToString:@"9"]) || [notification.notificationType isEqualToString:@"11"])
        {
            [ACCUtil openControllerOnNotification:notification.notificationType withSericeId:notification.serviceID andNotificationId:notification.ID];
        }
    }
}

@end
