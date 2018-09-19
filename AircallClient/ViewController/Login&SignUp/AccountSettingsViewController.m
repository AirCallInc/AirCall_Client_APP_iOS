//
//  AccountSettingsViewController.m
//  AircallClient
//
//  Created by ZWT112 on 5/18/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#import "AccountSettingsViewController.h"

@interface AccountSettingsViewController ()<UpdateUserNameViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ContactViewControllerDelegate>
@property NSArray *arrUserProfileInfo;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImage;
@property (strong, nonatomic) IBOutlet UILabel *lblCompanyName;

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *companyName;
@property ACCUser * userAccountData;
@end

@implementation AccountSettingsViewController

@synthesize  arrUserProfileInfo,lastName,firstName,txtPassword,lblEmail,lblName,btnUserImage,userAccountData,delegate,lblCompanyName,companyName;


#pragma mark - ACCViewController Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareView];
    [self getProfileData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Helper Method
-(void)prepareView
{
    btnUserImage.layer.cornerRadius = btnUserImage.width / 2;
    btnUserImage.layer.masksToBounds = YES;
    lblName.adjustsFontSizeToFitWidth = YES;
    arrUserProfileInfo = [[NSArray alloc]init];
}
-(void)setProfileData
{
    firstName = userAccountData.firstName;
    lastName = userAccountData.lastName;
    companyName = userAccountData.companyName;
    lblName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    lblEmail.text = userAccountData.email;
    lblCompanyName.text = companyName;
    
    [ACCWebService downloadImageWithURL:userAccountData.profileImageURL complication:^(UIImage *image, NSError *error)
     {
         if (image)
         {
             [btnUserImage setImage:image forState:UIControlStateNormal];
             [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:UKeyProfileImage];
         }
         else
         {
             [btnUserImage setImage:[UIImage imageNamed:@"userPlaceHolder"] forState:UIControlStateNormal];
         }
     }];
 
//    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:UKeyProfileImage];
//    
//    UIImage* image = [UIImage imageWithData:imageData];
//
//    if (image == nil)
//    {
//        [btnUserImage setImage:[UIImage imageNamed:@"userPlaceHolder"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [btnUserImage setImage:image forState:UIControlStateNormal];
//    }
}
-(void)saveInUserDefault
{
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(btnUserImage.imageView.image) forKey:UKeyProfileImage];
    
    ACCGlobalObject.user.firstName = firstName;
    ACCGlobalObject.user.lastName  = lastName;
    
    NSDictionary *dictUser = @{
                               UKeyID           : ACCGlobalObject.user.ID,
                               UKeyFirstName    : ACCGlobalObject.user.firstName,
                               UKeyLastName     : ACCGlobalObject.user.lastName,
                               //UKeyCompany      : ACCGlobalObject.user.companyName,
                               UKeyEmail        : ACCGlobalObject.user.email,
                               UKeyPassword     : ACCGlobalObject.user.password,
                               UKeyMobileNumber : ACCGlobalObject.user.mobileNumber
                               };
    [ACCGlobalObject.user saveInUserDefaults:dictUser];
}

#pragma mark - Event Methods
- (IBAction)btnMenuTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSubmitTap:(id)sender
{
    [self updateProfileData];
}
- (IBAction)btnChangePwdTap:(id)sender
{
    ChangePasswordViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)btnContactNoTap:(id)sender
{
    ContactViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    viewController.accContactInfo = userAccountData;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)btnPaymentMethodTap:(id)sender
{
    PaymentMethodViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentMethodViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)btnBillingHistoryTap:(id)sender
{
    BillingHistoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BillingHistoryViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)btnEditTap:(id)sender
{
    UpdateUserNameViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdateUserNameViewController"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    viewController.delegate = self;
    viewController.strFirstName = firstName;
    viewController.strLastName  = lastName;
    viewController.strCompanyName = companyName;
    
    [self.navigationController presentViewController:viewController animated:NO completion:nil];
}
- (IBAction)btnUserImageTap:(id)sender
{
    [self askImageSource];
}

#pragma mark - WebService Method
-(void)getProfileData
{
    [SVProgressHUD show];
    
    [ACCWebServiceAPI getClientProfile:ACCGlobalObject.user.ID completionHandler:^(ACCAPIResponse *response, ACCUser *userInfo)
    {
        if (response.code == RCodeSuccess)
        {
            userAccountData = userInfo;
            [self setProfileData];
        }
        else if (response.code == RCodeInvalidRequest)
        {
            [self showAlertFromWithMessageWithSingleAction:ACCInvalidRequest andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACCUtil logoutTap];
             }];
        }
        else if (response.code == RCodeUnAuthorized)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:response.message];
        }
        [SVProgressHUD popActivity];
    }];

}
-(void)updateProfileData
{
    [SVProgressHUD show];
    
    NSDictionary *userInfo = @{
                               UKeyID        : ACCGlobalObject.user.ID,
                               UKeyFirstName : firstName,
                               UKeyLastName  : lastName,
                               UKeyImage     : btnUserImage.imageView.image,
                               UKeyCompany   : companyName
                               };
    
    [self saveInUserDefault];
    
    [ACCWebServiceAPI updateUserProfile:userInfo completionHandler:^(ACCAPIResponse *response)
    {
        [SVProgressHUD dismiss];
        if (response.code == RCodeSuccess)
        {
            [self showAlertWithMessage:response.message];
        }
        else if (response.code == RCodeInvalidRequest)
        {
            [self showAlertFromWithMessageWithSingleAction:ACCInvalidRequest andHandler:^(UIAlertAction * _Nullable action)
             {
                 [ACCUtil logoutTap];
             }];
        }
        else if (response.code == RCodeUnAuthorized)
        {
            [self showAlertWithMessage:response.message];
        }
        else
        {
            [self showAlertWithMessage:response.message];
        }
    }];
}

#pragma mark - UpdateUserNameViewController Delegate Method
-(void)userName:(NSString *)strFirstName lastName:(NSString *)strLastName companyName:(NSString *)strCompany
{
    firstName = strFirstName;
    lastName = strLastName;
    companyName = strCompany;
    lblName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    lblCompanyName.text = strCompany;
}

-(void)askImageSource
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:AppName
                                                                         message:ACCTextAskImageSource
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:ACCTextFromCamera
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectUserImageFrom:UIImagePickerControllerSourceTypeCamera];
                                   
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:ACCTextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectUserImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
                                }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:ACCTextCancel
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                             {
                                 [actionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:fromAlbum];
    [actionSheet addAction:cancel];
    
    actionSheet.popoverPresentationController.sourceView = self.view;
    actionSheet.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    actionSheet.popoverPresentationController.sourceRect = CGRectMake(self.view.width/2, self.view.height/2 , 1.0, 1.0);
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)selectUserImageFrom:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        // Denied when photo disabled, authorized when photos is enabled. Not affected by camera
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
        
        BOOL isAuthorizedLibrary = NO;
        
        if (photoStatus == PHAuthorizationStatusAuthorized)
        {
            // Access has been granted.
            isAuthorizedLibrary = YES;
            [self openImagePicker:sourceType];
        }
        else if (photoStatus == PHAuthorizationStatusDenied)
        {
            // Access has been denied.
        }
//        else if (status == PHAuthorizationStatusNotDetermined)
//        {
//            // Access has not been determined.
//        }
        else if (photoStatus == PHAuthorizationStatusRestricted)
        {
            // Restricted access - normally won't happen.
        }
        
        if (isAuthorizedLibrary == NO)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus Authstatus)
             {
                 if (Authstatus == PHAuthorizationStatusAuthorized)
                 {
                     // Access has been granted.
                     [self openImagePicker:sourceType];
                 }
                 else
                 {
                     // Access has been denied.
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                    message:[NSString stringWithFormat:@"%@ %@",AppName,ACCAllowAccessPhotoLibrary]
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:ACCTextCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           
                                       }]];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:ACCTextSettings style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }]];
                     [self presentViewController:alert animated:YES completion:nil];

                     //[self showAlertWithMessage:ACCAllowAccessPhotoLibrary];
                 }
             }];
        }
        
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // Checks for Camera access:
        
        BOOL isAuthorizedCamera = NO;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized)
        {
            // do your logic
            isAuthorizedCamera = YES;
            [self openImagePicker:sourceType];
        }
        else if(authStatus == AVAuthorizationStatusDenied)
        {
            // denied
        }
        else if(authStatus == AVAuthorizationStatusRestricted)
        {
            // restricted, normally won't happen
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            // not determined?!
        }
        else
        {
            // impossible, unknown authorization status
        }
        
        if (isAuthorizedCamera == NO)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self openImagePicker:sourceType];
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                       message:[NSString stringWithFormat:@"%@ %@",AppName,ACCAllowAccessCamera]
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:ACCTextCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                          {
                                                              
                                                          }]];
                                        
                                        [alert addAction:[UIAlertAction actionWithTitle:ACCTextSettings style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                                          {
                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                          }]];
                                        [self presentViewController:alert animated:YES completion:nil];
                                        //[self showAlertWithMessage:ACCAllowAccessCamera];
                                    });
                 }
             }];
        }
    }
    else
    {

        NSAssert(NO, @"Permission type not found");
    }
}

-(void)openImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    imagePicker.delegate      = self;
    imagePicker.sourceType    = sourceType;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate Method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
         CGRect cropRect = [info[UIImagePickerControllerCropRect] CGRectValue];
         selectedImage = [selectedImage fixOrientation];
         selectedImage = [selectedImage cropedImagewithCropRect:cropRect];
         [btnUserImage setImage:selectedImage forState:UIControlStateNormal];
         //[btnUserImage setImage:[selectedImage resizedImageForProfile] forState:UIControlStateNormal];
     }];
}

#pragma mark - ContactViewControllerDelegate Method
-(void)contactNumbers:(NSDictionary *)dictNumbers
{
    ACCUser *user = [[ACCUser alloc]initWithDictionary:dictNumbers];
    userAccountData.officeNumber = user.officeNumber;
    userAccountData.mobileNumber = user.mobileNumber;
    userAccountData.homeNumber   = user.homeNumber;
}

@end
