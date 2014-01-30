//
//  FacebookViewController.m
//  mgx2013
//
//  Created by Amit Karande on 22/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "FacebookViewController.h"
#import "FacebookWritePost.h"
#import "FBJSON.h"
#import "TwitterFeedCustomCell.h"
#import "Constants.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "NSString+Custom.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController
@synthesize objConnection, objData, dictData;

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
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SOCIAL_MEDIA_FACEBOOK];
    
    //[UIView addTouchEffect:self.view];
}

-(void) viewWillAppear:(BOOL)animated
{
    //[self populateData];
    [self fetchFBFeeds];
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
    if([identifier isEqualToString:@"loadFacebookWritePost"])
    {
//        Shared *objShared = [Shared GetInstance];
//        
//        if([objShared GetIsInternetAvailable] == NO)
//        {
//            [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//            return NO;
//        }
    }
    
    return YES;
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
- (void)fetchFBFeeds
{
    [[self colFacebookPosts] setHidden:YES];
    [[self avLoading] setHidden:NO];
    
    NSString *strURL = @"https://graph.facebook.com/";
    strURL = [strURL stringByAppendingString:FACEBOOK_EVENTID];
    strURL = [strURL stringByAppendingString:@"/feed?access_token="];
    strURL = [strURL stringByAppendingString:[FACEBOOK_ACCESSTOKEN stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    strURL = [strURL stringByAppendingString:@"&fields=id,from,message,link,picture,name,caption,icon,created_time,updated_time,is_hidden"];
    
    NSURL *URL = [NSURL URLWithString:strURL];

    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];

    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES];
}

- (void)populateData
{
    NSError *error;
    
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        NSMutableArray *allFeeds = [dictData objectForKey:@"data"];
        
        if (self.arrFBFeeds == nil)
        {
            self.arrFBFeeds = [[NSMutableArray alloc] init];
        }
        
        int intCounter = 0;
        dictData = nil;
        
        if([allFeeds count] > 0)
        {
            for(NSDictionary *dictData in allFeeds)
            {
                NSDictionary *objFeed = [allFeeds objectAtIndex:intCounter];

                NSMutableDictionary *dicFeed = [[NSMutableDictionary alloc] init];

                NSDictionary *objFrom = [objFeed objectForKey:@"from"];
                [dicFeed setObject:[objFrom objectForKey:@"name"] forKey:@"name"];
                
                [dicFeed setObject:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[objFrom objectForKey:@"id"]]  forKey:@"profile_image_url"];
                [dicFeed setObject:[objFeed objectForKey:@"message"] forKey:@"message"];
                
                if([objFeed objectForKey:@"link"] == nil)
                {
                    [dicFeed setObject:@"" forKey:@"link"];
                }
                else
                {
                    [dicFeed setObject:[objFeed objectForKey:@"link"] forKey:@"link"];
                }
                
                [dicFeed setObject:[objFeed objectForKey:@"created_time"] forKey:@"created_time"];
                
                [self.arrFBFeeds addObject:dicFeed];
                
                intCounter = intCounter + 1;
            }
        }
        else
        {
            [[self lblNoFeeds] setHidden:NO];
        }
        
        [[self colFacebookPosts] setHidden:NO];
        [[self avLoading] setHidden:YES];
        
        [self.colFacebookPosts reloadData];
    }
    else
    {
    }
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrFBFeeds count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterFeedCustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    NSDictionary *objFeed = [self.arrFBFeeds objectAtIndex:indexPath.row];

    cell.lblTitle.text = [objFeed objectForKey:@"name"];

    cell.txtDescription.text = [NSString stringWithFormat:@"%@\r\n",[objFeed objectForKey:@"message"]];
    cell.txtDescription.scrollEnabled = NO;
    [cell.txtDescription setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];
    
    CGRect rect = cell.txtDescription.frame;
    CGSize size2 = [cell.txtDescription sizeThatFits:CGSizeMake(240, FLT_MAX)];
    rect.size.height = size2.height;
    cell.txtDescription.frame = rect;
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *dtStartDate = [dateFormater dateFromString:[objFeed objectForKey:@"created_time"]];
    [dateFormater setDateFormat:@"EEEE, dd MMM. hh:mm a"];
    cell.lblDatetime.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    
    if(![NSString IsEmpty:[objFeed objectForKey:@"link"] shouldCleanWhiteSpace:YES])
    {
        cell.textLink.hidden  = NO;
        cell.textLink.dataDetectorTypes = UIDataDetectorTypeAll;
        cell.textLink.editable = NO;
        
        cell.textLink.text = [objFeed objectForKey:@"link"];
        cell.textLink.scrollEnabled = NO;
        [cell.textLink setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];
        
        rect = cell.textLink.frame;
        CGSize size3 = [cell.textLink sizeThatFits:CGSizeMake(240, FLT_MAX)];
        rect.size.height = size3.height;
        cell.textLink.frame = rect;
        
        cell.textLink.frame = CGRectMake(cell.textLink.frame.origin.x, (cell.txtDescription.frame.origin.y + cell.txtDescription.frame.size.height), cell.textLink.frame.size.width, cell.textLink.frame.size.height);
        
        cell.lblDatetime.frame = CGRectMake(cell.lblDatetime.frame.origin.x, (cell.textLink.frame.origin.y + cell.textLink.frame.size.height), cell.lblDatetime.frame.size.width, cell.lblDatetime.frame.size.height);        
    }
    else
    {
        cell.textLink.hidden  = YES;
        
        cell.lblDatetime.frame = CGRectMake(cell.lblDatetime.frame.origin.x, (cell.txtDescription.frame.origin.y + cell.txtDescription.frame.size.height), cell.lblDatetime.frame.size.width, cell.lblDatetime.frame.size.height);
    }
    
    //NSLog(@"render %.f",cell.frame.size.height);
    if ([DeviceManager IsiPhone])
    {
        //cell.vwLine.frame = CGRectMake(0, (cell.lblDatetime.frame.origin.y + 30), 300, 1);
        cell.vwLine.frame = CGRectMake(0, (cell.frame.size.height - 1), 300, 1);
    }
    
    cell.imgLogo.image = nil;
    NSURL *imgURL = [NSURL URLWithString:[objFeed objectForKey:@"profile_image_url"]];
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
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    
    NSDictionary *objFeed = [self.arrFBFeeds objectAtIndex:indexPath.row];
    
    [self.textView setContentInset:UIEdgeInsetsMake(-5, -5, -5, -5)];

    UIFont *font = [UIFont fontWithName:@"SegoeWP" size:17.0f];
    
    [self.textView setFont:font];
    [self.textView setText:[objFeed objectForKey:@"name"]];
    CGSize size1 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];

    font = [UIFont fontWithName:@"SegoeWP" size:14.0f];
    
    [self.textView setFont:font];
    [self.textView setText:[NSString stringWithFormat:@"%@\r\n",[objFeed objectForKey:@"message"]]];
    CGSize size2 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];

    CGSize size3 = CGSizeMake(240, 0);
    if(![NSString IsEmpty:[objFeed objectForKey:@"link"] shouldCleanWhiteSpace:YES])
    {
        [self.textView setFont:font];
        [self.textView setText:[NSString stringWithFormat:@"%@\r\n",[objFeed objectForKey:@"link"]]];
        size3 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];
    }
    
    //NSLog(@"%@",[objFeed objectForKey:@"created_time"]);
    [self.textView setFont:font];
    [self.textView setText:[objFeed objectForKey:@"created_time"]];
    CGSize size4 = [self.textView sizeThatFits:CGSizeMake(240, FLT_MAX)];

    expectedLabelSize.height = size1.height + size2.height + size3.height + size4.height;
    
    if(![NSString IsEmpty:[objFeed objectForKey:@"link"] shouldCleanWhiteSpace:YES])
    {
        expectedLabelSize.height = expectedLabelSize.height + 0;
    }
    else
    {
        expectedLabelSize.height = expectedLabelSize.height + 0;
    }

    //NSLog(@"size %.f",expectedLabelSize.height);
    return (CGSize) {.width = 300, .height = expectedLabelSize.height};
}
#pragma mark -

#pragma mark View Events
- (void)OpenFB:(UIButton*)sender
{
    NSDictionary *objFeed = [self.arrFBFeeds objectAtIndex:sender.tag];
    
    NSLog(@"%@",[objFeed objectForKey:@"link"]);
    NSString *strLink = [objFeed objectForKey:@"link"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLink]];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
    
    /*NSInteger intTag = (int)[connection getTag];
     NSNumber *tag = [NSNumber numberWithInteger:intTag];
     
     if([dictData objectForKey:tag] == nil)
     {
     NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
     [dictData setObject:newData forKey:tag];
     return;
     }
     else
     {
     [[dictData objectForKey:tag] appendData:data];
     }*/
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    [self populateData];
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
