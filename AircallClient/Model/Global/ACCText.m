//
//  AIRText.m
//  AircallClient
//
//  Created by ZWT112 on 3/25/16.
//  Copyright © 2016 ZWT112. All rights reserved.
//

#pragma mark - Common Text
NSString *const AppName           = @"AirCall";
NSString *const ACCDeviceType     = @"iPhone";
NSString *const ACCNoInternet     = @"There is no network connection avaliable. Please connect to the internet and try again.";
NSString *const ACCServerError    = @"Could not connect to server. Please try again.";
NSString *const ACCTextOk         = @"OK";
NSString *const ACCTextYes        = @"Yes";
NSString *const ACCTextNo         = @"No";
NSString *const ACCTextCancel     = @"Cancel";
NSString *const ACCTextShowDetail = @"Show Detail";
NSString *const ACCTextSettings   = @"Settings";
NSString *const ACCInvalidRequest = @"Oops!!! Your session expired or your account may be logged using another device";
NSString *const ACCUnAuthorized   = @"You have been inactivated by Admin. Please contact to Admin.";
NSString *const ACCTextAgree      = @"Agree";
NSString *const ACCTextNotAgree   = @"Do not agree";

#pragma mark - Validation Message
NSString *const ACCInvalidFirstName      = @"Please enter valid first name";
NSString *const ACCInvalidLastName       = @"Please enter valid last name";
NSString *const ACCBlankFirstName        = @"Please enter first name";
NSString *const ACCBlankLastName         = @"Please enter last name";
NSString *const ACCBlankPhoneNumber      = @"Please enter number";
NSString *const ACCBlankEmail            = @"Please enter Email Address";
NSString *const ACCInvalidEmail          = @"Please enter valid Email Address";
NSString *const ACCBlankPassword         = @"Please enter Password";
NSString *const ACCValidPassword         = @"Please enter password of minimum 6 digits";
NSString *const ACCPasswordSpace         = @"Password contains space,Please re-enter password";
NSString *const ACCReBlankPassword       = @"Please re-enter password";
NSString *const ACCPasswordNoMatch       = @"Password doesn't match";
NSString *const ACCBlankDate             = @"Please choose the date";
NSString *const ACCBlankReason           = @"Please enter the reason";
NSString *const ACCInvalidMobileNumber   = @"Cell Number must have minimum 10 digits.";
NSString *const ACCInvalidPhoneNumber    = @"Phone Number must have minimum 8 digits.";
NSString *const ACCBlankUnitName         = @"Please enter unit name";
NSString *const ACCInvalidUnitName       = @"Please enter valid unit name";
NSString *const ACCInvalidNumber         = @"Please enter only numeric characters";

NSString *const ACCBlankOldPassword      = @"Please enter Old Password";
NSString *const ACCBlankNewPassword      = @"Please enter New Password";

NSString *const ACCBlankState            = @"Please select State";
NSString *const ACCBlankCity             = @"Please select City" ;
NSString *const ACCBlankAddress          = @"Please enter Address";
NSString *const ACCBlankZipcode          = @"Please enter Zip Code";

NSString *const ACCInvalidZipcode        = @"Please enter only numeric values";
NSString *const ACCZipcodeFiveLetter     = @"Please enter five letter Zip Code";

NSString *const ACCTextLoading    = @"Loading ...";
NSString *const ACCTextNoMoreData = @"No more data";

NSString *const ACCTextAskImageSource      = @"How do you want to select an image?";
NSString *const ACCAllowAccessPhotoLibrary = @"Does not have access to your photos. To enable access, tap on Settings and turn on Photos.";
NSString *const ACCAllowAccessCamera       = @"Does not have access to your camera. To enable access, tap on Settings and turn on Camera.";

NSString *const ACCDeleleUnitNotAllowed    = @"Units are available on this address. Thereby, you can not delete this address.";

NSString *const ACCNoAddressAdded     = @"No address has been added yet.";
NSString *const ACCNoActiveAddress    = @"No active address has been added yet.";
NSString *const ACCDeleteConformation = @"Are you sure you want to delete?";

NSString *const ACCNotAllowReschedule  = @"You are going to reschedule the service less then 24hr before the meeting. May be you will charge late reschedule penalty. Are you sure you want to reschedule the service?";

CGSize const ACCProfileImageMinSize   = {300, 300};

//Validation Add Unit
NSString *const ACCPlanSelection     = @"Please select any plan";
NSString *const ACCAddressSelection  = @"Please select or add any address";
NSString *const ACCInsideEquipment   = @"Inside Equipment";
NSString *const ACCOldUnitsAvailable = @"Previously added unit failed to complete. Did you want to load them first? If you answer NO they will be deleted.";
NSString *const ACCProcessingUnitsAvailable = @"Payment for old units is in process. Please try again later.";

#pragma mark - Button Message
NSString *const ACCTextFromCamera  = @"Take Photo";
NSString *const ACCTextFromLibrary = @"From Albums";

#pragma mark - Card Validation
NSString *const ACCInvalidNameOnCard     = @"Please enter valid name";
NSString *const ACCBlankNameOnCard       = @"Please enter your name";
NSString *const ACCBlankCardNumber       = @"Please enter a card number";
NSString *const ACCValidCardNumber       = @"Please enter valid card number";
NSString *const ACCBlankCardType         = @"Please choose card type";
NSString *const ACCBlankExpiryMonth      = @"Please enter expiry month";
NSString *const ACCValidExpiryMonth      = @"Please enter valid expiration month";
NSString *const ACCBlankExpiryYear       = @"Please enter expiry year";
NSString *const ACCBlankCVV              = @"Please enter CVV";
NSString *const ACCValidCVV              = @"Please enter valid CVV of card";
NSString *const ACCUnitLimit             = @"Only 5 units can be added per order";
NSString *const ACCVisitLimit            = @"Only 12 visits can be added per order";
NSString *const ACCValidQtyOfUnits       = @"Please enter valid quantity of Units.";
NSString *const ACCValidVisitPerYear     = @"Please enter valid visit per year.";

NSString *const ACCCardVisa              = @"Visa";
NSString *const ACCCardMaster            = @"MasterCard";
NSString *const ACCCardDiscover          = @"Discover";
NSString *const ACCCardAmerican          = @"AMEX";

NSString *const ACCAgreeToTerms = @"Please agree to Terms & Conditions";

NSString *const ACCBlankMessage = @"Please enter message";

NSString *const ACCBlankNotes = @"Please enter notes";

NSString *const ACCNoAddreess = @"Please add any address to submit your request.";

NSString *const ACCNoUnitsSelected = @"Please select the units to be serviced";

NSString *const ACCNoComplaint = @"Complaint was not added.";

NSString *const ACCBlankReview = @"Please enter review";

NSString *const ACCBlankRating = @"Please provide rating";

NSString *const ACCThankYou = @"Thank You!! for registering with AirCall";

NSString *const ACCUnitsLimit = @"More hours required to perform the service. Morning timeslot must be picked.";

NSString *const ACCChooseAnotherAddress = @"Please select another address as Default first";

NSString *const ACCNoRecordFound = @"No record found";

NSString *const ACCNotAllowWeekends = @"Only emergency services can be scheduled on weekends. Either change this request to Emergency (fee will incur) or please request the service during regular business hours.";
