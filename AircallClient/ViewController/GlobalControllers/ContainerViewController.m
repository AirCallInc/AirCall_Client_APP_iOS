//
//  ContainerViewController.m
//  AircallClient
//
//  Created by ZWT111 on 31/03/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    RootViewController * center = (RootViewController *)[self.childViewControllers firstObject];
    
    [center setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self	setModalPresentationStyle:UIModalPresentationCurrentContext];
    [ACCGlobalObject setRootViewController:center];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
