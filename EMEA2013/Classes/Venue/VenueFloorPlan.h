//
//  VenueFloorPlan.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueFloorPlan : NSObject
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
