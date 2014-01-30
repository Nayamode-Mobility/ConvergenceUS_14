//
//  VenuesViewController.m
//  Venues
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//
#define iPhone_Item_Width 250.0
#define iPhone_Item_Height 100.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 150.0
#define iPad_Item_Height 120.0
#define iPad_NO_of_Rows 3.0

#import "VenuesViewController.h"
#import "CustomCollectionViewCell.h"
#import "DeviceManager.h"
#import "VenueDetailViewController.h"
#import "VenueDB.h"
#import "Venue.h"
#import "VenueFloorPlan.h"
#import "Functions.h"
#import "PlaceMarker.h"

@interface VenuesViewController ()

@end

@implementation VenuesViewController
@synthesize  items, intSelectedIndex, lblVenue, venuesData;
@synthesize imgLogo, lblAddressLine1, lblAddressLine2, lblPhone, lblWebsite, lblSelectedItem;
@synthesize vwDropdownMenu, blnViewExpanded, arrFloorPlans, floorTableView, imgFloorPlan;
@synthesize mapView, vwBMap;

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
    if (items == nil) {
        items = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",nil] ;
    }
    if ([DeviceManager IsiPad]) {
        [self.venueScrollView setContentSize:CGSizeMake(1100, self.venueScrollView.frame.size.height)];
    }
    
    if (self.venuesData == nil) {
        self.venuesData = [[NSArray alloc] init];
    }
    
    VenueDB *objVenueDB = [VenueDB GetInstance];
    self.venuesData = [objVenueDB GetVenues];
    if ([DeviceManager IsiPad]) {
        if ([self.venuesData count]> 0) {
            [self setDataForIndex:0];
        }
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
    VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:indexPath.row];
    cell.textLabel.text = objVenueFloorPlan.strBriefDescription;

    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self setFloorPlanData:indexPath.row];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"loadVenueDetail"]) {
        CustomCollectionViewCell *venueCell = (CustomCollectionViewCell *)sender;
        VenueDetailViewController *controller = segue.destinationViewController;
        controller.venueData = (Venue *)venueCell.cellData;
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
    Venue *objVenue = [self.venuesData objectAtIndex:index];
    lblVenue.text = objVenue.strVenueName;
    lblAddressLine1.text = [NSString stringWithFormat:@"%@, %@, %@, %@ ", objVenue.strStreetAddress, objVenue.strCity, objVenue.strState, objVenue.strZipCode] ;
    //lblAddressLine1.text = objVenue.strStreetAddress;
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
    
    PlaceMarker *locationPin=[[PlaceMarker alloc] init:objVenue.strVenueName];
    CLLocationCoordinate2D coord;
    coord.latitude = newRegion.center.latitude;
    coord.longitude = newRegion.center.longitude;
    [locationPin setCoordinate:coord];
    [self.mapView addMarker:locationPin];
    
    /*if ([self.arrFloorPlans count] > 0) {
        VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:0];
        
        UIScrollView *imgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 360)];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgScroll.frame.size.width, imgScroll.frame.size.height)];
        img.tag = 100;
        img.contentMode = UIViewContentModeScaleAspectFit;
        
        NSURL *imgURL = [NSURL URLWithString:objVenueFloorPlan.strImageURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                   NSData *data,
                                                                                                                   NSError *error){
            if (!error)
            {
                img.image = [UIImage imageWithData:data];
            }
        }];
        [imgScroll addSubview:img];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        
        [imgScroll addGestureRecognizer:singleTap];
        [self.vwFloorPan addSubview:imgScroll];
    }*/
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.svwFloorPlan addGestureRecognizer:singleTap];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    UIScrollView *scroll = (UIScrollView *) gesture.view;
    //UIImageView *img = (UIImageView *)[self.view viewWithTag:100];
    
    if (self.imgFloorPlan.frame.size.width == self.imgFloorPlan.image.size.width) {
        CGSize size = scroll.frame.size;
        [scroll setContentSize:size];
        self.imgFloorPlan.frame = CGRectMake(0, 0, size.width, size.height);
    }
    else{
        [scroll setContentSize:self.imgFloorPlan.image.size];
        self.imgFloorPlan.frame = CGRectMake(0, 0, self.imgFloorPlan.image.size.width, self.imgFloorPlan.image.size.height);
    }
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
