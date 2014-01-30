//
//  MapView.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingMaps.h"
#import "Venue.h"

@interface MapView : UIViewController <BMMapViewDelegate,NSURLConnectionDelegate>
{
}

@property (strong, nonatomic) IBOutlet UIView *vwBMap;
@property (nonatomic,retain) BMMapView *mapView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingVenueMap;

@property (nonatomic,retain) NSString *strPlace;

@property (nonatomic,retain) NSString *strCity;
@property (nonatomic,retain) NSString *strState;
@property (nonatomic,retain) NSString *strPostalCode;
@property (nonatomic,retain) NSString *strLat;
@property (nonatomic,retain) NSString *strLon;
@property (nonatomic,retain) NSString *strStreetAddress;
@property (nonatomic,retain) NSString *strCountry;

@property (nonatomic) BOOL blnLatLonAvailable;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

- (IBAction)btnBackClicked:(id)sender;
@end
