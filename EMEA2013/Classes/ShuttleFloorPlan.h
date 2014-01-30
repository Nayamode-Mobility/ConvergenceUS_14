//
//  ShuttleFloorPlan.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode MacMini on 14/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuttleFloorPlan : NSObject
{
    NSString *strFloorPlanID;
    NSString *strVenueID;
    NSString *strImageURL;
    NSString *strBriefDescription;
    NSString *strDescription;
}

@property (nonatomic, retain) NSString *strFloorPlanID;
@property (nonatomic, retain) NSString *strVenueID;
@property (nonatomic, retain) NSString *strImageURL;
@property (nonatomic, retain) NSString *strBriefDescription;
@property (nonatomic, retain) NSString *strDescription;
@end




