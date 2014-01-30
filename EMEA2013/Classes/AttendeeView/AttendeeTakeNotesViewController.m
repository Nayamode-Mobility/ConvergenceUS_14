//
//  SessionNoteViewController.m
//  mgx2013
//
//  Created by Amit Karande on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AttendeeTakeNotesViewController.h"
#import "NSString+Custom.h"
#import "Speaker.h"
#import "NotesDB.h"
#import "UserSessionNotes.h"
#import "Functions.h"
#import "User.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Rooms.h"
#import "Attendee.h"
#import "AppDelegate.h"
#import "NSURLConnection+Tag.h"
#import "FBJSON.h"

@interface AttendeeTakeNotesViewController ()

@end

@implementation AttendeeTakeNotesViewController
@synthesize delegate,objConnection,objData;


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
    if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
    {
    }
    else
    {
        self.svwNotes.frame = CGRectMake(self.svwNotes.frame.origin.x, self.svwNotes.frame.origin.y + 20, self.svwNotes.frame.size.width, self.svwNotes.frame.size.height - 20);
        self.vwButtons.frame = CGRectMake(self.vwButtons.frame.origin.x, self.vwButtons.frame.origin.y + 20, self.vwButtons.frame.size.width, self.vwButtons.frame.size.height);
    }
    
    //Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[self txtNoteTitle] becomeFirstResponder];
    
    [[[self txtNote] layer] setBorderWidth:1.0f];
    [[[self txtNote] layer] setBorderColor:[[UIColor blackColor] CGColor]];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    
    //Prevents the scroll view from swallowing up the touch event of child buttons
    singleTap1.cancelsTouchesInView = NO;
    
    [[self svwNotes] addGestureRecognizer:singleTap1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    
    //Prevents the scroll view from swallowing up the touch event of child buttons
    singleTap2.cancelsTouchesInView = NO;
    
    [[self vwButtons] addGestureRecognizer:singleTap2];
    
    if([self blnNew] == YES)
    {
        [[self btnDelete] setHidden: YES];
    }
    
    [self populateData];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_USER_NOTE];
    
    //[UIView addTouchEffect:self.view];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == [self txtNoteTitle])
    {
        [[self txtNoteTitle] resignFirstResponder];
        [[self txtNote] becomeFirstResponder];
    }
    else
    {
        [[self txtNote] resignFirstResponder];
        [self btnAddSessionNote:[self btnAddSessionNote]];
    }
    
    return  YES;
}

-(void) populateData
{
//        self.lblCode.text = self.sessionData.strSessionCode;
//        self.lblTitle.text = self.sessionData.strSessionTitle;
    
        
        self.lblName.text = self.objAttendee.strAttendeeName;
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        NSDate *dtStartDate = [dateFormater dateFromString:self.sessionData.strStartDate];
        [dateFormater setDateFormat:@"EEEE, MMMM dd"];
        self.lblDate.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
        
        [dateFormater setDateFormat:@"HH:mm:ss"];
        NSDate *dtStartTime = [dateFormater dateFromString:self.sessionData.strStartTime];
        NSDate *dtEndTime = [dateFormater dateFromString:self.sessionData.strEndTime];
        
        [dateFormater setDateFormat:@"hh:mm a"];
        NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
        strTime = [strTime stringByAppendingString:@" - "];
        strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
        self.lblTiming.text = strTime;
        
    
    if (!self.blnNew)
    {
        self.txtNoteTitle.text = self.noteData.strTitle;
        self.txtNote.text = self.noteData.strContent;
        self.lblNotesPlaceHolder.hidden = YES;
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

- (void)keyboardDidShow:(NSNotification *)notif
{
    //Do something here
    if(self.objAttendee == nil)
    {
        if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
                self.svwNotes.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
                self.svwNotes.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height);
            } completion:nil];
        }
    }
    else
    {
        if([[DeviceManager GetDeviceSystemVersion] integerValue] < 7)
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
                self.svwNotes.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            } completion:nil];
        }
        else
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
                self.svwNotes.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
            } completion:nil];
        }
    }
}

- (void)keyboardDidHide:(NSNotification *)notif
{
    //Do something here
    //[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
    //    self.svwNotes.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //} completion:nil];
}

- (IBAction)textEditCancel:(id)sender
{
    [self.txtNote resignFirstResponder];
    [self keyboardDidHide:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //Any new character added is passed in as the "text" parameter
    /*if([text isEqualToString:@"\n"])
     {
     if(self.svwNotes.frame.origin.y > -180.0f)
     {
     [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
     self.svwNotes.frame = CGRectMake(0, self.svwNotes.frame.origin.y - 10, self.view.frame.size.width, self.view.frame.size.height);
     } completion:nil];
     }
     }*/
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[self lblNotesPlaceHolder] setHidden:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if(self.txtNote.text.length == 0)
    {
        [[self lblNotesPlaceHolder] setHidden:NO];
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    if([[self txtNoteTitle] isFirstResponder])
    {
        [[self txtNoteTitle] resignFirstResponder];
    }
    else
    {
        [[self txtNote] resignFirstResponder];
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDeleteNote:(id)sender
{
//    if (!APP.netStatus)
//    {
    
        if (self.blnNew)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NotesDB *objNotesDB = [NotesDB GetInstance];
            self.noteData.strIsDeleted = @"1";
            [objNotesDB UpdateUserSessionNoteAsDeleted:self.noteData];
            
            [self showAlert:@"" withMessage:@"Note deleted successfully." withButton:@"OK" withIcon:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
//    }
//    else
//    {
//        [[self vwLoading] setHidden:NO];
//        [[self avLoading] startAnimating];
//        
//        User *objUser = [User GetInstance];
//        
//        NSString *strURL = strAPI_URL;
//        strURL = [strURL stringByAppendingString:strAPI_NOTES_DELETE_ATTENDEE_NOTES];
//        
//        NSURL *URL = [NSURL URLWithString:strURL];
//        
//        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
//        [objRequest setHTTPMethod:@"POST"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        
//        [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
//        [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
//        [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
//        [objRequest addValue:self.objAttendee.strEmail forHTTPHeaderField:@"ForAttendeeEmail"];
//        
//        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:1];
//
//    }
}

-(void)DeleteAttendeeNotes
{
    
}

- (IBAction)btnAddSessionNote:(id)sender
{
    NSString *strMessage = @"";
    if([NSString IsEmpty:self.txtNoteTitle.text shouldCleanWhiteSpace:YES])
    {
        strMessage = [strMessage stringByAppendingString:@"Please enter a title."];
    }
    else if([NSString IsEmpty:self.txtNote.text shouldCleanWhiteSpace:YES])
    {
        strMessage = [strMessage stringByAppendingString:@"Please enter a note."];
    }
    
    if([NSString IsEmpty:strMessage shouldCleanWhiteSpace:YES])
    {
        [self AddAttendeeNotes];
    }
    else
    {
        [self showAlert:@"" withMessage:strMessage withButton:@"OK" withIcon:nil];
    }
}

-(void)AddAttendeeNotes
{
    NotesDB *objNoteDB = [NotesDB GetInstance];
    
    User *objUser = [User GetInstance];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    
//    if (!APP.netStatus)
//    {
        if (self.blnNew)
        {
            UserSessionNotes *objNotes = [[UserSessionNotes alloc] init];
            objNotes.strLocalID = [Functions GetGUID];
            objNotes.strNoteID = @"0";
            objNotes.strTitle = self.txtNoteTitle.text;
            objNotes.strContent = self.txtNote.text;
            objNotes.strCreatedDate = dateString;
            objNotes.strUserEmail = [objUser GetAccountEmail];
            objNotes.strAttendeeEmailId = self.objAttendee.strEmail;
            objNotes.strIsAdded = @"1";
            
            [objNoteDB AddAttendeeNote:objNotes];
        }
        else
        {
            self.noteData.strTitle = self.txtNoteTitle.text;
            self.noteData.strContent = self.txtNote.text;
            self.noteData.strUpdatedDate = dateString;
            
            if([self.noteData.strIsAdded boolValue] == NO)
            {
                self.noteData.strIsUpdated = @"1";
            }
            else
            {
                self.noteData.strIsUpdated = @"0";
            }
            
            [objNoteDB UpdateAttendeeNote:self.noteData];
        }
        
        [self showAlert:@"" withMessage:@"Your note has been saved." withButton:@"OK" withIcon:nil];
        
        [delegate noteSaved];
        
        [self.navigationController popViewControllerAnimated:YES];
        
//    }
//    else
//    {
//        
//        self.noteData = [[UserSessionNotes alloc] init];
//        self.noteData.strLocalID = [Functions GetGUID];
//        self.noteData.strNoteID = @"0";
//        self.noteData.strTitle = self.txtNoteTitle.text;
//        self.noteData.strContent = self.txtNote.text;
//        self.noteData.strCreatedDate = dateString;
//        self.noteData.strUserEmail = [objUser GetAccountEmail];
//        self.noteData.strAttendeeEmailId = self.objAttendee.strEmail;
//        self.noteData.strIsAdded = @"0";
//
//        [[self vwLoading] setHidden:NO];
//        [[self avLoading] startAnimating];
//        
//        User *objUser = [User GetInstance];
//        
//        NSMutableDictionary *dictAttendeeNotes = [[NSMutableDictionary alloc]init];
//        
//        [dictAttendeeNotes setObject:self.noteData.strLocalID forKey:@"LocalId"];
//        [dictAttendeeNotes setObject:self.objAttendee.strEmail forKey:@"ForAttendeeEmail"];
//        [dictAttendeeNotes setObject: self.txtNoteTitle.text forKey:@"Title"];
//        [dictAttendeeNotes setObject:self.txtNote.text forKey:@"Content"];
//        
//        NSString *strAttendeenotes = [dictAttendeeNotes JSONRepresentation];
//        
//        NSString *strURL = strAPI_URL;
//        strURL = [strURL stringByAppendingString:strAPI_NOTES_ADD_ATTENDEE_NOTES];
//        
//        NSURL *URL = [NSURL URLWithString:strURL];
//        
//        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
//        [objRequest setHTTPMethod:@"POST"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        
//        [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
//        [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
//        [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
//        [objRequest addValue:strAttendeenotes forHTTPHeaderField:@"NotesJSON"];
//        
//        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:0];
//    }
}

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
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case 0:
        {
            if ([strData isEqualToString:@"true"])
            {
                NotesDB *objNoteDB = [NotesDB GetInstance];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
                
                if (self.blnNew)
                {
                    [objNoteDB AddAttendeeNote:self.noteData];
                }
                else
                {
                    self.noteData.strTitle = self.txtNoteTitle.text;
                    self.noteData.strContent = self.txtNote.text;
                    self.noteData.strUpdatedDate = dateString;
                    
                    self.noteData.strIsAdded = @"0";
                    self.noteData.strIsDeleted = @"0";
                    self.noteData.strIsUpdated = @"0";
                    
                    [objNoteDB UpdateAttendeeNote:self.noteData];
                }
                
                [self showAlert:@"" withMessage:@"Your note has been saved." withButton:@"OK" withIcon:nil];
                
                [delegate noteSaved];
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            
            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
            
        }
            break;
        case 1:
        {
            NotesDB *objNoteDB = [NotesDB GetInstance];
            if ([strData isEqualToString:@"true"])
            {
                self.noteData.strIsDeleted = @"0";
            }
            else
            {
                self.noteData.strIsDeleted = @"1";
            }
            
            [objNoteDB UpdateUserSessionNoteAsDeleted:self.noteData];


            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
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

- (IBAction)OpenMail:(id)sender
{
    NSString *strMessage = @"";
    if([NSString IsEmpty:self.txtNoteTitle.text shouldCleanWhiteSpace:YES])
    {
        strMessage = [strMessage stringByAppendingString:@"Please enter a title."];
    }
    else if([NSString IsEmpty:self.txtNote.text shouldCleanWhiteSpace:YES])
    {
        strMessage = [strMessage stringByAppendingString:@"Please enter a note."];
    }
    
    if(![NSString IsEmpty:strMessage shouldCleanWhiteSpace:YES])
    {
        [self showAlert:@"" withMessage:strMessage withButton:@"OK" withIcon:nil];
        return;
    }
    NSString *Subject = self.txtNoteTitle.text;
    
    NSString *strNote = self.txtNote.text;
    strNote = [[strNote componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"<br/>"];
    NSString *Body = @"";
    
    if ([Subject isEqualToString:@""] && [Body isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter Subject and Notes" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        if(self.sessionData == nil)
        {
            Body = strNote;
        }
        else
        {
            Body = [Body stringByAppendingString:@"<font style='color: #7DBA00'>"];
            Body = [Body stringByAppendingString:self.sessionData.strSessionTitle];
            Body = [Body stringByAppendingString:@"</font><br/>"];
            
            NSString *strSpeakers = @"";
            if([self.sessionData.arrSpeakers count] > 0)
            {
                for (NSUInteger i = 0; i < [self.sessionData.arrSpeakers count]; i++)
                {
                    if(![NSString IsEmpty:strSpeakers shouldCleanWhiteSpace:YES])
                    {
                        strSpeakers = [strSpeakers stringByAppendingString:@", "];
                    }
                    
                    strSpeakers = [strSpeakers stringByAppendingString:[[[self.sessionData.arrSpeakers objectAtIndex:i] objectAtIndex:0] strFirstName]];
                    strSpeakers = [strSpeakers stringByAppendingString:@" "];
                    strSpeakers = [strSpeakers stringByAppendingString:[[[self.sessionData.arrSpeakers objectAtIndex:i] objectAtIndex:0] strLastName]];
                }
            }
            
            Body = [Body stringByAppendingString:strSpeakers];
            Body = [Body stringByAppendingString:@"<br/>"];
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            NSDate *dtStartDate = [dateFormater dateFromString:self.sessionData.strStartDate];
            [dateFormater setDateFormat:@"EEEE, MMMM dd"];
            Body = [Body stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]]];
            Body = [Body stringByAppendingString:@"<br/>"];
            
            [dateFormater setDateFormat:@"HH:mm:ss"];
            NSDate *dtStartTime = [dateFormater dateFromString:self.sessionData.strStartTime];
            NSDate *dtEndTime = [dateFormater dateFromString:self.sessionData.strEndTime];
            
            [dateFormater setDateFormat:@"hh:mm a"];
            NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
            strTime = [strTime stringByAppendingString:@" - "];
            strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
            Body = [Body stringByAppendingString:strTime];
            Body = [Body stringByAppendingString:@"<br/>"];
            
            Body = [Body stringByAppendingString:@"<b>Room</b>: "];
            if ([self.sessionData.arrRooms count] > 0){
                Rooms *objRoom = [self.sessionData.arrRooms objectAtIndex:0];
                Body = [Body stringByAppendingString:objRoom.strRoomName];
                Body = [Body stringByAppendingString:@"<br/>"];
                Body = [Body stringByAppendingString:@"<br/>"];
                
                Body = [Body stringByAppendingString:strNote];
            }
        }
        
        if([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
            
            [mailer setToRecipients: [[NSArray alloc] initWithObjects: nil]];
            [mailer setSubject:Subject];
            [mailer setMessageBody:Body isHTML:YES];
            mailer.mailComposeDelegate = self;
            
            [self presentViewController:mailer animated:YES completion:Nil];
        }
        else
        {
            [Functions OpenMailWithSubjectAndBody:Subject body:Body];
        }
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
@end
