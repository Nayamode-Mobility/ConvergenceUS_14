//
//  CityGuideMapViewController.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingMaps.h"
#import "Venue.h"

@interface CityGuideMapViewController : UIViewController<BMMapViewDelegate,NSURLConnectionDelegate>
{
}

@property (strong, nonatomic) Venue *venueData;
@property (strong, nonatomic)  NSDictionary *pageTitle;

@property (nonatomic, weak) IBOutlet UIView *vwLoader;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *actLoader;

-(void)ShowNearest;
@end
