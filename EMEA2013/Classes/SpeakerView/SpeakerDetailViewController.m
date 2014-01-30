//
//  SpeakerDetailViewController.m
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#define iPhone_Item_Width 300.0
#define iPhone_Item_Height 180.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 2.0

#import "SpeakerDetailViewController.h"
#import "CustomCollectionViewCell.h"
#import "SessionDetailViewController.h"
#import "SpeakerDB.h"
#import "MySessionDB.h"
#import "Speaker.h"
#import "DeviceManager.h"
#import "Session.h"
#import "User.h"
#import "Rooms.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "Functions.h"
#import "NotesViewController.h"
#import "SessionQAViewController.h"

@interface SpeakerDetailViewController ()
{
    @private
    id objSender;
    
}
@end

@implementation SpeakerDetailViewController
@synthesize speakersData, speakerData, strSpeakerInstanceID, lblName, lblSpeakerTitle, lblCompany, lblEmail, lblBio, txtBiography, sessionList, imgLogo;
@synthesize objConnection, objData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.speakersData == nil)
    {
        self.speakersData = [[NSArray alloc] init];
    }
    
    SpeakerDB *objSpeakerDB = [SpeakerDB GetInstance];
    
    if([NSString IsEmpty:strSpeakerInstanceID shouldCleanWhiteSpace:YES])
    {
        strSpeakerInstanceID = self.speakerData.strSpeakerInstanceID;
    }
    
    //self.speakersData = [objSpeakerDB GetSpeakersWithSpeakerID:strSpeakerInstanceID];
    self.speakersData = [objSpeakerDB GetSpeakersWithSpeakerIDAndSessionsAndGrouped:strSpeakerInstanceID IncludeSessions:YES Grouped:NO];
    self.speakerData = [self.speakersData objectAtIndex:0];
    
    [self populateData];
    
    [self.colSessions reloadData];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Do any additional setup after loading the view.
    [[self avLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    [[self imgLogo] setHidden:YES];
    
    //[self populateData];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SPEAKER];    
    
    //[UIView addTouchEffect:self.view];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadSessionDetail4"] || [segue.identifier isEqualToString:@"loadSessionDetail8"])
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
        
        controller.intTag=tagselected;
        controller.sessionData = [[self.sessionList objectAtIndex:tagselected] objectAtIndex:0];
    }
    else if ([segue.identifier isEqualToString:@"gotoNotes"])
    {
        UIButton *btnNote = (UIButton *)sender;
        NotesViewController *controller = segue.destinationViewController;
        controller.sessionData = [[self.sessionList objectAtIndex:btnNote.tag] objectAtIndex:0];
        controller.strSessionInstanceID = ((Session*)[[self.sessionList objectAtIndex:btnNote.tag] objectAtIndex:0]).strSessionInstanceID;
    }
    else if([segue.identifier isEqualToString:@"SendQuestion"])
    {
        
        UIButton *btnSendQts = (UIButton *)sender;
        SessionQAViewController *controller = segue.destinationViewController;
        controller.speakerData = self.speakerData;
       
        
        //NSLog(@"%@",self.lblSpeakerTitle);
        
        
        
    }

}

-(void) populateData
{
    lblName.text = [NSString stringWithFormat:@"%@ %@",self.speakerData.strFirstName,self.speakerData.strLastName];
    lblSpeakerTitle.text = self.speakerData.strTitle;
    lblCompany.text =self.speakerData.strCompany;
    lblEmail.text = self.speakerData.strEmail;
    lblBio.text = self.speakerData.strBiography;
    if ([self.speakerData.strBiography isEqualToString:@""]) {
       lblBio.text = @"No bio available for this speaker";
    }
    NSLog(@"bio %@",lblBio.text);
    
    if ([self.speakerData.strEmail isEqualToString:@""]) {
        self.sendQts.enabled = NO;
    }
   
    txtBiography.text = self.speakerData.strBiography;
    
    if(![NSString IsEmpty:self.speakerData.strSpeakerPhoto shouldCleanWhiteSpace:YES])
    {
        NSURL *imgURL = [NSURL URLWithString:self.speakerData.strSpeakerPhoto];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                UIImage *img = [[UIImage alloc] initWithData:data];;
                [self.imgLogo setImage:img];
                self.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
                self.imgLogo.backgroundColor = [UIColor clearColor];

                [[self imgLogo] setHidden:NO];
                [[self avLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
            else
            {
                [[self imgLogo] setHidden:NO];
                [[self avLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
        }];
    }
    else
    {
        [[self imgLogo] setHidden:NO];
        [[self avLoading] setHidden:YES];
        [[self avLoading] stopAnimating];
    }
    
    if (self.sessionList == nil)
    {
        self.sessionList = [[NSArray alloc] init];
    }
    self.sessionList = self.speakerData.arrSessions;

    if (self.speakerData.strEmail.length == 0)
    {
        [self.imgEmail setHidden:YES];
         [self.lblEmail setHidden:YES];
    }
}

-(void)viewDidLayoutSubviews
{
    [self.svwSpeakerDetail setContentSize:CGSizeMake(960, self.svwSpeakerDetail.frame.size.height)];
    if ([DeviceManager IsiPad])
    {
        self.sessionCollectionView.frame = [self collectionViewContentSize];
        
        [self.svwSpeakerDetail setContentSize:CGSizeMake(self.sessionCollectionView.frame.origin.x+[self collectionViewContentSize].size.width+768, self.sessionCollectionView.frame.size.height)];
        //[self.svwSpeakerDetail setContentSize:CGSizeMake(1536, self.svwSpeakerDetail.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AddToMySchedule:(id)sender
{
    BOOL blnResult = NO;
    
    objSender = sender;
    UIButton *btnAdd = (UIButton*)sender;
    
    Session *objSession = [[self.sessionList objectAtIndex:btnAdd.tag] objectAtIndex:0];;
    
    NSLog(@"%@",[objSession strSessionInstanceID]);
    NSLog(@"%@",[objSession strSessionTitle]);
    
    MySessionDB *objMySessionDB = [MySessionDB GetInstance];
    blnResult = [objMySessionDB AddSession:[objSession strSessionInstanceID]];
    
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
    
    [objRequest addValue:[objSession strSessionInstanceID] forHTTPHeaderField:@"SessionInstanceId"];
    [objRequest addValue:@"false" forHTTPHeaderField:@"IsScheduleRemoved"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_MY_SESSION_LIST];
}

- (IBAction)RemoveFromMySchedule:(id)sender
{
    BOOL blnResult = NO;
    
    objSender = sender;
    UIButton *btnRemove = (UIButton*)sender;
    
    Session *objSession = [[self.sessionList objectAtIndex:btnRemove.tag] objectAtIndex:0];
    
    NSLog(@"%@",[objSession strSessionInstanceID]);
    NSLog(@"%@",[objSession strSessionTitle]);
    
    MySessionDB *objMySessionDB = [MySessionDB GetInstance];
    blnResult = [objMySessionDB DeleteSession:[objSession strSessionInstanceID]];
    
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
    
    [objRequest addValue:[objSession strSessionInstanceID] forHTTPHeaderField:@"SessionInstanceId"];
    [objRequest addValue:@"true" forHTTPHeaderField:@"IsScheduleRemoved"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_REMOVE_MY_SESSION_LIST];
}
#pragma mark -

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.sessionList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Session *objSession = [[self.sessionList objectAtIndex:indexPath.row] objectAtIndex:0];
    
    cell.lblTitle.text = objSession.strSessionTitle;
    cell.tag = indexPath.row;
    cell.btnDetail.tag = indexPath.row;
    cell.btnNote.tag = indexPath.row;
    
    [cell.vwSessionButtons setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:122/255.0 alpha:1.0]];
    if([[objSession strIsAdded] boolValue])
    {
        [cell.vwSessionButtons setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
    }
    
    cell.btnAddToMySchedule.hidden = [[objSession strIsAdded] boolValue];
    cell.btnAddToMySchedule.tag = indexPath.row;
    
    cell.btnRemoveFromMySchedule.hidden = ![[objSession strIsAdded] boolValue];
    cell.btnRemoveFromMySchedule.tag = indexPath.row;
    
    [cell.btnAddToMySchedule addTarget:self action:@selector(AddToMySchedule:) forControlEvents:UIControlEventTouchUpInside];
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
    [dateFormater setDateFormat:@"EEEE, MMMM dd"];
    cell.lblDate.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];

    [dateFormater setDateFormat:@"HH:mm:ss"];
    NSDate *dtStartTime = [dateFormater dateFromString:objSession.strStartTime];
    NSDate *dtEndTime = [dateFormater dateFromString:objSession.strEndTime];

    [dateFormater setDateFormat:@"hh:mm a"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
    strTime = [strTime stringByAppendingString:@" - "];
    strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
    cell.lblTiming.text = strTime;
    
    if ([objSession.arrRooms count] > 0)
    {
        Rooms *objRoom = [objSession.arrRooms objectAtIndex:0];
        cell.lblRoom.text = objRoom.strRoomName;
    }
    
    cell.lblSessionCode.text = [NSString stringWithFormat:@"Session Code: %@",objSession.strSessionCode];
    
    //[UIView addTouchEffect:cell.contentView];

    return cell;
}

- (CGRect)collectionViewContentSize
{
    double itemCount = [self.sessionCollectionView numberOfItemsInSection:0];
    if([DeviceManager IsiPad] == YES)
    {
        double totalWidth = ceil(itemCount/iPad_NO_of_Rows)*(iPad_Item_Width+10);
        
        return CGRectMake(self.sessionCollectionView.frame.origin.x, self.sessionCollectionView.frame.origin.y, totalWidth, self.sessionCollectionView.frame.size.height);
    }
    else
    {
        double totalWidth = ceil((itemCount/iPhone_NO_of_Rows))*(iPhone_Item_Width+10);
        return CGRectMake(self.sessionCollectionView.frame.origin.x, self.sessionCollectionView.frame.origin.y, totalWidth, self.self.sessionCollectionView.frame.size.height);
    }
}






- (IBAction)btnBackClick:(id)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OpenMail:(id)sender
{
 	if([MFMailComposeViewController canSendMail])
	{
		if(![NSString IsEmpty:self.speakerData.strEmail shouldCleanWhiteSpace:YES])
        {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
		NSString *Subject = @"";
		
		NSString *Body = @"";
        
        [mailer setToRecipients: [[NSArray alloc] initWithObjects:self.speakerData.strEmail, nil]];
		[mailer setSubject:Subject];
		[mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
		
        [self presentViewController:mailer animated:YES completion:Nil];
	}
    }
    else
    {
        [Functions OpenMailWithReceipient:self.speakerData.strEmail];
    }
}

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
                UIButton *btnAdd = (UIButton*)objSender;
                [[[self.sessionList objectAtIndex:btnAdd.tag] objectAtIndex:0]  setStrIsAdded:@"1"];
                
                [self.colSessions reloadData];
            }
        }
            break;
        case OPER_REMOVE_MY_SESSION_LIST:
        {
            if ([strData isEqualToString:@"true"])
            {
                UIButton *btnRemove = (UIButton*)objSender;
                [[[self.sessionList objectAtIndex:btnRemove.tag] objectAtIndex:0]  setStrIsAdded:@"0"];
                
                [self.colSessions reloadData];
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark -
@end
