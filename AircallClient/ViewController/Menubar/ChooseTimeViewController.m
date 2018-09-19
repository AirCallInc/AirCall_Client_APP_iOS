//
//  ChooseTimeViewController.m
//  AircallClient
//
//  Created by Manali Shah on 14/02/17.
//  Copyright © 2017 ZWT112. All rights reserved.
//

#import "ChooseTimeViewController.h"

@interface ChooseTimeViewController ()

@property (weak, nonatomic) IBOutlet UIView *vwTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;

@end

@implementation ChooseTimeViewController

@synthesize vwTime, timePicker, delegate,selectedTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vwTime.hidden = YES;
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.minuteInterval = 15;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"]; //@"yyyy-MM-dd"
    
    if (selectedTime && ![selectedTime isEqualToString:@"Choose Emergency Time"])
    {
        timePicker.date = [dateFormat dateFromString:selectedTime];
    }
    
    [timePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];

}

-(void)viewDidAppear:(BOOL)animated
{
    vwTime.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.1
                        options:0
                     animations:^{
                         vwTime.transform = CGAffineTransformIdentity;
                         vwTime.hidden = NO;
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
    [dateFormat setDateFormat:@"hh:mm a"]; //@"yyyy-MM-dd"
    
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:timePicker.date]];
    [self.delegate setTime:str];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnCancelTap:(id)sender
{
    [self zoomOutanimation];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)timeChanged:(UIDatePicker *)sender
{
    
}

@end
