//
//  ACCViewController.h
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

@interface ACCViewController : UIViewController

@property (weak,nonatomic) UIStoryboard *__nullable storyboardLoginSignupProfile;

- (void)showErrorMessage:(NSString *_Nonnull)message belowView:(UIView *_Nonnull)viewDisplay;
- (void)removeErrorMessageBelowView:(UIView *_Nonnull)viewDisplay;
- (void)showAlertWithMessage:(NSString *__nullable)message;
- (void)showAlertFromWithMessage:(NSString *__nullable)message andHandler:(void (^ __nullable)(UIAlertAction *__nullable action))handler;
- (void)showAlertFromWithMessageWithSingleAction:(NSString *__nullable)message andHandler:(void (^ __nullable)(UIAlertAction *__nullable action))handler;
- (void)openSideBar;
-(void)zoomOutanimation;
-(void)savePasswordInUserDefault:(NSDictionary *_Nonnull)dict;
@end

