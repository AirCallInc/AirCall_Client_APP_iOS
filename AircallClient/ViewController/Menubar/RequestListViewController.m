//
//  RequestListViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "RequestListViewController.h"

@interface RequestListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tblvRequests;
@property NSMutableArray *arrRequests;
@property NSInteger noOfRows;
@property UIButton *btnSelectedHeader;
@property BOOL isShowingList;
@property UIImageView *imageOnClick;
@property BOOL isFirstTime;
@end

@implementation RequestListViewController
@synthesize tblvRequests,arrRequests,noOfRows,btnSelectedHeader,isShowingList,imageOnClick,isFirstTime;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    isShowingList = NO;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self prepareView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Webservice Methods
-(void)setRequestData
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID
                              };
        
        [ACCWebServiceAPI getRequestList:dict completionHandler:^(ACCAPIResponse *response, NSMutableArray *requests)
        {
            [SVProgressHUD dismiss];
            
            if (response.code == RCodeSuccess)
            {
                arrRequests = requests.mutableCopy;
                [tblvRequests reloadData];
            }
            else if (response.code == RCodeNoData)
            {
                tblvRequests.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvRequests.height];
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

-(void)deleteRequest:(NSDictionary*)dictRequestInfo section:(NSInteger)sectionNo
{
    [SVProgressHUD show];
    
    [ACCWebServiceAPI deleteRquest:dictRequestInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *requests)
     {
         [SVProgressHUD dismiss];
         
         if (response.code == RCodeSuccess)
         {
             arrRequests = requests.mutableCopy;

             if (btnSelectedHeader.tag > arrRequests.count - 1)
             {
                 UIButton *random = (UIButton *)[self.view viewWithTag:0];
                 [self sectionButtonTapped:random];
             }
             else
             {
                 NSDictionary *dict = arrRequests[btnSelectedHeader.tag];
                 noOfRows = [dict[SKeyServices] count];
             }
        
             [self showAlertWithMessage:response.message];
             
             if (arrRequests.count == 0)
             {
                  tblvRequests.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvRequests.height];
             }
            
         }
         else if (response.code == RCodeNoData)
         {
             arrRequests = nil;
              [self showAlertWithMessage:response.message];
             tblvRequests.backgroundView = [ACCUtil viewNoDataWithMessage:ACCNoRecordFound andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvRequests.height];
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
         
         [tblvRequests reloadData];
         
     }];

}

#pragma mark - Helper Methods
-(void)prepareView
{
    //isShowingList = NO;
    tblvRequests.separatorColor = [UIColor clearColor];
    tblvRequests.alwaysBounceVertical = NO;
    arrRequests = [[NSMutableArray alloc]init];
    [tblvRequests reloadData];
    [self setRequestData];
}

-(NSIndexPath *)getIndexpathFromButton:(UIButton *)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:tblvRequests];
    NSIndexPath *indexPath = [tblvRequests indexPathForRowAtPoint:rootViewPoint];
    return indexPath;
}

#pragma mark - UITableView DataSouce & Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrRequests.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 48)];
    
    UIButton *btnSection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 48)];

    imageOnClick = [[UIImageView alloc]init];

    btnSection.tag = section;
    
    if (!isFirstTime)
    {
        isFirstTime = YES;
        [self sectionButtonTapped:btnSection];
    }
    
//    NSDictionary *dict = arrRequests[section];
//    
//    NSMutableArray *arrServices = [dict[SKeyServices]mutableCopy];
//    if (arrServices.count > section)
//    {
//        
//        NSInteger addressId = [[arrServices[section] valueForKey:AKeyAddressId]integerValue];
//        if (addressID == addressId && isFromRequestForm)
//        {
//            isFromRequestForm = NO;
//            isFirstTime = YES;
//            [self sectionButtonTapped:btnSection];
//        }
//    }
//    
//    
//     if (!isFirstTime)
//    {
//        isFirstTime = YES;
//        [self sectionButtonTapped:btnSection];
//    }

    if (btnSection.tag == btnSelectedHeader.tag)
    {
        if(isShowingList)
        {
            imageOnClick.image = [UIImage imageNamed:@"minusColor"];
        }
        else
        {
            imageOnClick.image = [UIImage imageNamed:@"plusColor"];
        }
    }
    else
    {
        imageOnClick.image = [UIImage imageNamed:@"plusColor"];
    }
    
    imageOnClick.frame = CGRectMake(btnSection.frame.size.width - 25, btnSection.height / 2.7, 15, 15);
    
    [btnSection setTitle:arrRequests[section][AKeyAddress] forState:UIControlStateNormal];
    
    [btnSection addTarget:self action:@selector(sectionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [btnSection setTitleColor:[UIColor appGreenColor] forState:UIControlStateNormal];
    [btnSection setBackgroundColor:[UIColor selectedBackgroundColor]];
    
    [view addSubview:btnSection];
    [view addSubview:imageOnClick];
    return view;
}

- (void)sectionButtonTapped:(UIButton *)button
{
    if (!isShowingList)
    {
        btnSelectedHeader = button;
        isShowingList = YES;
        NSDictionary *dict = arrRequests[btnSelectedHeader.tag];
        noOfRows = [dict[SKeyServices] count];
    }
    else
    {
        if (button.tag == btnSelectedHeader.tag)
        {
            isShowingList = NO;
            noOfRows = 0;
        }
        else
        {
            btnSelectedHeader = button;
            isShowingList = YES;
            NSDictionary *dict = arrRequests[btnSelectedHeader.tag];
            noOfRows = [dict[SKeyServices] count];
        }
    }
    
   [tblvRequests reloadData];
    
    NSRange range = NSMakeRange(button.tag, 1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [tblvRequests reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == btnSelectedHeader.tag)
    {
        return noOfRows;
    }
    else
    {
        return 0;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCRequestCell *cell;
    
    NSDictionary *dict = arrRequests[indexPath.section];
    
    NSMutableArray *arrServices = [dict[SKeyServices]mutableCopy];
    
    BOOL isallowDelete = [[arrServices[indexPath.item] valueForKey:SKeyAllowDelete] boolValue];

    if (isallowDelete)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"editRequestCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"requestCell" forIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblUnit.text = [arrServices[indexPath.item] valueForKey:AKeyAddress];
    cell.lblRequestInfo.text = [arrServices[indexPath.item] valueForKey:SKeyMessage];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestDetailViewController *rdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestDetailViewController"];
    NSDictionary *dict = arrRequests[indexPath.section];
    
    NSMutableArray *arrServices = [dict[SKeyServices]mutableCopy];
    
    NSString *serviceId = [arrServices[indexPath.item] valueForKey:UKeyID];
    
    rdvc.serviceId = serviceId;
    [self.navigationController pushViewController:rdvc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // BOOL isallowDelete = [[arrRequests[indexPath.item] valueForKey:SKeyAllowDelete] boolValue];
    
    NSDictionary *dict = arrRequests[indexPath.section];
    
    NSMutableArray *arrServices = [dict[SKeyServices]mutableCopy];
    
    BOOL isallowDelete = [[arrServices[indexPath.item] valueForKey:SKeyAllowDelete] boolValue];

    if (isallowDelete)
    {
        if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone5)
        {
            return [UIScreen mainScreen].bounds.size.height/4.5;
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
        {
            return [UIScreen mainScreen].bounds.size.height/5.3;
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6Plus)
        {
            return [UIScreen mainScreen].bounds.size.height/5.8;
        }
        else
        {
            return [UIScreen mainScreen].bounds.size.height/4.5;
        }
        return 0;
    }
    else
    {
        if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone5)
        {
            return [UIScreen mainScreen].bounds.size.height/7.0;
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6)
        {
            return [UIScreen mainScreen].bounds.size.height/8.4;
        }
        else if (ACCGlobalObject.screenSizeType == ACCScreenSizeTypeiPhone6Plus)
        {
            return [UIScreen mainScreen].bounds.size.height/9.3;
        }
        else
        {
            return [UIScreen mainScreen].bounds.size.height/5.3;
        }
        return 0;
    }
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnEditTap:(id)sender
{
    NSIndexPath *index = [self getIndexpathFromButton:sender];
    
    NSDictionary *dict = arrRequests[index.section];
    
    NSMutableArray *arrServices = [dict[SKeyServices]mutableCopy];
    
    NSString *serviceId = [arrServices[index.item] valueForKey:GKeyId];
    
    RescheduleRequestViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RescheduleRequestViewController"];
    viewController.serviceId = serviceId;
    viewController.noOfUnits = [[arrServices[index.item] valueForKey:SKeyUnitsCount] integerValue];
    viewController.isFromRequestList = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate *dateFromString = [dateFormatter dateFromString:[arrServices[index.item] valueForKey:SKeyRequestedDate]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"]; //YYYY-MM-dd
    NSString * convertedString = [dateFormatter stringFromDate:dateFromString];
    viewController.selectedDate = convertedString;
    viewController.selectedTimeSlot = [arrServices[index.item] valueForKey:SKeyRequestedTime];
    viewController.purposeOfVisit = [[arrServices[index.item] valueForKey:SKeyVisitPurpose] stringValue];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnDeleteTap:(id)sender
{
    NSIndexPath *index = [self getIndexpathFromButton:sender];
    
    NSDictionary *dict = arrRequests[index.section];
    
    NSMutableArray *arrServices = [dict[SKeyServices]mutableCopy];

    NSString *serviceId = [arrServices[index.item] valueForKey:GKeyId];
    
    NSDictionary *dictRequestInfo = @{
                                      UKeyClientID : ACCGlobalObject.user.ID,
                                      SKeyID       : serviceId
                                      };
    
    [self showAlertFromWithMessage:ACCDeleteConformation andHandler:^(UIAlertAction * _Nullable action)
     {
         if ([ACCUtil reachable])
         {
             [self deleteRequest:dictRequestInfo section:index.section];
         }
         else
         {
             [self showAlertWithMessage:ACCNoInternet];
         }
         
     }];
}

@end
