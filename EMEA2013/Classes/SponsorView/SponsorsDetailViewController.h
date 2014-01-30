//
//  SponsorsDetailViewController.h
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

#import "Sponsor.h"
#import "Exhibitor.h"

@interface SponsorsDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate>
{
}

@property (nonatomic, retain) NSString *strData;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *vwDropdownMenu;
@property (nonatomic, assign) BOOL blnViewExpanded;
@property (nonatomic, assign) BOOL blnIsExhibitors;
@property (strong, nonatomic) Sponsor *sponsorData;
@property (strong, nonatomic) Exhibitor *exhibitorData;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (strong, nonatomic) IBOutlet UILabel *lblCompanyLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblCompanyInformation;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressLine1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddressLine2;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblBoothLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedItem;
@property (strong, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *svwDetail;
@property (strong, nonatomic) IBOutlet UIView *vwShare;
@property (strong, nonatomic) IBOutlet UIScrollView *svwCategories;
@property (strong, nonatomic) IBOutlet UICollectionView *colResources;
@property (strong, nonatomic) NSArray *arrResources;
@property (strong, nonatomic) IBOutlet UITextView *txtCompanyInformation;

@property (strong, nonatomic) IBOutlet UIScrollView *svwSponsors;
@property (strong, nonatomic) IBOutlet UIScrollView *svwResources;

@property (strong, nonatomic) IBOutlet UIButton *btnAddToFav;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveFromFav;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
- (IBAction)btnSocialMediaClicked:(id)sender;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
- (IBAction)OpenWebsite:(id)sender;
- (IBAction)OpenMail:(id)sender;
- (IBAction)OpenMapView:(id)sender;

- (IBAction)AddToFav:(id)sender;
- (IBAction)RemoveToFav:(id)sender;
@end
