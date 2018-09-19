//
//  MyUnitViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/9/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "MyUnitViewController.h"

@interface MyUnitViewController ()<UITableViewDataSource,UITableViewDelegate,SelectAddressViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvUnit;

@property ACCUnitCell *unitCell;
@property ACCUnit *unit;
@property NSString *lastSelectedAddressId;
@property (strong, nonatomic) ACCLoadMoreCell *loadMoreCell;
@property (nonatomic) NSString *pageNumber;
@property NSMutableArray *arrUnitsList;
@property BOOL isOldUnitsAvailable;
@property BOOL isProcessingUnitsAvailable;
@end

@implementation MyUnitViewController
@synthesize tblvUnit,unitCell,unit,lastSelectedAddressId,loadMoreCell,pageNumber,arrUnitsList,isOldUnitsAvailable,isProcessingUnitsAvailable;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    lastSelectedAddressId = @"";
    
}
-(void) viewDidAppear:(BOOL)animated
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
    pageNumber = @"1";
    tblvUnit.alwaysBounceVertical = NO;
    arrUnitsList = [[NSMutableArray alloc]init];
    tblvUnit.separatorColor = [UIColor clearColor];
    [self getUnitList];
}

#pragma mark - Event Methods
- (IBAction)btnMenuTap:(id)sender
{
    [self openSideBar];
}

- (IBAction)btnAddTap:(id)sender
{
    if([ACCUtil reachable])
    {
        if (isProcessingUnitsAvailable)
        {
            [self showAlertFromWithMessageWithSingleAction:ACCProcessingUnitsAvailable andHandler:^(UIAlertAction * _Nullable action)
             {
                 [self getUnitList];
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

- (IBAction)btnHomeTap:(id)sender
{
    SelectAddressViewController *savc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectAddressViewController"];
    savc.delegate = self;
    savc.selectedAddressId = lastSelectedAddressId;
    [self.navigationController presentViewController:savc animated:YES completion:nil];
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = arrUnitsList.count;
    
    if(numberOfRows > 0)
    {
        numberOfRows = arrUnitsList.count + 1;
    }
    
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.row < arrUnitsList.count)
        {
            unitCell = [tableView dequeueReusableCellWithIdentifier:@"unitCell" forIndexPath:indexPath];
            unitCell.selectionStyle = UITableViewCellSelectionStyleNone;
            unit = arrUnitsList[indexPath.row];
            [unitCell setCellData:unit];
            return unitCell;
        }
    UITableViewCell *Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"unitCell"];
    Cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return Cell;
//    if(indexPath.row == arrUnitsList.count)
//    {
//        int currentPage = [pageNumber intValue] + 1;
//        pageNumber = [NSString stringWithFormat:@"%d",currentPage];
//        loadMoreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell" forIndexPath:indexPath];
//        return loadMoreCell;
//    }
//    else
//    {
//        unitCell = [tableView dequeueReusableCellWithIdentifier:@"unitCell" forIndexPath:indexPath];
//        unitCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        unit = arrUnitsList[indexPath.row];
//        [unitCell setCellData:unit];
//        return unitCell;
//    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [tableView numberOfSections] -1;
    NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] -1;
    if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
    {
        if([cell isKindOfClass:[ACCLoadMoreCell class]])
        {
            loadMoreCell.lblTitle.text = ACCTextLoading;
            loadMoreCell.hidden = NO;
            loadMoreCell.indicator.hidden = NO;
            
            [loadMoreCell.indicator startAnimating];
            
            [self performSelector:@selector(getUnitList) withObject:nil afterDelay:0.5];
        }
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < arrUnitsList.count)
    {
        UnitDetailViewController * udvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UnitDetailViewController"];
        unitCell.selectionStyle = UITableViewCellSelectionStyleNone;
        ACCUnit *units = arrUnitsList[indexPath.row];
        udvc.unitId = units.unitID;
        [self.navigationController pushViewController:udvc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
#pragma mark - WebService Methods
-(void)getUnitList
{
    if ([ACCUtil reachable])
    {
        NSDictionary *dict = @{
                                UKeyClientID  : ACCGlobalObject.user.ID,
                                UKeyAddressId : lastSelectedAddressId,
                                GKeyPageNo    : pageNumber
                              };
        
//        if ([pageNumber isEqualToString:@"1"])
//        {
//            [SVProgressHUD show];
//        }
        
        [ACCWebServiceAPI getUnitList:dict completionHandler:^(ACCAPIResponse *response, NSMutableArray *UnitList, NSString *pageNo,BOOL hasPaymentFailedUnits,BOOL hasProcessingUnits)
         {
             // [SVProgressHUD dismiss];
             
             //arrUnits = UnitList.mutableCopy;
            if (response.code == RCodeSuccess)
             {
                 if(UnitList.count == 0)
                 {
                     arrUnitsList = UnitList.mutableCopy;
                 }
                 else
                 {
                     [arrUnitsList removeAllObjects];
                     [arrUnitsList addObjectsFromArray:UnitList];
                 }
                
                 [tblvUnit reloadData];
                 
                 loadMoreCell.hidden = YES;
                 //pageNumber = pageNo;
                 isOldUnitsAvailable = hasPaymentFailedUnits;
                 isProcessingUnitsAvailable = hasProcessingUnits;
                 tblvUnit.backgroundView = nil;
             }
             else if (response.code == RCodeNoData)
             {
                 if(arrUnitsList.count == 0)
                 {
                    tblvUnit.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
                 }
                 else
                 {
                     loadMoreCell.indicator.hidden = YES;
                     loadMoreCell.lblTitle.text = ACCTextNoMoreData;
                 }
                 isOldUnitsAvailable = hasPaymentFailedUnits;
                 isProcessingUnitsAvailable = hasProcessingUnits;
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
                 tblvUnit.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvUnit.height];
             }
             
             [loadMoreCell.indicator stopAnimating];
             [SVProgressHUD dismiss];
        }];
        
    }
    else
    {
        [tblvUnit reloadData];
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
                 SummaryViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryViewController"];
                 svc.dictUnitInfo = unitInfo;
                 svc.msgInactivePlan = unitInActiveMessage;
                 [self.navigationController pushViewController:svc animated:YES];
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
        [tblvUnit reloadData];
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


#pragma mark - SelectAddressDelegate Method
-(void)SelectionValue:(NSString *)selectedId
{
    arrUnitsList = nil;
    arrUnitsList = [[NSMutableArray alloc]init];
    pageNumber = @"1";
    lastSelectedAddressId = selectedId;
    //[self getUnitList];
    [tblvUnit reloadData];
}
@end
