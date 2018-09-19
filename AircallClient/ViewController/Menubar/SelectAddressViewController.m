//
//  SelectAddressViewController.m
//  AircallClient
//
//  Created by Manali on 28/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "SelectAddressViewController.h"

@interface SelectAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblvAddress;
@property NSMutableArray *arrAddress;
@property ACCAddress *addressDetail;

@end

@implementation SelectAddressViewController
@synthesize tblvAddress,arrAddress,addressDetail,delegate,selectedAddressId;

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
    arrAddress = [[NSMutableArray alloc]init];
    
    if([ACCUtil reachable])
    {
        [self getAddressList];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - Webservice methods
-(void)getAddressList
{
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getAddressListWithcompletioHandler:^(ACCAPIResponse *response, NSMutableArray *addressList)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             arrAddress = addressList.mutableCopy;
             [tblvAddress reloadData];
         }
         else if(response.code == RCodeNoData)
         {
             arrAddress = addressList.mutableCopy;
             
             tblvAddress.backgroundView = [ACCUtil viewNoDataWithMessage:ACCNoAddressAdded andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
             
             [tblvAddress reloadData];
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

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAddress.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
    
    addressDetail = arrAddress [indexPath.row];
    
    cell.lblDesc.text     = [NSString stringWithFormat:@"%@",addressDetail.address];
    
    cell.lblsubtitle.text = [NSString stringWithFormat:@"%@, %@ %@",addressDetail.cityName,addressDetail.stateName,addressDetail.zipcode];
    
    cell.imgvCheckmark.image = [UIImage imageNamed:@"tickmark"];
    
    if ([selectedAddressId isEqualToString:@""] && addressDetail.isDefaultAddress == YES)
    {
        selectedAddressId = addressDetail.addressId;
    }
    
    if([addressDetail.addressId isEqualToString:selectedAddressId])
    {
        cell.imgvCheckmark.hidden = NO;
        cell.backgroundColor      = [UIColor selectedBackgroundColor];
    }
    else
    {
        cell.imgvCheckmark.hidden = YES;
        cell.backgroundColor      = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imgvCheckmark.hidden = NO;
    cell.backgroundColor      = [UIColor selectedBackgroundColor];
    [self dismissViewControllerAnimated:YES completion:nil];
    addressDetail = arrAddress[indexPath.row];
    [delegate SelectionValue:addressDetail.addressId];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imgvCheckmark.hidden = YES;
    cell.backgroundColor      = [UIColor clearColor];
}


#pragma mark - Event methods
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
