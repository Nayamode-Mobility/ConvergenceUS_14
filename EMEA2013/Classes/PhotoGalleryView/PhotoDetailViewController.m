//
//  PhotoDetailViewController.m
//  mgx2013
//
//  Created by Paul Johnson on 10/25/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"
#import "User.h"
#import "CustomCollectionViewCell.h"
#import "Functions.h"
#import "Constants.h"
#import "Shared.h"
#import "NSString+Custom.h"
#import "SpeakerCell.h"
#import "PhotoLargeView.h"
#import "AppDelegate.h"

@interface PhotoDetailViewController ()
{
    @private
    int intCurrPhotoID;
}
@end

@implementation PhotoDetailViewController

@synthesize objConnection, objData, detailScrollView, filterSelect;

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
    
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    [[self avLoadingLike] setHidden:YES];
    [[self avLoadingLike] stopAnimating];
    
    [[self avLoadingPostComment] setHidden:YES];
    [[self avLoadingPostComment] stopAnimating];
    
    [[self avLoadingDelete] setHidden:YES];
    [[self avLoadingDelete] stopAnimating];
    
    [[self avLoadingSearch] setHidden:YES];
    [[self avLoadingSearch] stopAnimating];
    
    self.postComment = [[PostComment alloc] init];
    [self.postComment reset];
    self.postComment.activityView = self.activityView2;
    self.postComment.commentText = self.commentText;
    self.postComment.delegate = self;
    
    [[[self btnLike] layer] setBorderWidth:2.0f];
    [[[self btnLike] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnLike] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnLike] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnUnlike] layer] setBorderWidth:2.0f];
    [[[self btnUnlike] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnUnlike] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnUnlike] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnPostComment] layer] setBorderWidth:2.0f];
    [[[self btnPostComment] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnPostComment] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnPostComment] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    //[[[self btnRefresh] layer] setBorderWidth:2.0f];
    //[[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    //[[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    //[[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnDelete] layer] setBorderWidth:2.0f];
    [[[self btnDelete] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnDelete] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnDelete] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    filterSelect = 1;
    
    [self refresh];
    [self updateButtons];
    
    //[tapGestureRecognizer setCancelsTouchesInView:NO];
	// Do any additional setup after loading the view.
    
    [[[self popularButton] layer] setBorderWidth:2.0f];
    [[[self popularButton] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self popularButton] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self popularButton] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self recentButton] layer] setBorderWidth:2.0f];
    [[[self recentButton] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self recentButton] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self recentButton] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.galleryView setHidden:YES];
    [self.postView setHidden:YES];
    [self.commentsView setHidden:YES];
    
    [self.listView setHidden:NO];
    [self.searchView setHidden:NO];
    
    self.IsUserSelected = YES;
    
    if([self blnCalledFromMyUploads] == YES)
    {
        [self launchCarousel:0];
    }
    else
    {
        [detailScrollView setContentSize:CGSizeMake(640, detailScrollView.frame.size.height)];
        
        [[self photoCollectionView] setDelegate:self];
        [[self photoCollectionView] setDataSource:self];
    }
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewDidLayoutSubviews
{
    if([self blnCalledFromMyUploads] == NO)
    {
        [self.detailScrollView setContentSize:CGSizeMake(640, self.detailScrollView.frame.size.height)];
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Textfield and Textview Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    [[self lblCommentsPlaceHolder] setHidden:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if(self.commentText.text.length == 0)
    {
        [[self lblCommentsPlaceHolder] setHidden:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Button Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)prevClicked:(id)sender
{
    //Shared *objShared = [Shared GetInstance];
    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        //[self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        return;
//    }
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    
    if (self.intPhotoIndex==0 && [self.photoList count] > 0 )
    {
        self.intPhotoIndex = [self.photoList count] - 1;
    }
    else
    {
        if (self.intPhotoIndex > 0)
        {
            self.intPhotoIndex--;
        }
    }
    
    NSDictionary *dict = [self.photoList objectAtIndex:self.intPhotoIndex];
    self.startPict = dict;
    
    [self loadImage];
}

-(IBAction)nextClicked:(id)sender
{
   // Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
      //  NETWORK_ALERT();
        return;
    }
    if (self.intPhotoIndex < [self.photoList count]-1  )
    {
        self.intPhotoIndex++;
    }
    else
    {
        if (self.intPhotoIndex == [self.photoList count]-1 )
        {
            self.intPhotoIndex = 0;
        }
    }
    
    NSDictionary *dict = [self.photoList objectAtIndex:self.intPhotoIndex];
    self.startPict = dict;

    [self loadImage];
}

- (IBAction)likeButton:(id)sender
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    [[self avLoadingLike] setHidden:NO];
    [[self avLoadingLike] startAnimating];
    
    [self.postComment likeButton];
}

- (IBAction)unlikeButton:(id)sender
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    [[self avLoadingLike] setHidden:NO];
    [[self avLoadingLike] startAnimating];
    
    [self.postComment unlikeButton];
}

- (IBAction)postCommentButton:(id)sender
{
    if (self.commentText.text.length == 0)
    {
        [self showAlert:@"" withMessage:@"Please enter your comment." withButton:@"OK" withIcon:nil];
    }
    else
    {
        //Shared *objShared = [Shared GetInstance];
        
        if (!APP.netStatus) {
            NETWORK_ALERT();
            return;
        }
        [[self avLoadingPostComment] setHidden:NO];
        [[self avLoadingPostComment] startAnimating];
        
        [self.postComment postCommentButton];
    }
}

- (IBAction)deleteButton:(id)sender
{
    //int curid = [[[self.photoList objectAtIndex:intSelectedIndex] objectForKey:@"PhotoID"] intValue];
    
    [[self avLoadingDelete] setHidden:NO];
    [[self avLoadingDelete] startAnimating];
    
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_DELETE_PHOTO];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d", intCurrPhotoID] forHTTPHeaderField:@"PhotoID"];
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_DELETE_PHOTO];
}

- (IBAction)search:(id)sender
{
    /*filterSelect = -1;
     [self updateButtons];
     [self refresh];*/
    [self.textFieldSearch resignFirstResponder];
    
    [[self lblNoItemsFound] setHidden:YES];
    [[self avLoadingSearch] setHidden:NO];
    [[self avLoadingSearch] startAnimating];
    
    [self getSearchedPhotos];
}

- (IBAction)searchTypeSelected:(id)sender
{
    if (sender == self.rbtnUser)
    {
        self.IsUserSelected = YES;
        [self.rbtnUser setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        [self.rbtnHashtag setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.IsUserSelected = NO;
        [self.rbtnUser setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.rbtnHashtag setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[detailScrollView contentOffset].x);
    if([self.detailScrollView contentOffset].x == 0)
    {
        if(self.listView.isHidden == NO)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            if([self blnCalledFromMyUploads] == YES)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.galleryView setHidden:YES];
                [self.postView setHidden:YES];
                [self.commentsView setHidden:YES];
                
                [self.listView setHidden:NO];
                [self.searchView setHidden:NO];
                [[self lblTitle] setText:@"views"];
                
                [detailScrollView setContentSize:CGSizeMake(640, detailScrollView.frame.size.height)];
            }
        }
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            //[self.detailScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
             [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)popularClicked:(id)sender
{
    if (filterSelect!=1)
    {
        filterSelect = 1;
        [self updateButtons];
        [self refresh];
    }
}
- (IBAction)recentClicked:(id)sender
{
    if (filterSelect!=0)
    {
        filterSelect = 0;
        [self updateButtons];
        [self refresh];
    }
}

- (IBAction)imageSelected:(id)sender
{
    [self.galleryView setHidden:YES];
    [self.postView setHidden:YES];
    [self.commentsView setHidden:YES];

    [self.listView setHidden:NO];
    [self.searchView setHidden:NO];
    
    [detailScrollView setContentSize:CGSizeMake(640, detailScrollView.frame.size.height)];
}

- (IBAction)loadLargeView:(id)sender
{
    PhotoLargeView *vcPhotoLargeView;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcPhotoLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idPhotoLargeView"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcPhotoLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idPhotoLargeView"];
    }

    vcPhotoLargeView.curPict  = [self.photoList objectAtIndex:self.intPhotoIndex];
    [[self navigationController] pushViewController:vcPhotoLargeView animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Load Image
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) loadImage
{
    if (self.photoList.count == 0) return;
    
    if (self.startPict)
    {
        int startIndex = [[self.startPict objectForKey:@"PhotoID"] intValue];
        [self.postComment reset];
        
        for (int i=0; i<[self.photoList count]; i++)
        {
            //int curid = [[[self.photoList objectAtIndex:i] objectForKey:@"PhotoID"] intValue];
            intCurrPhotoID = [[[self.photoList objectAtIndex:i] objectForKey:@"PhotoID"] intValue];
            //NSLog(@"%d",intCurrPhotoID);
            
            //if(curid == startIndex)
            if(intCurrPhotoID == startIndex)
            {
                self.intPhotoIndex = i;
                self.startPict = nil;
                break;
            }
        }
    }
    
    [self.mainImage setAlpha:1.0];
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    [self.mainImage setAlpha:0.0];
    [UIView commitAnimations];
    
    [self.activityView setHidden:NO];
    NSDictionary *dict = [self.photoList objectAtIndex:self.intPhotoIndex];
    self.postComment.curPict = dict;
    
    if(self.commentText.text.length == 0)
    {
        [[self lblCommentsPlaceHolder] setHidden:NO];
    }
    
    [[self btnDelete] setHidden:YES];
    
    NSString *strImage = ([dict objectForKey:@"PhotoURL"]) ? [dict objectForKey:@"PhotoURL"] : [dict objectForKey:@"PhotoUrl"];
    if (!strImage || [strImage isKindOfClass:[NSNull class]] ) return;
    
    //if([strImage rangeOfString:@"_T."].location == NSNotFound)
    //{
    //}
    //else
    //{
    //    NSMutableArray *arrImageComponents = [[strImage componentsSeparatedByString:@"_T."] mutableCopy];
    //    [arrImageComponents replaceObjectAtIndex:[arrImageComponents count] - 1 withObject:[[arrImageComponents objectAtIndex:[arrImageComponents count] - 1] uppercaseString]];
    //    //strImage = [strImage stringByReplacingOccurrencesOfString:@"_T." withString:@"."];
    //    strImage = [arrImageComponents componentsJoinedByString:@"."];
    //}
    
    NSString *title = ([dict objectForKey:@"Title"]) ? [dict objectForKey:@"Title"]: [dict objectForKey:@"title"];
    NSString *desc = [ dict objectForKey:@"CommentText"];
    
    self.labelTitle.text = ( !title || [title isKindOfClass:[NSNull class]]) ? @"" : title;
    self.textViewDescription.text = ( !desc || [desc isKindOfClass:[NSNull class]] ) ? @"" : desc;
    
    NSURL *imgURL = [NSURL URLWithString:strImage];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error){
        if (!error)
        {
            [ self.mainImage setImage:[UIImage imageWithData:data]];
            
        }
        else
        {
            
            NSLog(@"error %@",error);
            
        }
        
        [self.mainImage setAlpha:0.0];
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [self.mainImage setAlpha:1.0];
        [UIView commitAnimations];
        
        [self.activityView setHidden:YES];
    }];
    
    [self getPhotoCommentList];
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

-(void)refresh
{
    NSString *serviceEndPoint = strAPI_PHOTOS_GET_RECENT_PHOTO;
    int serviceID = OPER_PHOTOS_GET_RECENT_PHOTO;
    NSString *method = @"POST";
    
    switch (filterSelect)
    {
        case -1:
            
            serviceEndPoint = strAPI_PHOTOS_GET_SEARCH_PHOTO;
            serviceID = OPER_PHOTOS_GET_SEARCH_PHOTO;
            method = @"GET";
            break;
        case 0:
            serviceEndPoint = strAPI_PHOTOS_GET_RECENT_PHOTO;
            serviceID = OPER_PHOTOS_GET_RECENT_PHOTO;
            break;
        case 1:
            serviceEndPoint = strAPI_PHOTOS_GET_POPULAR_PHOTO;
            serviceID = OPER_PHOTOS_GET_POPULAR_PHOTO;
            break;
        default:
            break;
    }
    
    self.intPhotoIndex = 0;
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [[strURL stringByAppendingString:serviceEndPoint] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *URL = [NSURL URLWithString:strURL];
   // NSLog(@"url %@",strURL);
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:method];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    if (filterSelect==-1)
    {
        [objRequest addValue:self.textFieldSearch.text forHTTPHeaderField:@"SearchCriteria"];
    }
    
    objConnection = nil;
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:serviceID];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Queries
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   // NSLog(@"Error: %@",error);
    [ExceptionHandler AddExceptionForScreen:strSCREEN_PHOTO MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
     // NSLog(@"didReceiveResponse: %@",response);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);

    //NSLog(@"data contents: %@", [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding]);
    //NSString *string = [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding];

    //NSError *jsonError;
    //NSArray *photos = [[NSArray alloc] init];
    //photos = [NSJSONSerialization JSONObjectWithData:objData options:0 error:&jsonError];
    
    //if (![photos isKindOfClass:[NSArray class]])
    //{
    //    return;
    //}
    
    //if(jsonError != nil)
    //{
    //    NSLog(@"JSON Error: %@", jsonError);
    //    return;
    //}
    
    if (intTag == OPER_PHOTOS_GET_PHOTO_COMMENT_LIST)
    {
        NSError *jsonError;
        NSArray *photos = [[NSArray alloc] init];
        photos = [NSJSONSerialization JSONObjectWithData:objData options:0 error:&jsonError];
        
        if (![photos isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if(jsonError != nil)
        {
            NSLog(@"JSON Error: %@", jsonError);
            return;
        }
        
        self.commentList = photos;
        [self.commentsCollectionView reloadData];
        
        [self getPhotoLikeStatus];
    }
    else if (intTag == OPER_PHOTOS_GET_PHOTO_LIKE_STATUS)
    {
        NSLog(@"data contents: %@", [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding]);
        NSString *strData= [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strData);
        
        BOOL isPhotoLiked = [strData isEqualToString:@"true"]?YES:NO;//[[NSString stringWithFormat:@"%@",objData] boolValue];
        
        [[self btnLike] setHidden:isPhotoLiked];
        [[self btnUnlike] setHidden:!isPhotoLiked];
        
        [self getPhotoLikesCommentsCount];
    }
    else if (intTag == OPER_PHOTOS_GET_PHOTO_LIKES_COMMENTS_COUNT)
    {
        NSError *jsonError;
        NSArray *photos = [[NSArray alloc] init];
        photos = [NSJSONSerialization JSONObjectWithData:objData options:0 error:&jsonError];
        
        if (![photos isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if(jsonError != nil)
        {
            NSLog(@"JSON Error: %@", jsonError);
            return;
        }
        
        self.arrLikesCommentsCount =  photos;
        
        if([[self arrLikesCommentsCount] count] > 0)
        {
            NSString *strPostedDate = [self.arrLikesCommentsCount[0] objectForKey:@"CreatedDate"];
            //strPostedDate = [strPostedDate substringWithRange:NSMakeRange(0, [strPostedDate length] - 13)];
            strPostedDate = [strPostedDate componentsSeparatedByString:@"T"][0];
            //NSLog(@"%@",strPostedDate);
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *dtPostedDate = [dateFormater dateFromString:strPostedDate];
            //NSLog(@"%@",dtPostedDate);
            [dateFormater setDateFormat:@"EEEE, dd MMM"];
            [[self lblPostedDate] setText:[dateFormater stringFromDate:dtPostedDate]];
            
            [[self lblLikesCount] setText:[NSString stringWithFormat:@"%@",[self.arrLikesCommentsCount[0] objectForKey:@"LikeCount"]]];

            [[self lblCommentsCount] setText:[NSString stringWithFormat:@"%@",[self.arrLikesCommentsCount[0] objectForKey:@"CommentCount"]]];

            NSString *strUploadedBy = [self.arrLikesCommentsCount[0] objectForKey:@"UploadedBy"];
            //NSLog(@"%@",strUploadedBy);
            [[self lblUploadedBy] setText:strUploadedBy];
            
            [[self lblUploadedBy] setNumberOfLines:0];
            CGRect orgSize = [self lblUploadedBy].frame;
            [[self lblUploadedBy] sizeToFit];
            [[self lblUploadedBy] setFrame:orgSize];
            
            User *objUser = [User GetInstance];
            NSString *strAccountEmail = [objUser GetAccountEmail];
            //NSLog(@"%@",strAccountEmail);
            if([[strUploadedBy uppercaseString] isEqualToString:[strAccountEmail uppercaseString]] == YES)
            {
                [[self btnDelete] setHidden:NO];
            }
            else
            {
                [[self btnDelete] setHidden:YES];
            }
        }
    }
    else if(intTag == OPER_PHOTOS_GET_SEARCH_PHOTO_USERWISE)
    {
        NSError *jsonError;
        self.searchPhotoList = [NSJSONSerialization JSONObjectWithData:objData options:0 error:&jsonError];
        
        if (![self.searchPhotoList isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        
        if(jsonError != nil)
        {
            NSLog(@"JSON Error: %@", jsonError);
            return;
        }
        
        if(self.searchPhotoList.count == 0)
        {
            [[self lblNoItemsFound] setHidden:NO];
            self.searchResultTableView.hidden = YES;
        }
        else
        {
            self.searchResultTableView.hidden = NO;
            [self.searchResultTableView reloadData];
        }
        
        [[self avLoadingSearch] setHidden:YES];
        [[self avLoadingSearch] stopAnimating];
    }
    else if(intTag == OPER_PHOTOS_GET_SEARCH_PHOTO_HASHTAG)
    {
        NSError *jsonError;
        NSString *string = [[NSString alloc] initWithData:objData encoding:NSUTF8StringEncoding];
        string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        string = [string substringFromIndex:1];
        string = [string substringToIndex:[string length] - 1];
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        self.searchPhotoList = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",objData]);
        
        if (![self.searchPhotoList isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if(jsonError != nil)
        {
            NSLog(@"JSON Error: %@", jsonError);
            return;
        }

        if(self.searchPhotoList.count)
        {
            [[self lblNoItemsFound] setHidden:NO];
            self.searchResultTableView.hidden = YES;
        }
        else
        {
            self.searchResultTableView.hidden = NO;
            [self.searchResultTableView reloadData];
        }
        
        [[self avLoadingSearch] setHidden:YES];
        [[self avLoadingSearch] stopAnimating];
    }
    else if(intTag == OPER_PHOTOS_DELETE_PHOTO)
    {
        NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
        //NSLog(@"Response: %@",strData);
        
        if ([strData boolValue] == TRUE)
        {
            [self showAlert:@"" withMessage:@"Your photo has been deleted." withButton:@"OK" withIcon:nil];
            
            [[self photoList] removeObjectAtIndex:[self intPhotoIndex]];

            [self nextClicked:nil];
            
            [[self avLoadingDelete] setHidden:YES];
            [[self avLoadingDelete] stopAnimating];
        }
    }
    else
    {
        NSError *jsonError;
        NSArray *photos = [[NSArray alloc] init];
        photos = [NSJSONSerialization JSONObjectWithData:objData
                                                 options:0 error:&jsonError];
        
        if (![photos isKindOfClass:[NSArray class]])
        {
            return;
        }
        
        if(jsonError != nil)
        {
            NSLog(@"JSON Error: %@", jsonError);
            return;
        }
        
        self.photoList = [photos mutableCopy];
        
        //NSLog(@"list: %@", self.photoList);
        
        [self loadImage];
        [self.photoCollectionView reloadData];
        
        //[[self vwLoading] setHidden:YES];
        //[[self avLoading] stopAnimating];
    }
}
#pragma mark -


- (void)updateButtons
{
    [self.popularButton setBackgroundColor:[UIColor colorWithRed:155/255 green:48/255 blue:255/255 alpha:1.0]];
    [self.recentButton setBackgroundColor:[UIColor colorWithRed:155/255 green:48/255 blue:255/255 alpha:1.0]];
    
    switch (filterSelect)
    {
        case 0:
        {
            [self.recentButton setBackgroundColor:[UIColor colorWithRed:155/255 green:48/255 blue:255/255 alpha:1.0]];
            [self.popularButton setBackgroundColor:[UIColor colorWithRed:104/255 green:33/255 blue:122/255 alpha:1.0]];
        }
            break;
            
        case 1:
        {
            [self.recentButton setBackgroundColor:[UIColor colorWithRed:155/255 green:48/255 blue:255/255 alpha:1.0]];
            [self.popularButton setBackgroundColor:[UIColor colorWithRed:155/255 green:48/255 blue:255/255 alpha:1.0]];
        }
            break;
            
        default:
            break;
    }
}

//- (void) getPhotoCommentList:(NSInteger)intSelectedIndex
- (void) getPhotoCommentList
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
       // NETWORK_ALERT();
        return;
    }
    //int curid = [[[self.photoList objectAtIndex:intSelectedIndex] objectForKey:@"PhotoID"] intValue];
    
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_PHOTO_COMMENT_LIST];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d", intCurrPhotoID] forHTTPHeaderField:@"PhotoID"];
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_PHOTO_COMMENT_LIST];
}

- (void) getSearchedPhotos
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
       // NETWORK_ALERT();
        return;
    }
    //int curid = [[[self.photoList objectAtIndex:intSelectedIndex] objectForKey:@"PhotoID"] intValue];
    
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    if (self.IsUserSelected)
    {
        strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_SEARCH_PHOTO_USERWISE];
    }
    else
    {
        strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_SEARCH_PHOTO_HASHTAG];
    }
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    if (self.IsUserSelected)
    {
        [objRequest addValue:self.textFieldSearch.text forHTTPHeaderField:@"SearchEmail"];
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_SEARCH_PHOTO_USERWISE];
    }
    else
    {
        [objRequest addValue:self.textFieldSearch.text forHTTPHeaderField:@"HashTag"];
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_SEARCH_PHOTO_HASHTAG];
    }
}

- (void) getPhotoLikeStatus
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
       // NETWORK_ALERT();
        return;
    }
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_PHOTO_LIKE_STATUS];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d", intCurrPhotoID] forHTTPHeaderField:@"PhotoID"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_PHOTO_LIKE_STATUS];
}

- (void) getPhotoLikesCommentsCount
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
      //  NETWORK_ALERT();
        return;
    }
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_PHOTOS_GET_PHOTO_LIKES_COMMENTS_COUNT];
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d", intCurrPhotoID] forHTTPHeaderField:@"PhotoID"];

    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_PHOTOS_GET_PHOTO_LIKES_COMMENTS_COUNT];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Collection View Callback
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self launchCarousel:indexPath.row];
    
    /*
    NSDictionary *dict = [self.photoList objectAtIndex:indexPath.row];
    self.startPict = dict;
    
    [self.galleryView setHidden:NO];
    [self.postView setHidden:NO];
    [self.commentsView setHidden:NO];

    [self.listView setHidden:YES];
    [self.searchView setHidden:YES];
    
    [detailScrollView setContentSize:CGSizeMake(960, detailScrollView.frame.size.height)];

    [self loadImage];

    //[self getPhotoCommentList:indexPath.row];
    //[self.commentsCollectionView reloadData];
 
    //intCurrPhotoID = [[[self.photoList objectAtIndex:indexPath.row] objectForKey:@"PhotoID"] intValue];
    //[self getPhotoCommentList];
    */
}

- (void)launchCarousel:(NSUInteger)intRow
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
      //  NETWORK_ALERT();
        return;
    }
    NSDictionary *dict = [self.photoList objectAtIndex:intRow];
    self.startPict = dict;
    
    [self.galleryView setHidden:NO];
    [self.postView setHidden:NO];
    [self.commentsView setHidden:NO];
    
    [self.listView setHidden:YES];
    [self.searchView setHidden:YES];
    
    [[self lblTitle] setText:@"details"];
    
    [detailScrollView setContentSize:CGSizeMake(960, detailScrollView.frame.size.height)];
    
    [self loadImage];
    
    //[self getPhotoCommentList:indexPath.row];
    //[self.commentsCollectionView reloadData];
    
    //intCurrPhotoID = [[[self.photoList objectAtIndex:indexPath.row] objectForKey:@"PhotoID"] intValue];
    //[self getPhotoCommentList];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (view == self.photoCollectionView)
    {
        return [self.photoList count];
    }
    else if (view == self.commentsCollectionView)
    {
        return [self.commentList count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    if (cv == self.photoCollectionView)
    {
        NSDictionary *dict = [self.photoList objectAtIndex:indexPath.row];
        
        [cell.avLoading  startAnimating];
        
        // Name conventions are not consistent in web service!!!! ugh!
        NSString *strImage = ([dict objectForKey:@"PhotoURL"]) ? [dict objectForKey:@"PhotoURL"] : [dict objectForKey:@"PhotoUrl"];
        
        //if([strImage rangeOfString:@"_T."].location == NSNotFound)
        //{
        //}
        //else
        //{
        //    NSMutableArray *arrImageComponents = [[strImage componentsSeparatedByString:@"_T."] mutableCopy];
        //    [arrImageComponents replaceObjectAtIndex:[arrImageComponents count] - 1 withObject:[[arrImageComponents objectAtIndex:[arrImageComponents count] - 1] uppercaseString]];
        //    //strImage = [strImage stringByReplacingOccurrencesOfString:@"_T." withString:@"."];
        //    strImage = [arrImageComponents componentsJoinedByString:@"."];
        //}
        
        cell.articleImage.image = nil;
        NSURL *imgURL = [NSURL URLWithString:strImage];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                cell.articleImage.image = [UIImage imageWithData:data];
                /*NSDictionary *obj = [self.photoList objectAtIndex:indexPath.row];
                NSString *strTitle = [obj objectForKey:@"Title"];
                if([NSString IsEmpty:strTitle shouldCleanWhiteSpace:YES] == YES)
                {
                    strTitle = [obj objectForKey:@"title"];
                }
                NSString *strEmail = [Functions ReplaceNUllWithBlank:[obj objectForKey:@"EmailAddress"]];
                //strComments = (strComments && ![strComments isKindOfClass:[NSNull class]]) ? strComments: @"";
                cell.TxtDesc.text = [NSString stringWithFormat:@"%@\n%@",strTitle,strEmail];
                */
                [cell.avLoading  stopAnimating];
            }
            else
            {
                [cell.avLoading  stopAnimating];
                NSLog(@"error %@",error);
            }
        }];
        
        NSDictionary *obj = [self.photoList objectAtIndex:indexPath.row];
        NSString *strTitle = [obj objectForKey:@"Title"];
        if([NSString IsEmpty:strTitle shouldCleanWhiteSpace:YES] == YES)
        {
            strTitle = [obj objectForKey:@"title"];
        }
        NSString *strEmail = [Functions ReplaceNUllWithBlank:[obj objectForKey:@"EmailAddress"]];
        //strComments = (strComments && ![strComments isKindOfClass:[NSNull class]]) ? strComments: @"";
        cell.TxtDesc.text = [NSString stringWithFormat:@"%@\n%@",strTitle,strEmail];
    }
    else if (cv == self.commentsCollectionView)
    {
        cell.lblTitle.text = [[self.commentList  objectAtIndex:indexPath.row] objectForKey:@"CommentText"];
        if(![NSString IsEmpty:[[self.commentList  objectAtIndex:indexPath.row] objectForKey:@"EmailAddress"] shouldCleanWhiteSpace:YES] == YES)
        {
            cell.lblName.text = [[self.commentList  objectAtIndex:indexPath.row] objectForKey:@"EmailAddress"];
        }

        NSString *strCommentDate = [[self.commentList  objectAtIndex:indexPath.row] objectForKey:@"CommentDate"];
        //strCommentDate = [strCommentDate substringWithRange:NSMakeRange(0, [strCommentDate length] - 12)];
        strCommentDate = [strCommentDate componentsSeparatedByString:@"T"][0];
        //NSLog(@"%@",strCommentDate);
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *dtCommentDate = [dateFormater dateFromString:strCommentDate];
        //NSLog(@"%@",dtCommentDate);
        [dateFormater setDateFormat:@"EEEE, dd MMM"];
        //[dateFormater setDateFormat:@"EEEE, d LLL"];
        cell.lblDate.text = [dateFormater stringFromDate:dtCommentDate];
    }
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
    
    return cell;
}

/*
 - (CGRect)collectionViewContentSize
 {
 double itemCount = [self.uploadList count];
 
 if([DeviceManager IsiPad] == YES)
 {
 double totalHeight = ceil(itemCount/iPad_NO_of_Cols)*(iPad_Item_Height) +10;
 
 return CGRectMake(self.photoCollectionView.frame.origin.x, self.photoCollectionView.frame.origin.y, self.photoCollectionView.frame.size.width, totalHeight);
 }
 else{
 double totalHeight = ceil(itemCount/iPhone_NO_of_Cols)*(iPhone_Item_Height) +10;
 return CGRectMake(self.photoCollectionView.frame.origin.x, self.photoCollectionView.frame.origin.y, self.photoCollectionView.frame.size.width, totalHeight);
 
 }
 
 
 }
 
 */

#pragma mark Post Comments Events
- (void)likeSuccess
{
    [[self btnLike] setHidden:YES];
    [[self btnUnlike] setHidden:NO];
    
    [self getPhotoLikesCommentsCount];
    
    [[self avLoadingLike] setHidden:YES];
    [[self avLoadingLike] stopAnimating];
}

- (void)unlikeSuccess
{
    [[self btnLike] setHidden:NO];
    [[self btnUnlike] setHidden:YES];
    
    [self getPhotoLikesCommentsCount];
    
    [[self avLoadingLike] setHidden:YES];
    [[self avLoadingLike] stopAnimating];
}

- (void)commentsAddedSuccess
{
    [self getPhotoCommentList];
    
    [[self avLoadingPostComment] setHidden:YES];
    [[self avLoadingPostComment] stopAnimating];
}
#pragma mark -

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.searchPhotoList count] > 0) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SpeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (self.IsUserSelected)
    {
        NSDictionary *obj = [self.searchPhotoList objectAtIndex:indexPath.row];
        cell.lblName.text =  [obj objectForKey:@"EmailAddress"];
        cell.lblTask.text = [NSString stringWithFormat:@"%d photo(s)",[self.searchPhotoList count]];
    }
    else
    {
        NSDictionary *obj = [self.searchPhotoList objectAtIndex:indexPath.row];
        cell.lblName.text =  [obj objectForKey:@"HashTag"];
        cell.lblTask.text = [NSString stringWithFormat:@"%d photo(s)",[self.searchPhotoList count]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.IsUserSelected)
    {
        NSDictionary *obj = [self.searchPhotoList objectAtIndex:indexPath.row];
        //self.lblSearchTitle.text =  [NSString stringWithFormat:@"%@ %@",[obj objectForKey:@"EmailAddress"], @"Photos"];
        self.lblSearchTitle.text = [obj objectForKey:@"EmailAddress"];
    }
    else
    {
        NSDictionary *obj = [self.searchPhotoList objectAtIndex:indexPath.row];
        //self.lblSearchTitle.text =  [NSString stringWithFormat:@"%@ %@",[obj objectForKey:@"HashTag"], @"Photos"];
        self.lblSearchTitle.text =  [obj objectForKey:@"HashTag"];
    }
    
    self.photoList = [self.searchPhotoList mutableCopy];
    
    [self.photoCollectionView reloadData];
    [self.recentButton setHidden:YES];
    [self.popularButton setHidden:YES];
    [self.lblSearchTitle setHidden:NO];

    [self.detailScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
@end
