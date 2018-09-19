//
//  SideBarViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/7/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "SideBarViewController.h"

@interface SideBarViewController ()<AccountSettingsViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *vwSideMenu;
@property (strong, nonatomic) IBOutlet UIImageView *imgvUser;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblVersionNumber;

@end

@implementation SideBarViewController
@synthesize vwSideMenu,imgvUser,lblUserName,lblVersionNumber;

#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgvUser.layer.cornerRadius = imgvUser.height / 2;
    imgvUser.layer.masksToBounds = YES;
    
    lblUserName.adjustsFontSizeToFitWidth = YES;
    
    lblVersionNumber.text = [NSString stringWithFormat:@"Version: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Event Methods
- (IBAction)btnCancelTap:(id)sender
{
    [self hideMenu];
}

- (IBAction)btnAccountSettingsTap:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    AccountSettingsViewController *viewController = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"AccountSettingsViewController"];
//    viewController.delegate = self;
//    [ACCGlobalObject.rootViewController pushViewController:viewController animated:YES];
    
    DashboardViewController *dbvc = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    AccountSettingsViewController *asvc = [ACCGlobalObject.storyboardLoginSignupProfile instantiateViewControllerWithIdentifier:@"AccountSettingsViewController"];
    [ACCGlobalObject.rootViewController setViewControllers:@[dbvc,asvc]];
}

- (IBAction)btnDashboardTap:(id)sender
{
    DashboardViewController * viewController = [ACCGlobalObject.storyboardDashboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnUpcomingScheduleTap:(id)sender
{
    UpcomingScheduleViewController * viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"UpcomingScheduleViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnPastServiceTap:(id)sender
{
    PastServicesViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"PastServicesViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnMyUnitsTap:(id)sender
{
    MyUnitViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"MyUnitViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnRequestForServiceTap:(id)sender
{
    ServiceRequestViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ServiceRequestViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnPlanCoverageTap:(id)sender
{
    PlanCoverageViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"PlanCoverageViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnTermsandConditionTap:(id)sender
{
    TermsAndConditionViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"TermsAndConditionViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnAboutUsTap:(id)sender
{
    AboutUsViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnContactUsTap:(id)sender
{
    ContactUsViewController *viewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
    [self displayController:viewController forMenuItem:sender];
}

- (IBAction)btnLogoutTap:(id)sender
{
    [ACCUtil logoutTap];
}

#pragma mark - Helper Method
- (void)showMenu
{
//    From Right
//    self.view.backgroundColor = [UIColor clearColor];
//    self.view.frame = [UIScreen mainScreen].bounds;
//    
//    vwSideMenu.x = CGRectGetWidth(vwSideMenu.frame);
//    
//    [self.view.superview bringSubviewToFront:self.view];
//    
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^
//     {
//         vwSideMenu.x = self.view.width / 5.5;
//         
//         self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
//     }
//                     completion:^(BOOL finished)
//     {
//     }];
    
//  From Left
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.frame = [UIScreen mainScreen].bounds;
    
    vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.view.superview bringSubviewToFront:self.view];
    //0.6
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:0
                     animations:^{
                         vwSideMenu.x = 0;
                         
                         self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
                         
                     }
                     completion:^(BOOL finished)
     {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
         
         NSData *dataImage = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyProfileImage];
         UIImage *image = [UIImage imageWithData:dataImage];
         
         if (dataImage == nil)
         {
             imgvUser.image = [UIImage imageNamed:@"userPlaceHolder"];
         }
         else
         {
             imgvUser.image = image;
         }
         
         lblUserName.text = [NSString stringWithFormat:@"%@ %@",ACCGlobalObject.user.firstName,ACCGlobalObject.user.lastName];
     }];
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.0 initialSpringVelocity:0 options:0 animations:^
//     {
//         vwSideMenu.x = 0;
//         
//         self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
//     }
//                     completion:^(BOOL finished)
//     {
//         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//         
//         NSData *dataImage = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyProfileImage];
//         UIImage *image = [UIImage imageWithData:dataImage];
//         
//         if (dataImage == nil)
//         {
//             imgvUser.image = [UIImage imageNamed:@"userPlaceHolder"];
//         }
//         else
//         {
//             imgvUser.image = image;
//         }
//         
//         lblUserName.text = [NSString stringWithFormat:@"%@ %@",ACCGlobalObject.user.firstName,ACCGlobalObject.user.lastName];
//     }];
}

-(void)hideMenu
{
//    From Right
//    [UIView animateWithDuration:0.3 animations:^
//     {
//         self.view.backgroundColor = [UIColor clearColor];
//         
//         vwSideMenu.x = self.view.width;
//     }
//                     completion:^(BOOL finished)
//     {
//         self.view.x = CGRectGetWidth([UIScreen mainScreen].bounds);
//     }];
    
    
//    From Left
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.view.backgroundColor = [UIColor clearColor];
         
         vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
     }
                     completion:^(BOOL finished)
     {
         self.view.x = -CGRectGetWidth([UIScreen mainScreen].bounds);
     }];
}

- (void) displayController:(UIViewController *)controller forMenuItem:(UIButton *)btnMenuItem
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        vwSideMenu.x = -CGRectGetWidth(vwSideMenu.frame);
        self.view.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished)
     {
         self.view.x = -CGRectGetWidth([UIScreen mainScreen].bounds);
         [ACCGlobalObject.rootViewController setViewControllers:@[controller] animated:NO];
     }];

}

#pragma mark - AccountSettingsViewControllerDelegate Method
-(void)isFromAccountSettings
{
    [self showMenu];
}

@end
