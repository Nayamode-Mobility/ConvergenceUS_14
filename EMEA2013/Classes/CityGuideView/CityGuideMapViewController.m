//
//  CityGuideMapViewController.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "CityGuideMapViewController.h"
#import "DeviceManager.h"
#import "VenuesLocation.h"
#import "PlaceMarker.h"
#import "SyncUp.h"
#import "User.h"
#import "Constants.h"
@interface CityGuideMapViewController ()
{
    NSMutableArray *pinMarker;
}
@property (strong, nonatomic) IBOutlet UIView *vwBMap;
@property (nonatomic,retain) BMMapView *searchMapView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableData *objData;
//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actLoader;
@end

@implementation CityGuideMapViewController

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
    //self.actLoader=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //self.actLoader.center=self.view.center;
    
 //   self.actLoader.center=CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
 //   self.actLoader.hidesWhenStopped=YES;
 //   [self.view addSubview:self.actLoader];
//    [self.actLoader startAnimating];

    [self.actLoader startAnimating];
    pinMarker =[[NSMutableArray alloc] init];
    
    [self populateData];

    [Analytics AddAnalyticsForScreen:strSCREEN_CITY_GUIDE_MAP];
    
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
#pragma mark Page events
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark page methods
-(void) populateData{
    [self.lblTitle setText: [self.pageTitle objectForKey:@"Title"]];
    
    
    if([DeviceManager IsiPad] == YES)
    {
        self.searchMapView = [[BMMapView alloc]initWithFrame:CGRectMake(0, 0, 716, 557)];//ToDo remove hardcoding
        
    }else
    {
        self.searchMapView = [[BMMapView alloc]initWithFrame:CGRectMake(0, 0, self.vwBMap.frame.size.width, self.vwBMap.frame.size.height)];
    }
    
    self.searchMapView.delegate = self;
    
    [self.vwBMap addSubview:self.searchMapView];
    
    BMCoordinateRegion newRegion;
    newRegion.center.latitude = [self.venueData.strLatitude doubleValue];
    newRegion.center.longitude = [self.venueData.strLongitude doubleValue];
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    
    //Add marker
    [self.searchMapView setRegion:newRegion animated:NO];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        VenuesLocation *locationPin=[[VenuesLocation alloc] init:[NSString stringWithFormat:@"%@",self.venueData.strVenueName]];
        CLLocationCoordinate2D coord;
        coord.latitude = newRegion.center.latitude;
        coord.longitude = newRegion.center.longitude;
        [locationPin setCoordinate:coord];
        
        //[self.searchMapView addMarker:locationPin];
        [self.searchMapView addMarkers:pinMarker];
        [self.actLoader stopAnimating];
    });
    
    if ([DeviceManager IsiPad])
    {
    }
    else
    {
        [self ShowNearest];
    }
}
-(void)ShowNearest
{
    self.actLoader.hidden=NO;
    [self.actLoader startAnimating];
    [self.lblTitle setText: [self.pageTitle objectForKey:@"Title"]];
    NSString *searchFor=[self.pageTitle objectForKey:@"searchInfo"];
    
    [self getPlaces:searchFor];
}

#pragma mark BingmapEvent


- (BMMarkerView *)mapView:(BMMapView *)bingmapView viewForMarker:(id <BMMarker>)marker
{
    if ([marker isKindOfClass:[VenuesLocation class]])
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
            
            /*
             UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
             [rightButton addTarget:self
             action:@selector(showAlert:)
             forControlEvents:UIControlEventTouchUpInside];
             customPinView.calloutAccessoryView2 = rightButton;
             */
            
            return customPinView;
        }
        else
        {
            pinView.marker= marker;
        }
        return pinView;
    }
    else if ([marker isKindOfClass:[PlaceMarker class]])
    {
        static NSString* SpaceNeedleMarkerIdentifier = @"PlaceMarker";
        BMMarkerView* pinView = (BMMarkerView *)[bingmapView dequeueReusableMarkerViewWithIdentifier:SpaceNeedleMarkerIdentifier];
        if (!pinView)
        {
            BMPushpinView* customPinView = [[BMPushpinView alloc]
                                            initWithMarker:marker reuseIdentifier:SpaceNeedleMarkerIdentifier];
            customPinView.pinColor = BMPushpinColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
			customPinView.enabled=YES ;
            
            /*
             UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
             [rightButton addTarget:self
             action:@selector(showAlert:)
             forControlEvents:UIControlEventTouchUpInside];
             customPinView.calloutAccessoryView2 = rightButton;
             */
            
            return customPinView;
        }
        else
        {
            pinView.marker= marker;
        }
        return pinView;
    }
    return nil;
}

#pragma mark API calls

#define kGOOGLE_API_KEY @"AIzaSyCKdcIgrRn-D5b7CdbF6iiDnt8sImPZbU4"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


- (void)getPlaces:(NSString *)searchFor
{
    int currenDist=1500;
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%@,%@&radius=%@&types=%@&sensor=false&key=%@", self.venueData.strLatitude, self.venueData.strLongitude, [NSString stringWithFormat:@"%i", currenDist], searchFor, kGOOGLE_API_KEY];
    
    NSLog(@"Latitiude is %@",self.venueData.strLatitude);
    NSLog(@"Longitude is %@",self.venueData.strLongitude);
    

    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData
{
    
    /*NSMutableArray *deleteList=[[NSMutableArray alloc] init];
     for (id object in self.searchMapView.markers)
     {
     // do something with object
     //if (![object isKindOfClass:[VenuesLocation class]])
     //{
     //[self.searchMapView  removeMarker:object ];
     [deleteList addObject:object];
     //}
     }
     
     if([deleteList count]>0)
     {
     [self.searchMapView removeMarkers:deleteList];
     }*/
    [self.searchMapView removeMarkers:pinMarker];
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    for (NSDictionary *item in places) {
        NSDictionary *geometry=[item objectForKey:@"geometry"];
        NSDictionary *location=[geometry objectForKey:@"location"];
        double lat=[[location objectForKey:@"lat"] doubleValue];
        double lng=[[location objectForKey:@"lng"] doubleValue];
        NSString *name=[item objectForKey:@"name"];
        
        PlaceMarker *locationPin=[[PlaceMarker alloc] init:name];
        CLLocationCoordinate2D coord;
        //latitude = 41.6544800119209
        //longitude = 2.42698001192093
        //41.654702,2.427964
        coord.latitude = lat;
        coord.longitude =  lng;
        [locationPin setCoordinate:coord];
        //locationPin.title=@"sameer";
        [pinMarker addObject:locationPin];
        //[self.searchMapView addMarker:locationPin];
        
    }
    BMCoordinateRegion newRegion;
    newRegion.center.latitude = [self.venueData.strLatitude doubleValue];
    newRegion.center.longitude = [self.venueData.strLongitude doubleValue];
    VenuesLocation *locationPin=[[VenuesLocation alloc] init:[NSString stringWithFormat:@"%@",self.venueData.strVenueName]];
    CLLocationCoordinate2D coord;
    coord.latitude = newRegion.center.latitude;
    coord.longitude = newRegion.center.longitude;
    [locationPin setCoordinate:coord];
    [pinMarker addObject:locationPin];
    
    
    
    
    //[self.searchMapView addMarker:locationPin];
    //[self.searchMapView addMarkers:pinMarker];
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
}

#pragma mark Connections Events

@end
