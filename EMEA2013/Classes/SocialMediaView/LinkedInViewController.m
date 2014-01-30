//
//  LinkedInViewController.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 22/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "LinkedInViewController.h"
#import "XQueryComponents.h"
#import "LinkedInFeedCustomeCell.h"
#import "Constants.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "AppDelegate.h"
#import "Functions.h"


@interface LinkedInViewController ()
{
    NSURLConnection *authConn;
    NSURLConnection *feedConn;
}

@property (strong, nonatomic) IBOutlet UIWebView *webAuthView;
@property (strong, nonatomic) IBOutlet UIWebView *webPostDiscussion;
@property (strong, nonatomic) IBOutlet UITableView *tableFeed;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *waitIndicator;
@property(nonatomic,retain) NSString *callbackURL;
@property(nonatomic,retain) NSString *authToken;
@property (nonatomic, retain) NSMutableData *objData;
@property(nonatomic,retain) NSString *clientSec;
@property(nonatomic,retain) NSString *appKey;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionFeed;
@property(nonatomic,retain) NSMutableArray *feedData;
@end

@implementation LinkedInViewController

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
    
    //self.callbackURL = @"http://goconvergence.cloudapp.net/uat/pageredirected.html";
	//self.clientSec = @"vLt1nx3D6kMlUblk";
    //self.appKey = @"1msu00m33bnp";
    
    [self.webPostDiscussion setHidden:YES];
    
    self.callbackURL = LINKEDIN_CALL_BACKURL;
	self.clientSec = LINKED_IN_SECRETID;
    self.appKey = LINKED_APPKEY;
    
    // Do any additional setup after loading the view.
    
    [[[self btnPost] layer] setBorderWidth:2.0f];
    [[[self btnPost] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnPost] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnPost] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];

    //If not authticate
    //[self setPreferences:@"LinkedinAuthToken" forValue:@""];
    [self AskLogin];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SOCIAL_MEDIA_LINKEDIN];
    
    //[UIView addTouchEffect:self.view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self AskLogin];
}

- (void)AskLogin
{
    [self.waitIndicator setHidden:YES];
    [self.waitIndicator  stopAnimating];
    
    if([[self getMyAuthToken]isEqualToString:@""])
    {
        NSString *strClientID=[NSString stringWithFormat:@"&client_id=%@",self.appKey];
        NSString *linkedinURL=@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&scope=r_fullprofile%20r_emailaddress%20r_network%20rw_groups&state=DCEEFWF45453sdffef424&redirect_uri=";
        NSURL *url = [NSURL URLWithString:[[linkedinURL stringByAppendingString:self.callbackURL] stringByAppendingString:strClientID]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.webAuthView setScalesPageToFit:YES];
        [self.webAuthView loadRequest:request];
    }
    else
    {
        [self.waitIndicator setHidden:NO];
        [self.waitIndicator  startAnimating];
        
        self.webAuthView.hidden=YES;
        
        self.authToken = [self getMyAuthToken];
        
        [self getFeed];
    }
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

- (IBAction)iPadMoveBAck:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moveBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -

#pragma mark  Auth process
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString hasPrefix:self.callbackURL])
    {
        //Get response parameter
        NSDictionary *response=[request.URL queryComponents];

        //NSLog(@"%@",response);
        if([response objectForKey:@"error"] != nil)
        {
             [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            //Login on server
            //NSLog(@"URL %@", request.URL.absoluteString);
            NSString * requestCode=[[response objectForKey:@"code"] objectAtIndex:0];
            //NSLog(@"Request for %@", requestCode);
            webView.hidden=YES;
            [self getAuthToken:requestCode];
            //return NO;
        }
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.waitIndicator setHidden:NO];
    [self.waitIndicator  startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.waitIndicator setHidden:YES];
    [self.waitIndicator  stopAnimating];
}
#pragma mark -

#pragma mark Call linkedin API
- (void)getAuthToken:(NSString *)code
{
    NSString *strURL = @"https://www.linkedin.com/uas/oauth2/accessToken";
    //NSLog(@"search for code %@",code);
    
    NSString *post = [NSString stringWithFormat:@"&grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",code,self.callbackURL,self.appKey,self.clientSec];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
     authConn= [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

-(void)getFeed
{
    NSString *strURL = [NSString stringWithFormat:@"https://api.linkedin.com/v1/groups/%@/posts:(creation-timestamp,title,summary,creator:(first-name,last-name,picture-url,headline),likes,attachment:(image-url,content-domain,content-url,title,summary),relation-to-viewer)?oauth2_access_token=%@",LINKED_GROUP_ID,self.authToken];

    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    feedConn= [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.objData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *response=[[NSString alloc]initWithData:self.objData encoding:NSStringEncodingConversionAllowLossy];
    //NSLog(@"%@",response);
    
    if (connection==authConn)
    {
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
        NSError *error;
        
        dictData = [NSJSONSerialization JSONObjectWithData:self.objData options:kNilOptions error:&error];
        
        if ([dictData objectForKey:@"access_token"]!=nil)
        {
            self.authToken=[dictData objectForKey:@"access_token"];
            //Save access token in prefrence for feture use
            [self setPreferences:@"LinkedinAuthToken" forValue:self.authToken];
            [authConn cancel];
            
            [self getFeed];
        }
    }
    else if(connection==feedConn)
    {
        //Retrive feeds
        
        [feedConn cancel];

        //NSLog(@"retrive feed");
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
        NSError *error;
        dictData = [NSJSONSerialization JSONObjectWithData:self.objData options:kNilOptions error:&error];
        if ([dictData objectForKey:@"values"]!=nil)
        {
            self.feedData = [NSMutableArray arrayWithArray:[dictData objectForKey:@"values"]];
            
            if([self.feedData count] > 0)
            {
                [self.collectionFeed reloadData];
            }
            else
            {
                [[self lblNoFeeds] setHidden:NO];
            }
        }
        else
        {
            [self setPreferences:@"LinkedinAuthToken" forValue:@""];
            [self AskLogin];
        }
        
        [self.waitIndicator setHidden:YES];
        [self.waitIndicator  stopAnimating];
    }
}

- (BOOL)setPreferences:(NSString *)key forValue:(NSString *) preferencesValue
{
	//NSLog(@"%@", key);
	// Set values
	[[NSUserDefaults standardUserDefaults] setValue: preferencesValue forKey: key];
    
	// Return the results of attempting to write preferences to system
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) getMyAuthToken
{
	if([[NSUserDefaults standardUserDefaults] stringForKey: @"LinkedinAuthToken"] != nil)
    {
		NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey: @"LinkedinAuthToken"];
		
		return value;
	}
	else
		return @"";
}

- (IBAction)PostDiscussion:(id)sender
{
    //Shared *objShared = [Shared GetInstance];
    
    //if([objShared GetIsInternetAvailable] == NO)
    //{
    //    [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
    //    return;
    //}
    
    NSString *linkedinURL = [NSString stringWithFormat:@"http://www.linkedin.com/groups?home=&gid=%@&oauth2_access_token=%@",LINKED_GROUP_ID,self.authToken];
    //NSURL *url = [NSURL URLWithString:linkedinURL];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //[self.webPostDiscussion setScalesPageToFit:YES];
    //[self.webPostDiscussion loadRequest:request];
    
    //[self.webPostDiscussion setHidden:NO];
    
    [Functions OpenWebsite:linkedinURL];
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.feedData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    LinkedInFeedCustomeCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    NSDictionary *objTweet = [self.feedData objectAtIndex:indexPath.row];
    
    NSDictionary *displayData = [objTweet objectForKey:@"creator"];
    
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@",[displayData objectForKey:@"firstName"],[displayData objectForKey:@"lastName"]];
    
    [cell.txtContent setText:[NSString stringWithFormat:@"%@\n%@",[NSString stringWithString:[objTweet objectForKey:@"title"]],[NSString stringWithString:[displayData objectForKey:@"headline"]]]];
    cell.txtContent.scrollEnabled = NO;
    [cell.txtContent setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];
    
    CGRect rect = cell.txtContent.frame;
    CGSize size2 = [cell.txtContent sizeThatFits:CGSizeMake(240, FLT_MAX)];
    rect.size.height = size2.height;
    cell.txtContent.frame = rect;
    
    NSDate *dtStartDate = [NSDate dateWithTimeIntervalSince1970:([[objTweet objectForKey:@"creationTimestamp"] doubleValue] / 1000)];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz YYYY"];
    [dateFormater setDateFormat:@"EEEE, dd MMM. hh:mm a"];
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    cell.lblDate.frame = CGRectMake(cell.lblDate.frame.origin.x, (cell.txtContent.frame.origin.y + cell.txtContent.frame.size.height), cell.lblDate.frame.size.width, cell.lblDate.frame.size.height);
    
    //NSLog(@"render %.f",cell.frame.size.height);
    if ([DeviceManager IsiPhone])
    {
        //cell.vwLine.frame = CGRectMake(0, (cell.lblDatetime.frame.origin.y + 30), 300, 1);
        cell.vwLine.frame = CGRectMake(0, (cell.frame.size.height - 1), 300, 1);
    }
    
    cell.imgWho.image = nil;
    NSURL *imgURL = [NSURL URLWithString:[displayData objectForKey:@"pictureUrl"]];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error)
     {
         if (!error)
         {
             cell.imgWho.image = [UIImage imageWithData:data];
         }
     }];
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    
    NSDictionary *objTweet = [self.feedData objectAtIndex:indexPath.row];
    NSDictionary *objFeed = [objTweet objectForKey:@"creator"];
    
    [self.textView setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];
    
    UIFont *font = [UIFont fontWithName:@"SegoeWP" size:17.0f];
    
    [self.textView setFont:font];
    [self.textView setText:[NSString stringWithFormat:@"%@ %@",[objFeed objectForKey:@"firstName"],[objFeed objectForKey:@"lastName"]]];
    CGSize size1 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    
    font = [UIFont fontWithName:@"SegoeWP" size:14.0f];
    
    [self.textView setFont:font];
    [self.textView setText:[NSString stringWithFormat:@"%@\n%@",[NSString stringWithString:[objTweet objectForKey:@"title"]],[NSString stringWithString:[objFeed objectForKey:@"headline"]]]];
    CGSize size2 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    
    NSDate *dtStartDate = [NSDate dateWithTimeIntervalSince1970:([[objTweet objectForKey:@"creationTimestamp"] longValue] / 1000)];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz YYYY"];
    [dateFormater setDateFormat:@"EEEE, dd MMM. HH:mm a"];
    [self.textView setText:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]]];
    CGSize size3 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    
    expectedLabelSize.height = size1.height + size2.height + size3.height;
    
    //NSLog(@"size %.f",expectedLabelSize.height);
    return (CGSize) {.width = 300, .height = expectedLabelSize.height};
}


/*
- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *objTweet = [self.feedData objectAtIndex:indexPath.row];
    //self.textView.text = [objTweet objectForKey:@"text"];
    //CGRect rect      = self.textView.frame;
    //rect.size.height = self.textView.contentSize.height;
    //self.textView.frame   = rect;
    if ([DeviceManager IsiPad]) {
        CGSize cellSize = (CGSize) { .width = 600, .height = 250};
        return cellSize;
    }
    else{
        //CGSize cellSize = (CGSize) { .width = 300, .height = (self.textView.frame.size.height+self.textView.frame.origin.y+35)};
        CGSize cellSize = (CGSize) { .width = 300, .height = (300+222+35)};
        return cellSize;
    }
}*/

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
