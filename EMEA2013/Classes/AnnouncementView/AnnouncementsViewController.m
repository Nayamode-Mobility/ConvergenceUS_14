//
//  AnnouncementsViewController.m
//  Announcements
//
//  Created by Joris Weimar (Clavicode) on 24/10/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#define iPhone_Item_Width 250.0
#define iPhone_Item_Height 100.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 150.0
#define iPad_Item_Height 120.0
#define iPad_NO_of_Rows 3.0

#import "AnnouncementsViewController.h"
#import "CustomCollectionViewCell.h"
#import "DeviceManager.h"
#import "AnnouncementsDetailViewController.h"
#import "AnnouncementDB.h"
#import "Announcement.h"
#import "VenueFloorPlan.h"
#import "Functions.h"
#import "AnnouncementHeaderView.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "User.h"
#import "DB.h"
#import "NSURLConnection+Tag.h"


@interface AnnouncementsViewController ()

@end

@implementation AnnouncementsViewController
@synthesize  items, intSelectedIndex, lblVenue;
@synthesize imgLogo, lblAddressLine1, lblAddressLine2, lblPhone, lblWebsite, lblSelectedItem;
@synthesize vwDropdownMenu, blnViewExpanded, arrFloorPlans, floorTableView, imgFloorPlan;
@synthesize mapView, vwBMap;
@synthesize lblAnnouncementTopic;
@synthesize lblAnnouncementCreated;
@synthesize lblAnnouncementTimeDiff;
@synthesize lblAnnouncementMessage;
@synthesize objConnection,objData;

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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshAnnouncement) name:@"SyncUpCompleted" object:nil];
    
	// Do any additional setup after loading the view.
    if (items == nil) {
        items = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil] ;
    }
    if ([DeviceManager IsiPad]) {
        [self.venueScrollView setContentSize:CGSizeMake(1350, self.venueScrollView.frame.size.height)];
    }
    
    if (self.announcementsData == nil) {
        self.announcementsData = [[NSArray alloc] init];
    }
    
    if (APP.netStatus) {
        
        User *objUser = [User GetInstance];
        DB *objDB = [DB GetInstance];
        NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:strAPI_ANNOUNCEMENT_GET_ANNOUNCEMENT_LIST];
        
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
        [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ANNOUNCEMENT]] forHTTPHeaderField:@"VersionNo"];
        
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ANNOUNCEMENT_LIST];
        
                
    }else{
    AnnouncementDB *objAnnouncementDB = [AnnouncementDB GetInstance];
    self.announcementsData = [objAnnouncementDB GetAnnouncements];
    if ([DeviceManager IsiPad]) {
        if ([self.announcementsData count]> 0) {
            [self setDataForIndex:0];
        }
    }
    }
    [Analytics AddAnalyticsForScreen:strSCREEN_ANNOUNCEMENT];
    
    //[UIView addTouchEffect:self.view];
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
    
    switch (intTag)
    {
        case OPER_GET_ANNOUNCEMENT_LIST:
        {
            AnnouncementDB *objAnnouncementDB = [AnnouncementDB GetInstance];
            self.announcementsData = [objAnnouncementDB GetAnnouncements];
            
           // [[self vwLoading] setHidden:YES];
           // [[self avLoading] stopAnimating];
        }
            break;
        default:
            break;
    }
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

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.announcementsData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Announcement *objAnnouncement = [self.announcementsData objectAtIndex:indexPath.row];
    if ([DeviceManager IsiPad]) {
        cell.lblName.text = objAnnouncement.strAnnouncementTopic;
        cell.lblAnnouncementMessage.text = objAnnouncement.strAnnouncementMessage;
        cell.lblAnnouncementTimeDiff.text = objAnnouncement.strTimeDiff;
        cell.cellData = objAnnouncement;
        
        if(indexPath.row == 0)
        {
            [cell.articleImage setHidden:NO];
        }
    }
    else{
        cell.lblName.text = objAnnouncement.strAnnouncementTopic;
        cell.lblAnnouncementMessage.text = objAnnouncement.strAnnouncementMessage;
        cell.lblAnnouncementTimeDiff.text = objAnnouncement.strTimeDiff;
        
        
        /*NSURL *imgURL = [NSURL URLWithString:objVenue.strImageURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                   NSData *data,
                                                                                                                   NSError *error){
            if (!error) {
                cell.imgLogo.image = [UIImage imageWithData:data];
            }
        }];*/
        cell.cellData = objAnnouncement;
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    intSelectedIndex = indexPath.row;
    if ([DeviceManager IsiPad]) {
        
        [self setDataForIndex:indexPath.row];
        /*
        CustomCollectionViewCell *cell;
        int count = [self.announcementsData count];
        for (NSUInteger i=0; i < count; ++i) {
            cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [cell.articleImage setHidden:YES];
        }
        cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.articleImage setHidden:NO];
        */
        
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
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
    return [self.arrFloorPlans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:indexPath.row];
   // cell.textLabel.text = objVenueFloorPlan.strBriefDescription;
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
 //   [self setFloorPlanData:indexPath.row];
}

- (void)expandView {
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 200);
        
    } completion:nil];
    blnViewExpanded = YES;
}

- (void)ShrinkView {
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 0);
    } completion:nil];
    blnViewExpanded = NO;
}

- (IBAction)showDropdownMenu:(id)sender {
    if (blnViewExpanded) {
        [self ShrinkView];
    }
    else{
        [self expandView];
    }
}

- (IBAction)MakePhoneCall:(id)sender
{
    [Functions MakePhoneCall:self.lblPhone.text];
}

- (IBAction)OpenWebsite:(id)sender
{
    [Functions OpenWebsite:self.lblWebsite.text];
}

- (IBAction)OpenMail:(id)sender
{
    if([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
		NSString *Subject = @"";
		
		NSString *Body = @"";
        
        //[mailer setToRecipients: [[NSArray alloc] initWithObjects:@"", nil]];
		[mailer setSubject:Subject];
		[mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
		
        [self presentViewController:mailer animated:YES completion:Nil];
	}
    else
    {
        [Functions OpenMail];
    }
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    AnnouncementHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:@"AnnouncementHeaderView" forIndexPath:indexPath];
    return headerView;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@", segue.identifier);
    if ([segue.identifier isEqualToString:@"loadAnnouncementDetail"]) {
        CustomCollectionViewCell *announcementCell = (CustomCollectionViewCell *)sender;
        AnnouncementsDetailViewController *controller = segue.destinationViewController;
        controller.announcementData = (Announcement *)announcementCell.cellData;
    }
}


- (void)RefreshAnnouncement
{
    AnnouncementDB *objAnnouncementDB = [AnnouncementDB GetInstance];
    self.announcementsData = [objAnnouncementDB GetAnnouncements];
    if ([DeviceManager IsiPad])
    {
        if ([self.announcementsData count]> 0)
        {
            [self setDataForIndex:0];
        }
    }
    else
    {
        [self.venuesCollectionView reloadData];
    }
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnFloorplanClicked:(id)sender {
    [self.vwFloorPan setHidden:NO];
    [self.vwDirection setHidden:YES];
}

- (IBAction)btnDirectionClicked:(id)sender {
    [self.vwFloorPan setHidden:YES];
    [self.vwDirection setHidden:NO];
}

- (void) setDataForIndex:(NSInteger)index{
    Announcement *objAnnouncement = [self.announcementsData objectAtIndex:index];
   // lblVenue.text = objAnnouncement.strAnnouncementTopic;
   /// lblAnnouncementTopic.text = objAnnouncement.strAnnouncementTopic;
    lblAnnouncementTimeDiff.text = objAnnouncement.strTimeDiff;
    lblAnnouncementMessage.text = objAnnouncement.strAnnouncementMessage;
    
   /* lblAddressLine1.text = objVenue.strStreetAddress;
    lblAddressLine2.text = objVenue.strCity;
    lblWebsite.text = objVenue.strVenueWebsite;
    lblPhone.text = objVenue.strVenuePhone;
    
    NSURL *imgURL = [NSURL URLWithString:objVenue.strImageURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error){
        if (!error) {
            imgLogo.image = [UIImage imageWithData:data];
        }
    }];
    
    self.arrFloorPlans = objVenue.arrFloorPlans;
    [self.floorTableView reloadData];
    if ([self.floorTableView numberOfRowsInSection:0] > 0) {
        [self setFloorPlanData:0];
    }
    
    self.mapView = [[BMMapView alloc]initWithFrame:CGRectMake(0, 0, self.vwBMap.frame.size.width, self.vwBMap.frame.size.height)];
    self.mapView.delegate = self ;
    [self.vwBMap addSubview:self.mapView];
    
    BMCoordinateRegion newRegion;
    newRegion.center.latitude = [objVenue.strLatitude doubleValue];
    newRegion.center.longitude = [objVenue.strLongitude doubleValue];
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion animated:NO];

*/
    
}

-(void) setFloorPlanData:(NSInteger)index{
    VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:index];
    
    [lblSelectedItem setText:objVenueFloorPlan.strBriefDescription];
    NSURL *imgURL = [NSURL URLWithString:objVenueFloorPlan.strImageURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error){
        if (!error) {
            imgFloorPlan.image = [UIImage imageWithData:data];
        }
    }];
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
