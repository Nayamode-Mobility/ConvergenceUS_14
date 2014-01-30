//
//  VenuesViewController.h
//  Venues
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "BingMaps.h"

@interface AnnouncementsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, BMMapViewDelegate, MFMailComposeViewControllerDelegate>
{
    BMMapView *mapView;
}
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedItem;
@property (strong, nonatomic) IBOutlet UICollectionView *venuesCollectionView;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (nonatomic, strong) NSArray *items;

@property (strong, nonatomic) IBOutlet UILabel *lblVenue;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementTopic;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementTimeDiff;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementCreated;

@property (strong, nonatomic) IBOutlet UIScrollView *venueScrollView;
@property (strong, nonatomic) IBOutlet UIView *vwFloorPan;
@property (strong, nonatomic) IBOutlet UIView *vwDirection;

@property (nonatomic, strong) NSArray *announcementsData;


@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressLine1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressLine2;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UIView *vwDropdownMenu;
@property (nonatomic, assign) BOOL blnViewExpanded;
@property (strong, nonatomic) NSArray *arrFloorPlans;
@property (strong, nonatomic) IBOutlet UITableView *floorTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgFloorPlan;
@property (strong, nonatomic) IBOutlet UIView *vwBMap;
@property (nonatomic,retain) BMMapView *mapView;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableData *objData;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnFloorplanClicked:(id)sender;
- (IBAction)btnDirectionClicked:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
- (IBAction)OpenWebsite:(id)sender;
- (IBAction)OpenMail:(id)sender;
@end
