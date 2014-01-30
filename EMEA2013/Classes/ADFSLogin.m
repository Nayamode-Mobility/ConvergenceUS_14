//
//  ADFSLogin.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ADFSLogin.h"
#import "Constants.h"
#import "Shared.h"
#import "XMLReader.h"
#import "User.h"
#import "AppSettings.h"
#import "DeviceManager.h"f
#import "optin.h"
#import "AppSettings.h"
#import "SyncUp.h"
#import "FBJSON.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "AppDelegate.h"

@interface ADFSLogin ()

@end

@implementation ADFSLogin
#pragma mark Synthesize
@synthesize btnBack, txtUsername, txtPassword, btnSignin, lblADFSError, lblCMSError;
@synthesize objConnection, objData;
@synthesize vwLoading, avLoading;
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
    
    [[[self btnSignin] layer] setBorderWidth:2.0f];
    [[[self btnSignin] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSignin] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSignin] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self txtUsername] becomeFirstResponder];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_ADFS_LOGON];
    
    //[UIView addTouchEffect:self.view];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == [self txtUsername])
    {
        [[self txtUsername] resignFirstResponder];
        [[self txtPassword] becomeFirstResponder];
    }
    else
    {
        [[self txtPassword] resignFirstResponder];
        [self ADFSSignin:[self btnSignin]];
    }
    
    return  YES;
}
#pragma mark -

#pragma mark View Methods
- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0 green:24/255.0 blue:143/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:0 green:24/255.0 blue:143/255.0 alpha:1.0]];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ADFSSignin:(id)sender
{
    [[self txtUsername] resignFirstResponder];
    [[self txtPassword] resignFirstResponder];
    

    if (!APP.netStatus) {
        NETWORK_ALERT();
    }else{
    
    
    
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    [lblADFSError setHidden: YES];
    [lblCMSError setHidden: YES];
    
    NSURL *URL = [NSURL URLWithString:strADFS_END_POINT_URL];
    NSMutableURLRequest *objRequest = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *soapMessage = [self GetSoapContent];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [objRequest addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

    //objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self];
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADFS_LOGON];
    }

}

-(NSString *)GetSoapContent
{
    NSString *strSoapContent = [NSString stringWithFormat:@"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:u=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd\">\n"
                                "<s:Header>\n"
                                "   <a:Action s:mustUnderstand=\"1\">http://docs.oasis-open.org/ws-sx/ws-trust/200512/RST/Issue</a:Action>\n"
                                "   <a:To s:mustUnderstand=\"1\">%@</a:To>\n"
                                "   <o:Security s:mustUnderstand=\"1\" xmlns:o=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd\">\n"
                                "       <o:UsernameToken u:Id=\"uuid-6a13a244-dac6-42c1-84c5-cbb345b0c4c4-1\">\n"
                                "           <o:Username>%@</o:Username>\n"
                                "           <o:Password Type=\"http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText\">%@</o:Password>\n"
                                "       </o:UsernameToken>\n"
                                "   </o:Security>\n"
                                "</s:Header>\n"
                                "<s:Body>\n"
                                "   <trust:RequestSecurityToken xmlns:trust=\"http://docs.oasis-open.org/ws-sx/ws-trust/200512\">\n"
                                "       <wsp:AppliesTo xmlns:wsp=\"http://schemas.xmlsoap.org/ws/2004/09/policy\">\n"
                                "           <a:EndpointReference>\n"
                                "               <a:Address>%@</a:Address>\n"
                                "           </a:EndpointReference>\n"
                                "       </wsp:AppliesTo>\n"
                                "   <trust:KeyType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Bearer</trust:KeyType>\n"
                                "   <trust:RequestType>http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue</trust:RequestType>\n"
                                "   <trust:TokenType>urn:oasis:names:tc:SAML:2.0:assertion</trust:TokenType>\n"
                                "   </trust:RequestSecurityToken>\n"
                                "</s:Body>\n"
                                "</s:Envelope>",strADFS_TO,[self txtUsername].text,[self txtPassword].text,strADFS_APPLY_TO];
    
    return strSoapContent;
}

- (void)GetDomainAttendeeInfo:(NSString*)strData
{
    [[self avLoading] startAnimating];
    [[self vwLoading] setHidden: NO];
    
    NSError *error = nil;
    NSDictionary *dictXML = [XMLReader dictionaryForXMLString:strData error:&error];
    //NSLog(@"%@", dictXML);
    
    if(!error)
    {
        NSString *strStatus = [[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Header"] objectForKey:@"a:Action"] valueForKey:@"text"];
        //NSLog(@"%@", strStatus);
        
        if([strStatus rangeOfString:@"/IssueFinal"].location != NSNotFound)
        {
            NSArray *arrAttribute;
            NSString *strAttribute = @"";
            
            User *objUser = [User GetInstance];
            AppSettings  *objAppSettings = [AppSettings GetInstance];
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:0];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:0] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/EmailAddress"].location != NSNotFound)
            {
                NSString *strEmail = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strEmail);
                
                [objUser SetAccountEmail:strEmail];
                [objUser SetPreferredEmail:strEmail];
                
                [objAppSettings SetAccountEmail:strEmail];
            }
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:1];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:1] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/FirstName"].location != NSNotFound)
            {
                NSString *strFirstName = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strFirstName);
                
                [objUser SetFirstName:strFirstName];
            }
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:6];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:6] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/PartnerImmutableID"].location != NSNotFound)
            {
                NSString *strPUID = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strPUID);
                
                [objUser SetPUID:strPUID];
                [objAppSettings SetPUID:[strPUID intValue]];
            }
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:5];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:5] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/PrimaryGroupSID"].location != NSNotFound)
            {
                NSString *strPrimaryGroupSID = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strPrimaryGroupSID);
                
                [objUser SetPrimaryGroupSID:strPrimaryGroupSID];
                [objAppSettings SetPrimaryGroupSID:strPrimaryGroupSID];
            }
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:2];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:2] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/PrimarySID"].location != NSNotFound)
            {
                NSString *strPrimarySID = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strPrimarySID);
                
                [objUser SetPrimarySID:strPrimarySID];
                [objAppSettings SetPrimarySID:strPrimarySID];
            }
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:3];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:3] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/UPN"].location != NSNotFound)
            {
                NSString *strUPN = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strUPN);
                
                [objUser SetUPN:strUPN];
                [objAppSettings SetUPN:strUPN];
            }
            
            arrAttribute = [[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:4];
            //strAttribute = [[[[[[[[[[dictXML objectForKey:@"s:Envelope"] objectForKey:@"s:Body"] objectForKey:@"trust:RequestSecurityTokenResponseCollection"] objectForKey:@"trust:RequestSecurityTokenResponse"] objectForKey:@"trust:RequestedSecurityToken"] objectForKey:@"Assertion"] objectForKey:@"AttributeStatement"] objectForKey:@"Attribute"]  objectAtIndex:3] valueForKey:@"Name"];
            strAttribute = [arrAttribute valueForKey:@"Name"];
            if([strAttribute rangeOfString:@"/user/Alias"].location != NSNotFound)
            {
                NSString *strAlias = [[arrAttribute valueForKey:@"AttributeValue"] valueForKey:@"text"];
                //NSLog(@"%@", strAlias);
                
                [objUser SetAlias:strAlias];
                [objAppSettings SetAlias:strAlias];
            }
            
            //NSLog(@"%@",[NSKeyedArchiver archivedDataWithRootObject:objUser]);
            //NSLog(@"%@",[[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:objUser]] GetAccountEmail]);
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:objUser] forKey:strUSER_DEFAULT_KEY_USER_INFO];
            
            NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
            [dictData setObject:[objUser GetFirstName] forKey:@"FirstName"];
            [dictData setObject:[objUser GetLastName] forKey:@"LastName"];
            [dictData setObject:[objUser GetAlias] forKey:@"UserAlias"];
            [dictData setObject:[objUser GetPUID] forKey:@"PUID"];
            [dictData setObject:@"" forKey:@"IMEINumber"];
            [dictData setObject:[objUser GetPrimaryGroupSID] forKey:@"PrimaryGroupSID"];
            [dictData setObject:[objUser GetPrimarySID] forKey:@"PrimarySID"];
            [dictData setObject:[objUser GetUPN] forKey:@"UPN"];
            
            NSString* strData = [dictData JSONRepresentation];
            NSLog(@"Post Data: %@",strData);
            
            //Shared *objShared = [Shared GetInstance];
            //NSString *strAuthenticationToken = [objShared GetLiveIDAuthenticationToken];
            
            //strData = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
            //                                                               (CFStringRef)strData,
            //                                                               NULL,
            //                                                               CFSTR(":/=,!$&'()*+;[]@#?"),
            //                                                               kCFStringEncodingUTF8));
            
            NSString *strURL = strAPI_URL;
            strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_VALIDATE_DOMAIN_ATTENDEE];
            
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
            
            objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_VALIDATE_DOMAIN_ATTENDEE];
        }
        else
        {
            //NSLog(@"%@", @"Invalid Username or Password");
            [lblADFSError setHidden: NO];
            [lblCMSError setHidden: YES];
            
            [[self avLoading] stopAnimating];
            [[self vwLoading] setHidden: YES];
        }
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
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
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
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    [[self avLoading] stopAnimating];
    [[self vwLoading] setHidden: YES];
    
    switch (intTag)
    {
        case OPER_ADFS_LOGON:
            {
                [self GetDomainAttendeeInfo:strData];
            }
            break;
        case OPER_VALIDATE_DOMAIN_ATTENDEE:
            {
                if ([strData isEqualToString:@"true"])
                {
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
                    
                    [lblADFSError setHidden: YES];
                    [lblCMSError setHidden: NO];
                }
            }
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
