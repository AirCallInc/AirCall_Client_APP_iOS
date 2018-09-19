//
//  ACCWebService.h
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "AFHTTPSessionManager.h"

extern NSString *const BaseImagePath ;
extern NSString *const BaseAPIPath   ;
extern NSString *const BaseUrlPath   ;
extern NSString *const BaseProfileImagePath;

extern NSString *const RKeyCode     ;
extern NSString *const RKeyData     ;
extern NSString *const RKeyMessage  ;
extern NSString *const RKeyToken    ;

extern NSInteger const RCodeSuccess       ;
extern NSInteger const RCodeNoData        ;
extern NSInteger const RCodeRequestFail   ;
extern NSInteger const RCodeInvalidRequest;
extern NSInteger const RCodeUnAuthorized  ;

#define ACCWebServiceAPI [ACCWebService APIClient]

@interface ACCWebService : AFHTTPSessionManager

+ (ACCWebService *)APIClient;

-(void)requestFail:(NSURLSessionDataTask *)task withError:(NSError *)error;

+ (NSURL *)URLForProfileImage:(NSString *)profileImageName andClientID:(NSString *)clientID;
+ (void)downloadImageWithURL:(NSURL *)URLImage complication:(void (^)(UIImage *image, NSError *error))completion;

@end


@interface ACCAPIResponse : NSObject
@property (nonatomic)         NSInteger code   ;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSError  *error  ;
@property (strong, nonatomic) NSString *token  ;

- (instancetype)initWithCode:(NSInteger)statusCode Message:(NSString *)responseMessage Token:(NSString*)responseToken;
- (instancetype)initWithCode:(NSInteger)statusCode andError:(NSError *)errorDetail;
@end
