//
//  ACCMessageBar.h
//  AssetArbor
//
//  Created by Manali on 29/01/16.
//  Copyright © 2016 com.ztt.www. All rights reserved.
//

extern NSInteger const ACCValidationMsgHeight;
extern NSInteger const ACCValidationMsgFontHeight;
extern NSString *const ACCValidationMsgFont;

@interface ACCMessageBar : UIControl

@property (strong, nonatomic) NSString *message;

@property (weak, nonatomic) UIView *relatedView;

- (void)prepareForError;

@end
