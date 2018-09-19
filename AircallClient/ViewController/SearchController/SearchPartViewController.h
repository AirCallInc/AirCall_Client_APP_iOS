//
//  SearchPartViewController.h
//  AircallClient
//
//  Created by ZWT111 on 21/06/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

extern NSString *const KeyPartType;


#import "ACCViewController.h"

@protocol SearchPartViewControllerDelegate <NSObject>

-(void)SelectionValue:(ACCPart*)selectedPart;

@end


@interface SearchPartViewController : ACCViewController

@property  (nonatomic ,strong) NSString *partType;
@property  (nonatomic, strong) id<SearchPartViewControllerDelegate> delegate;
@property  (nonatomic, strong) ACCPart *selectedPart;
@end
