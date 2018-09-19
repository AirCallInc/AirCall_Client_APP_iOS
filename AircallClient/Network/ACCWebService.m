//
//  AIRWebService.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.

#import "ACCWebService.h"

#define BasePath @"https://beta.aircallservices.com/"

//#define BasePath @"http://192.168.1.121:8989/"

#define BaseFilePath BasePath @""

NSString *const BaseAPIPath = BasePath @"api/v1/";
NSString *const BaseUrlPath = BasePath;
//NSString *const BaseAPIPath = BasePath @"api/";
NSString *const BaseProfileImagePath = BaseFilePath @"images/user/%@/Profile-Image/";

NSString *const BaseImagePath = BaseFilePath @"";

NSString *const RKeyCode     = @"StatusCode";
NSString *const RKeyData     = @"Data";
NSString *const RKeyMessage  = @"Message" ;
NSString *const RKeyToken    = @"Token";

NSInteger const RCodeSuccess        = 200;
NSInteger const RCodeRequestFail    = 00;
NSInteger const RCodeNoData         = 404;
NSInteger const RCodeInvalidRequest = 401;
NSInteger const RCodeUnAuthorized   = 406;

@implementation ACCWebService

#pragma mark - Initialization Method
+(ACCWebService *)APIClient
{
   
    static ACCWebService *_sharedClient = nil;
    static dispatch_once_t onceToken;
   
    dispatch_once(&onceToken, ^
                  {
                       NSURL *baseURL = [NSURL URLWithString:BaseAPIPath];
                
                      NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                      
                      _sharedClient = [[ACCWebService alloc] initWithBaseURL:baseURL sessionConfiguration:config];
                      _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
                      [_sharedClient.requestSerializer setTimeoutInterval:100];
                      _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
                  });
    
    return _sharedClient;
}

#pragma mark - Error Handler Methods
-(void)requestFail:(NSURLSessionDataTask *)task withError:(NSError *)error
{
    NSString *htmlError = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                encoding:NSUTF8StringEncoding];
    
    DDLogError(@"Error in Text format : %@", htmlError);
    
    [SVProgressHUD dismiss];
    
    if(error.code == kCFURLErrorTimedOut)
    {
        [ACCUtil showAlertFromController:nil withMessage:error.localizedDescription];
    }
    else if(error.code == kCFURLErrorCannotConnectToHost)
    {
        [ACCUtil showAlertFromController:nil withMessage:ACCServerError];
    }
    else if(error.code == kCFURLErrorCannotFindHost || error.code == kCFURLErrorNetworkConnectionLost)
    {
        [ACCUtil showAlertFromController:nil withMessage:ACCNoInternet];
    }
    else
    {
        [ACCUtil showAlertFromController:nil withMessage:error.localizedDescription];
    }
}

#pragma mark - URL Path Generation Methods
+ (NSURL *)URLForProfileImage:(NSString *)profileImageName andClientID:(NSString *)clientID
{
    if(![profileImageName isEqualToString:@""] && ![clientID isEqualToString:@""])
    {
        NSString *profileImagepath = [NSString stringWithFormat:BaseProfileImagePath, clientID];
        
        NSURL *profileImageURL = [NSURL URLWithString:profileImagepath];
        
        profileImageURL = [profileImageURL URLByAppendingPathComponent:profileImageName];
        
        return profileImageURL;
    }
    
    return nil;
}

+ (void)downloadImageWithURL:(NSURL *)URLImage complication:(void (^)(UIImage *image, NSError *error))completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URLImage.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         UIImage *image = [UIImage imageWithData:responseObject];
         
         if(image)
         {
             completion(image, nil);
         }
         else
         {
             completion(nil, nil);
         }
     }
         failure:^(NSURLSessionTask *operation, NSError *error)
     {
         completion(nil, error);
     }];
}
@end

@implementation ACCAPIResponse
@synthesize code,message,error,token;

- (instancetype)initWithCode:(NSInteger)statusCode Message:(NSString *)responseMessage Token:(NSString*)responseToken
{
    self = [super init];
    
    if(self)
    {
        code    = statusCode;
        message = responseMessage;
        token   = responseToken;
    }
    
    return self;
}

- (instancetype)initWithCode:(NSInteger)statusCode andError:(NSError *)errorDetail
{
    self = [super init];
    
    if(self)
    {
        code  = statusCode;
        error = errorDetail;
    }
    
    return self;
}
@end
