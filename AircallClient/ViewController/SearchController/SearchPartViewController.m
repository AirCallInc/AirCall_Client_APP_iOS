//
//  SearchPartViewController.m
//  AircallClient
//
//  Created by ZWT111 on 21/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//
NSString *const KeyPartType = @"PartType";

#import "SearchPartViewController.h"

@interface SearchPartViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblvPartData;
@property (strong, nonatomic) IBOutlet ACCTextField *txtSearch;
@property (strong, nonatomic) NSMutableArray *arrPartList;
@property (strong, nonatomic) NSArray *arrSearchPartList;
@property (strong, nonatomic) IBOutlet UIView *vwSearch;
@property CGRect originalTableFrame;
@property BOOL isCalledOnce;

@end

@implementation SearchPartViewController
@synthesize tblvPartData,txtSearch,arrPartList,partType,selectedPart,arrSearchPartList,vwSearch,originalTableFrame,isCalledOnce;
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    arrPartList       = [[NSMutableArray alloc]init];
    arrSearchPartList = [[NSMutableArray alloc]init];
    
    tblvPartData.alwaysBounceVertical = NO;
    originalTableFrame = tblvPartData.frame;
    [self setUpKeyboardNotificationHandlers];
    
    [self getPartDataOf:partType];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [self removeObserver];
}
-(void)getPartDataOf:(NSString *)part
{
    if([ACCUtil reachable])
    {
        [self getPartFromSearch:part];
    }
    else
    {
        [self showAlertWithMessage:ACCNoInternet];
    }
}
#pragma mark - Webservice Method
-(void)getPartFromSearch:(NSString *)part
{
    NSDictionary *dict = @{
                           KeyPartType : part
                           };
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getPartListFromPartType:dict completion:^(ACCAPIResponse *response, NSMutableArray *arrPart)
    {
        
        
        if(response.code == RCodeSuccess)
        {
            arrPartList         = arrPart.mutableCopy;
            arrSearchPartList   = arrPart.mutableCopy;
            
            [tblvPartData reloadData];
        }
        else if (response.code == RCodeNoData)
        {
            tblvPartData.backgroundView = [ACCUtil viewNoDataWithMessage:response.message andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartData.height];
        }
        else
        {
            [self showAlertWithMessage:response.message];
            txtSearch.userInteractionEnabled = NO;
        }
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Event Method
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)searchCancelTap:(id)sender
{
    txtSearch.text = @"";
    arrSearchPartList = arrPartList;
    [tblvPartData reloadData];
}

#pragma mark - UITableview delegate & datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSearchPartList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundView.hidden = YES;
    tableView.separatorColor = [UIColor appGreenColor];
    
    ACCSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"partCell"];
    cell.lblDesc.text     = [arrSearchPartList[indexPath.row] partName];
    cell.lblsubtitle.text = [NSString stringWithFormat:@"Size : %@",
    [arrSearchPartList[indexPath.row] partSize]];
    
    if([selectedPart.partId isEqualToString:[arrSearchPartList[indexPath.row] partId]])
    {
        cell.imgvCheckmark.hidden = NO;
    }
    else
    {
        cell.imgvCheckmark.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate SelectionValue:arrSearchPartList[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark - UITextField delegate method
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(![newString isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partName BEGINSWITH[c] %@",newString];
        
        arrSearchPartList = [arrPartList filteredArrayUsingPredicate:predicate];
        
        if (arrSearchPartList.count == 0)
        {
            tblvPartData.backgroundView = [ACCUtil viewNoDataWithMessage:@"No Part Found" andImage:nil withFontColor:[UIColor appGreenColor] withHeight:tblvPartData.height];
            tblvPartData.separatorColor = [UIColor clearColor];
        }
    }
    else
    {
        arrSearchPartList = arrPartList.copy;
    }
    
    [tblvPartData reloadData];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtSearch resignFirstResponder];
    return YES;
}

#pragma mark - Helper method
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
#pragma mark - KEyboard Notification Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!isCalledOnce)
    {
        CGRect keyboardRect        = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        
        tblvPartData.scrollEnabled = NO;
        
        [UIView animateWithDuration:duration animations:^
         {
             [UIView setAnimationCurve:curve];
             
             [tblvPartData setFrame:CGRectMake(tblvPartData.x,
                                               tblvPartData.y,
                                               tblvPartData.width,
                                               CGRectGetHeight(tblvPartData.frame) - CGRectGetHeight(keyboardRect))];
         }
                         completion:^(BOOL finished)
         {
             tblvPartData.scrollEnabled = YES;
             
         }];
        isCalledOnce = YES;

    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    isCalledOnce = NO;
    NSTimeInterval duration    = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    tblvPartData.scrollEnabled = NO;
    
    [UIView animateWithDuration:duration animations:^
     {
         [UIView setAnimationCurve:curve];
         tblvPartData.frame = originalTableFrame;
         
     }
                     completion:^(BOOL finished)
     {
         tblvPartData.scrollEnabled = YES;
     }];
}
@end
