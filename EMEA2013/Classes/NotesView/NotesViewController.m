//
//  NotesViewController.m
//  mgx2013
//
//  Created by Amit Karande on 16/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "NotesViewController.h"
#import "NotesDB.h"
#import "UserSessionNotes.h"
#import "UserSessionNoteCell.h"
#import "User.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "Functions.h"
#import "FBJSON.h"
#import "DeviceManager.h"
#import "Shared.h"
#import "AppDelegate.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize objConnection, objData;
@synthesize btnSyncNotes, btnTakeNotes;

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
    
    //self.arrNotes = [objNoteDB GetUserSessionNotes];
    
    [[btnSyncNotes layer] setBorderWidth:2.0f];
    [[btnSyncNotes layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [btnSyncNotes addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnSyncNotes addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[btnTakeNotes layer] setBorderWidth:2.0f];
    [[btnTakeNotes layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [btnTakeNotes addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [btnTakeNotes addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_USER_NOTE];
    
    if(![NSString IsEmpty:self.strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        self.lblPageTitle.text = @"SESSION NOTES";
    }
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.arrNotes == nil)
    {
        self.arrNotes = [[NSArray alloc] init];
    }
    
    NotesDB *objNoteDB = [NotesDB GetInstance];

    //if(self.sessionData)
    if(![NSString IsEmpty:self.strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        self.arrNotes = [objNoteDB GetUserSessionNoteWithSessionInstanceID:self.sessionData.strSessionInstanceID];
    }
    else
    {
        self.sessionData = nil;
        self.arrNotes = [objNoteDB GetUserSessionNotes];
    }

    [self.colNotes reloadData];
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

- (IBAction)SyncNotes:(id)sender
{
    //Shared *objShared = [Shared GetInstance];
    
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    
    NotesDB *objNotesDB = [NotesDB GetInstance];
    NSString *strMyNotes = [objNotesDB GetMyNotesJSON];
    //NSLog(@"%@",strMyNotes);
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_NOTES_ADD_NOTE];
    
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
    [objRequest addValue:strMyNotes forHTTPHeaderField:@"NotesJSON"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_NOTE_LIST];
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
    //NSLog(@"Connection Tag: %d",intTag);
    
    //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    NSError * error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    switch (intTag)
    {
        case OPER_ADD_NOTE_LIST:
            {
                if([dictData valueForKey:@"Message"])
                {
                    
                    NSLog(@"Error Occured");
                    
                }
                else
                {
                NotesDB *objNotesDB = [NotesDB GetInstance];
                BOOL blnResult = [objNotesDB SetUserSessionNotes:objData];
                NSLog(blnResult?@"Notes : YES":@"Notes : NO");
                
                //if(self.sessionData)
                if(![NSString IsEmpty:self.strSessionInstanceID shouldCleanWhiteSpace:YES])
                {
                    self.arrNotes = [objNotesDB GetUserSessionNoteWithSessionInstanceID:self.sessionData.strSessionInstanceID];
                }
                else
                {
                    self.sessionData = nil;
                    self.arrNotes = [objNotesDB GetUserSessionNotes];
                }
                }
                
                [[self colNotes] reloadData];
                
                
                [[self vwLoading] setHidden:YES];
                [[self avLoading] stopAnimating];
            }
            break;
        default:
            break;
    }
}
#pragma mark -

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrNotes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UserSessionNoteCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    UserSessionNotes *objUserSessionNotes = [self.arrNotes objectAtIndex:indexPath.row];
    
    if([NSString IsEmpty:objUserSessionNotes.strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        cell.lblCode.hidden = YES;
        cell.lblTitle.hidden = YES;
        
        cell.lblNoteTitle.frame = cell.lblCode.frame;
        cell.lblNoteDescription.frame = cell.lblTitle.frame;
    }
    else
    {
        cell.lblCode.hidden = NO;
        cell.lblTitle.hidden = NO;
        
        cell.lblCode.text = [NSString stringWithFormat:@"Session code: %@",objUserSessionNotes.strSessionCode];
        cell.lblTitle.text = [NSString stringWithFormat:@"Session title: %@",objUserSessionNotes.strSessionTitle];
        
        [cell.lblNoteTitle setFrame:CGRectMake(cell.lblNoteDescription.frame.origin.x, 46,  cell.lblNoteTitle.frame.size.width, cell.lblNoteTitle.frame.size.height)];
        [cell.lblNoteDescription setFrame:CGRectMake(cell.lblNoteDescription.frame.origin.x, 67, cell.lblNoteDescription.frame.size.width, cell.lblNoteDescription.frame.size.height)];
    }
    
    //NSLog(@"%.f",cell.lblNoteDescription.frame.origin.y);
    //NSLog(@"%.f",cell.lblNoteDescription.frame.size.height);

    cell.lblNoteTitle.text = objUserSessionNotes.strTitle;

    [cell.lblNoteDescription setFrame:CGRectMake(cell.lblNoteDescription.frame.origin.x, cell.lblNoteDescription.frame.origin.y, 165.0f, 60.0f)];
    cell.lblNoteDescription.text = objUserSessionNotes.strContent;
    cell.lblNoteDescription.numberOfLines = 3;
    [cell.lblNoteDescription sizeToFit];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dtStartDate = [dateFormater dateFromString:objUserSessionNotes.strUpdatedDate];
    
    [dateFormater setDateFormat:@"EEEE, dd"];
    cell.lblDate1.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    
    [dateFormater setDateFormat:@"MMMM"];
    cell.lblDate2.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    
    [dateFormater setDateFormat:@"hh:mm a"];
    cell.lblDate3.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartDate]];
    
    double dblY = cell.lblNoteDescription.frame.origin.y + cell.lblNoteDescription.frame.size.height;
    if(cell.lblDate3.frame.origin.y > dblY)
    {
        dblY = cell.lblDate3.frame.origin.y + cell.lblDate3.frame.size.height;
    }
    
    //NSLog(@"render %.f",cell.frame.size.height);
    //NSLog(@"render %.f",dblY);
    //if([NSString IsEmpty:objUserSessionNotes.strSessionInstanceID shouldCleanWhiteSpace:YES])
    //{
    //    cell.vwLine.frame = CGRectMake(0, (dblY + 25), 300, 1);
    //}
    //else
    //{
    //    cell.vwLine.frame = CGRectMake(0, (dblY + 10), 300, 1);
    //}
    
    cell.vwLine.frame = CGRectMake(0, (cell.frame.size.height - 1), 300, 1);
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    self.intSelectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"gotoNoteDetail" sender:self];
}

- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    
    UserSessionNotes *objUserSessionNotes = [self.arrNotes objectAtIndex:indexPath.row];
    
    if([NSString IsEmpty:objUserSessionNotes.strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        UIFont *font = [UIFont fontWithName:@"SegoeWP-Bold" size:14.0f];
        
        CGSize expectedLabelSize1 = [objUserSessionNotes.strTitle sizeWithFont:font
                                    constrainedToSize:CGSizeMake(165,21)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        font = [UIFont fontWithName:@"SegoeWP" size:14.0f];
        
        CGSize expectedLabelSize2 = [objUserSessionNotes.strContent sizeWithFont:font
                                    constrainedToSize:CGSizeMake(165,21*3)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        if(expectedLabelSize2.height < 21*2)
        {
            expectedLabelSize2.height = 21*2;
        }
        
        expectedLabelSize.height = expectedLabelSize1.height + expectedLabelSize2.height;
        expectedLabelSize.height = expectedLabelSize.height + 15;
    }
    else
    {
        UIFont *font = [UIFont fontWithName:@"SegoeWP-Bold" size:14.0f];
        
        CGSize expectedLabelSize1 = [objUserSessionNotes.strSessionCode sizeWithFont:font
                                    constrainedToSize:CGSizeMake(165,21)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize expectedLabelSize2 = [objUserSessionNotes.strSessionTitle sizeWithFont:font
                                    constrainedToSize:CGSizeMake(165,21)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize expectedLabelSize3 = [objUserSessionNotes.strTitle sizeWithFont:font
                                    constrainedToSize:CGSizeMake(165,21)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        font = [UIFont fontWithName:@"SegoeWP" size:14.0f];
        
        CGSize expectedLabelSize4 = [objUserSessionNotes.strContent sizeWithFont:font
                                    constrainedToSize:CGSizeMake(165,21*3)
                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        expectedLabelSize.height = expectedLabelSize1.height + expectedLabelSize2.height + expectedLabelSize3.height + expectedLabelSize4.height;
        expectedLabelSize.height = expectedLabelSize.height + 20;
    }
    
    //NSLog(@"size %.f",expectedLabelSize.height);
    return (CGSize) {.width = 280, .height = expectedLabelSize.height};
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gotoNoteDetail"])
    {
        SessionNoteViewController *controller = segue.destinationViewController;
        UserSessionNotes *objUserSessionNote = [self.arrNotes objectAtIndex:self.intSelectedIndex];
        controller.noteData = objUserSessionNote;
        
        if(self.sessionData == nil)
        {
            UserSessionNotes *objUserSessionNotes = [self.arrNotes objectAtIndex:self.intSelectedIndex];
            self.sessionData = [objUserSessionNotes.arrSession objectAtIndex:0];
        }
        
        controller.sessionData = self.sessionData;
        controller.blnNew = NO;
    }
    else if([segue.identifier isEqualToString:@"gotoAddNote"])
    {
        SessionNoteViewController *controller = segue.destinationViewController;
        controller.blnNew = YES;
        
        if(self.sessionData == nil)
        {
        }
        else
        {
            controller.sessionData = self.sessionData;
        }
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
@end
