//
//  Login.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Login.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Shared.h"
#import "User.h"
#import "optin.h"
#import "AppSettings.h"
#import "SyncUp.h"
#import "FBJSON.h"
#import "NSURLConnection+Tag.h"
#import "SponsorDB.h"
#import "VenueDB.h"
#import "ConferenceDB.h"
#import "AgendaDB.h"
#import "ExhibitorDB.h"
#import "SpeakerDB.h"
#import "SessionDB.h"
#import "AppSettings.h"
#import "Functions.h"

#import "LiveSDK/LiveConnectClient.h"
#import "LiveSDK/LiveConnectSession.h"
#import "AppDelegate.h"

@interface Login ()
{
    @private
    NSString *strEmail;
}
@end

@implementation Login
#pragma mark Synthesize
@synthesize liveClient;
@synthesize objConnection, objData;
@synthesize lblError;
@synthesize btnASFSSignin, btnMSSignin, btnHelpEmail;
@synthesize vwLoading, avLoading;
#pragma mark -

#pragma mark View Events
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    strEmail = @"ConvHelp@microsoft.com";    
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
    
    [[btnASFSSignin layer] setBorderWidth:2.0f];
    [[btnASFSSignin layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [btnASFSSignin addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnASFSSignin addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[btnMSSignin layer] setBorderWidth:2.0f];
    [[btnMSSignin layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [btnMSSignin addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnMSSignin addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[lblError layer] setBorderWidth:1.0f];
    [[lblError layer] setBorderColor:[UIColor colorWithRed:33 green:74 blue:75 alpha:1].CGColor];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_LOGON];
    
    [self configureLiveClientWithScopes];
    
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

- (IBAction)MSSignin:(id)sender
{
//    Shared *objShared = [Shared GetInstance];
//    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        return;
//    }
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    if (self.liveClient.session == nil)
    {
        [self loginWithScopes];
    }
    else
    {
        [self logout];
    }
}

- (IBAction)ADFSSignin:(id)sender
{
    //MSClient *client = [MSClient clientWithApplicationURLString:@"https://emea.azure-mobile.net/" applicationKey:@"fnKRBRbiqQosMXUtYFcDLsEJXHGPqw98"];
    
    //[client loginViewControllerWithProvider:@"Microsoft Account" completion:^(MSUser *user, NSError *err)
    //{
    //    if(!err)
    //    {
    //    }
    //}];
}

- (IBAction)SendEmail:(id)sender
{
 	if([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
		NSString *Subject = @"";
		
		NSString *Body = @"";
        
        [mailer setToRecipients:[NSArray arrayWithObject:strEmail]];
		[mailer setSubject:Subject];
		[mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
		
        [self presentViewController:mailer animated:YES completion:Nil];
	}
    else
    {
        [Functions OpenMailWithReceipient:strEmail];
    }
}
#pragma mark -

#pragma mark View Methods
- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0 green:24/255.0 blue:143/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0/255.0 green:24/255.0 blue:143/255.0 alpha:1.0]];
}

- (void)configureLiveClientWithScopes
{
    if ([strLIVESDK_CLIENT_ID isEqualToString:@"%CLIENT_ID%"])
    {
        [NSException raise:NSInvalidArgumentException format:@"The CLIENT_ID value must be specified."];
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:@"The CLIENT_ID value must be specified."];
    }
    
    self.liveClient = [[LiveConnectClient alloc] initWithClientId:strLIVESDK_CLIENT_ID
                        scopes:[strLIVESDK_SCOPES componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                        delegate:self
                        userState:strLIVESDK_INIT];
}

- (void) loginWithScopes
{
    @try
    {
        NSArray *scopes = [strLIVESDK_SCOPES componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.liveClient login:self
                   scopes:scopes
                 delegate:self
                userState:strLIVESDK_LOGIN];
    }
    @catch(id ex)
    {
        NSLog(@"Exception detail: %@", ex);
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Exception detail: %@", ex]];
        
        [[self avLoading] stopAnimating];
        [[self vwLoading] setHidden: YES];
    }
}

- (void) logout
{
    @try
    {
        [self.liveClient logoutWithDelegate:self userState:strLIVESDK_LOGOUT];
    }
    @catch(id ex)
    {
        NSLog(@"Exception detail: %@", ex);
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Exception detail: %@", ex]];
        
        [[self avLoading] stopAnimating];
        [[self vwLoading] setHidden: YES];
    }
}

- (void)getMe
{
    @try
    {
        [self.liveClient getWithPath:@"me" delegate:self userState:strLIVESDK_GETME];
    }
    @catch (id ex)
    {
        NSLog(@"Exception detail: %@", ex);
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Exception detail: %@", ex]];
        
        [[self avLoading] stopAnimating];
        [[self vwLoading] setHidden: YES];
    }
}

- (void)loadOptin
{
    optin *vcOptin;

    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcOptin = [storyboard instantiateViewControllerWithIdentifier:@"idOptin"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcOptin = [storyboard instantiateViewControllerWithIdentifier:@"idOptin"];
    }

    [[self navigationController] pushViewController:vcOptin animated:YES];
}

- (void)loadSyncup
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

- (BOOL)GetPrivacySaved
{
	BOOL blnResult = NO;
    
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		blnResult = [[dictPList objectForKey:strAPP_SETTINGS_SET_PRIVACY]boolValue];
	}
    
    return blnResult;
}
#pragma mark -

#pragma mark LiveAuthDelegate
- (void)authCompleted:(LiveConnectSessionStatus)status session:(LiveConnectSession *)session userState:(id)userState
{
    NSString *strScope = [session.scopes componentsJoinedByString:@" "];
    NSLog(@"auth succeeded for %@ with scopes: %@",userState, strScope);
    
    if(userState == strLIVESDK_LOGIN)
    {
        [[self vwLoading] setHidden:NO];
        [[self avLoading] startAnimating];
        
        //NSLog(@"Authentication token: %@",session.authenticationToken);
        //NSLog(@"Access token: %@",session.accessToken);
        Shared *objShared = [Shared GetInstance];
        [objShared SetLiveIDAuthenticationToken:session.authenticationToken];
        //NSLog(@"Authentication token: %@",[objShared GetLiveIDAuthenticationToken]);
        
        AppSettings  *objAppSettings = [AppSettings GetInstance];
        [objAppSettings SetLiveIDAuthenticationToken:session.authenticationToken];
        
        //NSData *objLiveConnectSession = [NSKeyedArchiver archivedDataWithRootObject:session];
        //NSArray *arrLiveConnectSession = [NSArray arrayWithObject:session];
        //NSUserDefaults  *objUserDefaults = [NSUserDefaults standardUserDefaults];
        //[objUserDefaults setObject:arrLiveConnectSession forKey:strLIVESDK_LOGIN];
        
        [self getMe];
    }	
}

- (void)authFailed:(NSError *)erroruserState :(id)userState
{
    NSLog(@"auth failed during %@", userState);
    [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"auth failed during %@", userState]];
    
    [[self avLoading] stopAnimating];
    [[self vwLoading] setHidden: YES];
}
#pragma mark -

#pragma mark LiveOperationDelegate
- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    NSLog(@"operation succeeded during %@", operation.userState);
    [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"operation succeeded during %@", operation.userState]];
    
    if (operation.rawResult)
    {
        //NSLog(@"%@", operation.rawResult);
        //NSLog(@"%@", operation.result);
        
        User *objUser = [User GetInstance];
        AppSettings  *objAppSettings = [AppSettings GetInstance];
        
        NSDictionary *dictUser = operation.result;
        
        NSString *strID = [dictUser objectForKey:@"id"];
        [objUser SetID:strID];
        
        NSString *strName = [dictUser objectForKey:@"name"];
        if(strName != nil && ![strName isEqual:[NSNull null]])
        {
            [objUser SetName:strName];
        }
        
        NSString *strFirstName = [dictUser objectForKey:@"first_name"];
        if(strFirstName != nil && ![strFirstName isEqual:[NSNull null]])
        {
            [objUser SetFirstName:strFirstName];
        }
        
        NSString *strLastName = [dictUser objectForKey:@"last_name"];
        if(strLastName != nil && ![strLastName isEqual:[NSNull null]])
        {
            [objUser SetLastName:strLastName];
        }
        
        NSString *strLink = [dictUser objectForKey:@"link"];
        [objUser SetLink:strLink];
        [objAppSettings SetLiveIDLink:strLink];
        
        NSString *strGender = [dictUser objectForKey:@"gender"];
        if(strGender != nil && ![strGender isEqual:[NSNull null]])
        {
            [objUser SetGender:strGender];
        }
        
        NSString *strLocale = [dictUser objectForKey:@"locale"];
        [objUser SetLocale:strLocale];
        
        NSString *strUpdatedTime = [dictUser objectForKey:@"updated_time"];
        [objUser SetUpdatedTime:strUpdatedTime];
        
        NSDictionary *dictUserEmails = [dictUser objectForKey:@"emails"];
        
        NSString *strPreferredEmail = [dictUserEmails objectForKey:@"preferred"];
        if(strPreferredEmail != nil && ![strPreferredEmail isEqual:[NSNull null]])
        {
            [objUser SetPreferredEmail:strPreferredEmail];
        }
        
        NSString *strAccountEmail = [dictUserEmails objectForKey:@"account"];
        if(strAccountEmail != nil && ![strAccountEmail isEqual:[NSNull null]])
        {
            [objUser SetAccountEmail:strAccountEmail];
            [objAppSettings SetAccountEmail:strAccountEmail];
        }
        
        NSString *strPersonalEmail = [dictUserEmails objectForKey:@"personal"];
        if(strPersonalEmail != nil && ![strPersonalEmail isEqual:[NSNull null]])
        {
            [objUser SetPersonalEmail:strPersonalEmail];
        }
        
        NSString *strBusinessEmail = [dictUserEmails objectForKey:@"business"];
        if(strBusinessEmail != nil && ![strBusinessEmail isEqual:[NSNull null]])
        {
            [objUser SetBusinessEmail:strBusinessEmail];
        }
        
        //NSLog(@"%@",[NSKeyedArchiver archivedDataWithRootObject:objUser]);
        //NSLog(@"%@",[[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:objUser]] GetAccountEmail]);
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:objUser] forKey:strUSER_DEFAULT_KEY_USER_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
        [dictData setObject:[objUser GetLink] forKey:@"Link"];
        [dictData setObject:[objUser GetGender] forKey:@"Gender"];
        [dictData setObject:[objUser GetLocale] forKey:@"Locale"];
        [dictData setObject:[objUser GetUpdateTime] forKey:@"UpdatedTime"];
        [dictData setObject:[objUser GetPreferredEmail] forKey:@"PreferredEmail"];
        [dictData setObject:[objUser GetAccountEmail] forKey:@"AccountEmail"];
        [dictData setObject:[objUser GetBusinessEmail] forKey:@"BusinessEmail"];
        [dictData setObject:[objUser GetPersonalEmail] forKey:@"PersonalEmail"];
        [dictData setObject:@"" forKey:@"PUID"];
        [dictData setObject:@"" forKey:@"IMEINumber"];
        
        NSString* strData = [dictData JSONRepresentation];
        NSLog(@"Post Data: %@",strData);
        
        //NSLog(@"%@",[objUser GetAccountEmail]);
        
        //Shared *objShared = [Shared GetInstance];
        //NSString *strAuthenticationToken = [objShared GetLiveIDAuthenticationToken];
        
        //strData = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
        //                                                               (CFStringRef)strData,
        //                                                               NULL,
        //                                                               CFSTR(":/=,!$&'()*+;[]@#?"),
        //                                                               kCFStringEncodingUTF8));
        
        NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_VALIDATE_MS_ATTENDEE];

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

        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_VALIDATE_MS_ATTENDEE];
    }
}

- (void) liveOperationFailed:(NSError *)error operation:(LiveOperation *)operation
{
    NSLog(@"operation failed during %@", operation.userState);
    [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"operation failed during %@", operation.userState]];
    
    [[self avLoading] stopAnimating];
    [[self vwLoading] setHidden: YES];
}
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ExceptionHandler AddExceptionForScreen:strSCREEN_LOGON MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    
    [[self avLoading] stopAnimating];
    [[self vwLoading] setHidden: YES];
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
    
    [[self avLoading] stopAnimating];
    [[self vwLoading] setHidden: YES];
    
    switch (intTag)
    {
        case OPER_VALIDATE_MS_ATTENDEE:
            if ([strData isEqualToString:@"true"])
            {
                //if([self GetPrivacySaved] == NO)
                AppSettings *objAppSettings = [AppSettings GetInstance];

                if([objAppSettings GetPrivacySaved] == NO)
                {
                    [self loadOptin];
                }
                else
                {
                    [self loadSyncup];
                }
            }
            else
            {
                User *objUser = [User GetInstance];
                [objUser ClearUserInfo];
                
                AppSettings  *objAppSettings = [AppSettings GetInstance];
                [objAppSettings ClearAppSettings];
                
                [lblError setHidden:NO];
            }
            break;
        default:
            break;
    }
}
#pragma mark -

#pragma mark Mail Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result) {
		case MFMailComposeResultCancelled:
			NSLog(@"%@",@"Message Canceled");
			break;
		case MFMailComposeResultSaved:
            NSLog(@"%@",@"Message Saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"%@",@"Message Sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"%@",@"Message Failed");
			break;
		default:
			NSLog(@"%@",@"Message Not Sent");
		break;	}

    [self dismissViewControllerAnimated:YES completion:Nil];
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
