//
//  ACCViewController.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ACCViewController.h"

@interface ACCViewController ()

@property (strong, nonatomic) ACCMessageBar *messageBar;
@property SideBarViewController *sideBarViewController;

@end

@implementation ACCViewController
@synthesize messageBar,sideBarViewController;

#pragma mark - UIViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ACCMessage Bar Methods
- (ACCMessageBar *)messageBar
{
    if(!messageBar)
    {
        messageBar = [[ACCMessageBar alloc] init];
    }
    
    return messageBar;
}

- (void)showErrorMessage:(NSString *)message belowView:(UIView *)viewDisplay
{
    CGRect messageBarFrame      = self.messageBar.frame;
    
    messageBarFrame.origin.x    = CGRectGetMinX(viewDisplay.frame);
    messageBarFrame.origin.y    = CGRectGetMaxY(viewDisplay.frame) + 3;
    messageBarFrame.size.width  = CGRectGetWidth(viewDisplay.frame);
    messageBarFrame.size.height = 0;
    
    self.messageBar.frame       = messageBarFrame;
    self.messageBar.message     = message;
    self.messageBar.relatedView = viewDisplay;
    
    [self.messageBar prepareForError];
    
    [viewDisplay.superview addSubview:self.messageBar];
    
    [UIView animateWithDuration:0.3 animations:^
     {
         self.messageBar.height = ACCValidationMsgHeight;
     }];
}

- (void)removeErrorMessageBelowView:(UIView *)viewDisplay
{
    if (self.messageBar.relatedView == viewDisplay)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             self.messageBar.height = 0;
         }
                         completion:^(BOOL finished)
         {
             [self.messageBar removeFromSuperview];
         }];
    }
}

#pragma mark - Alert Methods
- (void)showAlertWithMessage:(NSString *)message
{
    [ACCUtil showAlertFromController:self withMessage:message];
}

- (void)showAlertFromWithMessage:(NSString *)message andHandler:(void (^ __nullable)(UIAlertAction *action))handler
{
    [ACCUtil showAlertFromController:self withMessage:message andHandler:handler];
}

- (void)showAlertFromWithMessageWithSingleAction:(NSString *__nullable)message andHandler:(void (^ __nullable)(UIAlertAction *__nullable action))handler
{
    [ACCUtil showAlertFromControllerWithSingleAction:self withMessage:message andHandler:handler];
}

#pragma mark- UIStoryboard Methods
-(UIStoryboard*)storyboardLoginSignupProfile
{
    return ACCGlobalObject.storyboardLoginSignupProfile;
}
-(void)openSideBar
{
    if(!sideBarViewController)
    {
        sideBarViewController = [ACCGlobalObject.storyboardMenuBar instantiateViewControllerWithIdentifier:@"SideBarViewController"];
        [self.view addSubview:sideBarViewController.view];
    }
    
    [sideBarViewController showMenu];
}

#pragma mark - Animation Method
-(void)zoomOutanimation
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromBottom;
    [self.view.window.layer addAnimation:transition forKey:kCATransition];
}

#pragma mark - Save in userdefault Method
-(void)savePasswordInUserDefault:(NSDictionary*)dict
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setValue:dict forKey:UKeySaveCurrentEmailPass];
    
    [userDefaults synchronize];
}

@end
