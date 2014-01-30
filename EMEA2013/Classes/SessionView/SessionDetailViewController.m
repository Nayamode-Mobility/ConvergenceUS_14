//
//  SessionDetailViewController.m
//  mgx2013
//
//  Created by Amit Karande on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

//#define TWITTER_HASH_NAME @"%23Conv13EMEA"
//#define TWITTER_POST_HASH_NAME @"#Conv13EMEA"

#import "SessionDetailViewController.h"
#import "SessionResourceCell.h"
#import "SessionNoteViewController.h"
#import "Constants.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "SessionDB.h"
#import "MySessionDB.h"
#import "Speaker.h"
#import "User.h"
#import "SessionCategories.h"
#import "SessionResources.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "SpeakerDetailViewController.h"
#import "Functions.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "FBJSON.h"
#import "TwitterFeedCustomCell.h"
#import "Rooms.h"
#import "CustomCollectionViewCell.h"
#import "EvaluationViewController.h"
#import "NotesViewController.h"
#import "TwitterViewController.h"
#import "FacebookViewController.h"
#import "LinkedInViewController.h"
#import "LargeView.h"
#import "SessionQAViewController.h"
#import "AppDelegate.h"
#import "SessionVideos.h"

@interface SessionDetailViewController ()
{
    
}

@property (strong, nonatomic) IBOutlet UICollectionView *colSpeaker;
@property (nonatomic,readwrite) EKEventStore *store;
@end

@implementation SessionDetailViewController
@synthesize arrSessionSpeakers, arrSessionResources, objConnection, objData;

// Newly Added

@synthesize objMoviePlalyer;

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
    [[self avLoadingVenurFloorPlan] startAnimating];
    
    [self populateData];
    
    if(![DeviceManager IsiPad])
    {
        [[[self btnEvaluation] layer] setBorderWidth:2.0f];
        [[[self btnEvaluation] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnEvaluation] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnEvaluation] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];

        [[[self btnTakeNotes] layer] setBorderWidth:2.0f];
        [[[self btnTakeNotes] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnTakeNotes] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnTakeNotes] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[self btnViewNotes] layer] setBorderWidth:2.0f];
        [[[self btnViewNotes] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnViewNotes] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnViewNotes] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[self btnAddToMySchedule] layer] setBorderWidth:2.0f];
        [[[self btnAddToMySchedule] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnAddToMySchedule] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnAddToMySchedule] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[self btnRemoveFromMySchedule] layer] setBorderWidth:2.0f];
        [[[self btnRemoveFromMySchedule] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnRemoveFromMySchedule] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnRemoveFromMySchedule] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[self btnAddToMyCalendar] layer] setBorderWidth:2.0f];
        [[[self btnAddToMyCalendar] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnAddToMyCalendar] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnAddToMyCalendar] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [[[self btnRemoveFromMyCalendar] layer] setBorderWidth:2.0f];
        [[[self btnRemoveFromMyCalendar] layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [[self btnRemoveFromMyCalendar] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [[self btnRemoveFromMyCalendar] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SESSION];
    
    //[UIView addTouchEffect:self.view];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self populateTwitterData];
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

-(void) populateData
{
    self.lblSessionCode.text = [NSString stringWithFormat:@"Session :%@",self.sessionData.strSessionCode];
    self.lblSessionTitle.text = self.sessionData.strSessionTitle;
    
    if ([self.sessionData.arrRooms count] > 0){
    Rooms *objRoom = [self.sessionData.arrRooms objectAtIndex:0];
    self.lblRoom.text = objRoom.strRoomName;
    }
    
    self.vwAddToMySchedule.hidden = [[self.sessionData strIsAdded] boolValue];
    self.vwRemoveFromMySchedule.hidden = ![[self.sessionData strIsAdded] boolValue];
    
    self.btnTakeNotes.hidden = [[self.sessionData strNotesAvailable] boolValue];
    self.btnViewNotes.hidden = ![[self.sessionData strNotesAvailable] boolValue];
    
    [self GetEventID];
    
    NSURL *imgURL = [NSURL URLWithString:self.sessionData.strLocationURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error)
    {
         if (!error)
         {
             UIImage *img = [[UIImage alloc] initWithData:data];;
             [self.imgLocation setImage:img];
             
             UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
             [self.imgLocation addGestureRecognizer:singleTap];
         }
        
        [[self avLoadingVenurFloorPlan] stopAnimating];
    }];
    
    //self.lblLocation.text = @"No DATA FOUND";
    //self.lblRoom.text = @"NO DATA FOUND";
    
    NSString *strSpeakers = @"";
    if([self.sessionData.arrSpeakers count] > 0)
    {
        //for (NSUInteger i = 0; i < [self.sessionData.arrSpeakers count]; i++)
        //{
        //if(![NSString IsEmpty:strSpeakers shouldCleanWhiteSpace:YES])
        //{
        //    strSpeakers = [strSpeakers stringByAppendingString:@", "];
        //}
        strSpeakers = [strSpeakers stringByAppendingString:[[[self.sessionData.arrSpeakers objectAtIndex:0] objectAtIndex:0] strFirstName]];
        strSpeakers = [strSpeakers stringByAppendingString:@" "];
        strSpeakers = [strSpeakers stringByAppendingString:[[[self.sessionData.arrSpeakers objectAtIndex:0] objectAtIndex:0] strLastName]];
        //}
        
        self.lblSpeakerName.text = strSpeakers;
        self.lblSpeakerCompany.text = [[[self.sessionData.arrSpeakers objectAtIndex:0] objectAtIndex:0] strCompany];
        self.lblSpeakerTitle.text = [[[self.sessionData.arrSpeakers objectAtIndex:0] objectAtIndex:0] strTitle];
        
        NSURL *imgURL = [NSURL URLWithString:[[[self.sessionData.arrSpeakers objectAtIndex:0] objectAtIndex:0] strSpeakerPhoto]];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                   NSData *data,
                                                                                                                   NSError *error)
         {
             if (!error)
             {
                 UIImage *img = [[UIImage alloc] initWithData:data];;
                 [self.imgSpeakerPhoto setImage:img];
                 
             }
         }];
    }
    
    //[dateFormater setDateFormat:@"yyyy-MM-dd"];
    //NSDate *dtStartDate = [dateFormater dateFromString:self.sessionData.strStartDate];
    //[dateFormater setDateFormat:@"EEEE, MMMM dd"];
    //self.lblDate.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    
    NSDateFormatter *dateFormater1 = [[NSDateFormatter alloc] init];
    [dateFormater1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *dtStartDate = [dateFormater1 dateFromString:self.sessionData.strStartDate];
    [dateFormater1 setDateFormat:@"EEEE, dd MMM."];
    //self.lblLocation.text = [NSString stringWithFormat:@"%@",[dateFormater1 stringFromDate:dtStartDate]];

    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"HH:mm:ss"];
    NSDate *dtStartTime = [dateFormater dateFromString:self.sessionData.strStartTime];
    NSDate *dtEndTime = [dateFormater dateFromString:self.sessionData.strEndTime];
    
    [dateFormater setDateFormat:@"hh:mm a"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
    strTime = [strTime stringByAppendingString:@" - "];
    strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
    self.lblTiming.text = strTime;
    
    [dateFormater setDateFormat:@"HH:mm"];
    strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
    strTime = [strTime stringByAppendingString:@" - "];
    strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
    self.lblLocation.text = [NSString stringWithFormat:@"%@ %@",[dateFormater1 stringFromDate:dtStartDate],strTime];
    
    self.arrSessionSpeakers = self.sessionData.arrSpeakers;
    
    if([self.arrSessionSpeakers count] == 0)
    {
        self.colSpeaker.hidden = YES;
    }
    
    self.arrSessionResources = self.sessionData.arrResources;

    [[self lblNoItemsFound] setHidden:YES];
    if([self.arrSessionResources count] == 0)
    {
        [[self lblNoItemsFound] setHidden:NO];
        [[self colSessionResources] setHidden:YES];
    }

    SessionCategories *objSessionsCategories;
    NSString *strSessionsCategories = @"";
    for(objSessionsCategories in self.sessionData.arrCategories)
    {
        if([NSString IsEmpty:strSessionsCategories shouldCleanWhiteSpace:YES])
        {
            strSessionsCategories = [strSessionsCategories stringByAppendingFormat:@"Categories: %@",objSessionsCategories.strCategoryName];
        }
        else
        {
            strSessionsCategories = [strSessionsCategories stringByAppendingFormat:@", %@",objSessionsCategories.strCategoryName];
        }
    }
    
    if(strSessionsCategories.length > 0)
    {
        if ([self.lblSessionCategories respondsToSelector:@selector(setAttributedText:)])
        {
            UIFont *boldFont = [UIFont fontWithName:@"SegoeWP-Bold" size:self.lblSessionCategories.font.pointSize];
            UIFont *regularFont = [UIFont fontWithName:@"SegoeWP" size:self.lblSessionCategories.font.pointSize];
            
            // Create the attributes
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   boldFont, NSFontAttributeName, nil];
            NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      regularFont, NSFontAttributeName, nil];

            const NSRange range = NSMakeRange(0,10);
            
            // Create the attributed string (text + attributes)
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:strSessionsCategories attributes:subAttrs];
            [attributedText setAttributes:attrs range:range];
            
            // Set it in our UILabel and we are done!
            [self.lblSessionCategories setAttributedText:attributedText];
        }
        else
        {
            self.lblSessionCategories.text = strSessionsCategories;        
        }
    }
    self.lblSessionCategories.numberOfLines = 0;
    [self.lblSessionCategories sizeToFit];
    
    self.lblAbstract.text = self.sessionData.strSessionAbstract;
    
    self.lblAbstract.numberOfLines = 0;
    [self.lblAbstract sizeToFit];
    
    //UIFont *ft=[UIFont fontWithName:@"SegoeWP" size:14.0f];
    
    //CGSize expectedLabelSize = [self.sessionData.strSessionAbstract sizeWithFont:ft
    //                            constrainedToSize:CGSizeMake((self.lblAbstract.frame.size.width - 10)  ,1000)
    //                            lineBreakMode:NSLineBreakByWordWrapping];
    
    //self.lblAbstract.scrollEnabled = NO;
    //self.lblAbstract.frame = CGRectMake(self.lblAbstract.frame.origin.x, (self.lblAbstract.frame.origin.y + self.lblSessionCategories.frame.size.height + 10), self.lblAbstract.frame.size.width, expectedLabelSize.height);
    
  //New Addeed Code
    
    if([self.sessionData.arrVideos count]==0)
    {
        
        self.videodescLbl.hidden=NO;
        // self.videodescLbl.text=@"video for this session not available";
    }
    
    
    
    
    
    self.lblAbstract.frame = CGRectMake(self.lblAbstract.frame.origin.x, (self.lblAbstract.frame.origin.y + self.lblSessionCategories.frame.size.height + 10), self.lblAbstract.frame.size.width, self.lblAbstract.frame.size.height);
    
    self.btnTakeNotes.frame = CGRectMake(self.btnTakeNotes.frame.origin.x, (self.lblAbstract.frame.origin.y + self.lblAbstract.frame.size.height + 10), self.btnTakeNotes.frame.size.width, self.btnTakeNotes.frame.size.height);
    self.btnViewNotes.frame = CGRectMake(self.btnViewNotes.frame.origin.x, (self.lblAbstract.frame.origin.y + self.lblAbstract.frame.size.height + 10), self.btnViewNotes.frame.size.width, self.btnViewNotes.frame.size.height);

    self.btnEvaluation.frame = CGRectMake(self.btnEvaluation.frame.origin.x, (self.btnTakeNotes.frame.origin.y + self.btnTakeNotes.frame.size.height + 10), self.btnEvaluation.frame.size.width, self.btnEvaluation.frame.size.height);
    
    self.btnSessionQA.frame = CGRectMake(self.btnEvaluation.frame.origin.x, (self.btnEvaluation.frame.origin.y + self.btnEvaluation.frame.size.height + 10), self.btnSessionQA.frame.size.width, self.btnSessionQA.frame.size.height);

    self.vwAddToMySchedule.frame = CGRectMake(self.vwAddToMySchedule.frame.origin.x, (self.lblAbstract.frame.origin.y + self.lblAbstract.frame.size.height + 10), self.vwAddToMySchedule.frame.size.width, self.vwAddToMySchedule.frame.size.height);
    self.vwRemoveFromMySchedule.frame = CGRectMake(self.vwAddToMySchedule.frame.origin.x, (self.lblAbstract.frame.origin.y + self.lblAbstract.frame.size.height + 10), self.vwRemoveFromMySchedule.frame.size.width, self.vwRemoveFromMySchedule.frame.size.height);
    
    self.vwAddToMyCalendar.frame = CGRectMake(self.vwAddToMySchedule.frame.origin.x, (self.vwAddToMySchedule.frame.origin.y + self.vwAddToMySchedule.frame.size.height + 10), self.vwAddToMyCalendar.frame.size.width, self.vwAddToMyCalendar.frame.size.height);
    self.vwRemoveFromMyCalendar.frame = CGRectMake(self.vwAddToMySchedule.frame.origin.x, (self.vwAddToMySchedule.frame.origin.y + self.vwAddToMySchedule.frame.size.height + 10), self.vwRemoveFromMyCalendar.frame.size.width, self.vwRemoveFromMyCalendar.frame.size.height);
    
//    self.vwSocialMedia.frame = CGRectMake(20, (self.vwRemoveFromMyCalendar.frame.origin.y + self.vwRemoveFromMyCalendar.frame.size.height + 10), self.vwSocialMedia.frame.size.width, self.vwSocialMedia.frame.size.height);
//    
    self.vwSocialMedia.frame = CGRectMake(20, (self.btnSessionQA.frame.origin.y + self.btnSessionQA.frame.size.height + 45), self.vwSocialMedia.frame.size.width, self.vwSocialMedia.frame.size.height);


    self.vwSessionOverview.frame = CGRectMake(0, 0, 320, (self.vwSocialMedia.frame.origin.y + self.vwSocialMedia.frame.size.height + 10));
    [self.svwSessionOverview setContentSize:CGSizeMake(320, (self.vwSocialMedia.frame.origin.y + self.vwSocialMedia.frame.size.height + 10))];
}

-(void)viewDidLayoutSubviews
{
    //[self.svwSessionDetail setContentSize:CGSizeMake(320*5, self.svwSessionDetail.frame.size.height)];
    [self.svwSessionDetail setContentSize:CGSizeMake(320*6, 460)];
    
    //if ([DeviceManager IsiPad])
    //{
    //    [self.svwSessionDetail setContentSize:CGSizeMake(330, self.svwSessionDetail.frame.size.height)];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)AddToMySchedule:(id)sender
{
    if (APP.netStatus)
    {
        User *objUser = [User GetInstance];
        
        NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:strAPI_SESSION_ADD_MY_SESSION_LIST];
        
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
        
        [objRequest addValue:self.sessionData.strSessionInstanceID forHTTPHeaderField:@"SessionInstanceId"];
        [objRequest addValue:@"false" forHTTPHeaderField:@"IsScheduleRemoved"];
        
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_MY_SESSION_LIST];
        
    }
    else
    {
        BOOL blnResult = NO;
        
        MySessionDB *objMySessionDB = [MySessionDB GetInstance];
        blnResult = [objMySessionDB AddSession:self.sessionData.strSessionInstanceID];
    }
    
}

- (IBAction)RemoveFromMySchedule:(id)sender
{
    
    UIAlertView *confirm = [[UIAlertView alloc]
                            initWithTitle:nil
                            message:@"Do you really want to remove this session from you r schedule?"
                            delegate:self
                            cancelButtonTitle:@"Yes"
                            otherButtonTitles:@"No", nil];
    
    confirm.tag = 1;
    [confirm show];
}

- (void)RemoveFromMySchedule
{
    if (APP.netStatus)
    {
        User *objUser = [User GetInstance];
        
        NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:strAPI_SESSION_ADD_MY_SESSION_LIST];
        
        
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
        
        [objRequest addValue:self.sessionData.strSessionInstanceID forHTTPHeaderField:@"SessionInstanceId"];
        [objRequest addValue:@"true" forHTTPHeaderField:@"IsScheduleRemoved"];
        
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_REMOVE_MY_SESSION_LIST];
        
    }
    else
    {
        BOOL blnResult = NO;
        
        MySessionDB *objMySessionDB = [MySessionDB GetInstance];
        blnResult = [objMySessionDB DeleteSession:self.sessionData.strSessionInstanceID];
    }
    
    //    self.vwAddToMySchedule.hidden = NO;
    //    self.vwRemoveFromMySchedule.hidden = YES;
    //
    //    [self showAlert:nil withMessage:@"Session has been removed from your schedule." withButton:@"OK" withIcon:nil];
    
    
    
    
    //    User *objUser = [User GetInstance];
    //
    //    NSString *strURL = strAPI_URL;
    //    strURL = [strURL stringByAppendingString:strAPI_SESSION_ADD_MY_SESSION_LIST];
    //
    //    NSURL *URL = [NSURL URLWithString:strURL];
    //
    //    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    //    [objRequest setHTTPMethod:@"POST"];
    //    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //
    //    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    //    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    //    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    //
    //    [objRequest addValue:self.sessionData.strSessionInstanceID forHTTPHeaderField:@"SessionInstanceId"];
    //    [objRequest addValue:@"true" forHTTPHeaderField:@"IsScheduleRemoved"];
    //
    //    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_REMOVE_MY_SESSION_LIST];
}

/*
 - (IBAction)AddToMyCalendar:(id)sender
 {
 EKEventStore *store = [[EKEventStore alloc] init];
 [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL blnGranted, NSError *error)
 {
 if(!blnGranted)
 {
 return;
 }
 
 EKEvent *event = [EKEvent eventWithEventStore:store];
 event.title = self.sessionData.strSessionTitle;
 
 NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
 [dateFormater setDateFormat:@"yyyy-MM-dd"];
 NSDate *dtStartDate = [dateFormater dateFromString:self.sessionData.strStartDate];
 event.startDate = dtStartDate;
 event.endDate = dtStartDate;
 
 [event setCalendar:[store defaultCalendarForNewEvents]];
 
 NSError *err = nil;
 [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
 
 if(error == nil)
 {
 NSString *strEventID = event.eventIdentifier;
 NSLog(@"Added - Event ID: %@",strEventID);
 
 self.vwAddToMyCalendar.hidden = YES;
 self.vwRemoveFromMyCalendar.hidden = NO;
 }
 else
 {
 self.vwAddToMyCalendar.hidden = NO;
 self.vwRemoveFromMyCalendar.hidden = YES;
 }
 }];
 }
 
 - (IBAction)RemoveFromMyCalendar:(id)sender
 {
 EKEventStore* store = [[EKEventStore alloc] init];
 [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
 {
 if(!granted)
 {
 return;
 }
 
 [self GetEventID];
 EKEvent *event = [store eventWithIdentifier:self.strEventID];
 
 if(event)
 {
 NSError* error = nil;
 [store removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
 
 if(error == nil)
 {
 
 NSLog(@"Removed - Event ID: %@",self.strEventID);
 
 self.vwAddToMyCalendar.hidden = NO;
 self.vwRemoveFromMyCalendar.hidden = YES;
 }
 }
 }];
 }
 
 - (void)GetEventID
 {
 EKEventStore* store = [[EKEventStore alloc] init];
 
 [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
 {
 if(!granted)
 {
 return;
 }
 
 //NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
 //[dateFormater setDateFormat:@"yyyy-MM-dd"];
 //NSDate *dtStartDate = [dateFormater dateFromString:self.sessionData.strStartDate];
 
 //Create the predicate. Pass it the default calendar.
 NSArray *arrCalendar = [NSArray arrayWithObject:[store defaultCalendarForNewEvents]];
 //NSPredicate *predicate = [store predicateForEventsWithStartDate:dtStartDate endDate:dtStartDate calendars:arrCalendar];
 NSPredicate *predicate = [store predicateForEventsWithStartDate:[NSDate distantPast] endDate:[NSDate distantFuture] calendars:arrCalendar];
 
 //Fetch all events that match the predicate.
 NSArray *arrEvents = [store eventsMatchingPredicate:predicate];
 
 self.vwAddToMyCalendar.hidden = NO;
 self.vwRemoveFromMyCalendar.hidden = YES;
 
 for (NSUInteger i = 0; i < [arrEvents count]; i++)
 {
 if([[[arrEvents objectAtIndex:i] title] isEqualToString:self.sessionData.strSessionTitle])
 {
 self.strEventID = [[arrEvents objectAtIndex:i] eventIdentifier];
 self.vwAddToMyCalendar.hidden = YES;
 self.vwRemoveFromMyCalendar.hidden = NO;
 }
 }
 }];
 }
 */

- (IBAction)AddToMyCalendar:(id)sender
{
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL blnGranted, NSError *error)
     {
         if(!blnGranted)
         {
             return;
         }
         
         EKEvent *event = [EKEvent eventWithEventStore:self.store];
         event.title = self.sessionData.strSessionTitle;
         
         NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
         [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSDate *dtStartDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",self.sessionData.strStartDate,self.sessionData.strStartTime]];
         NSDate *dtendDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",self.sessionData.strStartDate,self.sessionData.strEndTime]];
         event.startDate = dtStartDate;
         event.endDate = dtendDate;
         
         [event setCalendar:[self.store defaultCalendarForNewEvents]];
         
         NSError *err = nil;
         [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
         
         if(error == nil)
         {
             //NSString *strEventID = event.eventIdentifier;
             self.strEventID = event.eventIdentifier;
             NSLog(@"Added - Event ID: %@",self.strEventID);
             
             dispatch_async(dispatch_get_main_queue(), ^
                {
                    self.vwAddToMyCalendar.hidden = YES;
                    self.vwRemoveFromMyCalendar.hidden = NO;

                    [self showAlert:nil withMessage:@"This session has been successfully added in your calendar." withButton:@"OK" withIcon:nil];
                });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^
                {
                    self.vwAddToMyCalendar.hidden = NO;
                    self.vwRemoveFromMyCalendar.hidden = YES;
                });
         }
     }];
}

- (IBAction)RemoveFromMyCalendar:(id)sender
{
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if(!granted)
         {
             return;
         }
         
         //[self GetEventID];
         EKEvent *event = [self.store eventWithIdentifier:self.strEventID];
         
         if(event)
         {
             NSError* error = nil;
             [self.store removeEvent:event span:EKSpanThisEvent commit:YES error:&error];
             
             if(error == nil)
             {
                 
                 NSLog(@"Removed - Event ID: %@",self.strEventID);
                 dispatch_async(dispatch_get_main_queue(), ^
                    {
                        self.vwAddToMyCalendar.hidden = NO;
                        self.vwRemoveFromMyCalendar.hidden = YES;
                        
                        [self showAlert:nil withMessage:@"This session has been removed from your calendar." withButton:@"OK" withIcon:nil];
                    });
             }
         }
     }];
}

- (void)GetEventID
{
    self.vwAddToMyCalendar.hidden = YES;
    self.vwRemoveFromMyCalendar.hidden = YES;
    
    if (self.store ==nil)
    {
        self.store = [[EKEventStore alloc] init];
    }

    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if(!granted)
         {
             NSLog(@"No access granted");
             return;
         }
         
         NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
         [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSDate *dtStartDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",self.sessionData.strStartDate,self.sessionData.strStartTime]];
         NSDate *dtendDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",self.sessionData.strStartDate,self.sessionData.strEndTime]];
            
         NSPredicate *predicate = [self.store predicateForEventsWithStartDate:dtStartDate endDate:dtendDate calendars:nil];

         NSArray *arrEvents = [self.store eventsMatchingPredicate:predicate];
         
         BOOL iSFound=NO;
         
         for (NSUInteger i = 0; i < [arrEvents count]; i++)
         {
             if([[[arrEvents objectAtIndex:i] title] isEqualToString:self.sessionData.strSessionTitle])
             {
                 NSLog(@"Finding data");
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    self.strEventID = [[arrEvents objectAtIndex:i] eventIdentifier];
                                    self.vwAddToMyCalendar.hidden = YES;
                                    self.vwRemoveFromMyCalendar.hidden = NO;
                                    
                                });
                 iSFound=YES;
                 break;
             }
         }
         if(!iSFound){
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                self.vwAddToMyCalendar.hidden = NO;
                                self.vwRemoveFromMyCalendar.hidden = YES;
                                
                            });
             
         }
     }];
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
#pragma mark -

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (view.tag == 100) // For Video Section
    {
        return [self.sessionData.arrVideos count];
    }
    else if (view.tag > 0)
    {
        return [self.arrTweets count];
    }
    else
    {
        if (view==self.colSpeaker)
        {
            return [self.sessionData.arrSpeakers count];
        }
        else{
            return [self.arrSessionResources count];
        }
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (cv.tag == 100) // For Video Section
    {
        SessionResourceCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
        SessionVideos *objSessionVideos = [self.sessionData.arrVideos objectAtIndex:indexPath.row];
        if (objSessionVideos.strVideoTitle)
        {
            cell.lblDocTitle.text = objSessionVideos.strVideoTitle;
        }
        else
        {
            cell.lblDocTitle.text = objSessionVideos.strVideoURL;
        }
        
        return cell;
    }
    else if (cv.tag > 0) {
        TwitterFeedCustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
        NSDictionary *objTweet = [self.arrTweets objectAtIndex:indexPath.row];
        //NSLog(@"%@",[aTweet objectForKey:@"created_at"]);
        //Mon Oct 21 14:55:50 +0000 2013
        cell.lblTitle.text = [objTweet objectForKey:@"name"];
        cell.txtDescription.text = [objTweet objectForKey:@"text"];
        CGRect rect      = cell.txtDescription.frame;
        rect.size.height = cell.txtDescription.contentSize.height;
        cell.txtDescription.frame   = rect;
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"EEE MMM dd HH:mm:ss +zzzz YYYY"];
        NSDate *dtStartDate = [dateFormater dateFromString:[objTweet objectForKey:@"created_at"]];
        [dateFormater setDateFormat:@"EEEE, dd MMM. HH:mm a"];
        cell.lblDatetime.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
        
        
        //cell.lblDatetime.text = [aTweet objectForKey:@"created_at"];
        cell.lblDatetime.frame = CGRectMake(cell.lblDatetime.frame.origin.x, (cell.txtDescription.frame.origin.y + cell.txtDescription.frame.size.height), 232, 21);
        cell.vwLine.frame = CGRectMake(0, (cell.lblDatetime.frame.origin.y + 30), 300, 1);
        //if ([DeviceManager IsiPhone]) {
        
        //}
        NSURL *imgURL = [NSURL URLWithString:[objTweet objectForKey:@"profile_image_url"]];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                   NSData *data,
                                                                                                                   NSError *error){
            if (!error) {
                cell.imgLogo.image = [UIImage imageWithData:data];
            }
        }];
        
        //[UIView addTouchEffect:cell.contentView];
        
        return cell;
    }
    else{
        UICollectionViewCell *cell;
        
        if (cv==self.colSpeaker)
        {
            if([self.arrSessionSpeakers count] > 0)
            {
                //return [self.sessionData.arrSpeakers count];
                cell = [cv dequeueReusableCellWithReuseIdentifier:@"TSpeakerCell" forIndexPath:indexPath];
                //CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
                Speaker *objSpeaker = [[self.sessionData.arrSpeakers objectAtIndex:indexPath.row] objectAtIndex:0];
                
                ((CustomCollectionViewCell *)cell).lblName.text = [NSString stringWithFormat:@"%@ %@",objSpeaker.strFirstName,objSpeaker.strLastName];
                ((CustomCollectionViewCell *)cell).lblTitle.text = objSpeaker.strTitle;
                ((CustomCollectionViewCell *)cell).lblCompany.text = objSpeaker.strCompany;
                ((CustomCollectionViewCell *)cell).cellData = objSpeaker;
                
                ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageNamed:@"normal.png"];
                if(![NSString IsEmpty:objSpeaker.strSpeakerPhoto shouldCleanWhiteSpace:YES])
                {
                    NSURL *imgURL = [NSURL URLWithString:objSpeaker.strSpeakerPhoto];
                    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
                    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                               NSData *data,
                                                                                                                               NSError *error){
                        if (!error)
                        {
                            ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageWithData:data];
                            ((CustomCollectionViewCell *)cell).imgLogo.contentMode = UIViewContentModeScaleAspectFit;
                        }
                    }];
                }
            }
        }
        else
        {
            cell = [cv dequeueReusableCellWithReuseIdentifier:@"SessionResourceCell" forIndexPath:indexPath];
            
            if([self.arrSessionResources count] > 0)
            {
                SessionResources *objSessionResources = [self.arrSessionResources objectAtIndex:indexPath.row];
                
                ((SessionResourceCell *)cell).lblDocTitle.text = [objSessionResources strFileName];
                ((SessionResourceCell *)cell).btnOpenFile.tag = indexPath.row;
                
                NSArray *arrDocComponents = [[objSessionResources strFileName] componentsSeparatedByString:@"."];
                NSString *strDocType = [arrDocComponents objectAtIndex:[arrDocComponents count] - 1];
                strDocType = [strDocType uppercaseString];
                
                //if([objSessionResources.strDocType isEqualToString:strDOC_TYPE_PDF])
                if([strDocType isEqualToString:strDOC_TYPE_PDF])
                {
                    NSString *strDocType = [[NSBundle mainBundle] pathForResource:strDOC_TYPE_PDF_IMG ofType:@"png"];
                    UIImage *imgDocType = [UIImage imageWithContentsOfFile:strDocType];
                    
                    [((SessionResourceCell *)cell).imgDocType setImage:imgDocType];
                }
                
                if([strDocType isEqualToString:strDOC_TYPE_DOC] | [strDocType isEqualToString:strDOC_TYPE_DOCX])
                {
                    NSString *strDocType = [[NSBundle mainBundle] pathForResource:strDOC_TYPE_DOC_IMG ofType:@"png"];
                    UIImage *imgDocType = [UIImage imageWithContentsOfFile:strDocType];
                    
                    [((SessionResourceCell *)cell).imgDocType setImage:imgDocType];
                }
                
                if([strDocType isEqualToString:strDOC_TYPE_XLS] | [strDocType isEqualToString:strDOC_TYPE_XLSX])
                {
                    NSString *strDocType = [[NSBundle mainBundle] pathForResource:strDOC_TYPE_XLS_IMG ofType:@"png"];
                    UIImage *imgDocType = [UIImage imageWithContentsOfFile:strDocType];
                    
                    [((SessionResourceCell *)cell).imgDocType setImage:imgDocType];
                }
                
                if([strDocType isEqualToString:strDOC_TYPE_PPT] | [strDocType isEqualToString:strDOC_TYPE_PPTX])
                {
                    NSString *strDocType = [[NSBundle mainBundle] pathForResource:strDOC_TYPE_PPT_IMG ofType:@"png"];
                    UIImage *imgDocType = [UIImage imageWithContentsOfFile:strDocType];
                    
                    [((SessionResourceCell *)cell).imgDocType setImage:imgDocType];
                }
            }
        }
        
        //[UIView addTouchEffect:cell.contentView];
        
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (collectionView.tag == 100)
    {
//        SessionVideos *objSessionVideos = [self.sessionData.arrVideos objectAtIndex:indexPath.row];
//        MPMoviePlayerViewController *objMoviePlalyer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:objSessionVideos.strVideoURL]];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(moviePlaybackDidFinish:)
//                                                     name:MPMoviePlayerPlaybackDidFinishNotification
//                                                   object:nil];
//        
//        objMoviePlalyer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//        objMoviePlalyer.moviePlayer.controlStyle   = MPMovieControlStyleDefault;
//        objMoviePlalyer.moviePlayer.shouldAutoplay = YES;
//        
//        [self presentMoviePlayerViewControllerAnimated:objMoviePlalyer];
        
        
        // Newly Added Code
        
        SessionVideos *objSessionVideos = [self.sessionData.arrVideos objectAtIndex:indexPath.row];
        
        objMoviePlalyer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:objSessionVideos.strVideoURL]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        
        objMoviePlalyer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        objMoviePlalyer.moviePlayer.controlStyle   = MPMovieControlStyleDefault;
        objMoviePlalyer.moviePlayer.shouldAutoplay = YES;
        
        [objMoviePlalyer.moviePlayer setContentURL:[NSURL URLWithString:objSessionVideos.strVideoURL]];
        
        [self presentMoviePlayerViewControllerAnimated:objMoviePlalyer];
        
    }
    else if (collectionView.tag > 0) {
        
    }
    else{
        if (collectionView==self.colSpeaker)
        {
            //idSpeakerDetail
            SpeakerDetailViewController *vsSpeakerDetail;
            
            if([DeviceManager IsiPad] == YES)
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
                vsSpeakerDetail = [storyboard instantiateViewControllerWithIdentifier:@"idSpeakerDetail"];
            }
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
                vsSpeakerDetail = [storyboard instantiateViewControllerWithIdentifier:@"idSpeakerDetail"];
            }

            vsSpeakerDetail.speakerData = [[self.arrSessionSpeakers objectAtIndex:indexPath.row] objectAtIndex:0];
            [[self navigationController] pushViewController:vsSpeakerDetail animated:YES];
        }
        else
        {
            SessionResources *objSessionResources = [self.arrSessionResources objectAtIndex:indexPath.row];
            [Functions OpenWebsite:objSessionResources.strURL];
        }
    }
    
}

- (void) moviePlaybackDidFinish:(NSNotification*)notification
{
    NSLog(@"playback finished...");
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        NSLog(@"Reason: movie finished playing");
    }else if (reason == MPMovieFinishReasonUserExited) {
        NSLog(@"Reason: user hit done button");
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        NSLog(@"Reason: error");
    }
    
    
}

#pragma maek -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
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
    
    switch (intTag)
    {
        case OPER_ADD_MY_SESSION_LIST:
        {
            if ([strData isEqualToString:@"true"])
            {
                MySessionDB *objMySessionDB = [MySessionDB GetInstance];
                MySession *objMySession = [[MySession alloc] init];
                
                objMySession.strSessionInstanceID = self.sessionData.strSessionInstanceID;
                [objMySessionDB AddMySession:objMySession isSynced:TRUE];
                
                
            }
            else
            {
                MySessionDB *objMySessionDB = [MySessionDB GetInstance];
                MySession *objMySession = [[MySession alloc] init];
                
                objMySession.strSessionInstanceID = self.sessionData.strSessionInstanceID;
                [objMySessionDB AddMySession:objMySession isSynced:FALSE];
            }
            
            self.vwAddToMySchedule.hidden = YES;
            self.vwRemoveFromMySchedule.hidden = NO;
            
            [self showAlert:nil withMessage:@"Session added to your schedule." withButton:@"OK" withIcon:nil];
            
            
        }
            break;
        case OPER_REMOVE_MY_SESSION_LIST:
        {
            if ([strData isEqualToString:@"true"])
            {
                MySessionDB *objMySessionDB = [MySessionDB GetInstance];
                [objMySessionDB UpdateMySession:self.sessionData.strSessionInstanceID isSynced:TRUE];
            }
            else
            {
                MySessionDB *objMySessionDB = [MySessionDB GetInstance];
                [objMySessionDB UpdateMySession:self.sessionData.strSessionInstanceID isSynced:FALSE];
            }
            self.vwAddToMySchedule.hidden = NO;
            self.vwRemoveFromMySchedule.hidden = YES;
            
            [self showAlert:nil withMessage:@"Session has been removed from your schedule." withButton:@"OK" withIcon:nil];
            
        }
            break;
        default:
            break;
    }
}
#pragma mark -

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"SendQuestion"]) {
        // perform your computation to determine whether segue should occur
        if([self.arrSessionSpeakers count] == 0){
            
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Alert"
                                         message:@"Speakers not available"
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    
   
    if([identifier isEqualToString:@"loadEvaluation2"])
    {
        //Shared *objShared = [Shared GetInstance];
        
        if (!APP.netStatus) {
            NETWORK_ALERT();
            return NO;
        }
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoNotes"])
    {
        NotesViewController *controller = segue.destinationViewController;
        controller.sessionData = self.sessionData;
        controller.strSessionInstanceID = self.sessionData.strSessionInstanceID;
    }
    if([segue.identifier isEqualToString:@"gotoAddNote"])
    {
       // SessionNoteViewController *controller = segue.destinationViewController;
       // controller.sessionData = self.sessionData;
       // controller.strSessionInstanceID = self.sessionData.strSessionInstanceID;
       // controller.blnNew = YES;
        
        self.objSessionNoteViewController = [[SessionNoteViewController alloc] init];
        self.objSessionNoteViewController = segue.destinationViewController;
        self.objSessionNoteViewController.sessionData = self.sessionData;
        self.objSessionNoteViewController.strSessionInstanceID = self.sessionData.strSessionInstanceID;
        self.objSessionNoteViewController.blnNew = YES;
        self.objSessionNoteViewController.delegate = self;
    }
    
    else if ([segue.identifier isEqualToString:@"loadEvaluation2"])
    {
        //Shared *objShared = [Shared GetInstance];
        
        if (!APP.netStatus) {
            NETWORK_ALERT();
            return;
        }
        
       
        EvaluationViewController *controller = segue.destinationViewController;
        controller.sessionid = self.sessionData.strSessionInstanceID;
    }
    if([segue.identifier isEqualToString:@"SendQuestion"])
    {

        
        SessionQAViewController *objSessionQAViewController = segue.destinationViewController;
        objSessionQAViewController.sessionData = self.sessionData;
 
        
    }

}


- (void) populateTwitterData
{
    [[self vwLoadingFeeds] setHidden:NO];
    [[self avLoadingFeeds] startAnimating];
    
    // Request access to the Twitter accounts
    //Help:https://dev.twitter.com/docs/api/1.1/get/search/tweets
    
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
                            
                            [[self vwLoadingFeeds] setHidden:YES];
                            [[self avLoadingFeeds] stopAnimating];
                            
                            return;
                        }
                        
                        // Check if there was an error
                        if (error)
                        {
                            NSLog(@"Error: %@", error.localizedDescription);
                            
                            [[self lblNoFeeds] setHidden:NO];
                            
                            [[self vwLoadingFeeds] setHidden:YES];
                            [[self avLoadingFeeds] stopAnimating];
                            
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
                            
                            [[self vwLoadingFeeds] setHidden:YES];
                            [[self avLoadingFeeds] stopAnimating];
                            
                            [self.colTwitterFeeds reloadData];
                        }
                        else
                        {
                            NSLog(@"%@",error);
                            
                            [[self lblNoFeeds] setHidden:NO];
                            
                            [[self vwLoadingFeeds] setHidden:YES];
                            [[self avLoadingFeeds] stopAnimating];
                        }
                        //End
                    });
                }];
            }
        }
        else
        {
            NSLog(@"No access granted");
            
            [[self lblNoFeeds] setHidden:NO];
            
            [[self vwLoadingFeeds] setHidden:YES];
            [[self avLoadingFeeds] stopAnimating];
        }
    }];
}

- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *objTweet = [self.arrTweets objectAtIndex:indexPath.row];
    
    self.textView.text = [objTweet objectForKey:@"text"];
    CGRect rect      = self.textView.frame;
    rect.size.height = self.textView.contentSize.height;
    self.textView.frame   = rect;
    
    if ([DeviceManager IsiPad])
    {
        //CGSize cellSize = (CGSize) { .width = 600, .height = 250};
        CGSize cellSize = (CGSize) { .width = 300, .height = (self.textView.frame.size.height+self.textView.frame.origin.y+35)};
        return cellSize;
    }
    else
    {
        CGSize cellSize = (CGSize) { .width = 300, .height = (self.textView.frame.size.height+self.textView.frame.origin.y+35)};
        return cellSize;
    }
    
}



- (IBAction)btnSocialMediaClicked:(id)sender {
       // Shared *objShared = [Shared GetInstance];
        
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    UIStoryboard *storyboard;
    if([DeviceManager IsiPad] == YES)
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
    }
    
    if (sender == self.btnTwitter) {
        TwitterViewController *vcTwitter = [storyboard instantiateViewControllerWithIdentifier:@"idTwitter"];
        [[self navigationController] pushViewController:vcTwitter animated:YES];
    }
    else if(sender == self.btnFacebook){
        FacebookViewController *vcFacebook = [storyboard instantiateViewControllerWithIdentifier:@"idFacebook"];
        [[self navigationController] pushViewController:vcFacebook animated:YES];
    }
    else if(sender == self.btnLinkedIn){
        LinkedInViewController *vcLinkedIn = [storyboard instantiateViewControllerWithIdentifier:@"idLinkedIn"];
        [[self navigationController] pushViewController:vcLinkedIn animated:YES];
    }
}



- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    LargeView *vcLargeView;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];
    }
    
    vcLargeView.imgSource = self.imgLocation.image;
    [[self navigationController] pushViewController:vcLargeView animated:YES];
}

#pragma mark Alert Events
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 1)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            [self RemoveFromMySchedule];
        }
            break;
        case 1:
        {
            //Do Nothing
        }
            break;
        default:
            break;
    }
}
#pragma mark  -

- (void)noteSaved
{
    self.btnTakeNotes.hidden = YES;
    self.btnViewNotes.hidden = NO;
}

@end
