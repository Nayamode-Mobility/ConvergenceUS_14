//
//  ComposeViewController.m
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ComposeViewController.h"
#import "AttendeeDB.h"
#import "Attendee.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessagingDB.h"
#import "User.h"
#import "DB.h"
#import "Constants.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"
#import "FBJSON.h"
#import "NSString+Custom.h"
#import "AppDelegate.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController
@synthesize objConnection, objData;

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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    self.txtMessage.delegate = self;
    
    [[[self btnSave] layer] setBorderWidth:2.0f];
    [[[self btnSave] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSave] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSave] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnSend] layer] setBorderWidth:2.0f];
    [[[self btnSend] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSend] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSend] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];

    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnRefresh] layer] setBorderWidth:2.0f];
    [[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.arrAttendees == nil)
    {
        self.arrAttendees = [[NSArray alloc] init];
    }
    
    //AttendeeDB *objAttendee = [AttendeeDB GetInstance];
    //self.arrAttendees = [objAttendee GetAttendeesAndGrouped:NO];
    
    if([self blnCalledFromAttendeeDetail] == YES)
    {
        self.txtAttendee.text = self.strAttendeeName;
    }
    
    if(self.intDraftMessageID > 0)
    {
        self.txtAttendee.text = self.selectedMessage.strToAttendeeName;
        self.txtMessageSubject.text = self.selectedMessage.strMessageSubject;
        self.txtMessage.text = self.selectedMessage.strAttendeeMessage;
    }
    
    if(self.blnIsInboxMessage)
    {
        [self populateInboxData];
    }
    
    if(self.blnIsSentboxMessage)
    {
        [self popualteSentboxData];
    }
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewDidLayoutSubviews
{
    [self.svwCompose setContentSize:CGSizeMake(640, self.svwCompose.frame.size.height)];
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

- (void)populateInboxData
{
    if (self.blnIsReply)
    {
        self.txtAttendee.text = self.selectedMessage.strFromAttendee;
        self.txtMessageSubject.text = self.selectedMessage.strMessageSubject;
        self.txtMessage.text = self.selectedMessage.strAttendeeMessage;
    }
    else
    {
        self.txtMessageSubject.text = self.selectedMessage.strMessageSubject;
        self.txtMessage.text = self.selectedMessage.strAttendeeMessage;
    }
}

- (void)popualteSentboxData
{
    if (self.blnIsReply)
    {
        self.txtAttendee.text = self.selectedMessage.strToAttendee;
        self.txtMessageSubject.text = self.selectedMessage.strMessageSubject;
        self.txtMessage.text = self.selectedMessage.strAttendeeMessage;
    }
    else
    {
        self.txtMessageSubject.text = self.selectedMessage.strMessageSubject;
        self.txtMessage.text = self.selectedMessage.strAttendeeMessage;
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.arrAttendees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Attendee *objAttendee = [self.arrAttendees objectAtIndex:indexPath.row];
    
    cell.lblAttendeeName.text = objAttendee.strAttendeeName;
    cell.lblSubject.text = objAttendee.strCompany;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.intSelectedIndex = indexPath.row;
    
    Attendee *objAttendee = [self.arrAttendees objectAtIndex:indexPath.row];
    self.txtAttendee.text = objAttendee.strAttendeeName;
    
    [self.svwCompose setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == [self txtSearch])
    {
        //[[self txtSearch] resignFirstResponder];
        [self btnSearchClicked:[self btnSearch]];
    }
    else if(textField == [self txtMessageSubject])
    {
        [[self txtMessageSubject] resignFirstResponder];
        [[self txtMessage] becomeFirstResponder];
    }
    else
    {
        [[self txtMessage] resignFirstResponder];
        [self btnSendClicked:[self btnSend]];
    }
    
    return  YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
        self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations: ^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:nil];
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[svwCompose contentOffset].x);
    if([self.svwCompose contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [[self txtSearch] resignFirstResponder];
            [self.svwCompose setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.txtAttendee resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    [self.txtMessageSubject resignFirstResponder];
}

- (IBAction)btnSaveClicked:(id)sender
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    if ([self validate:NO])
    {
        User *objUser = [User GetInstance];
        Message *objMessage = [[Message alloc] init];
        
        if([self blnCalledFromAttendeeDetail] == NO && [[self arrAttendees] count] > 0)
        {
            Attendee *objAttendee = [self.arrAttendees objectAtIndex:self.intSelectedIndex];

            self.strAttendeeName = objAttendee.strAttendeeName;
            self.strAttendeeEmail = objAttendee.strEmail;
            
            objMessage.strToAttendeeName = self.strAttendeeName;
            objMessage.strToAttendee = self.strAttendeeEmail;
        }

        if(self.intDraftMessageID > 0)
        {
            objMessage = self.selectedMessage;

            if([[self arrAttendees] count] > 0)
            {
                Attendee *objAttendee = [self.arrAttendees objectAtIndex:self.intSelectedIndex];
                
                self.strAttendeeName = objAttendee.strAttendeeName;
                self.strAttendeeEmail = objAttendee.strEmail;
            }
            else
            {
                self.strAttendeeName =  objMessage.strToAttendeeName;
                self.strAttendeeEmail = objMessage.strToAttendee;
            }
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        //objMessage.strToAttendeeName = objAttendee.strAttendeeName;
        //objMessage.strToAttendee = objAttendee.strEmail;
        objMessage.strToAttendeeName = self.strAttendeeName;
        objMessage.strToAttendee = self.strAttendeeEmail;
        
        objMessage.strFromAttendeeName = [NSString stringWithFormat:@"%@ %@",[objUser GetFirstName], [objUser GetLastName]];
        objMessage.strFromAttendee = [objUser GetAccountEmail];
        objMessage.strMessageSubject = self.txtMessageSubject.text;
        objMessage.strAttendeeMessage = self.txtMessage.text;
        objMessage.strCreatedDate = [dateFormat stringFromDate:[NSDate date]];

        MessagingDB *objMessageDB = [MessagingDB GetInstance];
        if (self.intDraftMessageID > 0)
        {
            [objMessageDB UpdateMessage:objMessage TableName:@"Sentbox"];
        }
        else
        {
            [objMessageDB AddMessage:objMessage TableName:@"Draft"];
        }
        
        [self showAlert:@"" withMessage:@"Message saved in your draft." withButton:@"OK" withIcon:nil];
        
        [[self vwLoading] setHidden:YES];
        [[self avLoading] stopAnimating];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[self vwLoading] setHidden:YES];
        [[self avLoading] stopAnimating];
    }
}

- (IBAction)btnSendClicked:(id)sender
{
    
    Shared *objShared = [Shared GetInstance];
    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        UIAlertView *confirm = [[UIAlertView alloc]
//                                initWithTitle:nil
//                                message:@"Your request could not be processed since you don't have internet connection. Would you like to save it as draft?"
//                                delegate:self
//                                cancelButtonTitle:@"Yes"
//                                otherButtonTitles:@"No", nil];
//        
//        confirm.tag = 1;
//        [confirm show];
//        
//        return;
//    }
    
    if (APP.netStatus) {
   
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    if ([self validate:YES])
    {
        User *objUser = [User GetInstance];
        Message *objMessage = [[Message alloc] init];
        
        if([self blnCalledFromAttendeeDetail] == NO && [[self arrAttendees] count] > 0)
        {
            Attendee *objAttendee = [self.arrAttendees objectAtIndex:self.intSelectedIndex];
         
            self.strAttendeeName = objAttendee.strAttendeeName;
            self.strAttendeeEmail = objAttendee.strEmail;
            
            objMessage.strToAttendeeName = self.strAttendeeName;
            objMessage.strToAttendee = self.strAttendeeEmail;
        }

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        if(self.intDraftMessageID > 0)
        {
            objMessage = self.selectedMessage;
            
            if([[self arrAttendees] count] > 0)
            {
                Attendee *objAttendee = [self.arrAttendees objectAtIndex:self.intSelectedIndex];
                
                self.strAttendeeName = objAttendee.strAttendeeName;
                self.strAttendeeEmail = objAttendee.strEmail;
            }
            else
            {
                self.strAttendeeName =  objMessage.strToAttendeeName;
                self.strAttendeeEmail = objMessage.strToAttendee;
            }
            
            objMessage.strToAttendeeName = self.strAttendeeName;
            objMessage.strToAttendee = self.strAttendeeEmail;
            objMessage.strMessageSubject = self.txtMessageSubject.text;
            objMessage.strAttendeeMessage = self.txtMessage.text;
            objMessage.strCreatedDate = [dateFormat stringFromDate:[NSDate date]];
            
            MessagingDB *objMessageDB = [MessagingDB GetInstance];
            [objMessageDB UpdateMessage:objMessage TableName:@"Sentbox"];
        }
        else
        {
            //objMessage.strToAttendeeName = objAttendee.strAttendeeName;
            //objMessage.strToAttendee = objAttendee.strEmail;
            objMessage.strToAttendeeName = self.strAttendeeName;
            objMessage.strToAttendee = self.strAttendeeEmail;
            
            objMessage.strFromAttendeeName = [NSString stringWithFormat:@"%@ %@",[objUser GetFirstName], [objUser GetLastName]];
            objMessage.strFromAttendee = [objUser GetAccountEmail];
            objMessage.strMessageSubject = self.txtMessageSubject.text;
            objMessage.strAttendeeMessage = self.txtMessage.text;
            objMessage.strCreatedDate = [dateFormat stringFromDate:[NSDate date]];
            
            MessagingDB *objMessageDB = [MessagingDB GetInstance];            
            self.intDraftMessageID = [objMessageDB AddDraftMessage:objMessage];
        }
        
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
        [dictData setObject:objMessage.strFromAttendee forKey:@"FromAttendeeEmail"];
        [dictData setObject:objMessage.strToAttendee forKey:@"ToAttendeeEmail"];
        [dictData setObject:objMessage.strMessageSubject forKey:@"MessageSubject"];
        [dictData setObject:objMessage.strAttendeeMessage forKey:@"AttendeeMessage"];

        NSString* strData = [dictData JSONRepresentation];
        NSLog(@"Post Data: %@",strData);
        
        NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_ADD_MESSAGE];
        
        NSString *postString = [NSString stringWithFormat:@"%@",strData];
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
        
        NSURL *URL = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        [objRequest setHTTPMethod:@"POST"];
        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
        //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
        [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
        [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
        
        [objRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [objRequest setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_MESSAGE];
    }
    else
    {
        [[self vwLoading] setHidden:YES];
        [[self avLoading] stopAnimating];
    }
    }else{
        NETWORK_ALERT();
    }
}

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_GET_ANTENDEE_LIST:
            {
                [self SetAttendees];
                
                if(self.txtSearch.text.length < 3)
                {
                    AttendeeDB *objAttendee = [AttendeeDB GetInstance];
                    self.arrAttendees = [objAttendee GetAttendeesAndGrouped:NO];
                    
                    //[self.tvAttendees reloadData];
                    [[self txtSearch] becomeFirstResponder];
                }
                else
                {
                    [self btnSearchClicked:[self btnSearch]];
                }
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
            break;
        case OPER_ADD_MESSAGE:
            {
                NSError *err;
                id objJSON = [NSJSONSerialization JSONObjectWithData:objData options:0 error:&err];
                BOOL blnIsJSON = [NSJSONSerialization isValidJSONObject:objJSON];
                
                if(blnIsJSON == NO)
                {
                    MessagingDB *objMessageDB = [MessagingDB GetInstance];
                    [objMessageDB UpdateSentMessage:self.intDraftMessageID];
                    self.intDraftMessageID = 0;
                    
                    [self showAlert:@"" withMessage:@"Message sent successfully." withButton:@"OK" withIcon:nil];
                }
                else
                {
                    [self showAlert:@"" withMessage:@"Message saved in your draft." withButton:@"OK" withIcon:nil];
                }
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];

                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        default:
            break;
    }
}
#pragma mark -

- (IBAction)txtAttendeeTouched:(id)sender
{
    [self.svwCompose setContentOffset:CGPointMake(320, 0) animated:YES];
    //[[self txtSearch] becomeFirstResponder];
 

    [self performSelector:@selector(CheckIfAttendeesAvailable) withObject:nil afterDelay:0.5];
}

- (IBAction)btnRefreshClicked:(id)sender
{
    //Do not remove the search for 4 spaces
    //[[self txtSearch] setText:@"    "];
    
    //[self btnSearchClicked:[self btnSearch]];
    
    //[[self txtSearch] setText:@""];
    
    [self.txtSearch resignFirstResponder];
    
    [self SyncAttendees];
}

- (IBAction)btnSearchClicked:(id)sender
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    [[self lblNoItemsFound] setHidden: YES];

    //Min. 3 charecters need to be searched
    if(self.txtSearch.text.length < 3)
    {
        if(self.txtSearch.text.length == 0)
        {
            [self.txtSearch resignFirstResponder];
        }
        
        [[self vwLoading] setHidden:YES];
        [[self avLoading] stopAnimating];
        
        return;
    }

    [[self txtSearch] resignFirstResponder];

    if (self.arrAttendees == nil)
    {
        self.arrAttendees = [[NSArray alloc] init];
    }

    AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];

    //self.arrAttendees = [objAttendeeDB GetAttendeesLikeName:self.txtSearch.text];
    self.arrAttendees = [objAttendeeDB GetAttendeesLikeNameAndGrouped:self.txtSearch.text blnGrouped:NO];

    if([self.arrAttendees count] == 0)
    {
        [[self lblNoItemsFound] setHidden:NO];
    }
    //else
    //{
        [self.tvAttendees reloadData];
    //}
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
}

- (void)CheckIfAttendeesAvailable
{
    if([NSString IsEmpty:self.txtSearch.text shouldCleanWhiteSpace:YES] == YES)
    {
        AttendeeDB *objAttendee = [AttendeeDB GetInstance];
        self.arrAttendees = [objAttendee GetAttendees];
        
        if([self DataExists] == NO)
        {
            [self SyncAttendees];
        }
        else
        {
            [[self txtSearch] becomeFirstResponder];
        }
    }
    //else
    //{
    //    [[self txtSearch] becomeFirstResponder];
    //}
}

- (BOOL)DataExists
{
    BOOL blnDataExists = NO;
    
    if([[self arrAttendees] count] > 0)
    {
        blnDataExists = YES;
    }
    
    return blnDataExists;
}

- (void)SyncAttendees
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_GET_ATTENDEE_LIST];
    
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
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ATTENDEE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ANTENDEE_LIST];
}

- (void)SetAttendees
{
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc] init];
    BOOL blnResult = [objAttendeeDB SetAttendees:objData];
    NSLog(blnResult?@"Attendees: YES":@"Attendees: NO");
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

- (BOOL)validate:(BOOL)blnFromSend
{
    [self.txtAttendee resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    [self.txtMessageSubject resignFirstResponder];
    
    BOOL blnResult = YES;
    NSString *strMessage = @"";
    
    if (self.txtAttendee.text.length == 0)
    {
        blnResult = NO;
        if(blnFromSend == YES)
        {
            strMessage = @"Please enter valid attendee.";
        }
        else
        {
            strMessage = @"Message can't save in your draft need at least recipient.";
        }
    }
    
    if(blnFromSend == YES && blnResult)
    {
        if (self.txtMessageSubject.text.length == 0)
        {
            blnResult = NO;
            strMessage = @"Recipient, subject and message body must be filled in!";
        }
    }
    
    if(blnFromSend == YES && blnResult)
    {
        if (self.txtMessage.text.length == 0)
        {
            blnResult = NO;
            strMessage = @"Recipient, subject and message body must be filled in!";
        }
    }
    
    if (!blnResult)
    {
        [self showAlert:@"" withMessage:strMessage withButton:@"OK" withIcon:nil];
    }

    return blnResult;
}


@end
