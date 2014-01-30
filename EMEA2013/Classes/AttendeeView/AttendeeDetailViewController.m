//
//  AttendeeDetailViewController.m
//  mgx2013
//
//  Created by Amit Karande on 04/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AttendeeDetailViewController.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Functions.h"
#import "ComposeViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "sqlite3.h"
#import "DB.h"
#import "AttendeeDB.h"
#import "AppDelegate.h"
#import "User.h"
#import "DB.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"
#import "AttendeeTakeNotesViewController.h"
#import "AttendeeNotesViewController.h"

@interface AttendeeDetailViewController ()

@end

@implementation AttendeeDetailViewController

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
    //Do any additional setup after loading the view.
    
    [[[self btnSendMessage] layer] setBorderWidth:2.0f];
    [[[self btnSendMessage] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSendMessage] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSendMessage] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self populateData];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_ATTENDEE];
    
    if ([self.attendeeData.strIsNotesAvailable isEqualToString:@"1"])
    {
        btnTakeNotes.hidden = YES;
        btnViewNotes.hidden = NO;
    }
    else
    {
        btnTakeNotes.hidden = NO;
        btnViewNotes.hidden = YES;
    }

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ViewNotes"])
    {
        AttendeeNotesViewController *controller = segue.destinationViewController;
        controller.objAttendee  = self.attendeeData;
        controller.strAttendeeEmail = self.attendeeData.strEmail;
    }
    if([segue.identifier isEqualToString:@"TakeNotes"])
    {
        AttendeeTakeNotesViewController *objAttendeeTakeNotes = [[AttendeeTakeNotesViewController alloc] init];
        objAttendeeTakeNotes = segue.destinationViewController;
        objAttendeeTakeNotes.objAttendee = self.attendeeData;
        objAttendeeTakeNotes.strAttendeeEmail = self.attendeeData.strEmail;
        objAttendeeTakeNotes.blnNew = YES;
        objAttendeeTakeNotes.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"loadComposeMail2"])
    {
        ComposeViewController *composeMail = segue.destinationViewController;;
        composeMail.strAttendeeName = self.attendeeData.strAttendeeName;
        composeMail.strAttendeeEmail = self.attendeeData.strEmail;
        composeMail.blnCalledFromAttendeeDetail = YES;
    }
}

-(void) populateData
{
    self.lblName.text = [NSString stringWithFormat:@"%@",self.attendeeData.strAttendeeName];
    self.lblSpeakerTitle.text = self.attendeeData.strAttendeeName;
    self.lblCompany.text =self.attendeeData.strCompany;
    self.lblEmail.text = self.attendeeData.strEmail;
    self.lblPhone.text = self.attendeeData.strPhone;
    self.lblMessaging.text = @"";
    
    NSURL *imgURL = [NSURL URLWithString:self.attendeeData.strPhotoURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error)
     {
         if (!error)
         {
             UIImage *img = [[UIImage alloc] initWithData:data];;
             [self.imgLogo setImage:img];
             
         }
     }];
}

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (IBAction)btnBackCLicked:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)MakePhoneCall:(id)sender
{
    [Functions MakePhoneCall:self.attendeeData.strPhone];
}

- (IBAction)OpenMessageing:(id)sender
{
}

- (IBAction)btnAddToContactsClick:(id)sender {
    ABUnknownPersonViewController *unknownPersonViewController = [[ABUnknownPersonViewController alloc] init];
    unknownPersonViewController.displayedPerson = (ABRecordRef)[self buildContactDetails];
    unknownPersonViewController.allowsAddingToAddressBook = YES;
    //    [self.navigationController pushViewController:unknownPersonViewController animated:YES];
    
    //ABUnknownPersonViewController *view = [[ABUnknownPersonViewController alloc] init];
    unknownPersonViewController.unknownPersonViewDelegate = self;
    
    //Add person record data
    
    //view.displayedPerson = person;
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:unknownPersonViewController];
    
    unknownPersonViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                                    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self
                                                                    action:@selector(dismissContactView:)];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)dismissContactView:(id)sender{
    NSLog(@"gghhjj");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (ABRecordRef)buildContactDetails {
    NSLog(@"building contact details");
    ABRecordRef person = ABPersonCreate();
    CFErrorRef  error = NULL;
    
    // firstname
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.lblName.text), NULL);
    
    // email
    ABMutableMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(email, (__bridge CFTypeRef)(self.lblEmail.text), CFSTR("email"), NULL);
    ABRecordSetValue(person, kABPersonEmailProperty, email, &error);
    CFRelease(email);
    
    //phone
    if([self.lblPhone.text length] > 0){
        //ABMutableMultiValueRef phone = ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMutableMultiValueRef phone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phone, (__bridge CFTypeRef)((self.lblPhone.text)), CFSTR("phone"), NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phone, &error);
        CFRelease(phone);
        
    }
    
    if (error != NULL)
        NSLog(@"Error: %@", error);
    
    // [(id)person autorelease];
    return person;
}

-(void)AddFavAttendeeInLocalDB
{
    self.attendeeData.strIsSynced = @"0";
    
    AttendeeDB *objAttendee = [AttendeeDB GetInstance];
    
    [objAttendee AddFavAttendee:self.attendeeData];
    
    [self.btnFav setTitle:@"Remove from Favourite" forState:UIControlStateNormal];
}

-(void)RemoveFavAttendeeFromLocalDB
{
    AttendeeDB *objAttendee = [AttendeeDB GetInstance];
    NSString *strSQL = @"Select AttendeeID From FavouriteAttendees Where AttendeeID = ? and IsSynced =1";
    
    DB *objDB = [DB GetInstance];
    if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[self.attendeeData.strAttendeeID intValue] Query:strSQL] == NO)
    {
        [objAttendee DeleteFavAttendee:[self.attendeeData.strAttendeeID intValue]];
    }
    else
    {
        [objAttendee UpdateFavAttendee:self.attendeeData];
    }
}

- (IBAction)btnAddToFavClick:(id)sender
{
    
    if (APP.netStatus)
    {
        if ([self.btnFav.titleLabel.text isEqualToString:@"Add To Favourite"])
        {
            [self AddAttendeeOnline];
        }
        else
        {
            [self RemoveFavAttendeeOnline];
        }
    }
    else
    {
        if ([self.btnFav.titleLabel.text isEqualToString:@"Add To Favourite"])
        {
            [self AddFavAttendeeInLocalDB];
        }
        else
        {
            
            [self RemoveFavAttendeeFromLocalDB];
            
            //        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
            //
            //        sqlite3_stmt *compiledStmt;
            //        NSLog(@"title is %@",self.btnFav.titleLabel.text);
            //
            //        NSString *strSQL = @"Delete From FavouriteAttendees ";
            //        strSQL = [strSQL stringByAppendingFormat:@"Where AttendeeID = ? "];
            //
            //
            //        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
            //        {
            //            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            //            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            //        }
            //        else
            //        {
            //            sqlite3_bind_int(compiledStmt, 1, [self.attendeeData.strAttendeeID intValue]);
            //
            //            [self.btnFav setTitle:@"Add To Favourites" forState:UIControlStateNormal];
            //            if( SQLITE_DONE != sqlite3_step(compiledStmt) )
            //            {
            //                NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            //                [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            //
            //
            //            }
            //
            //        }
            
            
        }
    }
}

-(void)AddAttendeeOnline
{
    
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_SAVE_FAV_ATTENDEE];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[Functions GetGUID] forHTTPHeaderField:@"LocalId"];
    [objRequest addValue:self.attendeeData.strEmail forHTTPHeaderField:@"FavouriteAttendeeEmail"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:0];
    
}

-(void)RemoveFavAttendeeOnline
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_DELETE_FAV_ATTENDEE];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:self.attendeeData.strEmail forHTTPHeaderField:@"FavouriteAttendeeEmail"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:1];
    
}

- (IBAction)btnTakeNoteClick:(id)sender
{
    
}

- (IBAction)OpenMail:(id)sender
{
 	if([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
		NSString *Subject = @"";
		
		NSString *Body = @"";
        
        [mailer setToRecipients: [[NSArray alloc] initWithObjects:self.attendeeData.strEmail, nil]];
		[mailer setSubject:Subject];
		[mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
		
        [self presentViewController:mailer animated:YES completion:Nil];
	}
    else
    {
        [Functions OpenMailWithReceipient:self.attendeeData.strEmail];
    }
}

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
    
    switch (intTag)
    {
        case 0:
        {
            [self AddFavAttendeeInLocalDB];
            
            break;
        }
        case 1:
        {
            [self RemoveFavAttendeeFromLocalDB];
            
            break;
        }
            
        default:
            break;
    }
    
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
    
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

- (void)noteSaved
{
    btnTakeNotes.hidden = YES;
    btnViewNotes.hidden = NO;
}

@end
