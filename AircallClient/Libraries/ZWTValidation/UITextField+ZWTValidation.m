//
//  UITextField+ZWTValidation.m
//  ZWTValidation Example
//
//  Created by chintan on 08/07/13.
//  Copyright (c) 2013 ZWT. All rights reserved.
//

#import "UITextField+ZWTValidation.h"

@implementation UITextField (ZWTValidation)

- (ZWTValidationResult) validate:(ZWTValidationType)type
{
    @try
    {
        ZWTValidationResult result;
        
        switch (type)
        {
            case ZWTValidationTypeBlank:
                result = [ZWTValidation isBlank:self.text];
                break;
                
            case ZWTValidationTypeEmail:
                self.text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                result = [ZWTValidation validateEmail:self.text isRequire:YES];
                break;
                
            case ZWTValidationTypePassword:
                result = [ZWTValidation validatePassword:self.text isRequire:YES];
                break;
            
            case ZWTValidationTypeName:
                result = [ZWTValidation validateName:self.text isRequire:YES];
                break;
                
            case ZWTValidationTypeNumber:
                result = [ZWTValidation validateNumber:self.text isRequire:YES];
                break;
                
            case ZWTValidationTypeInteger:
                result = [ZWTValidation validateInteger:self.text isRequire:NO];
                break;
                
            case ZWTValidationTypeAlphaNoSpace:
                result = [ZWTValidation validateAlphaNospace:self.text isRequire:NO];
                break;
                
            case ZWTValidationTypeAlphaWithSpace:
                result = [ZWTValidation validateAlphaWithspace:self.text isRequire:NO];
                break;
                
            case ZWTValidationTypeAlphaNumericNospace:
                result = [ZWTValidation validateAlphaNumericNospace:self.text isRequire:NO];
                break;
                
            case ZWTValidationTypeAlphaNumericWithspace:
                result = [ZWTValidation validateAlphaNumericWithspace:self.text isRequire:NO];
                break;
            case ZWTValidationTypeRegExp:
                break;
        }
        
        return result;
    }
    @catch (NSException *exception)
    {
       
    }
}

- (ZWTValidationResult) validate:(ZWTValidationType)type showRedRect:(BOOL)errorRect
{
    ZWTValidationResult result = [self validate:type];
    
    if(result != ZWTValidationResultValid && errorRect)
    {
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[UIColor redColor].CGColor];
        [self setClipsToBounds:YES];
    }
    else
    {
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[UIColor borderColor].CGColor];
        [self setClipsToBounds:YES];
    }
    
    return result;
}

- (ZWTValidationResult) validate:(ZWTValidationType)type showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError
{
    ZWTValidationResult result = [self validate:type showRedRect:errorRect];
    
    if(result != ZWTValidationResultValid && focusOnError)
    {
        [self becomeFirstResponder];
    }
    
    return result;
}

- (ZWTValidationResult) validate:(ZWTValidationType)type showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError alertMessage:(NSString *)message;
{
    ZWTValidationResult result = [self validate:type showRedRect:errorRect getFocus:focusOnError];

    if(result != ZWTValidationResultValid && message)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation"
                                                        message:message
                                                       delegate:Nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    
    return result;
}

- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp
{
    return [ZWTValidation validateString:self.text againstRegExp:regExp];
}

- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp showRedRect:(BOOL)errorRect
{
    ZWTValidationResult result = [ZWTValidation validateString:self.text againstRegExp:regExp];
    
    if(result != ZWTValidationResultValid && errorRect)
    {
        (self.layer).borderWidth = 2;
        [self.layer setBorderColor:[UIColor redColor].CGColor];
        [self setClipsToBounds:YES];
    }
    else
    {
        (self.layer).borderWidth = 1;
        (self.layer).borderColor = [UIColor borderColor].CGColor;
        [self setClipsToBounds:YES];
    }
    
    return result;
}

- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError
{
    ZWTValidationResult result = [self validateWithRegExp:regExp showRedRect:errorRect];
    
    if(result != ZWTValidationResultValid && focusOnError)
    {
        [self becomeFirstResponder];
    }
    
    return result;
}

- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError alertMessage:(NSString *)message
{
    ZWTValidationResult result = [self validateWithRegExp:regExp showRedRect:errorRect getFocus:focusOnError];
    
    if(result != ZWTValidationResultValid && message)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation"
                                                        message:message
                                                       delegate:Nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    
    return result;
}

@end