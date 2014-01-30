//
//  Venue.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Venue.h"

@implementation Venue
#pragma mark Synthesize
@synthesize strVenueID, strCity, strStreetAddress, strState, strZipCode, strLongitude, strLatitude, strImageURL, strVenueName, strVenueWebsite,
strVenuePhone, arrFloorPlans;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
