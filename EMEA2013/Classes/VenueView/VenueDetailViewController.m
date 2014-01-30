//
//  VenueDetailViewController.m
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import "VenueDetailViewController.h"
#import "DeviceManager.h"
#import "VenueFloorPlan.h"
#import "Functions.h"
#import "Constants.h"
#import "VenueDB.h"
#import "Venue.h"
#import "VenuesLocation.h"
#import "PlaceMarker.h"
#import "LargeView.h"
#import "MapView.h"
#import "NSString+Custom.h"

@interface VenueDetailViewController ()

@end

@implementation VenueDetailViewController
@synthesize strData, lblSelectedItem, venueScrollView, vwDropdownMenu, blnViewExpanded;
@synthesize imgLogo, lblPhone, lblEmail, lblTimings, lblTitle, venueData, arrFloorPlans, imgFlooPlan;
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
    
    [[self avLoadingVenueImage] startAnimating];
    [[self avLoadingVenurFloorPlan] startAnimating];
    
    VenueDB *objVenueDB = [VenueDB GetInstance];
    self.venueData = [[objVenueDB GetVenues] objectAtIndex:0];
    
    [self populateData];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_VENUE];
    
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

-(void) populateData
{
    if ([DeviceManager IsiPad])
    {
        
    }
    else
    {
        self.lblAddress1.text = [NSString stringWithFormat:@"%@, %@, %@, %@ ", self.venueData.strStreetAddress, self.venueData.strCity, self.venueData.strState, self.venueData.strZipCode] ;
        self.lblAddress2.text = self.venueData.strState;
        self.lblAddress3.text = self.venueData.strCity;
        
        lblTitle.text = self.venueData.strStreetAddress;
        
        lblEmail.text =  self.venueData.strVenuePhone;
        lblPhone.text = self.venueData.strVenueWebsite;
        
        
        lblTimings.text = @"";
        
        NSURL *imgURL = [NSURL URLWithString:self.venueData.strImageURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error){
            if (!error)
            {
                imgLogo.image = [UIImage imageWithData:data];
                [[self avLoadingVenueImage] stopAnimating];
            }
        }];
        
        self.arrFloorPlans = self.venueData.arrFloorPlans;
        
        if([self.arrFloorPlans count] > 0)
        {
            [self setFloorPlanData:0];
        }
        
        self.avLoadingVenurMap = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.avLoadingVenurMap.center = CGPointMake(CGRectGetMidX(self.vwBMap.bounds), CGRectGetMidY(self.vwBMap.bounds));
        self.avLoadingVenurMap.hidesWhenStopped = YES;
        
        [self.vwBMap addSubview:self.avLoadingVenurMap];
        [self.avLoadingVenurMap startAnimating];
        
        BMCoordinateRegion newRegion;
        newRegion.center.latitude = [self.venueData.strLatitude doubleValue];
        newRegion.center.longitude = [self.venueData.strLongitude doubleValue];
        newRegion.span.latitudeDelta = 0.112872;
        newRegion.span.longitudeDelta = 0.109863;
        
        self.mapView = [[BMMapView alloc]initWithFrame:CGRectMake(0, 0, self.vwBMap.frame.size.width, self.vwBMap.frame.size.height)];
        self.mapView.delegate = self;
        [self.vwBMap addSubview:self.mapView];

        [self.mapView setRegion:newRegion animated:NO];
        
        //Add marker
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            VenuesLocation *locationPin=[[VenuesLocation alloc] init:[NSString stringWithFormat:@"%@",self.venueData.strVenueName]];
            CLLocationCoordinate2D coord;
            coord.latitude = newRegion.center.latitude;
            coord.longitude = newRegion.center.longitude;
            [locationPin setCoordinate:coord];
            [self.mapView addMarker:locationPin];
        });
        
        /*if ([self.arrFloorPlans count] > 0) {
            VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:0];
            
            UIScrollView *imgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 360)];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.svwImgFloor.frame.size.width, self.svwImgFloor.frame.size.height)];
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
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadLargeView:)];
            
            [imgScroll addGestureRecognizer:singleTap];
            [self.vwFloorPlan addSubview:imgScroll];
        }*/

        UITapGestureRecognizer *singleFloorPlanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadLargeView:)];
        [self.svwImgFloor addGestureRecognizer:singleFloorPlanTap];
        
        //UITapGestureRecognizer *singleMapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMapView:)];
        //[self.vwBMap addGestureRecognizer:singleMapTap];
    }
}





#pragma mark BingmapEvent
- (BMMarkerView *)mapView:(BMMapView *)bingmapView viewForMarker:(id <BMMarker>)marker
{
    static NSString* SpaceNeedleMarkerIdentifier = @"venueLocation";
    BMMarkerView* pinView = (BMMarkerView *)[bingmapView dequeueReusableMarkerViewWithIdentifier:SpaceNeedleMarkerIdentifier];

    if (!pinView)
    {
        BMPushpinView* customPinView = [[BMPushpinView alloc]
                                        initWithMarker:marker reuseIdentifier:SpaceNeedleMarkerIdentifier];
        customPinView.pinColor = BMPushpinColorRed;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.enabled=YES;
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(loadMapView:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.calloutAccessoryView2 = rightButton;
        
        return customPinView;
    }
    else
    {
        pinView.marker= marker;
    }
    return pinView;
}

- (void)mapViewDidFinishLoadingMap:(BMMapView *)mapView
{
    [[self avLoadingVenurMap] stopAnimating];
}
#pragma mark -

- (void)loadLargeView:(UITapGestureRecognizer *)gesture
{

    
    LargeView *vcLargeView;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];
    }
    
    vcLargeView.imgSource = self.imgFlooPlan.image;
    [[self navigationController] pushViewController:vcLargeView animated:YES];
}

- (void)loadMapView:(id)sender
{
    if([NSString IsEmpty:self.venueData.strCity shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.venueData.strState shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.venueData.strZipCode shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.venueData.strStreetAddress shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.venueData.strLatitude shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.venueData.strLongitude shouldCleanWhiteSpace:YES])
    {
        return;
    }
    
    MapView *vcMapView;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcMapView = [storyboard instantiateViewControllerWithIdentifier:@"idMapView"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcMapView = [storyboard instantiateViewControllerWithIdentifier:@"idMapView"];
    }
    
    vcMapView.strPlace = self.venueData.strVenueName;
    
    vcMapView.strCity = self.venueData.strCity;
    vcMapView.strState = self.venueData.strState;
    vcMapView.strPostalCode = self.venueData.strZipCode;
    vcMapView.strStreetAddress = self.venueData.strStreetAddress;
    vcMapView.strCountry = @"";

    vcMapView.strLat = self.venueData.strLatitude;
    vcMapView.strLon = self.venueData.strLongitude;
    vcMapView.blnLatLonAvailable = YES;
    
    [[self navigationController] pushViewController:vcMapView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    //[self.venueScrollView setContentSize:CGSizeMake(960, self.venueScrollView.frame.size.height)];
    [self.venueScrollView setContentSize:CGSizeMake(960, 460)];
    /*if ([DeviceManager IsiPad]) {
        [self.svwSpeakerDetail setContentSize:CGSizeMake(1536, self.svwSpeakerDetail.frame.size.height)];
    }*/
}

- (IBAction)btnBackClicked:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showDropdownMenu:(id)sender
{
    if (blnViewExpanded)
    {
        [self ShrinkView];
    }
    else
    {
        [self expandView];
    }
}

- (IBAction)MakePhoneCall:(id)sender
{
    [Functions MakePhoneCall:self.venueData.strVenuePhone];
}

- (IBAction)OpenWebsite:(id)sender
{
    [Functions OpenWebsite:self.venueData.strVenueWebsite];
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

- (IBAction)OpenMapView:(id)sender
{
    [self loadMapView:sender];
}

- (void)expandView
{
    //NSLog(@"%d",self.arrFloorPlans.count * 44);
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), self.arrFloorPlans.count * 44);
        
    } completion:nil];
 
    blnViewExpanded = YES;
}

- (void)ShrinkView
{
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 0);
    } completion:nil];
    
    blnViewExpanded = NO;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self setFloorPlanData:indexPath.row];
}

-(void) setFloorPlanData:(NSInteger)index
{
    VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:index];
    
    [lblSelectedItem setText:objVenueFloorPlan.strBriefDescription];
    
    NSURL *imgURL = [NSURL URLWithString:objVenueFloorPlan.strImageURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error)
    {
        if (!error)
        {
            imgFlooPlan.image = [UIImage imageWithData:data];
        }
        [[self avLoadingVenurFloorPlan] stopAnimating];
    }];
}

#pragma mark Mail Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
    {
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
		break;
    }
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}
#pragma mark -
@end
