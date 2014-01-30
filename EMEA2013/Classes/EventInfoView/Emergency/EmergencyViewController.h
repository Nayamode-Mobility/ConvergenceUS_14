//
//  EmergencyViewController.h
//  mgx2013
//
//  Created by Amit Karande on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmergencyOverview.h"


@interface EmergencyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *svwEmergency;
@property (strong, nonatomic) EmergencyOverview *emergencyOverviewData;
@property (strong, nonatomic) NSArray *arrHospitals;
@property (strong, nonatomic) NSArray *arrFloorPlans;
@property (strong, nonatomic) IBOutlet UILabel *lblOverviewTitle;
//@property (strong, nonatomic) IBOutlet UILabel *lblHospitalTitle;
@property (strong, nonatomic) IBOutlet UIScrollView *svwOverview;
@property (strong, nonatomic) IBOutlet UIScrollView *svwHospitals;
@property (strong, nonatomic) IBOutlet UIScrollView *svwLeftHand;
@property (strong, nonatomic) IBOutlet UIView *vwDropdownMenu;
@property (nonatomic, assign) BOOL blnViewExpanded;
@property (strong, nonatomic) IBOutlet UITableView *tvwHospitals;
@property (strong, nonatomic) IBOutlet UILabel *lblHospitalTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblHospitalDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblHospitalAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblHospitalWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblHospitalPhone;
@property (strong, nonatomic) IBOutlet UIView *vwHospitalContact;
@property (strong, nonatomic) IBOutlet UILabel *lblDropDownHospitalTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDropdownFloorTitle;
@property (strong, nonatomic) IBOutlet UITableView *tvwFloorPlan;
@property (strong, nonatomic) IBOutlet UIView *vwFloorPlanDropdown;
@property (strong, nonatomic) IBOutlet UIScrollView *svwFloorPlan;
@property (strong, nonatomic) IBOutlet UIImageView *imgFloorPlan;
@property (strong, nonatomic) IBOutlet UIView *vwOverviewContact;
@property (strong, nonatomic) IBOutlet UILabel *lblOverviewAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblOverviewWebsite;
@property (strong, nonatomic) IBOutlet UILabel *lblOverviewPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnOpenWebsite;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingVenurFloorPlan;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)showFloorDropdownMenu:(id)sender;
- (IBAction)OpenMapView:(id)sender;
- (IBAction)OpenWebsite:(id)sender;
@end
