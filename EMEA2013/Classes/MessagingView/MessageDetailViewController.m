//
//  MessageDetailViewController.m
//  mgx2013
//
//  Created by Amit Karande on 28/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "ComposeViewController.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Shared.h"
#import "User.h"
#import "NSURLConnection+Tag.h"
#import "MessagingDB.h"
#import "AppDelegate.h"


@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController
@synthesize objConnection, objData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[[self btnReply] layer] setBorderWidth:2.0f];
    [[[self btnReply] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnReply] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnReply] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnForward] layer] setBorderWidth:2.0f];
    [[[self btnForward] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnForward] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnForward] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnDelete] layer] setBorderWidth:2.0f];
    [[[self btnDelete] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnDelete] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnDelete] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self populateData];
    
    //[UIView addTouchEffect:self.view];    
}

-(void)populateData
{
    self.lblFrom.text = [NSString stringWithFormat:@"From: %@", self.selectedMessage.strFromAttendeeName];
    self.lblTo.text = [NSString stringWithFormat:@"To: %@",self.selectedMessage.strToAttendeeName];
    self.lblSubject.text = self.selectedMessage.strMessageSubject;
    self.lblMessage.text = self.selectedMessage.strAttendeeMessage;
    CGSize expectedLabelSize = [self.lblMessage.text sizeWithFont:self.lblMessage.font
                                                            constrainedToSize:CGSizeMake(280,1000)
                                                                lineBreakMode:NSLineBreakByWordWrapping];
    self.lblMessage.numberOfLines = 0;
    self.lblMessage.frame = CGRectMake(self.lblMessage.frame.origin.x, self.lblMessage.frame.origin.y, 280, expectedLabelSize.height);
    self.vwButtons.frame = CGRectMake(self.vwButtons.frame.origin.x, (self.lblMessage.frame.origin.y+ expectedLabelSize.height + 20), self.vwButtons.frame.size.width, self.vwButtons.frame.size.height);
    [self.svwMessageDetail setContentSize:CGSizeMake(320, (self.vwButtons.frame.origin.y + self.vwButtons.frame.size.height + 10))];
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

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ReplyClicked:(id)sender
{
    [self redirectToComposeScreen:1];
}

- (IBAction)ForwardClicked:(id)sender
{
    [self redirectToComposeScreen:2];
}

- (IBAction)DeleteClicked:(id)sender
{
   // Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    NSString *strURL = strAPI_URL;
    User *objUser = [User GetInstance];

    if(self.blnIsInboxMessage)
    {
        strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_DELETE_INBOX_MESSAGE];
    }
    else
    {
        strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_DELETE_SENTBOX_MESSAGE];
    }
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    [objRequest addValue:self.selectedMessage.strMessageID forHTTPHeaderField:@"MessageID"];
    
    if (self.blnIsInboxMessage)
    {
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ATTENDEE_DELETE_INBOX_MESSAGE];
    }
    else{
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ATTENDEE_DELETE_SENTBOX_MESSAGE];
    }
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSInteger intTag = (int)[connection getTag];
    MessagingDB *objMessageDB = [MessagingDB GetInstance];
    if (intTag == OPER_ATTENDEE_DELETE_INBOX_MESSAGE) {
        [objMessageDB DeleteMessage:self.selectedMessage.strMessageID TableName:@"Inbox"];
        [self showAlert:@"Complete" withMessage:@"Inbox message has been successfully deleted!" withButton:@"OK" withIcon:nil];
    }
    else{
        [objMessageDB DeleteMessage:self.selectedMessage.strMessageID TableName:@"Sentbox"];
        [self showAlert:@"Complete" withMessage:@"Sentbox message has been successfully deleted!" withButton:@"OK" withIcon:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) redirectToComposeScreen:(NSInteger)intValue
{
    UIStoryboard *storyboard;
    if([DeviceManager IsiPad] == YES)
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
    }
    
    ComposeViewController *controller;
    controller = [storyboard instantiateViewControllerWithIdentifier:@"idCompose"];
    controller.selectedMessage = self.selectedMessage;
    controller.blnIsInboxMessage = self.blnIsInboxMessage;
    controller.blnIsSentboxMessage = self.blnIsSentboxMessage;
    controller.blnIsDraftMessage = self.blnIsDraftMessage;
    
    switch (intValue) {
        case 1:
            controller.blnIsReply = YES;
            break;
        case 2:
            controller.blnIsForward = YES;
            break;
        default:
            break;
    }
    [[self navigationController] pushViewController:controller animated:YES];
}
@end
