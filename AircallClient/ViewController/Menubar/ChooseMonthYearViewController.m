//
//  ChooseMonthYearViewController.m
//  AircallClient
//
//  Created by ZWT112 on 10/14/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ChooseMonthYearViewController.h"

@interface ChooseMonthYearViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *vwDate;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property NSMutableArray *yearsArray;
@property NSMutableArray *monthsArray;
@property NSString *selectedYear;
@property NSInteger selectedMonth;
@property NSInteger currentMnth ;
@property NSInteger currentYear;
@end

@implementation ChooseMonthYearViewController
@synthesize monthsArray,yearsArray,myPickerView,vwDate,selectedYear,selectedMonth,delegate,currentYear,currentMnth;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Method 
-(void)prepareView
{
    monthsArray=[[NSMutableArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    currentMnth =  [components month];
    currentYear =  [components year];
    
    yearsArray=[[NSMutableArray alloc]init];
    
    for (int i = 1980; i<=currentYear; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
   
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(myPickerView.x, myPickerView.y, myPickerView.width, myPickerView.height)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView selectRow:yearsArray.count-1 inComponent:1 animated:YES];
    [myPickerView selectRow:currentMnth-1 inComponent:0 animated:YES];
    [vwDate addSubview:myPickerView];
}

#pragma mark - UIPickerView Delegate Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// tell the picker how many rows are available for a given component

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    
    if (component== 0)
    {
        rowsInComponent=[monthsArray count];
    }
    else
    {
        rowsInComponent=[yearsArray count];
    }
    return rowsInComponent;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedYear   = [yearsArray objectAtIndex:[myPickerView selectedRowInComponent:1]];
    selectedMonth  = [myPickerView selectedRowInComponent:0]+1;
    
    if([selectedYear isEqualToString:[NSString stringWithFormat:@"%ld",(long)currentYear]] && selectedMonth > currentMnth)
    {
        [pickerView selectRow:currentMnth-1 inComponent:0 animated:YES];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * nameInRow;
    if (component==0)
    {
        nameInRow=[monthsArray objectAtIndex:row];
    }
    else  if (component==1)
    {
        nameInRow=[yearsArray objectAtIndex:row];
    }
    
    return nameInRow;
}

#pragma mark - Event Handler Method 
- (IBAction)btnSetTap:(id)sender
{
    [self zoomOutanimation];
    selectedMonth  = [myPickerView selectedRowInComponent:0] + 1;
    selectedYear   = [yearsArray objectAtIndex:[myPickerView selectedRowInComponent:1]];
    
    
    NSString *str=[NSString stringWithFormat:@"%02ld/%@",(long)selectedMonth,selectedYear];
    [self.delegate setMonthYear:str];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
