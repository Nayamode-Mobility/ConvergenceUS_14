//
//  optin.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 16/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum OptinTags
{
    ALLOW_IN_APP_MESSAGING = 1,
    MAKE_YOUR_EMAIL_ID_PRIVATE = 2,
    MAKE_YOUR_PHONE_NUMBER_PRIVATE = 3,
    MAKE_YOUR_NAME_PRIVATE = 4,
    MAKE_YOUR_DESIGNATION_PRIVATE = 5,
    MAKE_YOUR_COMPANY_NAME_PRIVATE = 6,
    ALLOW_FOR_MEETING_REQUEST = 7,
    HIDE_YOUR_BIOGRAPHY = 8,
    HIDE_YOUR_PHOTOS = 9
}OptinTags;

@interface optin : UIViewController
{
    IBOutlet UILabel *lblGreenTitle;
    IBOutlet UIButton *btnBack;
    IBOutlet UISwitch  *swAllowInAppMessaging;
    IBOutlet UISwitch  *swMakeYourEmailIDPrivate;
    IBOutlet UISwitch  *swMakeYourPhoneNumberPrivate;
    IBOutlet UISwitch  *swMakeYourNamePrivate;
    IBOutlet UISwitch  *swMakeYourDesignationPrivate;
    IBOutlet UISwitch  *swMakeYourCompanyNamePrivate;
    IBOutlet UISwitch  *swAllowForMeetingRequest;
    IBOutlet UISwitch  *swHideYourBiography;
    IBOutlet UISwitch  *swHideYourPhotos;
    
    IBOutlet UIButton *btnSignAndContinue;
    IBOutlet UIButton *btnSave;
}

@property (nonatomic, retain) IBOutlet UILabel *lblGreenTitle;
@property (nonatomic, retain) IBOutlet UIButton *btnBack;

@property (nonatomic, retain) UISwitch  *swAllowInAppMessaging;
@property (nonatomic, retain) UISwitch  *swMakeYourEmailIDPrivate;
@property (nonatomic, retain) UISwitch  *swMakeYourPhoneNumberPrivate;
@property (nonatomic, retain) UISwitch  *swMakeYourNamePrivate;
@property (nonatomic, retain) UISwitch  *swMakeYourDesignationPrivate;
@property (nonatomic, retain) UISwitch  *swMakeYourCompanyNamePrivate;
@property (nonatomic, retain) UISwitch  *swAllowForMeetingRequest;
@property (nonatomic, retain) UISwitch  *swHideYourBiography;
@property (nonatomic, retain) UISwitch  *swHideYourPhotos;

@property (nonatomic, retain) UIButton *btnSignAndContinue;
@property (nonatomic, retain) UIButton *btnSave;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

@property (nonatomic, assign) BOOL blnCalledFromResources;

- (void)GetOptins;
- (void)SetOptins:(NSData*)objData;
- (void)loadHome;
- (void)loadSyncup;

- (IBAction)SaveAndcontinue;
- (IBAction)btnBackClicked:(id)sender;
@end
