//
//  ChooseDateViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/30/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ChooseDateViewController.h"

@interface ChooseDateViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *vwDate;
@property NSDate *minimumDate;
@end

@implementation ChooseDateViewController
@synthesize datePicker,delegate,vwDate,selectedDate,dayGap,isAllowWeekEnds,minimumDate;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vwDate.hidden = YES;
    datePicker.datePickerMode = UIDatePickerModeDate;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"]; //@"yyyy-MM-dd"
    
    if (isAllowWeekEnds)
    {
        minimumDate = [dateFormat dateFromString:[ACCUtil getCurrentDate]];
    }
    else
    {
        minimumDate = [dateFormat dateFromString:[ACCUtil getDefaultDateWithoutWeekends:dayGap withAllowWeekends:NO]];
    }
    
    datePicker.minimumDate = minimumDate;
    
    if (selectedDate)
    {
        datePicker.date = [dateFormat dateFromString:selectedDate];
    }
    else
    {
        datePicker.date = minimumDate;
    }
    
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated
{
    vwDate.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwDate.transform = CGAffineTransformIdentity;
                         vwDate.hidden = NO;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Methods
- (IBAction)btnSetTap:(id)sender
{
    [self zoomOutanimation];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"]; //@"yyyy-MM-dd"

    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    [self.delegate setDate:str];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dateChanged:(UIDatePicker *)sender
{
//        NSDate *pickedDate = sender.date;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy-MM-dd";
//        
//        if (!isAllowWeekEnds)
//        {
//            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//            NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:pickedDate];
//            NSInteger weekday = [weekdayComponents weekday];
//            
//            if (weekday == 1 || weekday == 7)
//            {
//                // Sunday or Saturday
//                NSDate *nextMonday = nil;
//                
//                if (weekday == 1 || pickedDate == [NSDate date])
//                {
//                    nextMonday = [pickedDate dateByAddingTimeInterval:24 * 60 * 60]; // Add 24 hours
//                }
//                else
//                {
//                    nextMonday = [pickedDate dateByAddingTimeInterval:4 * 24 * 60 * 60]; // Add two days
//                }
//                
//                [sender setDate:nextMonday animated:YES];
//                
//                return;
//            }
//        }
}

@end
