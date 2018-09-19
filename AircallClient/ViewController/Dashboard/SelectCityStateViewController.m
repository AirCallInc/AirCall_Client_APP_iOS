//
//  SelectCityStateViewController.m
//  AircallClient
//
//  Created by ZWT112 on 6/6/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "SelectCityStateViewController.h"

@interface SelectCityStateViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvSelectCityState;
@property (strong, nonatomic) IBOutlet UILabel *lblTop;
@property (strong, nonatomic) IBOutlet UIView *vwSearch;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property NSMutableArray *arrData;
@property NSArray *arrSearchData;
@property NSUserDefaults *prefs;
@property NSString * stateId;
@property NSString * cityId;
@property CGRect     tblvOriginalFrame;
@property BOOL isCalledOnce;
@end

@implementation SelectCityStateViewController
@synthesize isCity,lblTop,tblvSelectCityState,delegate,arrData,prefs,selectedCityId,selectedStateId,cityId,stateId,arrSearchData,vwSearch,txtSearch,tblvOriginalFrame,isCalledOnce;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    [self getDataForList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self removeObserver];
}

#pragma mark - websewrvice Method
-(void)getDataForList
{
    if([ACCUtil reachable])
    {
        if(isCity)
        {
            [self getCities];
        }
        else
        {
            [self getStates];
        }
    }
    
}
-(void)getStates
{
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getAllStateList:^(ACCAPIResponse *response, NSMutableArray *arrState)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            arrSearchData = arrState.mutableCopy;
            [tblvSelectCityState reloadData];
        }
        else if (response.code == RCodeUnAuthorized)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            arrSearchData = nil;
            tblvSelectCityState.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSelectCityState.height];
        }
        
    }];
}
-(void)getCities
{
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getCitiesFromState:selectedStateId completion:^(ACCAPIResponse *response, NSMutableArray *arrCity)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
            arrSearchData = arrCity.mutableCopy;
            arrData = arrCity.mutableCopy;
            [tblvSelectCityState reloadData];
        }
        else if (response.code == RCodeUnAuthorized)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            arrSearchData = nil;
            tblvSelectCityState.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSelectCityState.height];
        }

    }];
    
}
#pragma mark - Helper Methods
-(void)prepareView
{
    prefs = [NSUserDefaults standardUserDefaults];

    arrData = [[NSMutableArray alloc]init];
    arrSearchData = [[NSArray alloc]init];
   
    tblvSelectCityState.separatorColor = [UIColor clearColor];
    tblvSelectCityState.tintColor = [UIColor colorWithRed:0.02 green:0.76 blue:0.80 alpha:1.0];
    
    if (isCity)
    {
        lblTop.text = @"Select City";
        tblvSelectCityState.frame = CGRectMake(tblvSelectCityState.x, vwSearch.y + vwSearch.height , tblvSelectCityState.width, tblvSelectCityState.height - vwSearch.height);
        
    }
    else
    {
        lblTop.text = @"Select State";
    }
    tblvOriginalFrame = tblvSelectCityState.frame;
    [self setUpKeyboardNotificationHandlers];
}
- (void)setUpKeyboardNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self];
}

#pragma mark - Event Methods
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnCancelSearchTap:(id)sender
{
    txtSearch.text = @"";
    arrSearchData = arrData;
    [tblvSelectCityState reloadData];
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityStateCell" forIndexPath:indexPath];
    
    cell.lblDesc.text   = [arrSearchData[indexPath.row]valueForKey:GKeyName];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (isCity == NO)
    {
        stateId = [[arrSearchData[indexPath.row]valueForKey:GKeyId] stringValue];
    }
    else
    {
        cityId = [[arrSearchData[indexPath.row]valueForKey:GKeyId] stringValue];
    }
    
    BOOL isDefaulState = [[arrSearchData[indexPath.row]valueForKey:GKeyStateDefault] boolValue];
    
    if (selectedStateId == nil &&  isDefaulState == YES)
    {
        selectedStateId = stateId;
    }
    
    if ([selectedStateId isEqualToString:stateId] && isCity == NO)
    {
        cell.imgvCheckmark.hidden = NO;
    }
    else if ([selectedCityId isEqualToString:cityId] && isCity == YES)
    {
        cell.imgvCheckmark.hidden = NO;
    }
    else
    {
        cell.imgvCheckmark.hidden = YES;
    }
    
    if (indexPath.row > 0)
    {
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
   ACCSelectionCell *cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgvCheckmark.hidden = NO;

    if (isCity == YES)
    {
        cityId = [arrSearchData[indexPath.row]valueForKey:GKeyId];
        
        if (selectedCityId != cityId)
        {
            cell.imgvCheckmark.hidden = YES;
        }
        
        selectedCityId = cityId;
    }
    else if (isCity == NO)
    {
        stateId = [arrSearchData[indexPath.row]valueForKey:GKeyId];
        
        if (selectedStateId != stateId)
        {
            cell.imgvCheckmark.hidden = YES;
        }
        
        stateId = cityId;
    }
    
    [delegate SelectionValue:arrSearchData[indexPath.row] isCity:isCity];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCSelectionCell *cell = (ACCSelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgvCheckmark.hidden = YES;
}

#pragma mark - UITextField Delegate Method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(![newString isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name BEGINSWITH[c] %@",newString];
        arrSearchData = [arrData filteredArrayUsingPredicate:predicate];
        if (arrSearchData.count == 0)
        {
            tblvSelectCityState.backgroundView = [ACCUtil viewNoDataWithMessage:@"No Part Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvSelectCityState.height];
            tblvSelectCityState.separatorColor = [UIColor clearColor];
        }
    }
    else
    {
        arrSearchData = arrData.copy;
    }
    
    [tblvSelectCityState reloadData];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtSearch resignFirstResponder];
    return YES;
}


#pragma mark - KEyboard Notification Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!isCalledOnce)
    {
        isCalledOnce = YES;
        CGRect keyboardRect        = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        
        tblvSelectCityState.scrollEnabled = NO;
        
        [UIView animateWithDuration:duration animations:^
         {
             [UIView setAnimationCurve:curve];
             
             [tblvSelectCityState setFrame:CGRectMake(tblvSelectCityState.x,
                                                      tblvSelectCityState.y,
                                                      tblvSelectCityState.width,
                                                      CGRectGetHeight(tblvSelectCityState.frame) - CGRectGetHeight(keyboardRect))];
         }
                         completion:^(BOOL finished)
         {
             tblvSelectCityState.scrollEnabled = YES;
             
         }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isCalledOnce = NO;
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvSelectCityState.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         tblvSelectCityState.frame = tblvOriginalFrame;
         
     }
                     completion:^(BOOL finished)
     {
         tblvSelectCityState.scrollEnabled = YES;
     }];
}

@end
