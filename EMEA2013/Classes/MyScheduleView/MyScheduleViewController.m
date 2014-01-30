//
//  MyScheduleViewController.m
//  mgx2013
//
//  Created by Amit Karande on 07/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//


#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 2.0


#import "MyScheduleViewController.h"
#import "SessionDetailViewController.h"
#import "MySheduleCustomCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "DeviceManager.h"
#import "SessionDB.h"
#import "MySessionDB.h"
#import "Speaker.h"
#import "User.h"
#import "DB.h"
#import "Rooms.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "SessionNoteViewController.h"
#import "NotesViewController.h"
#import "Constants.h"
#import "Shared.h"
#import "AppDelegate.h"


@interface MyScheduleViewController ()
{
    @private
    id objSender;
    NSUInteger intDateRow;
    
    NSArray *arrSessionsiPad;
}

@property (nonatomic,readwrite) EKEventStore *store;
@end

@implementation MyScheduleViewController
#pragma mark Synthesize
@synthesize objConnection, objData;
#pragma mark -

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
    
    [[[self btnRefresh] layer] setBorderWidth:2.0f];
    [[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnAddToMyCalendar] layer] setBorderWidth:2.0f];
    [[[self btnAddToMyCalendar] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnAddToMyCalendar] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnAddToMyCalendar] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_MY_SCHEDULE];
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([DeviceManager IsiPad])
    {
        NSIndexPath *selection = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.myScheduleCollectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    MySessionDB *objMySesions = [MySessionDB GetInstance];
    self.arrSessions = [objMySesions GetMySessionsAndGrouped:YES];
    
//    if([[self arrSessions] count] == 0)
//    {
//        [self SyncMySessions];
//    }
//    else
//    {
        [[self myScheduleCollectionView] reloadData];
//    }
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

-(void)viewDidLayoutSubviews
{
    //if ([DeviceManager IsiPad])
    //{
    //    self.sessionCollectionView.frame = [self collectionViewContentSize];
    //
    //    [self.svwMySchedule setContentSize:CGSizeMake(self.sessionCollectionView.frame.origin.x+[self collectionViewContentSize].size.width, self.sessionCollectionView.frame.size.height)];
    //    //[self.svwSpeakerDetail setContentSize:CGSizeMake(1536, self.svwSpeakerDetail.frame.size.height)];
    //}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MySessionDB *objMySesions = [MySessionDB GetInstance];
    self.arrSessions = [objMySesions GetMySessionsAndGrouped:YES];
    
    if([[self arrSessions] count] == 0)
    {
    }
    else
    {
        [[self myScheduleCollectionView] reloadData];
    }
    
    if ([segue.identifier isEqualToString:@"loadSessionDetail3"] || [segue.identifier isEqualToString:@"loadSessionDetail7"])
    {
        NSInteger tagselected;
        
        //UIButton *btnDetail = (UIButton *)sender;
        SessionDetailViewController *controller = segue.destinationViewController;
        
        if ([sender isKindOfClass:[UIButton class]])
        {
            UIButton *btnDetail = (UIButton *)sender;
            tagselected = btnDetail.tag;
        }
        else
        {
            tagselected = ((CustomCollectionViewCell *)sender).tag;
        }
        
        controller.intTag = tagselected;
        controller.sessionData = [[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:tagselected];
        //controller.sessionData = [[self.arrSessions objectAtIndex:tagselected] objectAtIndex:0];
    }
    else if ([segue.identifier isEqualToString:@"gotoAddNote"])
    {
        UIButton *btnNote = (UIButton *)sender;
        Session *objSession = [[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:btnNote.tag];
        
        SessionNoteViewController *controller = segue.destinationViewController;
        controller.sessionData = objSession;
        controller.strSessionInstanceID = objSession.strSessionInstanceID;
        controller.blnNew = YES;
    }
    else if ([segue.identifier isEqualToString:@"gotoNotes"])
    {
        UIButton *btnNote = (UIButton *)sender;
        Session *objSession = [[[self.arrSessions objectAtIndex:intDateRow] objectAtIndex:1] objectAtIndex:btnNote.tag];
        
        NotesViewController *controller = segue.destinationViewController;
        controller.sessionData = objSession;
        controller.strSessionInstanceID = objSession.strSessionInstanceID;
    }
}

- (void)SyncMySessions
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_MY_SESSION_LIST];
    
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
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_MY_SCHEDULE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_MY_SESSION_LIST];
}

- (void)SetMySessions
{
    MySessionDB *objMySessionDB = [[MySessionDB alloc] init];
    BOOL blnResult = [objMySessionDB SetMySessions:objData];
    NSLog(blnResult?@"My Sessions: YES":@"My Sessions: NO");
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

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (view.tag == 1)
    {
        if([DeviceManager IsiPhone])
        {
            if([[self arrSessions] count] > 0)
            {
                return [[[self.arrSessions objectAtIndex:self.intSelectedIndex] objectAtIndex:1] count];
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return [arrSessionsiPad count];
        }
    }
    
    return [self.arrSessions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([DeviceManager IsiPhone])
    {
        intDateRow = indexPath.row;
        //if (cv.tag == 0)
        //{
            MySheduleCustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            
            NSString *strDate = [NSString stringWithFormat:@"%@",[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:0]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *dbdate = [dateFormat dateFromString:strDate];
            [dateFormat setDateFormat:@"EE, d LLL"];
            NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
            cell.articleTitle.text = [strFormattedDate lowercaseString];
        
            [cell setTableViewDataSourceDelegate:cell arrSessionList:[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:1]];
        
            //[UIView addTouchEffect:cell.contentView];
        
            return cell;
        //}
    }
    else
    {
        //NSLog(@"%d",cv.tag);
        if (cv.tag == 0)
        {
            MySheduleCustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
            
            NSString *strDate = [NSString stringWithFormat:@"%@",[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:0]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *dbdate = [dateFormat dateFromString:strDate];
            [dateFormat setDateFormat:@"EEEE, LLLL d"];
            NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
            cell.articleTitle.text = [strFormattedDate lowercaseString];
            
            if(cell.selected)
            {
                [cell.articleImage setHidden:NO];
            }
            
            if(indexPath.row == 0)
            {
                arrSessionsiPad = [NSArray arrayWithArray:[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:1]];
                self.sessionCollectionView.dataSource = self;
                self.sessionCollectionView.delegate = self;
                
                [self.sessionCollectionView reloadData];
                
                self.sessionCollectionView.frame = [self collectionViewContentSize];
                [self.svwMySchedule setContentSize:CGSizeMake(self.sessionCollectionView.frame.origin.x+[self collectionViewContentSize].size.width, self.sessionCollectionView.frame.size.height)];
            }

            //[UIView addTouchEffect:cell.contentView];
            
            return cell;
        }
        else
        {
            //CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
            //Session *objSession = [self.arrSessions objectAtIndex:indexPath.row];
            //cell.lblTitle.text = objSession.strSessionTitle;
            //cell.lblName.text = @"";
            //cell.lblDate.text = [self formatDate:objSession.strStartDate sourceFormat:@"yyyy-MM-dd" destinationFormat:@"EEEE, LLLL d"];
            //cell.lblLocation.text = @"";
            //cell.lblCompany.text = objSession.strSessionTitle;
            //cell.lblTiming.text = [NSString stringWithFormat:@"%@ - %@",[self formatDate:objSession.strStartDate sourceFormat:@"HH:mm:ss" destinationFormat:@"HH:mm a"],[self formatDate:objSession.strStartDate sourceFormat:@"HH:mm:ss" destinationFormat:@"HH:mm a"]];
            
            //return cell;
            
            CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
            
            Session *objSession = [arrSessionsiPad objectAtIndex:indexPath.row];
            
            cell.lblTitle.text = objSession.strSessionTitle;
            cell.tag = indexPath.row;
            cell.btnDetail.tag = indexPath.row;
            
            cell.btnNote.tag = indexPath.row;
            cell.btnTakeNote.tag = indexPath.row;
            
            if([objSession.strNotesAvailable boolValue] == YES)
            {
                cell.btnTakeNote.hidden = YES;
                cell.btnNote.hidden = NO;
            }
            else
            {
                cell.btnTakeNote.hidden = NO;
                cell.btnNote.hidden = YES;
            }

            [cell.vwSessionButtons setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
            
            cell.btnRemoveFromMySchedule.hidden = ![[objSession strIsAdded] boolValue];
            cell.btnRemoveFromMySchedule.tag = indexPath.row;
            
            [cell.btnRemoveFromMySchedule addTarget:self action:@selector(RemoveFromMySchedule:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *strSpeakers = @"";
            if([objSession.arrSpeakers count] > 0)
            {
                for (NSUInteger i = 0; i < [objSession.arrSpeakers count]; i++)
                {
                    if(![NSString IsEmpty:strSpeakers shouldCleanWhiteSpace:YES])
                    {
                        strSpeakers = [strSpeakers stringByAppendingString:@", "];
                    }
                    strSpeakers = [strSpeakers stringByAppendingString:[[[objSession.arrSpeakers objectAtIndex:i] objectAtIndex:0] strFirstName]];
                    strSpeakers = [strSpeakers stringByAppendingString:@" "];
                    strSpeakers = [strSpeakers stringByAppendingString:[[[objSession.arrSpeakers objectAtIndex:i] objectAtIndex:0] strLastName]];
                }
            }
            cell.lblName.text = strSpeakers;
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *dtStartDate = [dateFormater dateFromString:objSession.strStartDate];
            [dateFormater setDateFormat:@"EEEE, dd MMM."];
            cell.lblDate.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
            
            [dateFormater setDateFormat:@"HH:mm:ss"];
            NSDate *dtStartTime = [dateFormater dateFromString:objSession.strStartTime];
            NSDate *dtEndTime = [dateFormater dateFromString:objSession.strEndTime];
            
            [dateFormater setDateFormat:@"hh:mm a"];
            NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
            strTime = [strTime stringByAppendingString:@" - "];
            strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
            cell.lblTiming.text = strTime;
            
            if ([objSession.arrRooms count] > 0){
                Rooms *objRoom = [objSession.arrRooms objectAtIndex:0];
                cell.lblRoom.text = objRoom.strRoomName;
            }
            cell.lblSessionCode.text = [NSString stringWithFormat:@"Session Code: %@",objSession.strSessionCode];
            
            //[UIView addTouchEffect:cell.contentView];
            
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([DeviceManager IsiPad])
    {
        CustomCollectionViewCell *cell;
        int count = [self.arrSessions count];
        for (NSUInteger i=0; i < count; ++i)
        {
            cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [cell.articleImage setHidden:YES];
        }
        cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.articleImage setHidden:NO];
       
        //intSelectedIndex = indexPath.row;
        
        [self.sessionCollectionView reloadData];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if(collectionView.tag == 0)
    {
        arrSessionsiPad = [NSArray arrayWithArray:[[self.arrSessions objectAtIndex:indexPath.row] objectAtIndex:1]];
        self.sessionCollectionView.dataSource = self;
        self.sessionCollectionView.delegate = self;
        
        [self.sessionCollectionView reloadData];
        
        self.sessionCollectionView.frame = [self collectionViewContentSize];
        [self.svwMySchedule setContentSize:CGSizeMake(self.sessionCollectionView.frame.origin.x+[self collectionViewContentSize].size.width, self.sessionCollectionView.frame.size.height)];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if([DeviceManager IsiPad])
    {
        if(collectionView.tag == 0)
        {
            size = CGSizeMake(250.0f, 50.0f);
        }
        else
        {
            size = CGSizeMake(300.0f, 250.0f);
        }
    }
    else
    {
        if([DeviceManager Is4Inch])
        {
            size = CGSizeMake(320.0f, 418.0f);
        }
        else
        {
            size = CGSizeMake(320.0f, 330.0f);
        }
    }
    
    return size;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//}

- (CGRect)collectionViewContentSize
{
    double itemCount = [self.sessionCollectionView numberOfItemsInSection:0];
    double totalWidth = ceil(itemCount/iPad_NO_of_Rows)*(iPad_Item_Width+10);
    NSLog(@"%0.2f",itemCount);
    NSLog(@"%0.2f",totalWidth);
    NSLog(@"%0.2f",self.sessionCollectionView.frame.size.height);
    return CGRectMake(self.sessionCollectionView.frame.origin.x, self.sessionCollectionView.frame.origin.y, totalWidth, self.sessionCollectionView.frame.size.height);
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)CheckAndAddToMyCalendar:(id)sender
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
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
        
        int intI;
        int intJ;
        BOOL blnFoundInMyCalendar = NO;
        
        for (intI=0; intI<[self.arrSessions count]; intI++)
        {
            if(blnFoundInMyCalendar)
            {
                break;
            }

            NSArray *arrS = [[self.arrSessions objectAtIndex:intI] objectAtIndex:1];
            
            for (intJ=0; intJ<[arrS count]; intJ++)
            {
                if(blnFoundInMyCalendar)
                {
                    break;
                }
                
                Session *objSession = [arrS objectAtIndex:intJ];

                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dtStartDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",objSession.strStartDate,objSession.strStartTime]];
                NSDate *dtendDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",objSession.strStartDate,objSession.strEndTime]];

                NSPredicate *predicate = [self.store predicateForEventsWithStartDate:dtStartDate endDate:dtendDate calendars:nil];

                NSArray *arrEvents = [self.store eventsMatchingPredicate:predicate];
                 
                for (NSUInteger i = 0; i < [arrEvents count]; i++)
                {
                    if([[[arrEvents objectAtIndex:i] title] isEqualToString:objSession.strSessionTitle])
                    {
                        NSString *strEventID = [[arrEvents objectAtIndex:i] eventIdentifier];
                        NSLog(@"%@",strEventID);

                        blnFoundInMyCalendar = YES;

                        double delayInSeconds = 1.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            UIAlertView *confirm = [[UIAlertView alloc]
                                                    initWithTitle:nil
                                                    message:@"Your are about to sync your entire schedule. If you have done this previously, it may create duplicate entries in your calendar. you may send individual sessions to calendar by clicking on the \"Add to calendar\" button on each session detail page."
                                                    delegate:self
                                                    cancelButtonTitle:@"Yes"
                                                    otherButtonTitles:@"No", nil];
                            
                            confirm.tag = 1;
                            [confirm show];
                        });
                        
                        break;
                    }
                }
            }
        }
        
        if(blnFoundInMyCalendar == NO && [[self arrSessions] count] > 0)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self AddToMyCalendar];
                });
        }
        else
        {
            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
        }
    }];
}

- (IBAction)btnRefreshClicked:(id)sender
{
   // Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    MySessionDB *objMySessionDB = [MySessionDB GetInstance];
    NSString *strMySessions = [objMySessionDB GetMySessionsJSON];
    //NSLog(@"%@",strMySessions);
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_SYNC_MY_SESSION_LIST];
    
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
    [objRequest addValue:strMySessions forHTTPHeaderField:@"ScheduleJSON"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_MY_SCHEDULE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_SYNC_MY_SESSION_LIST];
}

- (void)AddToMyCalendar
{
    [self.store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL blnGranted, NSError *error)
    {
        if(!blnGranted)
        {
            return;
        }
        
        int intI;
        int intJ;
        BOOL blnAddedToMyCalendar = NO;

        for (intI=0; intI<[self.arrSessions count]; intI++)
        {
            NSArray *arrS = [[self.arrSessions objectAtIndex:intI] objectAtIndex:1];

            for (intJ=0; intJ<[arrS count]; intJ++)
            {
                Session *objSession = [arrS objectAtIndex:intJ];

                EKEvent *event = [EKEvent eventWithEventStore:self.store];
                event.title = objSession.strSessionTitle;

                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dtStartDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",objSession.strStartDate,objSession.strStartTime]];
                NSDate *dtendDate = [dateFormater dateFromString:[NSString stringWithFormat:@"%@ %@",objSession.strStartDate,objSession.strEndTime]];
                event.startDate = dtStartDate;
                event.endDate = dtendDate;

                [event setCalendar:[self.store defaultCalendarForNewEvents]];

                NSError *err = nil;
                [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];

                if(error == nil)
                {
                    blnAddedToMyCalendar = YES;
                    
                    NSString *strEventID = event.eventIdentifier;
                    NSLog(@"Added - Event ID: %@",strEventID);
                }
                else
                {
                }
            }
        }
        
        if(blnAddedToMyCalendar == YES && [[self arrSessions] count] > 0)
        {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self showAlert:nil withMessage:@"The sessions have been added to your calendar." withButton:@"OK" withIcon:nil];
                    
                    [[self vwLoading] setHidden:YES];
                    [[self avLoading] stopAnimating];
            });
        }
        else
        {
            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
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
                [self AddToMyCalendar];
            }
            break;
        case 1:
            {
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
                //Do Nothing
            }
            break;
        default:
            break;
    }
}
#pragma mark  -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@",error.description);
    [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
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
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_SYNC_MY_SESSION_LIST:
            {
                MySessionDB *objMySessionDB = [[MySessionDB alloc] init];
                BOOL blnResult = [objMySessionDB SyncMySessions:objData];
                NSLog(blnResult?@"Sync My Sessions: YES":@"Sync My Sessions: NO");
                
                MySessionDB *objMySesions = [MySessionDB GetInstance];
                self.arrSessions = [objMySesions GetMySessionsAndGrouped:YES];
                
                [[self myScheduleCollectionView] reloadData];
            }
            break;
        case OPER_GET_MY_SESSION_LIST:
            {
                [self SetMySessions];
                
                MySessionDB *objMySesions = [MySessionDB GetInstance];
                self.arrSessions = [objMySesions GetMySessionsAndGrouped:YES];
                
                [[self myScheduleCollectionView] reloadData];
            }
            break;
        default:
            break;
    }
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
}
#pragma mark -
@end
