//
//  TKTextboxToolbarHandeler.h
//  Trukit
//
//  Created by Chintan Dave on 06/05/14.
//  Copyright (c) 2014 zwt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ZWTTextboxToolbarHandlerDelegate <NSObject>

@optional
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidBeginEditing:(UITextView *)textView;
-(BOOL)textViewShouldEndEditing:(UITextView *)textView;

- (void)textFieldEndWithDoneButtonwithView:(UIView *)txtBox;
- (void)doneTap;
@end

@interface ZWTTextboxToolbarHandler : NSObject

@property (nonatomic) NSInteger offset;

@property (nonatomic) BOOL showNextPrevious;

@property (nonatomic, strong) id<ZWTTextboxToolbarHandlerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *textBoxes;
- (instancetype)initWithTextboxs:(NSMutableArray *)textBoxs andScroll:(UIScrollView *)scroll;
- (void) btnDoneTap;

@end