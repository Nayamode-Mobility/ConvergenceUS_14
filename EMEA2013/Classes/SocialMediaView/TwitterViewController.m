//
//  TwitterViewController.m
//  mgx2013
//
//  Created by Amit Karande on 21/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterFeedCustomCell.h"
#import "TwitterPostViewController.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Shared.h"
#import "FBJSON.h"
#import "AppDelegate.h"

@interface TwitterViewController ()
{
    @private
    BOOL blnNoAccess;
}
@end

@implementation TwitterViewController
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

	//Do any additional setup after loading the view.
    [[[self btnCompose] layer] setBorderWidth:2.0f];
    [[[self btnCompose] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnCompose] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnCompose] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SOCIAL_MEDIA_TWITTER];
    
    //[UIView addTouchEffect:self.view];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self populateData];
}

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:13/255.0 blue:122/255.0 alpha:1.0]];
}

- (void) populateData
{
    // Request access to the Twitter accounts
    //Help:https://dev.twitter.com/docs/api/1.1/get/search/tweets
    
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    
     [self.arrTweets removeAllObjects];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            blnNoAccess = YES;
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                NSURL *twitterURL =[[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                
                SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:twitterURL parameters:[NSDictionary dictionaryWithObjectsAndKeys:TWITTER_HASH_NAME ,@"q",@"50",@"count",nil]];
                //%40MSFTConvergence
                [twitterInfoRequest setAccount:twitterAccount];
                
                // Making the request
                
                [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Check if we reached the reate limit
                        if ([urlResponse statusCode] == 429)
                        {
                            NSLog(@"Rate limit reached");
                            
                            [[self lblNoFeeds] setHidden:NO];
                            
                            [[self vwLoading] setHidden:YES];
                            [[self avLoading] stopAnimating];
                            
                            return;
                        }
                        
                        // Check if there was an error
                        if (error)
                        {
                            NSLog(@"Error: %@", error.localizedDescription);
                            
                            [[self lblNoFeeds] setHidden:NO];
                            
                            [[self vwLoading] setHidden:YES];
                            [[self avLoading] stopAnimating];
                            
                            return;
                        }
                        
                        // Check if there is some response data
                        
                        if (responseData)
                        {
                            //Add your code here
                            if (self.arrTweets == nil)
                            {
                                self.arrTweets = [[NSMutableArray alloc] init];
                            }
                            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                            NSDictionary *results = [responseString JSONValue];
                            NSMutableArray *allTweets = [results objectForKey:@"statuses"];
                            int intCounter = 0;
                            for(NSDictionary *dictData in allTweets)
                            {
                                NSDictionary *objTweet = [allTweets objectAtIndex:intCounter];
                                NSDictionary *objUser = [objTweet objectForKey:@"user"];
                                //NSLog(@"Name:%@--ProfileImage:%@--tweet:%@--Created:%@",[aUser objectForKey:@"name"],[aUser objectForKey:@"profile_image_url"],[aTweet objectForKey:@"text"],[aTweet objectForKey:@"created_at"]);
                                NSMutableDictionary *dicTweet = [[NSMutableDictionary alloc] init];
                                [dicTweet setObject:[objUser objectForKey:@"name"] forKey:@"name"];
                                [dicTweet setObject:[objUser objectForKey:@"profile_image_url"] forKey:@"profile_image_url"];
                                [dicTweet setObject:[objTweet objectForKey:@"text"] forKey:@"text"];
                                [dicTweet setObject:[objTweet objectForKey:@"created_at"] forKey:@"created_at"];
                                [self.arrTweets addObject:dicTweet];
                                intCounter = intCounter + 1;
                            }
                            
                            [self.colTwitterTweets reloadData];
                            
                            [[self vwLoading] setHidden:YES];
                            [[self avLoading] stopAnimating];
                        }
                        else
                        {
                            NSLog(@"%@",error);
                            
                            [[self lblNoFeeds] setHidden:NO];
                            
                            [[self vwLoading] setHidden:YES];
                            [[self avLoading] stopAnimating];
                        }
                        
                        //End
                    });
                }];
            }
            else
            {
                NSLog(@"You needsetup at least one Twitter account");
                
                //[self showAlert:@"" withMessage:@"No access granted" withButton:@"OK" withIcon:nil];
                
                //blnNoAccess = NO;
                
                [[self lblNoAccess] setHidden:NO];
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
        }
        else
        {
            NSLog(@"No access granted");
            
            //[self showAlert:@"" withMessage:@"No access granted" withButton:@"OK" withIcon:nil];
            
            blnNoAccess = NO;
            
            [[self lblNoAccess] setHidden:NO];
            
            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"loadTwitterPost"])
    {
       // Shared *objShared = [Shared GetInstance];
        
        if (!APP.netStatus) {
            NETWORK_ALERT();
            return NO;
        }
        
        return blnNoAccess;
    }
    
    return YES;
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrTweets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterFeedCustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    NSDictionary *objTweet = [self.arrTweets objectAtIndex:indexPath.row];
    //NSLog(@"%@",[aTweet objectForKey:@"created_at"]);
    //Mon Oct 21 14:55:50 +0000 2013
    cell.lblTitle.text = [objTweet objectForKey:@"name"];
    /*cell.txtDescription.text = [objTweet objectForKey:@"text"];
    CGRect rect      = cell.txtDescription.frame;
    rect.size.height = cell.txtDescription.contentSize.height;
    cell.txtDescription.frame   = rect;*/
    
    cell.txtDescription.text = [NSString stringWithFormat:@"%@\r\n",[objTweet objectForKey:@"text"]];
    cell.txtDescription.scrollEnabled = NO;
    [cell.txtDescription setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];
    
    CGRect rect = cell.txtDescription.frame;
    CGSize size2 = [cell.txtDescription sizeThatFits:CGSizeMake(240, FLT_MAX)];
    rect.size.height = size2.height;
    cell.txtDescription.frame = rect;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz YYYY"];
    NSDate *dtStartDate = [dateFormater dateFromString:[objTweet objectForKey:@"created_at"]];
    [dateFormater setDateFormat:@"EEEE, dd MMM. HH:mm a"];
    cell.lblDatetime.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    
    //cell.lblDatetime.text = [aTweet objectForKey:@"created_at"];
    //cell.lblDatetime.frame = CGRectMake(cell.lblDatetime.frame.origin.x, (cell.txtDescription.frame.origin.y + cell.txtDescription.frame.size.height), 232, 21);
    cell.lblDatetime.frame = CGRectMake(cell.lblDatetime.frame.origin.x, (cell.txtDescription.frame.origin.y + cell.txtDescription.frame.size.height), cell.lblDatetime.frame.size.width, cell.lblDatetime.frame.size.height);
    
    /*if ([DeviceManager IsiPhone])
     {
     cell.vwLine.frame = CGRectMake(0, (cell.lblDatetime.frame.origin.y + 30), 300, 1);
     }*/
    
    //NSLog(@"render %.f",cell.frame.size.height);
    if ([DeviceManager IsiPhone])
    {
        //cell.vwLine.frame = CGRectMake(0, (cell.lblDatetime.frame.origin.y + 30), 300, 1);
         cell.vwLine.frame = CGRectMake(0, (cell.frame.size.height - 1), 300, 1);
    }
    
    NSURL *imgURL = [NSURL URLWithString:[objTweet objectForKey:@"profile_image_url"]];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error)
    {
        if (!error)
        {
            cell.imgLogo.image = [UIImage imageWithData:data];
        }
    }];
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *objTweet = [self.arrTweets objectAtIndex:indexPath.row];
    /*self.textView.text = [objTweet objectForKey:@"text"];
    CGRect rect      = self.textView.frame;
    rect.size.height = self.textView.contentSize.height;
    self.textView.frame   = rect;
    if ([DeviceManager IsiPad]) {
        CGSize cellSize = (CGSize) { .width = 600, .height = 250};
        return cellSize;
    }
    else{
        CGSize cellSize = (CGSize) { .width = 300, .height = (self.textView.frame.size.height+self.textView.frame.origin.y+35)};
        return cellSize;
    }*/
    
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    
    [self.textView setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];
    
    UIFont *font = [UIFont fontWithName:@"SegoeWP" size:17.0f];
    
    [self.textView setFont:font];
    [self.textView setText:[objTweet objectForKey:@"name"]];
    CGSize size1 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    
    font = [UIFont fontWithName:@"SegoeWP" size:14.0f];
    
    [self.textView setFont:font];
    [self.textView setText:[NSString stringWithFormat:@"%@\r\n",[objTweet objectForKey:@"text"]]];
    CGSize size2 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    
    //NSLog(@"%@",[objFeed objectForKey:@"created_time"]);
    [self.textView setFont:font];
    [self.textView setText:[objTweet objectForKey:@"created_at"]];
    CGSize size3 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    
    expectedLabelSize.height = size1.height + size2.height + size3.height + 0;
    
    //NSLog(@"size %.f",expectedLabelSize.height);
    return (CGSize) {.width = 300, .height = expectedLabelSize.height};
    
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
