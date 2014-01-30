//
//  FacebookWritePost.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 06/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "FacebookWritePost.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Shared.h"
#import "Functions.h"
#import "NSString+Custom.h"
#import "AppDelegate.h"

@interface FacebookWritePost ()
{
    @private
    NSString *strFBID;
    NSString *strFirstName;
    NSString *strLastName;
    NSString *strName;
    NSString *strEmail;
    NSString *strProfileImage;
    int intFriendsCount;
    
    int intOperation;
}
@end

@implementation FacebookWritePost
#pragma mark Synthesize
@synthesize objFaceBook;
@synthesize objConnection, objData, dictData;
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
    
    [[[self btnPost] layer] setBorderWidth:2.0f];
    [[[self btnPost] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnPost] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnPost] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
 
    [self LoginFacebook];
    
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
#pragma mark -

#pragma mark View Methods
- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[self txtMessage] setBackgroundColor:[UIColor whiteColor]];
    
    return TRUE;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //Any new character added is passed in as the "text" parameter
    if([text isEqualToString:@"\n"])
    {
        [self.txtMessage resignFirstResponder];
        [[self txtMessage] setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
    
        return FALSE;
    }

    return TRUE;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
        self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.txtMessage resignFirstResponder];
    [[self txtMessage] setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)writePost:(id)sender
{
    if([NSString IsEmpty:self.txtMessage.text shouldCleanWhiteSpace:YES] == NO)
    {
        //Shared *objShared = [Shared GetInstance];
        
       if (APP.netStatus) {
        [[self vwLoading] setHidden:NO];
        [[self avLoading] startAnimating];
        
        intOperation = OPER_FB_PUBLISH;
        //privacy={'value':'ALL_FRIENDS'}
        //NSMutableDictionary *dictPrivacy = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"EVERYONE", @"value", nil];
        //NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:FACEBOOK_APPID, @"app_id", self.txtMessage.text, @"message", dictPrivacy, @"privacy", nil];
        NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:FACEBOOK_APPID, @"app_id", self.txtMessage.text, @"message", @"{'value': 'EVERYONE'}", @"privacy", nil];
        
        [objFaceBook requestWithGraphPath:@"me/feed" andParams:dictParams andHttpMethod:@"POST" andDelegate:self];
    }
    else
    {
        [self showAlert:nil withMessage:@"Please enter a message." withButton:@"OK" withIcon:nil];
    }
    }else{
        NETWORK_ALERT();
        return;
    }
}

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

- (void) LoginFacebook
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    intOperation = OPER_FB_GETUSER_INFO;
    
    objFaceBook = [[Facebook alloc] initWithAppId:FACEBOOK_APPID andDelegate:self];
    objFaceBook.sessionDelegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
    {
        objFaceBook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        objFaceBook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![objFaceBook isSessionValid])
    {
        NSArray *arrPermissions = [[NSArray alloc] initWithObjects:@"user_about_me",@"user_photos",@"offline_access",@"publish_stream",nil];
        
        [objFaceBook authorize:arrPermissions];
    }
    else
    {
        [self GetUserInfomation];
    }
}

- (void) GetUserInfomation
{
    [objFaceBook requestWithGraphPath:@"me" andDelegate:self];
}
#pragma mark -

#pragma mark Facebook Event
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [objFaceBook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [objFaceBook handleOpenURL:url];
}

- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[objFaceBook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[objFaceBook expirationDate] forKey:@"FBExpirationDateKey"];
    
    [defaults synchronize];
    
    [self GetUserInfomation];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) fbDidLogout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"])
    {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
}

- (void)fbSessionInvalidated
{
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.userInfo);
    NSLog(@"%@",[[(NSDictionary *)error.userInfo objectForKey:@"error"] objectForKey:@"message"]);
    
    NSString *strError = [[(NSDictionary *)error.userInfo objectForKey:@"error"] objectForKey:@"message"];
    //NSDictionary *dictError = [[(NSDictionary *)error.userInfo objectForKey:@"error"] objectForKey:@"message"];
    
    [self showAlert:Nil withMessage:strError withButton:@"OK" withIcon:nil];
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
    
    
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    //NSLog(@"%@",result);
    
    switch (intOperation)
    {
        case OPER_FB_GETUSER_INFO:
            {
                strFBID = [result objectForKey:@"id"];
                strEmail = [result objectForKey:@"email"];
                strFirstName = [result objectForKey:@"first_name"];
                strLastName = [result objectForKey:@"last_name"];
                strName = [result objectForKey:@"name"];
                
                self.lblName1.text = [NSString stringWithFormat:@"Hi %@",strName];
                self.lblName2.text = strName;
                
                intOperation = OPER_FB_GETUSER_PICTURE;
                [objFaceBook requestWithGraphPath:@"me/picture?redirect=false&type=large" andDelegate:self];
            }
            break;
        case OPER_FB_GETUSER_PICTURE:
            {
                [[self avLoadingPP] startAnimating];
                
                strProfileImage = [[result objectForKey:@"data"] objectForKey:@"url"];
                NSURL *imgURL = [NSURL URLWithString:strProfileImage];
                NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
                [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                NSData *data,
                NSError *error)
                {
                    if (!error)
                    {
                        UIImage *img = [[UIImage alloc] initWithData:data];;
                        self.imgvProfilePicture.image = img;
                        
                        [[self avLoadingPP] stopAnimating];
                    }
                }];
                
                intOperation = OPER_FB_GETUSER_FRIENDS;
                [objFaceBook requestWithGraphPath:@"me/friends" andDelegate:self];
            }
            break;
        case OPER_FB_GETUSER_FRIENDS:
            {
                NSArray *arrData = [result objectForKey:@"data"];
                //NSLog(@"%d",[arrData count]);
                intFriendsCount = [arrData count];
                self.lblFreinds.text = [NSString stringWithFormat:@"You have %d friend(s)",intFriendsCount];
                
                intOperation = 0;
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
                
                [[self txtMessage] becomeFirstResponder];
            }
            break;
        case OPER_FB_PUBLISH:
            {
                //NSLog(@"%@",result);
                [self showAlert:@"" withMessage:@"Message posted successfully" withButton:@"OK" withIcon:nil];
                
                self.txtMessage.text = @"";

                [[self navigationController] popViewControllerAnimated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark -
@end
