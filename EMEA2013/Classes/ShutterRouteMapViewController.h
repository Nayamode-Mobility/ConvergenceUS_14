//
//  ShutterRouteMapViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode MacMini on 09/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "VenueDB.h"
#import "VenueFloorPlan.h"
#import "AppDelegate.h"

@interface ShutterRouteMapViewController :UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrShuttleRouteMap;
    NSString *cellLabelText;
    UILabel * locationName;
    UILabel * descriptionName;
    UILabel * lbllocationName;
    UILabel * lbldescriptionName;
    
}

@property NSArray * arrFloorPlans;
@property NSArray *shuttlebrief;

@property NSMutableArray *routeID ;
@property (nonatomic, assign) BOOL blnViewExpanded;

@property (weak, nonatomic) IBOutlet UILabel *lblselectedItem;

@property (weak, nonatomic) IBOutlet UIImageView *mapImg;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityindiacator;

- (IBAction)shutterrouteBackBtn:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lblRouteID;
@property (strong, nonatomic) IBOutlet UILabel *lbllRoute;
- (IBAction)showDropdown:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *vwLocatonDropdown;
@property (strong, nonatomic) IBOutlet UITableView *TableViewLocation;

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollVwImage;

@property (strong, nonatomic) IBOutlet UIView *sampleView;


@property (strong, nonatomic) IBOutlet UIView *demoView;


@property NSDictionary * mainDic;


@end
