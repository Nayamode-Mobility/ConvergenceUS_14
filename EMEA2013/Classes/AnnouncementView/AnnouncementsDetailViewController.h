//
//  VenueDetailViewController.h
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Announcement.h"
#import "BingMaps.h"

@interface AnnouncementsDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, BMMapViewDelegate, MFMailComposeViewControllerDelegate>
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
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementTopic;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementTimeDiff;
@property (weak, nonatomic) IBOutlet UIScrollView *messageScrollview;

@property (strong, nonatomic) Announcement *announcementData;
@property (strong, nonatomic) NSArray *arrFloorPlans;
@property (strong, nonatomic) IBOutlet UIImageView *imgFlooPlan;
@property (strong, nonatomic) IBOutlet UIView *vwBMap;
@property (nonatomic,retain) BMMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIView *vwSocialMedia;
- (IBAction)btnSocialMediaClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)OpenMail:(id)sender;
@end
