//
//  MapView.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MapView.h"
#import "DeviceManager.h"
#import "VenuesLocation.h"
#import "PlaceMarker.h"

@interface MapView ()
{
    NSMutableArray *pinMarker;
    
     BOOL blnMarkersAdded;
}
@end

@implementation MapView

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
    
    blnMarkersAdded = NO;
    
    [self.vwBMap setHidden:YES];
    
    //self.avLoadingVenueMap = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   // self.avLoadingVenueMap.center = CGPointMake(CGRectGetMidX(self.vwBMap.bounds), CGRectGetMidY(self.vwBMap.bounds));
   // self.avLoadingVenueMap.hidesWhenStopped = YES;
    
   // [self.vwBMap addSubview:self.avLoadingVenueMap];
    
    
    
    [self.avLoadingVenueMap startAnimating];
    
    pinMarker =[[NSMutableArray alloc] init];    
    
    if(self.blnLatLonAvailable == YES)
    {
        [self LoadMap];
    }
    else
    {
        [self GetLatLonFromAddress];
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

- (IBAction)btnBackClicked:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self GoBack];
}

- (void)GoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark BingmapEvent
- (BMMarkerView *)mapView:(BMMapView *)bingmapView viewForMarker:(id <BMMarker>)marker
{
    static NSString* SpaceNeedleMarkerIdentifier = @"venueLocation";
    BMMarkerView* pinView = (BMMarkerView *)[bingmapView dequeueReusableMarkerViewWithIdentifier:SpaceNeedleMarkerIdentifier];

    if(!pinView)
    {
        BMPushpinView* customPinView = [[BMPushpinView alloc]
                                        initWithMarker:marker reuseIdentifier:SpaceNeedleMarkerIdentifier];
        customPinView.pinColor = BMPushpinColorRed;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.enabled = YES;
        
        return customPinView;
    }
    else
    {
        pinView.marker = marker;
    }

    return pinView;
}

- (void)mapViewDidFinishLoadingMap:(BMMapView *)mapView
{
    
    if(blnMarkersAdded == YES)
    {
        return;
    }
    
    BMCoordinateRegion newRegion;
    
    newRegion.center.latitude = [self.strLat doubleValue];
    newRegion.center.longitude = [self.strLon doubleValue];
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    //Add marker
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        VenuesLocation *locationPin=[[VenuesLocation alloc] init:[NSString stringWithFormat:@"%@",self.strPlace]];
        CLLocationCoordinate2D coord;
        coord.latitude = newRegion.center.latitude;
        coord.longitude = newRegion.center.longitude;
        [locationPin setCoordinate:coord];
        
        //[self.mapView addMarker:locationPin];
        
        [pinMarker addObject:locationPin];
        [self.mapView addMarkers:pinMarker];
        
         blnMarkersAdded = YES;
        
    });
    
    delayInSeconds = 5.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self.vwBMap setHidden:NO];
                       self.mapView.zoomEnabled = YES;
                       [[self avLoadingVenueMap] stopAnimating];
                   });
    
    
   // [[self avLoadingVenueMap] stopAnimating];
}

/*
 - (void)mapView:(BMMapView *)mapView didAddMarkerViews:(NSArray *)views
 {
 [self.avLoadingVenueMap stopAnimating];
 [self.vwBMap setHidden:NO];
 self.mapView.zoomEnabled = YES;
 }
 */

#pragma mark -

#pragma mark View Methods
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

- (void)LoadMap
{
    BMCoordinateRegion newRegion;

    newRegion.center.latitude = [self.strLat doubleValue];
    newRegion.center.longitude = [self.strLon doubleValue];
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    self.mapView = [[BMMapView alloc]initWithFrame:CGRectMake(0, 0, self.vwBMap.frame.size.width, self.vwBMap.frame.size.height)];
    [self.mapView setBackgroundColor:[UIColor clearColor]];

    self.mapView.delegate = self;
    self.mapView.zoomEnabled = NO;
    
    [self.vwBMap addSubview:self.mapView];
    
    [self.mapView setRegion:newRegion animated:NO];
    
    /*
    //Add marker
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        VenuesLocation *locationPin=[[VenuesLocation alloc] init:[NSString stringWithFormat:@"%@",self.strPlace]];
        CLLocationCoordinate2D coord;
        coord.latitude = newRegion.center.latitude;
        coord.longitude = newRegion.center.longitude;
        [locationPin setCoordinate:coord];
        
        //[self.mapView addMarker:locationPin];
        
        [pinMarker addObject:locationPin];
        [self.mapView addMarkers:pinMarker];
    });
    */
}

- (void)GetLatLonFromAddress
{
    NSString *strURL = @"http://dev.virtualearth.net/REST/v1/Locations?";
    strURL = [strURL stringByAppendingString:@"countryRegion="];
    strURL = [strURL stringByAppendingString:[self urlencode:[self.strCountry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    strURL = [strURL stringByAppendingString:@"&adminDistrict="];
    strURL = [strURL stringByAppendingString:[self urlencode:[self.strState stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    strURL = [strURL stringByAppendingString:@"&locality="];
    strURL = [strURL stringByAppendingString:[self urlencode:[self.strCity stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    strURL = [strURL stringByAppendingString:@"&postalCode="];
    strURL = [strURL stringByAppendingString:[self urlencode:[self.strPostalCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    strURL = [strURL stringByAppendingString:@"&addressLine="];
    strURL = [strURL stringByAppendingString:[self urlencode:[self.strStreetAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    strURL = [strURL stringByAppendingString:@"&key="];
    strURL = [strURL stringByAppendingString:BING_MAP_KEY];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"GET"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES];
}

- (NSString *)urlencode:(NSString*)str
{
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) str,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    return escapedString;
}

- (void)LoadMapError
{
    [self showAlert:@"" withMessage:@"Could not locate this address." withButton:@"OK" withIcon:nil];
    [[self avLoadingVenueMap] stopAnimating];
    
    [self performSelector:@selector(GoBack) withObject:nil afterDelay:1.0];
    //[self.navigationController popViewControllerAnimated:YES];
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
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        NSString *strStatusCode = @"";
        
        strStatusCode = [NSString stringWithFormat:@"%d",[[dictData objectForKey:@"statusCode"] intValue]];
        
        if([strStatusCode isEqualToString:@"200"])
        {
            NSArray *arrResources = [dictData objectForKey:@"resourceSets"];

            NSUInteger intEstimatedTotal = [[[arrResources objectAtIndex:0] objectForKey:@"estimatedTotal"] intValue];
            if(intEstimatedTotal > 0)
            {
                NSArray *arrResource = [[arrResources objectAtIndex:0] objectForKey:@"resources"];
                NSDictionary *dictPoint = [[arrResource objectAtIndex:0] objectForKey:@"point"];
                NSArray  *arrCoordinates = [dictPoint objectForKey:@"coordinates"];
                
                self.strLat = arrCoordinates[0];
                self.strLon = arrCoordinates[1];
                
                [self LoadMap];
            }
            else
            {
                [self LoadMapError];
            }
        }
        else
        {
            [self LoadMapError];            
        }
    }
}
#pragma mark -

@end
