//
//  AddressListViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "AddressListViewController.h"

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate,AddAddressViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvAddress;
@property NSMutableArray *arrAddress;

@end

@implementation AddressListViewController
@synthesize tblvAddress,arrAddress;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self prepareView];
}

#pragma mark -Helper Method
-(void)prepareView
{
    tblvAddress.alwaysBounceVertical = NO;
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

-(NSIndexPath *)getIndexpathFromButton:(UIButton *)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:tblvAddress];
    NSIndexPath *indexPath = [tblvAddress indexPathForRowAtPoint:rootViewPoint];
    return indexPath;
}

-(void)deleteAddress:(ACCAddress *)add
{
    if([ACCUtil reachable])
    {
        [self deleteAddressAtIndex:add.addressId];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}

-(void)openAddressViewController:(ACCAddress *)address isUPdate:(BOOL)ans isdeletable:(BOOL)isDelete
{
    AddAddressViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    viewController.delegate = self;
    viewController.address  = address;
    viewController.isEditAddress = ans;
    viewController.isAllowDelete = isDelete;
    viewController.addressCount = (NSInteger)arrAddress.count;
    [self.navigationController pushViewController:viewController animated:YES];
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
            
            tblvAddress.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
            
            [tblvAddress reloadData];
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

-(void)deleteAddressAtIndex:(NSString *)addId
{
    [SVProgressHUD show];
    
    NSDictionary *addressInfo = @{
                                  UKeyAddressId : addId,
                                  UKeyClientID  : ACCGlobalObject.user.ID
                                  };
   
    [ACCWebServiceAPI deleteAddressAtIndex:addressInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *arrAddressInfo)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            arrAddress = arrAddressInfo.mutableCopy;
            if (arrAddress.count == 0)
            {
                tblvAddress.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
            }
            [tblvAddress reloadData];
            [self showAlertWithMessage:response.message];
        }
        else if (response.code == RCodeNoData)
        {
            tblvAddress.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvAddress.height];
            [tblvAddress reloadData];
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

-(void)updateDefaultAddress:(NSIndexPath *)selectedIndexPath
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        ACCAddress *dAdd = arrAddress[selectedIndexPath.row];
        
        NSDictionary *updateInfo = @{
                                     AKeyAddressId : dAdd.addressId,
                                     AKeyIsDefault : @"true"
                                     };
        
        [ACCWebServiceAPI updateAddress:updateInfo completionHandler:^(ACCAPIResponse *response, NSMutableArray *arrAddresses)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 arrAddress = arrAddresses.mutableCopy;
                // [tblvAddress reloadData];
                 //[self showAlertWithMessage:response.message];
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
             [tblvAddress reloadData];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAddTap:(id)sender
{
    [self openAddressViewController:nil isUPdate:NO isdeletable:NO];
}
- (IBAction)btnEditTap:(UIButton *)sender
{
    NSIndexPath *path = [self getIndexpathFromButton:sender];

    ACCAddress *dAdd = arrAddress[path.row];
    
    [self openAddressViewController:dAdd isUPdate:YES isdeletable:dAdd.isAllowDelete];
}
- (IBAction)btnDeleteTap:(UIButton *)sender
{
    NSIndexPath *path = [self getIndexpathFromButton:sender];
    
    ACCAddress *dAdd = arrAddress[path.row];
    
    if (dAdd.isAllowDelete)
    {
        if (arrAddress.count > 1 && dAdd.isDefaultAddress)
        {
            [self showAlertWithMessage:ACCChooseAnotherAddress];
        }
        else
        {
            [self showAlertFromWithMessage:ACCDeleteConformation andHandler:^(UIAlertAction * _Nullable action)
             {
                 [self deleteAddress:dAdd];
             }];
        }
    }
    else
    {
        [self showAlertWithMessage:ACCDeleleUnitNotAllowed];
    }
}

#pragma mark - AddAddressViewController Delegate
-(void)AddressList:(NSMutableArray *)addressList
{
    arrAddress = addressList.mutableCopy;
    tblvAddress.backgroundView.hidden = YES;
    [tblvAddress reloadData];
}

#pragma mark - UITableView DataSource & Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrAddress.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
    
    ACCAddress *add = arrAddress [indexPath.row];
    
    cell.lblDesc.text     = [NSString stringWithFormat:@"%@",add.address];
    
    cell.lblsubtitle.text = [NSString stringWithFormat:@"%@, %@ %@",add.cityName,add.stateName,add.zipcode];
    
    cell.imgvCheckmark.image = [UIImage imageNamed:@"tickmark"];
    
    if (add.isAllowDelete)
    {
        cell.vwEditDelete.hidden = NO;
        cell.vwEdit.hidden = YES;
    }
    else
    {
        cell.vwEditDelete.hidden = YES;
        cell.vwEdit.hidden = NO;
    }
    if(add.isDefaultAddress == YES)
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
        [self updateDefaultAddress:indexPath];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imgvCheckmark.hidden = YES;
    cell.backgroundColor      = [UIColor clearColor];
}

@end
