//
//  SessionNoteViewController.m
//  mgx2013
//
//  Created by Amit Karande on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SessionNoteViewController.h"
#import "NSString+Custom.h"
#import "Speaker.h"
#import "NotesDB.h"
#import "UserSessionNotes.h"
#import "Functions.h"
#import "User.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Rooms.h"

@interface SessionNoteViewController ()

@end

@implementation SessionNoteViewController
@synthesize delegate;


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
    if(self.sessionData == nil)
    {
        self.vwSession.hidden = YES;
        self.vwText.frame = CGRectMake(0, 0, self.vwText.frame.size.width, (self.vwText.frame.size.height + self.vwSession.frame.size.height));
    }
    else
    {
        self.lblCode.text = self.sessionData.strSessionCode;
        self.lblTitle.text = self.sessionData.strSessionTitle;
        
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
        
        self.lblName.text = strSpeakers;
        
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
        
        if ([self.sessionData.arrRooms count] > 0){
            Rooms *objRoom = [self.sessionData.arrRooms objectAtIndex:0];
            self.lblRoom.text = objRoom.strRoomName;
        }
    }
    
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
    if(self.sessionData == nil)
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
    if (self.blnNew)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NotesDB *objNotesDB = [NotesDB GetInstance];
        [objNotesDB UpdateUserSessionNoteAsDeleted:self.noteData];

        [self showAlert:@"" withMessage:@"Note deleted successfully." withButton:@"OK" withIcon:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnAddSessionNote:(id)sender
{
    NotesDB *objNoteDB = [NotesDB GetInstance];
    
    User *objUser = [User GetInstance];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
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
        if (self.blnNew)
        {
            UserSessionNotes *objNotes = [[UserSessionNotes alloc] init];
            objNotes.strLocalID = [Functions GetGUID];
            objNotes.strNoteID = @"0";
            objNotes.strTitle = self.txtNoteTitle.text;
            objNotes.strContent = self.txtNote.text;
            objNotes.strCreatedDate = dateString;
            objNotes.strUserEmail = [objUser GetAccountEmail];
            objNotes.strSessionInstanceID = self.sessionData.strSessionInstanceID;
            objNotes.strIsAdded = @"1";
            
            [objNoteDB AddUserSessionNote:objNotes];
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
         
            [objNoteDB UpdateUserSessionNote:self.noteData];
        }
        
      //  [self showAlert:@"" withMessage:@"Your note has been saved." withButton:@"OK" withIcon:nil];
        
        // New Code
        
        if([self blnNew])
        {
            [self showAlert:@"" withMessage:@"Your note has been saved." withButton:@"OK" withIcon:nil];
        }
        else
        {
            [self showAlert:@"" withMessage:@"Your note has been updated." withButton:@"OK" withIcon:nil];
        }
        
        [delegate noteSaved];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self showAlert:@"" withMessage:strMessage withButton:@"OK" withIcon:nil];
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
