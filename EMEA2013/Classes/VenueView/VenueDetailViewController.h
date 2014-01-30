//
//  VenueDetailViewController.h
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Venue.h"
#import "BingMaps.h"

@interface VenueDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BMMapViewDelegate, MFMailComposeViewControllerDelegate>
{
    BMMapView *mapView;
}
@property (nonatomic, retain) NSString *strData;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedItem;
@property (strong, nonatomic) IBOutlet UIScrollView *venueScrollView;
@property (strong, nonatomic) IBOutlet UIView *vwDropdownMenu;
@property (nonatomic, assign) BOOL blnViewExpanded;
@property (strong, nonatomic) IBOutlet UIWebView *mapWebView;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblTimings;
@property (strong, nonatomic) Venue *venueData;
@property (strong, nonatomic) NSArray *arrFloorPlans;
@property (strong, nonatomic) IBOutlet UIImageView *imgFlooPlan;
@property (strong, nonatomic) IBOutlet UIView *vwBMap;
@property (nonatomic,retain) BMMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress3;
@property (strong, nonatomic) IBOutlet UIScrollView *svwImgFloor;
@property (strong, nonatomic) IBOutlet UIView *vwFloorPlan;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingVenueImage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingVenurFloorPlan;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingVenurMap;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
- (IBAction)OpenWebsite:(id)sender;
- (IBAction)OpenMail:(id)sender;
- (IBAction)OpenMapView:(id)sender;
@end
