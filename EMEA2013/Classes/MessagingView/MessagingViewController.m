//
//  MessagingViewController.m
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MessagingViewController.h"
#import "MessagingDB.h"
#import "Message.h"
#import "MessageCell.h"
#import "DeviceManager.h"
#import "ComposeViewController.h"
#import "MessageDetailViewController.h"
#import "User.h"
#import "Constants.h"
#import "NSURLConnection+Tag.h"
#import "Shared.h"
#import "AppDelegate.h"

@interface MessagingViewController ()

@end

@implementation MessagingViewController
#pragma mark Synthesize
@synthesize objConnection, objData, dictData;
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
	// Do any additional setup after loading the view.
    
    [[[self btnCompose] layer] setBorderWidth:2.0f];
    [[[self btnCompose] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnCompose] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnCompose] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [self SyncMessages];
    
    //[UIView addTouchEffect:self.view];    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self ShowMessages];
}

-(void)viewDidLayoutSubviews{
    [self.svwMessaging setContentSize:CGSizeMake(960, self.svwMessaging.frame.size.height)];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tvInbox) {
        return [self.arrInboxItems count];
    }
    else if (tableView == self.tvSentbox) {
        return [self.arrSentboxItems count];
    }
    else if (tableView == self.tvDraftbox) {
        return [self.arrDraftItems count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Message *objMessage;
    if (tableView == self.tvInbox)
    {
        objMessage = [self.arrInboxItems objectAtIndex:indexPath.row];
        cell.lblAttendeeName.text = objMessage.strFromAttendeeName;
    }
    else if (tableView == self.tvSentbox)
    {
        objMessage = [self.arrSentboxItems objectAtIndex:indexPath.row];
        cell.lblAttendeeName.text = objMessage.strToAttendeeName;
    }
    else if (tableView == self.tvDraftbox)
    {
        objMessage = [self.arrDraftItems objectAtIndex:indexPath.row];
        cell.lblAttendeeName.text = objMessage.strToAttendeeName;
    }
    
    cell.lblSubject.text = objMessage.strMessageSubject;
    cell.lblMessage.text = objMessage.strAttendeeMessage;
    
    //NSLog(@"%@",objMessage.strCreatedDate);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *dbdate = [dateFormat dateFromString:objMessage.strCreatedDate];

    [dateFormat setDateFormat:@"EEEE, dd"];
    cell.lblDate1.text = [dateFormat stringFromDate:dbdate];
    [dateFormat setDateFormat:@"MMMM."];
    cell.lblDate2.text = [dateFormat stringFromDate:dbdate];
    [dateFormat setDateFormat:@"HH:mm a"];
    cell.lblDate3.text = [dateFormat stringFromDate:dbdate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self ShrinkView];
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *storyboard;
    Message *objMessage;
    
    if([DeviceManager IsiPad] == YES)
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
    }
    
    if (tableView == self.tvDraftbox)
    {
        ComposeViewController *controller;
        objMessage = [self.arrDraftItems objectAtIndex:indexPath.row];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idCompose"];
        controller.intDraftMessageID =  [objMessage.strMessageID intValue];
        controller.selectedMessage = objMessage;
        
        [[self navigationController] pushViewController:controller animated:YES];
    }
    else if(tableView == self.tvInbox)
    {
        MessageDetailViewController *controller;
        objMessage = [self.arrInboxItems objectAtIndex:indexPath.row];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idMessageDetail"];
        controller.selectedMessage = objMessage;
        controller.blnIsInboxMessage = YES;
        
        [[self navigationController] pushViewController:controller animated:YES];
    }
    else if(tableView == self.tvSentbox)
    {
        MessageDetailViewController *controller;
        objMessage = [self.arrSentboxItems objectAtIndex:indexPath.row];
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idMessageDetail"];
        controller.selectedMessage = objMessage;
        controller.blnIsSentboxMessage = YES;
    
        [[self navigationController] pushViewController:controller animated:YES];
    }
}
#pragma mark - 

#pragma mark View Methods
- (void)ShowMessages
{
    MessagingDB *objMessagingDB = [MessagingDB GetInstance];
    
    if (self.arrInboxItems == nil)
    {
        self.arrInboxItems = [[NSArray alloc] init];
    }
    self.arrInboxItems = [objMessagingDB GetInboxMessages];

    
    if (self.arrSentboxItems == nil)
    {
        self.arrSentboxItems = [[NSArray alloc] init];
    }
    self.arrSentboxItems = [objMessagingDB GetSentboxMessages];
    
    if (self.arrDraftItems == nil)
    {
        self.arrDraftItems = [[NSArray alloc] init];
    }
    self.arrDraftItems = [objMessagingDB GetDraftMessages];

    [self.tvInbox reloadData];
    [self.tvSentbox reloadData];
    [self.tvDraftbox reloadData];
}

- (void)SyncMessages
{
    Shared *objShared = [Shared GetInstance];
    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        //[self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        [self ShowMessages];
//        return;
//    }
    if (!APP.netStatus) {
        NETWORK_ALERT();
        [self ShowMessages];
        return;
    }
    
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_GET_MESSAGING_LIST];
    
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
    [objRequest addValue:[NSString stringWithFormat:@"0"] forHTTPHeaderField:@"MaxMessageId"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_MESSAGING_LIST];
}

- (void)SetMessages
{
    MessagingDB *objMessagingDB = [[MessagingDB alloc] init];
    BOOL blnResult = [objMessagingDB SetMessages:objData];
    NSLog(blnResult?@"Messages: YES":@"Messages: NO");
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
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_GET_MESSAGING_LIST:
            {
                [self SetMessages];
                
                [self ShowMessages];
                
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
@end
