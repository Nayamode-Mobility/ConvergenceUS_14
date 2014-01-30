//
//  AppDelegate.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

//Just testing git

// Jitendra First Comment

//Sushma's commit

// NEW Commit from Jitendra

#import <UIKit/UIKit.h>
#import "Reachability.h"

#import "LiveSDK/LiveConnectClient.h"
#import "LiveSDK/LiveConnectSession.h"
#import "StyledPullableView.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, PullableViewDelegate>
{
    StyledPullableView *pullUpView;
}

@property (nonatomic, retain) LiveConnectClient *liveClient;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) NetworkStatus netStatus;

@property NSMutableArray *scheduleData;
@property NSMutableArray *RouteData;
@property (strong, nonatomic) NSMutableArray *ShuttleScheduleLArrayobj;
@property (strong, nonatomic) NSMutableArray *shuttleRouteArrayobj;
@property (strong, nonatomic) NSMutableArray *shuttleInfoArrayobj;
@property (strong, nonatomic) NSUserDefaults * def;

@property (strong, nonatomic) NSMutableDictionary *dictShuttleData;


- (void) addBottomPullOutMenu;
- (void) hideBottomPullOutMenu;
- (void) showBottomPullOutMenu;

@end
