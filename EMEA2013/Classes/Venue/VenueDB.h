//
//  VenueDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Venue.h"
#import "VenueFloorPlan.h"

@interface VenueDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetVenues;
- (NSArray*)GetVenuesWithVenueID:(id)strVenueID;
- (NSArray*)SetVenues:(NSData*)objData;

@end
