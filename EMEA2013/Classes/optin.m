//
//  optin.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 16/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "optin.h"
#import "Home.h"
#import "SyncUp.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Shared.h"
#import "AppSettings.h"
#import "User.h"
#import "optin.h"
#import "FBJSON.h"
#import "NSURLConnection+Tag.h"
#import "Functions.h"
#import "AppDelegate.h"

@interface optin ()
{
    @private
    BOOL blnAllowInAppMessaging;
    BOOL blnMakeYourEmailIDPrivate;
    BOOL blnMakeYourPhoneNumberPrivate;
    BOOL blnMakeYourNamePrivate;
    BOOL blnMakeYourDesignationPrivate;
    BOOL blnMakeYourCompanyNamePrivate;
    BOOL blnAllowForMeetingRequest;
    BOOL blnHideYourBiography;
    BOOL blnHideYourPhotos;
}
@end

@implementation optin
#pragma mark Synthesize
@synthesize swAllowInAppMessaging, swMakeYourEmailIDPrivate, swMakeYourPhoneNumberPrivate, swMakeYourNamePrivate, swMakeYourDesignationPrivate,
            swMakeYourCompanyNamePrivate, swAllowForMeetingRequest, swHideYourBiography, swHideYourPhotos;
@synthesize btnSignAndContinue, btnSave;
@synthesize objConnection, objData;
@synthesize lblGreenTitle, btnBack, blnCalledFromResources;
#pragma mark -

#pragma mark View Events
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(blnCalledFromResources == YES)
    {
        [btnBack setHidden: NO];
        [lblGreenTitle setFrame:CGRectMake(60, 45, 250, 45)];
        [[self btnSignAndContinue] setHidden:YES];
        [[self btnSave] setHidden:NO];
    }
        
    [self GetOptins];
    
    [[btnSignAndContinue layer] setBorderWidth:2.0f];
    [[btnSignAndContinue layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [btnSignAndContinue addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnSignAndContinue addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[btnSave layer] setBorderWidth:2.0f];
    [[btnSave layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [btnSave addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnSave addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SETTINGS];
    
    //[UIView addTouchEffect:self.view];
    
    [APP hideBottomPullOutMenu];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if([DeviceManager IsiPad] == YES)
    {
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (void)GetOptins
{
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_GET_PRIVACY];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_PRIVACY];
}

- (void)SetOptins:(NSData *)objSettings
{
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objSettings options:kNilOptions error:&error];
    
    if(error==nil)
    {
        blnAllowInAppMessaging = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"AllowInAppMessanging"]] boolValue];
        blnMakeYourEmailIDPrivate = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsEmailVisible"]] boolValue];
        blnMakeYourPhoneNumberPrivate = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsPhoneNumberVisible"]] boolValue];
        blnMakeYourNamePrivate = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsNameVisible"]] boolValue];
        blnMakeYourDesignationPrivate = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsDesginationVisible"]] boolValue];
        blnMakeYourCompanyNamePrivate = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsCompanyVisible"]] boolValue];
        blnAllowForMeetingRequest = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsNotificationEnabled"]] boolValue];
        blnHideYourBiography = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsBioVisible"]] boolValue];
        blnHideYourPhotos = [[Functions ReplaceNUllWithZero:[dictData valueForKey:@"IsPhotoVisible"]] boolValue];
    }
    
    [swAllowInAppMessaging setOn:blnAllowInAppMessaging];
    [swMakeYourEmailIDPrivate setOn:blnMakeYourEmailIDPrivate];
    [swMakeYourPhoneNumberPrivate setOn:blnMakeYourPhoneNumberPrivate];
    [swMakeYourNamePrivate setOn:blnMakeYourNamePrivate];
    [swMakeYourDesignationPrivate setOn:blnMakeYourDesignationPrivate];
    [swMakeYourCompanyNamePrivate setOn:blnMakeYourCompanyNamePrivate];
    [swAllowForMeetingRequest setOn:blnAllowForMeetingRequest];
    [swHideYourBiography setOn:blnHideYourBiography];
    [swHideYourPhotos setOn:blnHideYourPhotos];
}

- (IBAction)SaveAndcontinue
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    blnAllowInAppMessaging = [swAllowInAppMessaging isOn];
    blnMakeYourEmailIDPrivate = [swMakeYourEmailIDPrivate isOn];
    blnMakeYourPhoneNumberPrivate = [swMakeYourPhoneNumberPrivate isOn];
    blnMakeYourNamePrivate = [swMakeYourNamePrivate isOn];
    blnMakeYourDesignationPrivate = [swMakeYourDesignationPrivate isOn];
    blnMakeYourCompanyNamePrivate = [swMakeYourCompanyNamePrivate isOn];
    blnAllowForMeetingRequest = [swAllowForMeetingRequest isOn];
    blnHideYourBiography = [swHideYourBiography isOn];
    blnHideYourPhotos = [swHideYourPhotos isOn];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    [dictData setObject:[NSNumber numberWithBool:blnAllowInAppMessaging] forKey:@"IsNotificationEnabled"];
    [dictData setObject:[NSNumber numberWithBool:blnAllowInAppMessaging] forKey:@"AllowInAppMessanging"];
    [dictData setObject:[NSNumber numberWithBool:blnMakeYourEmailIDPrivate] forKey:@"IsEmailVisible"];
    [dictData setObject:[NSNumber numberWithBool:blnMakeYourPhoneNumberPrivate] forKey:@"IsPhoneNumberVisible"];
    [dictData setObject:[NSNumber numberWithBool:blnMakeYourNamePrivate] forKey:@"IsNameVisible"];
    [dictData setObject:[NSNumber numberWithBool:blnMakeYourDesignationPrivate] forKey:@"IsDesginationVisible"];
    [dictData setObject:[NSNumber numberWithBool:blnMakeYourCompanyNamePrivate] forKey:@"IsCompanyVisible"];
    [dictData setObject:[NSNumber numberWithBool:blnHideYourBiography] forKey:@"IsBioVisible"];
    [dictData setObject:[NSNumber numberWithBool:blnHideYourPhotos] forKey:@"IsPhotoVisible"];
    
    NSString* strData = [dictData JSONRepresentation];
    NSLog(@"Post Data: %@",strData);
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_SET_PRIVACY];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSString *postString = [NSString stringWithFormat:@"%@",strData];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    [objRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [objRequest setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_SET_PRIVACY];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadHome
{
    Home *vcHome;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcHome = [storyboard instantiateViewControllerWithIdentifier:@"idHome"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcHome = [storyboard instantiateViewControllerWithIdentifier:@"idHome"];
    }
    
    [[self navigationController] pushViewController:vcHome animated:YES];
}

- (void)loadSyncup
{
    if(blnCalledFromResources == YES)
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        SyncUp *vcSyncUp;
        
        if([DeviceManager IsiPad] == YES)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            vcSyncUp = [storyboard instantiateViewControllerWithIdentifier:@"idSyncUp"];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
            vcSyncUp = [storyboard instantiateViewControllerWithIdentifier:@"idSyncUp"];
        }
        
        [[self navigationController] pushViewController:vcSyncUp animated:YES];
    }
}

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ExceptionHandler AddExceptionForScreen:strSCREEN_SETTINGS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSInteger intTag = (int)[connection getTag];
    NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_SET_PRIVACY:
            if ([strData isEqualToString:@"true"])
            {
                //[self SetPrivacySaved];
                AppSettings *objAppSettings = [AppSettings GetInstance];
                [objAppSettings SetPrivacySaved];
                
                //[self loadHome];
                [self loadSyncup];
            }
            break;
        case OPER_GET_PRIVACY:
            [self SetOptins:objData];
            break;
        default:
            break;
    }
}
#pragma mark -
- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}
@end
