//
//  SelectQuantityViewController.m
//  AircallClient
//
//  Created by ZWT112 on 6/1/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "SelectQuantityViewController.h"

@interface SelectQuantityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *vwQuantity;
@property (strong, nonatomic) IBOutlet UITableView *tblvQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblHeading;

@property NSMutableArray * arrQuantity;
@end

@implementation SelectQuantityViewController
@synthesize vwQuantity,tblvQuantity,delegate,txtSelected,tblvSelected,popupFor,arrQuantity,lblHeading;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
}

-(void)viewDidAppear:(BOOL)animated
{
    vwQuantity.transform = CGAffineTransformMakeScale(0.2, 0.2);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwQuantity.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Methods
-(void)prepareView
{
    tblvQuantity.separatorColor = [UIColor clearColor];
    tblvQuantity.alwaysBounceVertical = NO;
    
    if ([popupFor isEqualToString:@"Quantity"])
    {
        arrQuantity = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",nil];
        lblHeading.text = @"Quantity";
    }
    else if ([popupFor isEqualToString:@"ExMonth"])
    {
        arrQuantity = [[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
        lblHeading.text = @"Expiry Month";
    }
    else
    {
        arrQuantity = [self setYear];
        lblHeading.text = @"Expiry Year";
    }
}

-(NSMutableArray *)setYear
{
    NSMutableArray * years = [[NSMutableArray alloc]init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
    
    for (int i = currentYear; i <= currentYear + 20; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%ld",(long)i]];
    }
    
    return years;
}

#pragma mark - UITableView DataSource & Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrQuantity.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quantityCell" forIndexPath:indexPath];
    cell.textLabel.text = arrQuantity[indexPath.row];
    
    if (indexPath.row > 0)
    {
        UIView *lineView         = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, self.view.bounds.size.width, 1.5)];
        lineView.backgroundColor = [UIColor colorWithRed:0.81 green:0.81 blue:0.81 alpha:1.0];
        [cell.contentView addSubview:lineView];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate setQuantity:arrQuantity[indexPath.row] inTextField:txtSelected andReloadTable:tblvSelected];
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Event Method
- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
