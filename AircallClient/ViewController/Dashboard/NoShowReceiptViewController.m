//
//  NoShowReceiptViewController.m
//  AircallClient
//
//  Created by ZWT112 on 8/10/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "NoShowReceiptViewController.h"

@interface NoShowReceiptViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblCaseNo;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@end

@implementation NoShowReceiptViewController
@synthesize lblEmail,lblName,lblTotalAmount,lblCaseNo,lblPrice,total,dictReceiptInfo;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setReceiptData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Helper Method
-(void)setReceiptData
{
    lblEmail.text = dictReceiptInfo[UKeyEmail];
    lblName.text  = [NSString stringWithFormat:@"%@ %@",dictReceiptInfo[UKeyFirstName],dictReceiptInfo[UKeyLastName]];
    lblTotalAmount.text = [NSString stringWithFormat:@"$%0.02f",[dictReceiptInfo[SKeyNoShowAmount] floatValue]];
    lblCaseNo.text = dictReceiptInfo[SKeyServiceCaseNo];
    lblPrice.text = [NSString stringWithFormat:@"$%0.02f",[dictReceiptInfo[SKeyNoShowAmount] floatValue]];
}

#pragma mark - Event Method
- (IBAction)btnDashboardTap:(id)sender
{
    DashboardViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
