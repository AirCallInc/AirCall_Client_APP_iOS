//
//  AddUnitViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//
NSString *const UnitTypePackaged  = @"Packaged";
NSString *const UnitTypeHeating   = @"Heating";
NSString *const UnitTypeSplit     = @"Split";
NSString *const UnitTypeCooling   = @"Cooling";
NSString *const UnittypeHeating   = @"Heating";

#import "AddUnitViewController.h"
#import "ACCUser.h"
#import "ACCUnit.h"

@interface AddUnitViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, AddAddressViewControllerDelegate,ZWTTextboxToolbarHandlerDelegate,SelectQuantityViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwPlanType;
@property (strong, nonatomic) IBOutlet UIView *vwUnitInfo;
@property (strong, nonatomic) IBOutlet UIView *vwAddress;
@property (strong, nonatomic) IBOutlet UIView *vwPayment;
@property (weak, nonatomic) IBOutlet UIView *vwQuantityOfUnits;
@property (weak, nonatomic) IBOutlet UIView *vwVisitPerYear;
@property (weak, nonatomic) IBOutlet UIView *vwPricePerYear;
@property (strong, nonatomic) IBOutlet UILabel *lblPricePerYear;
@property (strong, nonatomic) IBOutlet UIButton *btnPlanComparisonLink;

@property (strong, nonatomic) IBOutlet UILabel *lblNoAddress;

@property (strong, nonatomic) IBOutlet ACCTextField *txtUnitName;

@property (strong, nonatomic) IBOutlet UITableView *tblvAddress;
@property (strong, nonatomic) IBOutlet UITableView *tblvPlanType;

@property (strong, nonatomic) IBOutlet UILabel *lblPlanDuartion;

@property (strong, nonatomic) IBOutlet UIScrollView *scrlvUnit;

@property (strong, nonatomic) IBOutlet UILabel *lblPerMonthPrice;

@property (strong, nonatomic) IBOutlet UILabel *lblSpecialOffer;
@property (strong, nonatomic) IBOutlet UIImageView *imgvAutoRenewal;
@property (weak, nonatomic) IBOutlet UIButton *btnSpecialOffer;
@property (strong, nonatomic) IBOutlet UIImageView *imgvSpecialOffer;
@property (strong, nonatomic) IBOutlet UIView *vwSpecialOffer;
@property (strong, nonatomic) IBOutlet UIView *vwAutoRenewal;
@property BOOL isAutoRenewal;
@property BOOL isSpecialOffer;
@property (strong, nonatomic) IBOutlet UIView *vwSpOfferAndAutoRenew;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoRenewal;

@property (weak, nonatomic) IBOutlet ACCTextField *txtfQtyUnit;

@property (weak, nonatomic) IBOutlet ACCTextField *txtVisitPerYear;


@property NSMutableArray *arrTextBoxes;

@property NSArray *arrPlanType;
@property NSMutableArray *arrAddresses;

@property NSInteger currentSelectedTag;

@property NSInteger selectedPlanIndex;
@property NSInteger selectedAddressIndex;

@property NSString *planId;
@property NSString *addressId;
@property NSString *unitTypeId;
@property NSString *UnitType;

@property (strong, nonatomic) UITextField *txtSelectedSearch;
@property (strong, nonatomic) ACCPart *selectedPart;

@property BOOL isDisplayAutoRenewal;
@property BOOL isDisplaySpecialOffer;

@property ZWTTextboxToolbarHandler *textboxHandler;

@property float price;
@property float basicPrice;
@property float specialPrice;
@property float discountedPrice;

@end

@implementation AddUnitViewController

@synthesize vwPlanType,vwAddress,vwUnitInfo,tblvAddress,scrlvUnit,vwPayment,arrPlanType,textboxHandler,txtUnitName,arrTextBoxes,currentSelectedTag,tblvPlanType,planId,imgvAutoRenewal,imgvSpecialOffer,lblSpecialOffer,lblPerMonthPrice,arrAddresses,vwSpecialOffer,vwAutoRenewal,isAutoRenewal,UnitType,unitTypeId,selectedAddressIndex,addressId,price,txtSelectedSearch,selectedPart,lblNoAddress,isDisplayAutoRenewal,isDisplaySpecialOffer,vwSpOfferAndAutoRenew,btnAutoRenewal,isSpecialOffer,btnSpecialOffer,lblPlanDuartion,vwQuantityOfUnits,txtfQtyUnit,vwVisitPerYear,vwPricePerYear,txtVisitPerYear,specialPrice,discountedPrice,basicPrice,lblPricePerYear,btnPlanComparisonLink;

@synthesize selectedPlanIndex,strBlankSummary,allowQtyOfUnits,allowVisitPerYear;

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
    if (allowQtyOfUnits == 0)
    {
        allowQtyOfUnits = 5;
    }
    
    if (allowVisitPerYear == 0)
    {
        allowVisitPerYear = 12;
    }
    selectedPlanIndex = 0;
//    
//    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection: 0];
//        [tblvPlanType selectRowAtIndexPath:indexPathForFirstRow animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    btnSpecialOffer.selected   = NO;
    btnAutoRenewal.selected    = NO;
    isSpecialOffer             = false;
    
    arrAddresses    = [[NSMutableArray alloc]init];
    arrPlanType     = [[NSArray alloc]init];
    
    tblvAddress.separatorColor     = [UIColor clearColor];
    tblvPlanType.separatorColor    = [UIColor clearColor];

   
    
    [self getPlanTypes];
    
    [tblvAddress reloadData];
    
    [tblvPlanType reloadData];
    btnPlanComparisonLink.userInteractionEnabled = true;
    //[self btnAutoRenewalTap:btnAutoRenewal];
}

-(void)setInitialFrames
{
    tblvPlanType.frame = CGRectMake(tblvPlanType.x, tblvPlanType.y, tblvPlanType.width, tblvPlanType.contentSize.height);
    vwPlanType.frame = CGRectMake(vwPlanType.x, vwPlanType.y, vwPlanType.width, tblvPlanType.contentSize.height + 78);
    vwVisitPerYear.frame = CGRectMake(vwVisitPerYear.x, vwPlanType.y + vwPlanType.height, vwVisitPerYear.width, vwVisitPerYear.height);
    
    vwUnitInfo.frame = CGRectMake(vwUnitInfo.x, vwPlanType.y + vwPlanType.height + vwVisitPerYear.height +vwPricePerYear.height, vwUnitInfo.width, vwUnitInfo.height);

    vwUnitInfo.frame = CGRectMake(vwUnitInfo.x, vwPlanType.y + vwPlanType.height + vwVisitPerYear.height, vwUnitInfo.width, vwUnitInfo.height);
    tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.contentSize.height);
    vwAddress.frame = CGRectMake(vwAddress.x, vwUnitInfo.y + vwUnitInfo.height, vwAddress.width, tblvAddress.contentSize.height + 65);
    vwQuantityOfUnits.frame = CGRectMake(vwQuantityOfUnits.x, vwAddress.y + vwAddress.height, vwQuantityOfUnits.width, vwQuantityOfUnits.height-22);
//    vwPayment.frame = CGRectMake(vwPayment.x, vwQuantityOfUnits.y + vwQuantityOfUnits.height, vwPayment.width, vwPayment.height);
//    
//    scrlvUnit.contentOffset = CGPointMake(0, 0);
//    
//    if (vwSpecialOffer.hidden == YES && vwAutoRenewal.hidden == YES)
//    {
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPlanType.height + vwUnitInfo.height + vwAddress.height + vwQuantityOfUnits.height +vwPayment.height - vwSpecialOffer.height - vwAutoRenewal.height);
//    }
//    else if (vwSpecialOffer.hidden == YES)
//    {
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPlanType.height + vwUnitInfo.height + vwAddress.height + vwQuantityOfUnits.height +vwPayment.height -vwSpecialOffer.height);
//    }
//    else if (vwAutoRenewal.hidden == YES)
//    {
//        vwSpecialOffer.frame = CGRectMake(vwSpecialOffer.x, vwAutoRenewal.y, vwSpecialOffer.width, vwSpecialOffer.height);
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPlanType.height + vwUnitInfo.height + vwAddress.height + vwQuantityOfUnits.height +vwPayment.height - vwAutoRenewal.height);
//    }
//    else
//    {
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPlanType.height + vwUnitInfo.height + vwAddress.height + vwQuantityOfUnits.height +vwPayment.height);
//    }
}

-(void)resizeViews
{
    tblvPlanType.frame = CGRectMake(tblvPlanType.x, tblvPlanType.y, tblvPlanType.width, tblvPlanType.contentSize.height);
    vwPlanType.frame = CGRectMake(vwPlanType.x, vwPlanType.y, vwPlanType.width, tblvPlanType.contentSize.height + 78);
    vwVisitPerYear.frame = CGRectMake(vwVisitPerYear.x, vwPlanType.y + vwPlanType.height, vwVisitPerYear.width, vwVisitPerYear.height);
  
    vwPricePerYear.frame = CGRectMake(vwPricePerYear.x, vwPlanType.y + vwPlanType.height + vwVisitPerYear.height, vwPricePerYear.width, vwPricePerYear.height);
    
    vwUnitInfo.frame = CGRectMake(vwUnitInfo.x, vwPlanType.y + vwPlanType.height + vwVisitPerYear.height +vwPricePerYear.height, vwUnitInfo.width, vwUnitInfo.height);
    
    if (arrAddresses.count == 0)
    {
        tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.height);
        vwAddress.frame = CGRectMake(vwAddress.x, vwUnitInfo.y + vwUnitInfo.height, vwAddress.width, tblvAddress.height + 65);
    }
    else
    {
        tblvAddress.frame = CGRectMake(tblvAddress.x, tblvAddress.y, tblvAddress.width, tblvAddress.contentSize.height);
        vwAddress.frame = CGRectMake(vwAddress.x, vwUnitInfo.y + vwUnitInfo.height, vwAddress.width, tblvAddress.contentSize.height + 65);
    }
    
    vwQuantityOfUnits.frame = CGRectMake(vwQuantityOfUnits.x, vwAddress.y + vwAddress.height, vwQuantityOfUnits.width, vwQuantityOfUnits.height);
    
//    vwPayment.frame = CGRectMake(vwPayment.x, vwQuantityOfUnits.y + vwQuantityOfUnits.height + 10, vwPayment.width, vwPayment.height);
//   
//    if (!isDisplayAutoRenewal && isDisplaySpecialOffer)
//    {
//        vwSpecialOffer.frame = CGRectMake(vwSpecialOffer.x, vwAutoRenewal.y, vwSpecialOffer.width, vwSpecialOffer.height);
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height - vwAutoRenewal.height);
//    }
//    else if (isDisplayAutoRenewal && !isDisplaySpecialOffer)
//    {
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height - vwSpecialOffer.height);
//    }
//    else if (!isDisplaySpecialOffer && !isDisplayAutoRenewal)
//    {
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height - vwSpOfferAndAutoRenew.height);
//    }
//    else
//    {
//        vwSpecialOffer.frame = CGRectMake(vwSpecialOffer.x, vwAutoRenewal.y + vwAutoRenewal.height, vwSpecialOffer.width, vwSpecialOffer.height);
//        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height);
//    }
    
    arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtUnitName,txtfQtyUnit]];
    textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvUnit];
    textboxHandler.delegate = self;
    //scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height + 30);
}

-(BOOL)validateUnitInfo
{
    if (planId == nil)
    {
        [self showAlertWithMessage:ACCPlanSelection];
        return NO;
    }
    else if (addressId == nil)
    {
        [self showAlertWithMessage:ACCAddressSelection];
        return NO;
    }
    else if ([txtfQtyUnit.text isEqualToString:@"0"] || [txtfQtyUnit.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACCValidQtyOfUnits];
        return NO;
    }
    else if ([txtVisitPerYear.text isEqualToString:@"0"] || [txtVisitPerYear.text isEqualToString:@""])
    {
        [self showAlertWithMessage:ACCValidVisitPerYear];
        return NO;
    }
    else if((allowQtyOfUnits && [txtfQtyUnit.text integerValue] > allowQtyOfUnits) || [txtfQtyUnit.text integerValue] > 5)
    {
        [self showAlertWithMessage:ACCUnitLimit];
        return NO;
    }
    else if((allowVisitPerYear && [txtVisitPerYear.text integerValue] > allowVisitPerYear) || [txtVisitPerYear.text integerValue] > 12)
    {
        [self showAlertWithMessage:ACCVisitLimit];
        return NO;
    }

    return YES;
}

-(void)setUnitDataByplan:(ACCUnit*)unit
{
    lblPlanDuartion.text  = [NSString stringWithFormat:@"For %@ Months",unit.planDuartion != nil ? unit.planDuartion : @"0"];
    price = unit.planPricePerMonth;
    float planPrice = price * txtfQtyUnit.text.integerValue;
    lblPerMonthPrice.text = [NSString stringWithFormat:@"$%0.2f",planPrice];
    //lblSpecialOffer.text  = unit.specialOfferText;
    specialPrice = unit.specialPrice;
    discountedPrice = unit.discountPrice;
    lblSpecialOffer.text  = [NSString stringWithFormat:@"Save $%0.2f & pay only $%0.2f now!",specialPrice,discountedPrice];
    isDisplaySpecialOffer = unit.isSpecialOfferDisplay;
    isDisplayAutoRenewal  = unit.isAutoRenewalDisplay;
    
    if (isDisplaySpecialOffer)
    {
        vwSpecialOffer.hidden = NO;
    }
    else
    {
        vwSpecialOffer.hidden = YES;
    }
    
    if (isDisplayAutoRenewal)
    {
        vwAutoRenewal.hidden = NO;
    }
    else
    {
        vwAutoRenewal.hidden = YES;
    }
    
    [self resizeViews];
}

-(NSMutableArray *)getValidAddresses:(NSMutableArray *)addressList
{
    NSMutableArray *arrAddressList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < addressList.count; i++)
    {
        ACCAddress *address = addressList[i];
        
        if (address.isShowAddress)
        {
            [arrAddressList addObject:address] ;
        }
    }
    
    return arrAddressList;
}

-(BOOL)isInactiveAddress:(NSString *)selectedAddressId
{
    for (int i = 0; i < arrAddresses.count; i++)
    {
        ACCAddress *address = arrAddresses[i];
        
        if ([selectedAddressId isEqualToString:address.addressId])
        {
            if (!address.isShowAddress)
            {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - Webservice Methods
-(void)getPlanTypes
{
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getPlanTypeWithcompletionHandler:^(ACCAPIResponse *response, NSMutableArray *planType)
         {
             if (response.code == RCodeSuccess)
             {
                 arrPlanType = planType.mutableCopy;
                 planId = [arrPlanType[selectedPlanIndex]valueForKey:GKeyId];
                 [tblvPlanType reloadData];
                 [self getAddressList];
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

-(void)getUnitDataByPlan
{
    if(planId != nil)
    {
        NSDictionary *dict = @{UKeyPlanId : planId};
        
        if ([ACCUtil reachable])
        {
            [SVProgressHUD show];
            
            [ACCWebServiceAPI getUnitDataByPlan:dict completionHandler:^(ACCAPIResponse *response, ACCUnit *unit)
             {
                 [SVProgressHUD dismiss];
                 
                 if (response.code == RCodeSuccess)
                 {
                     [self setUnitDataByplan:unit];
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
                     [self setUnitDataByplan:nil];
                 }
                 
             }];
        }
        else
        {
            [self showAlertWithMessage:ACCNoInternet];
        }
    }
    else
    {
        [self setUnitDataByplan:nil];
    }
}

-(void)sendUnitData
{
    if ([self validateUnitInfo])
    {
        
//        NSString *strPricePerMonth = [lblPricePerYear.text stringByReplacingOccurrencesOfString:@"$"withString:@""];
//        
        NSDictionary *dictUnit = @{
                                   UKeyClientID            : ACCGlobalObject.user.ID,
                                   UKeyUnitName            : txtUnitName.text,
                                   UKeyPlanId              : planId,
                                   UKeyAddressId           : addressId,
                                   UKeyQuantityOfUnits     : txtfQtyUnit.text,
                                   UKeyVisitPerYear        : txtVisitPerYear.text,
                                   UKeyplanPricePerMonth   : [NSString stringWithFormat:@"%f",basicPrice],
                                   //UkeyUnitAutoRenewal     : @(isAutoRenewal),
                                   //UkeyUnitSpecialOffer    : @(isSpecialOffer),
                                   };
        
        if ([ACCUtil reachable])
        {
            [SVProgressHUD show];
            
            [ACCWebServiceAPI sendUnitData:dictUnit completionHandler:^(ACCAPIResponse *response, NSDictionary *unitInfo,NSString * unitInActiveMessage)
             {
                 [SVProgressHUD dismiss];
                 
                 if (response.code == RCodeSuccess)
                 {
                     SummaryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
                     viewController.dictUnitInfo = unitInfo;
                     viewController.msgInactivePlan = unitInActiveMessage;
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
}
-(void)getAddressList
{
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getAddressListWithcompletioHandler:^(ACCAPIResponse *response, NSMutableArray *addressList)
     {
         if (response.code == RCodeSuccess)
         {
             lblNoAddress.hidden = YES;
             arrAddresses = [self getValidAddresses:addressList].mutableCopy;
             if (arrAddresses.count == 0)
             {
                 lblNoAddress.hidden = NO;
                 lblNoAddress.text = ACCNoActiveAddress;
             }
             [tblvAddress reloadData];
             //[self getUnitDataByPlan];
         }
         else if ( response.code == RCodeNoData)
         {
             lblNoAddress.hidden = NO;
             lblNoAddress.text = ACCNoAddressAdded;
             [self getUnitDataByPlan];
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
         
//         arrTextBoxes = [[NSMutableArray alloc]initWithArray:@[txtUnitName,txtUnitTon]];
//         textboxHandler = [[ZWTTextboxToolbarHandler alloc] initWithTextboxs:arrTextBoxes andScroll:scrlvUnit];
         
         [self resizeViews];
         
     }];
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)//Address
    {
        return arrAddresses.count;
    }
    if (tableView.tag == 5)// Plan Type
    {
        return arrPlanType.count;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)//Address
    {
        ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ACCAddress *add = arrAddresses[indexPath.row];
        cell.lblDesc.text = [NSString stringWithFormat:@"%@\n%@, %@ %@",add.address,add.cityName,add.stateName,add.zipcode];
        
        if (add.isDefaultAddress)
        {
            if(arrAddresses.count == 1)
            {
                addressId = add.addressId;
                selectedAddressIndex = indexPath.row;
                cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
            }
        }
        else
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        return cell;
    }
    
    if (tableView.tag == 5) // Plan Type
    {
        ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"planTypeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblDesc.text = [arrPlanType[indexPath.item]valueForKey:GKeyPlanName];
        // set default choose,and set price per month 
        if (indexPath.row == selectedPlanIndex)
        {
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
            NSInteger visitCount = txtVisitPerYear.text.integerValue;
            NSInteger quantity = txtfQtyUnit.text.integerValue;
            NSString *basicFee = [arrPlanType[indexPath.item] valueForKey:GKeyBasic];
            NSString *feeincrement = [arrPlanType[indexPath.item] valueForKey:GKeyIncrement];
            basicPrice = [basicFee floatValue] + (visitCount -1) * [feeincrement floatValue];
            lblPricePerYear.text = [NSString stringWithFormat:@"$%.2f", basicPrice * quantity];

        }else{
           cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell;
    
    if (tableView.tag == 0)//Address
    {
        [self.view endEditing:YES];
        [self resizeViews];
        
        if (selectedAddressIndex != indexPath.row)
        {
            NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedAddressIndex inSection:0];
            cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell  = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        addressId = [arrAddresses[indexPath.row] addressId];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
    }
    else if (tableView.tag == 5)//Plan Type
    {
        [self.view endEditing:YES];
        [self resizeViews];
        
        if (selectedPlanIndex != indexPath.row)
        {
            NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:selectedPlanIndex inSection:0];
            cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
            cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
        }
        
        cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        planId = [arrPlanType[indexPath.item] valueForKey:GKeyId];
        NSInteger visitCount = txtVisitPerYear.text.integerValue;
        NSInteger quantity = txtfQtyUnit.text.integerValue;
        NSString *basicFee = [arrPlanType[indexPath.item] valueForKey:GKeyBasic];
        NSString *feeincrement = [arrPlanType[indexPath.item] valueForKey:GKeyIncrement];
        basicPrice = [basicFee floatValue] + (visitCount -1) * [feeincrement floatValue];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobuttonSelected"];
        lblPricePerYear.text = [NSString stringWithFormat:@"$%.2f", basicPrice * quantity];
        //[self getUnitDataByPlan];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ACCSelectionCell *cell;
    
    if (tableView.tag == 0)//Address
    {
        cell  = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
    }
    else if(tableView.tag == 5)//Plan Type
    {
        cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        cell.imgvCheckmark.image = [UIImage imageNamed:@"radiobutton"];
    }
}

#pragma mark - Event Methods
- (IBAction)btnSubmitTap:(id)sender
{
    [self sendUnitData];
}
- (IBAction)btnPlanComparisonTap:(id)sender {
    TermsAndConditionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
    viewController.isfromPayment = YES;
    viewController.pageTitle = @"Plan Comparison";
    viewController.pdfURL = [NSString stringWithFormat:@"%@/uploads/plan/Aicall_Plan_v2.pdf",BaseUrlPath];
    viewController.isOpenPDF = YES;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)btnBackTap:(id)sender
{
    if ([strBlankSummary isEqualToString:@"BlankSummary"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnAddAddressTap:(id)sender
{
    [self.view endEditing:YES];
    [self doneTap];
    AddAddressViewController *viewController = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"AddAddressViewController"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)btnAutoRenewalTap:(UIButton *)btn
{
    if (!btn.selected)
    {
        vwSpecialOffer.hidden = YES;
        vwAutoRenewal.hidden = NO;
        
        isAutoRenewal = true;
        isSpecialOffer = false;
        btnAutoRenewal.selected = true;
        btnSpecialOffer.selected = false;
        imgvAutoRenewal.image = [UIImage imageNamed:@"ckeckboxSelected"];
        imgvSpecialOffer.image  = [UIImage imageNamed:@"checkbox"];
    }
    else
    {
        vwSpecialOffer.hidden = NO;
        vwAutoRenewal.hidden = NO;
        
        isAutoRenewal = false;
        btnAutoRenewal.selected = false;
        btnSpecialOffer.selected = false;
        
        imgvSpecialOffer.image = [UIImage imageNamed:@"checkbox"];
        imgvAutoRenewal.image = [UIImage imageNamed:@"checkbox"];
    }
}

- (IBAction)btnSpecialOfferTap:(UIButton *)btn
{
    if (!btn.selected)
    {
        vwSpecialOffer.hidden = NO;
        vwAutoRenewal.hidden = YES;
        
        isSpecialOffer = true;
        isAutoRenewal  = false;
        vwAutoRenewal.hidden = YES;
        btnSpecialOffer.selected = true;
        btnAutoRenewal.selected  = false;
        imgvAutoRenewal.image = [UIImage imageNamed:@"checkbox"];
        imgvSpecialOffer.image = [UIImage imageNamed:@"ckeckboxSelected"];
    }
    else
    {
        vwSpecialOffer.hidden = NO;
        vwAutoRenewal.hidden = NO;
        
        isSpecialOffer = false;
        vwAutoRenewal.hidden = NO;
        btnSpecialOffer.selected = false;
        btnAutoRenewal.selected = false;
        
        imgvAutoRenewal.image = [UIImage imageNamed:@"checkbox"];
        imgvSpecialOffer.image = [UIImage imageNamed:@"checkbox"];
    }
}

- (IBAction)btnPlusTap:(id)sender
{
    NSInteger value = txtfQtyUnit.text.integerValue;
    if (value < allowQtyOfUnits)
    {
        value = value + 1;
        txtfQtyUnit.text = [NSString stringWithFormat:@"%ld",(long)value];
        lblPricePerYear.text = [NSString stringWithFormat:@"$%.2f", basicPrice * value];
//        txtfQtyUnit.text = [NSString stringWithFormat:@"%ld",(long)value];
//        float planPrice = price * txtfQtyUnit.text.integerValue;
//        lblPerMonthPrice.text = [NSString stringWithFormat:@"$%0.2f",planPrice];
//        float sPrice = specialPrice * txtfQtyUnit.text.integerValue;
//        float dPrice = discountedPrice * txtfQtyUnit.text.integerValue;
//        lblSpecialOffer.text  = [NSString stringWithFormat:@"Save $%0.2f & pay only $%0.2f now!",sPrice,dPrice];
    }
    
}
- (IBAction)btnMinusTap:(id)sender
{
    NSInteger value = txtfQtyUnit.text.integerValue;
    if (value > 1)
    {
        value = value - 1;
        txtfQtyUnit.text = [NSString stringWithFormat:@"%ld",(long)value];
        lblPricePerYear.text = [NSString stringWithFormat:@"$%.2f", basicPrice * value];
        
//        txtfQtyUnit.text = [NSString stringWithFormat:@"%ld",(long)value];
//        float planPrice = price * txtfQtyUnit.text.integerValue;
//        lblPerMonthPrice.text = [NSString stringWithFormat:@"$%0.2f",planPrice];
//        float sPrice = specialPrice * txtfQtyUnit.text.integerValue;
//        float dPrice = discountedPrice * txtfQtyUnit.text.integerValue;
//        lblSpecialOffer.text  = [NSString stringWithFormat:@"Save $%0.2f & pay only $%0.2f now!",sPrice,dPrice];
    }
}

- (IBAction)btnMinusVisitTap:(id)sender {
    NSInteger value = txtVisitPerYear.text.integerValue;
    if (value > 1)
    {
        value = value - 1;
        txtVisitPerYear.text = [NSString stringWithFormat:@"%ld",(long)value];
    }
    for(int i =0;i<arrPlanType.count;i++)
    {
        NSString *id = [arrPlanType[i]valueForKey:GKeyId];
        if ([id isEqual:planId])
        {
              NSString *basicFee = [arrPlanType[i]valueForKey:GKeyBasic];
              NSString *feeincrement = [arrPlanType[i]valueForKey:GKeyIncrement];
              basicPrice = [basicFee floatValue] + (value -1) * [feeincrement floatValue];
        }
    }
    lblPricePerYear.text = [NSString stringWithFormat:@"$%.2f", basicPrice];
}
- (IBAction)btnPlusVisitTap:(id)sender {
     NSInteger value = txtVisitPerYear.text.integerValue;
     if (value < allowVisitPerYear)
     {
         value = value + 1;
         txtVisitPerYear.text = [NSString stringWithFormat:@"%ld",(long)value];
     }
    
    for(int i =0;i<arrPlanType.count;i++)
    {
        NSString *id = [arrPlanType[i]valueForKey:GKeyId];
        if ([id isEqual:planId])
        {
            NSString *basicFee = [arrPlanType[i]valueForKey:GKeyBasic];
            NSString *feeincrement = [arrPlanType[i]valueForKey:GKeyIncrement];
            basicPrice = [basicFee floatValue] + (value -1) * [feeincrement floatValue];
        }
    }
    lblPricePerYear.text = [NSString stringWithFormat:@"$%.2f", basicPrice];

}

//- (IBAction)btnQtyOfUnitsTap:(id)sender
//{
//    SelectQuantityViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectQuantityViewController"];
//    viewController.popupFor = @"Quantity";
//    viewController.providesPresentationContextTransitionStyle = YES;
//    viewController.definesPresentationContext = YES;
//    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
//    viewController.txtSelected = txtfQtyUnit;
//    viewController.tblvSelected = nil;
//    viewController.delegate = self;
//    [self.navigationController presentViewController:viewController animated:NO completion:nil];
//}

#pragma mark - UITextField Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4)
    {
        return YES;
    }
    else
    {
        [self doneTap];
    }
        return NO;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//
//    if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4)
//    {
////        currentSelectedTag = textField.tag;
////        SelectQuantityViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectQuantityViewController"];
////        viewController.providesPresentationContextTransitionStyle = YES;
////        viewController.definesPresentationContext = YES;
////        [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
////        viewController.txtSelected = textField;
////
////        if (textField.tag == 1)
////        {
////            viewController.tblvSelected = tblvFilter;
////        }
////        else if (textField.tag == 2)
////        {
////            viewController.tblvSelected = tblvFuse;
////        }
////        else if (textField.tag == 3)
////        {
////            viewController.tblvSelected = tblvSplitFilter;
////        }
////        else if (textField.tag == 4)
////        {
////            viewController.tblvSelected = tblvSplitFuse;
////        }
////        viewController.delegate = self;
////
////       [self.navigationController presentViewController:viewController animated:YES completion:nil];
//    }
//    else
//    {
//        //(@"%@",textField.superview.superview);
//        if(textField == txtBooster)
//        {
//            txtSelectedSearch = textField;
//            [self openSearchPartViewcontroller:@"Booster"];
//        }
//        else if (textField == txtSplitBooster)
//        {
//            txtSelectedSearch = textField;
//            [self openSearchPartViewcontroller:@"Booster"];
//        }
//        else
//        {
//            UIView *vw = textField.superview.superview;
//
//            if([vw isKindOfClass:[ACCFilterCell class]])
//            {
//                UITableView *tb = [self findParentTableViewOfView:vw];
//
//                if(tb == tblvFilter)
//                {
//                    txtSelectedSearch = textField;
//                    [self openSearchPartViewcontroller:@"Filter"];
//                }
//                else if(tb == tblvSplitFilter)
//                {
//                    txtSelectedSearch = textField;
//                    [self openSearchPartViewcontroller:@"Filter"];
//                }
//            }
//            else if([vw isKindOfClass:[ACCFuseCell class]])
//            {
//                UITableView *tb = [self findParentTableViewOfView:vw];
//                if(tb == tblvFuse)
//                {
//                    txtSelectedSearch = textField;
//                    [self openSearchPartViewcontroller:@"Fuse"];
//                }
//                else if(tb == tblvSplitFuse)
//                {
//                    txtSelectedSearch = textField;
//                    [self openSearchPartViewcontroller:@"Fuse"];
//                }
//            }
//        }
//    }
//
//
//}

#pragma mark - SelectQuantityViewController Delegate Method

-(void)setQuantity:(NSString*)strQuantity inTextField:(UITextField *)txtField andReloadTable:(UITableView *)tblview
{
//    txtField.text = strQuantity;
//    [tblview reloadData];
    
    if (txtField == txtfQtyUnit)
    {
        txtfQtyUnit.text = strQuantity;
    }
    
    //[btnTitle setTitle:strQuantity forState:UIControlStateNormal];
    
    //    UITextField *textFeild = [[self.view viewWithTag:currentSelectedTag] isKindOfClass:[UITextField class]]?(UITextField *)[self.view viewWithTag:currentSelectedTag]:nil;
    //
    //    if(nil != textFeild)
    //    {
    //        textFeild.text = strQuantity;
    //        UITableView *tblv = (UITableView*)[self.view viewWithTag:currentSelectedTag];
    //        [tblv reloadData];
    //    }
    //    else
    //    {
    //        NSLog(@"textFeild is null");
    //    }
    
    //        if ([self.view isKindOfClass: [UITextField class]])
    //        {
    //            UITextField *txtField = (UITextField*)[self.view viewWithTag:currentSelectedTag];
    //            txtField.text = strQuantity;
    //
    //        }
    //        else if ([self.view isKindOfClass: [UITableView class]])
    //        {
    //            UITableView *tblv = (UITableView*)[self.view viewWithTag:currentSelectedTag];
    //            [tblv reloadData];
    //        }
    
    
    //        [tblvFuse reloadData];
    //        [tblvFilter reloadData];
    //        [tblvSplitFilter reloadData];
    //        [tblvSplitFuse reloadData];
    
    //[self setInitialFrames];
}

#pragma mark - AddAddressViewController Delegate Method
-(void)AddressList:(NSMutableArray *)addressList
{
    lblNoAddress.hidden = YES;
    arrAddresses = [self getValidAddresses:addressList].mutableCopy;
    [tblvAddress reloadData];
    [self resizeViews];
}

#pragma mark - SearchPartViewcontroller Delegate Method
-(void)SelectionValue:(ACCPart *)selPart
{
    selectedPart = selPart;
    txtSelectedSearch.text = [NSString stringWithFormat:@"%@ %@",selPart.partName,selPart.partSize];
    txtSelectedSearch.placeholder = [NSString stringWithFormat:@"%@",selPart.partId];
}

#pragma mark - ZWTTextboxToolbarHandlerDelegate Method
-(void)doneTap
{
    //scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height + 30);
    
    if (!isDisplayAutoRenewal && isDisplaySpecialOffer)
    {
        vwSpecialOffer.frame = CGRectMake(vwSpecialOffer.x, vwAutoRenewal.y, vwSpecialOffer.width, vwSpecialOffer.height);
        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height - vwAutoRenewal.height);
    }
    else if (isDisplayAutoRenewal && !isDisplaySpecialOffer)
    {
        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height - vwSpecialOffer.height);
    }
    else if (!isDisplaySpecialOffer && !isDisplayAutoRenewal)
    {
        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height - vwSpOfferAndAutoRenew.height);
    }
    else
    {
        vwSpecialOffer.frame = CGRectMake(vwSpecialOffer.x, vwAutoRenewal.y + vwAutoRenewal.height, vwSpecialOffer.width, vwSpecialOffer.height);
        scrlvUnit.contentSize = CGSizeMake(scrlvUnit.width, vwPayment.y + vwPayment.height);
    }

}
@end
