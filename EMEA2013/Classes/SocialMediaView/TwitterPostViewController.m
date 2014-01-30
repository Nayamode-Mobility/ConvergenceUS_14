//
//  TwitterPostViewController.m
//  mgx2013
//
//  Created by Amit Karande on 06/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "TwitterPostViewController.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Shared.h"
#import "NSString+Custom.h"
#import "AppDelegate.h"

@interface TwitterPostViewController ()

@end

@implementation TwitterPostViewController

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
    
    [[[self btnPostTweet] layer] setBorderWidth:2.0f];
    [[[self btnPostTweet] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnPostTweet] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnPostTweet] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self txtTweet] setText:TWITTER_POST_HASH_NAME];
    
    [[self txtTweet] becomeFirstResponder];
    
    //[UIView addTouchEffect:self.view];    
}

-(void) viewWillAppear:(BOOL)animated
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted)
        {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                self.lblUserName.text = [NSString stringWithFormat:@"Welcome %@",twitterAccount.username];
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
        }
        else
        {
            NSLog(@"No access granted");
            
            //[self showAlert:@"" withMessage:@"No access granted" withButton:@"OK" withIcon:nil];
            
            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
            
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }];
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
    [[self txtTweet] setBackgroundColor:[UIColor whiteColor]];
    
    return TRUE;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //Any new character added is passed in as the "text" parameter
    if([text isEqualToString:@"\n"])
    {
        [self.txtTweet resignFirstResponder];
        [[self txtTweet] setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
        
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
    [self.txtTweet resignFirstResponder];
    [[self txtTweet] setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1]];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPostTweetClicked:(id)sender
{
    if([NSString IsEmpty:self.txtTweet.text shouldCleanWhiteSpace:YES] == NO)
    {
        //Shared *objShared = [Shared GetInstance];
        
        if (!APP.netStatus) {
            NETWORK_ALERT();
            return;
        }
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
    [self postTweet:accounts];
}
    else
    {
        [self showAlert:nil withMessage:@"Please enter a message." withButton:@"OK" withIcon:nil];
    }
}

-(void)postTweet:(NSArray *)accounts
{
    //create the SLRequest and post to the account
    
    //create the NSURL for the Twitter endpoint
    NSURL *profileURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
    
    //Create the dictionary of parameters that contains the text to be posted
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:[self.txtTweet text] forKey:@"status"];
    
    //create the SLRequest
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:profileURL parameters:parameters];
    
    //assign the twitter account for posting
    twitterRequest.account = [accounts objectAtIndex:0];
    
    SLRequestHandler requestHandler = ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if(error)
        {
            NSLog(@"%@", error);

            dispatch_async(dispatch_get_main_queue(), ^{
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            });
        }
        else
        {
            double delayInSeconds = 5.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showAlert:@"" withMessage:@"Tweet posted succesfully." withButton:@"OK" withIcon:nil];
                
                self.txtTweet.text = @"";
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
                
                [[self navigationController] popViewControllerAnimated:YES];
            });
        }
    };
    
    //perform the request
    [twitterRequest performRequestWithHandler:requestHandler];
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
@end
