//
//  PastServicesViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "PastServicesViewController.h"

@interface PastServicesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *arrServices;
@property (strong, nonatomic) IBOutlet UITableView *tblvService;
@property ACCServiceCell *serviceCell;
@property (strong, nonatomic) ACCLoadMoreCell *loadMoreCell;
@property (nonatomic) NSString *pageNo;
@end

@implementation PastServicesViewController
@synthesize arrServices, tblvService, serviceCell,loadMoreCell,pageNo;

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
    pageNo = @"1";
    tblvService.alwaysBounceVertical = NO;
    tblvService.separatorColor = [UIColor clearColor];
    arrServices = [[NSMutableArray alloc]init];
    [self getServiceList];
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = arrServices.count;
    
    if(numberOfRows > 0)
    {
        numberOfRows = arrServices.count + 1;
    }
    
    return numberOfRows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < arrServices.count)
    {
        if (arrServices.count > 0)
        {
            serviceCell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell" forIndexPath:indexPath];
            serviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            ACCService *service = [[ACCService alloc]initWithDictionary:arrServices[indexPath.item]];
            [serviceCell setCellData:service];
        }
        return serviceCell;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < arrServices.count)
    {
        PastServiceDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PastServiceDetailViewController"];
        viewController.serviceId = [arrServices[indexPath.item] valueForKey:GKeyId];
        [self.navigationController pushViewController:viewController animated:YES];
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
        
        [self performSelector:@selector(getServiceList) withObject:nil afterDelay:0.5];
    }
}
#pragma mark - WebService Methods
-(void)getServiceList
{
    if ([ACCUtil reachable])
    {
        //[SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyClientID : ACCGlobalObject.user.ID,
                               GKeyPageNo   : pageNo
                               };
        
        if ([pageNo isEqualToString:@"1"])
        {
            [SVProgressHUD show];
        }
        
        [ACCWebServiceAPI getPastServiceList:dict completionHandler:^(ACCAPIResponse *response, NSMutableArray *serviceList, NSString *pageNumber)
        {
            if (response.code == RCodeSuccess)
            {
                if(serviceList.count == 0)
                {
                    arrServices = serviceList.mutableCopy;
                }
                else
                {
                    [arrServices addObjectsFromArray:serviceList];
                }
                
                [SVProgressHUD dismiss];
                [tblvService reloadData];
                
                loadMoreCell.hidden = YES;
                pageNo = pageNumber;
                tblvService.backgroundView = nil;
            }
            else if (response.code == RCodeNoData)
            {
                if(arrServices.count == 0)
                {
                    tblvService.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvService.height];
                    loadMoreCell.hidden = YES;
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
                loadMoreCell.hidden= YES;
                tblvService.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvService.height];
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
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}

@end
