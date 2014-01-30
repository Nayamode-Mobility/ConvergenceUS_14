//
//  Venue.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject
{
    NSString *strVenueID;
    NSString *strCity;
    NSString *strStreetAddress;
    NSString *strState;
    NSString *strZipCode;
    NSString *strLongitude;
    NSString *strLatitude;
    NSString *strImageURL;
    NSString *strVenueName;
    NSString *strVenueWebsite;
    NSString *strVenuePhone;
    
    NSArray *arrFloorPlans;
}

@property (nonatomic, retain) NSString *strVenueID;
@property (nonatomic, retain) NSString *strCity;
@property (nonatomic, retain) NSString *strStreetAddress;
@property (nonatomic, retain) NSString *strState;
@property (nonatomic, retain) NSString *strZipCode;
@property (nonatomic, retain) NSString *strLongitude;
@property (nonatomic, retain) NSString *strLatitude;
@property (nonatomic, retain) NSString *strImageURL;
@property (nonatomic, retain) NSString *strVenueName;
@property (nonatomic, retain) NSString *strVenueWebsite;
@property (nonatomic, retain) NSString *strVenuePhone;

@property (nonatomic, retain) NSArray *arrFloorPlans;
@end
