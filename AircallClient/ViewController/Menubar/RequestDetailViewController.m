//
//  RequestDetailViewController.m
//  AircallClient
//
//  Created by Manali on 30/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "RequestDetailViewController.h"

@interface RequestDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *txtvAddress;
@property (weak, nonatomic) IBOutlet UITableView *tblvUnits;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPurpose;
@property (weak, nonatomic) IBOutlet UITextView *txtvNotes;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;
@property (weak, nonatomic) IBOutlet UIView *vwBelowUnits;

@property NSMutableArray *unitList;

@end

@implementation RequestDetailViewController
@synthesize txtvAddress,tblvUnits,lblTime,lblDate,lblPurpose,txtvNotes,scrlv,vwBelowUnits,serviceId,unitList;

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
    [self getRequestDetail];
    
    tblvUnits.alwaysBounceVertical = NO;
    lblPurpose.adjustsFontSizeToFitWidth = YES;
    [tblvUnits reloadData];
    [self setFrames];
}

-(void)setFrames
{
    tblvUnits.frame = CGRectMake(tblvUnits.x, tblvUnits.y, tblvUnits.width, tblvUnits.contentSize.height);
    
    vwBelowUnits.frame = CGRectMake(vwBelowUnits.x, CGRectGetMaxY(tblvUnits.frame) + 20, vwBelowUnits.width, vwBelowUnits.height);
    
    CGFloat height = tblvUnits.contentSize.height + vwBelowUnits.height + txtvAddress.height * 3;
    
    scrlv.contentSize = CGSizeMake(scrlv.width, height);
}

-(void)setDetail:(NSDictionary *)requestInfo
{
    txtvNotes.text = requestInfo[SKeyNotes];
    lblTime.text   = requestInfo[SKeyRequestedTime];
    lblDate.text   = requestInfo[SKeyRequestedDate];
    lblPurpose.text = requestInfo[SKeyPurposeOfVisit];
    ACCAddress *address = [[ACCAddress alloc]initWithDictionary:requestInfo[AKeyAddress]];
    txtvAddress.text = [NSString stringWithFormat:@"%@, %@, %@ %@",address.address,address.cityName,address.stateName,address.zipcode];
    
    NSMutableArray *arrUnits = requestInfo[UKeyUnits];
    
    unitList = @[].mutableCopy;
    
    for (int i = 0; i < arrUnits.count; i++)
    {
        ACCUnit *unitDetail = [[ACCUnit alloc]iniWithDictionary:arrUnits[i]];
        [unitList addObject:unitDetail] ;
    }
    
    [tblvUnits reloadData];
    [self setFrames];
}

#pragma mark - WebService Methods
-(void)getRequestDetail
{
    NSDictionary *requestInfo = @{
                                  UKeyClientID : ACCGlobalObject.user.ID,
                                  SKeyID       : serviceId
                                 };
    
    if ([ACCUtil reachable])
    {
        [SVProgressHUD show];
        
        [ACCWebServiceAPI getRequestDetail:requestInfo completionHandler:^(ACCAPIResponse *response, NSDictionary *requestInfo)
         {
             [SVProgressHUD dismiss];
             
             if (response.code == RCodeSuccess)
             {
                 [self setDetail:requestInfo];
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
        [self showAlertFromWithMessageWithSingleAction:ACCNoInternet andHandler:^(UIAlertAction * _Nullable action)
         {
             [self.navigationController popViewControllerAnimated:YES];
         }];
        
        //[self showAlertWithMessage:ACCNoInternet];
    }
}

#pragma mark - UITableView DataSouce & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return unitList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tblvUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"unitCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ACCUnit *unit = unitList[indexPath.row];
    cell.lblDesc.text = unit.unitName;
    
    return cell;
}

#pragma mark - Event Methods
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
