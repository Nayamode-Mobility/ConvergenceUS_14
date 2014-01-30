//
//  EventInfoDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LostNFound.h"
#import "EmergencyHospitals.h"
#import "EmergencyOverview.h"
#import "EmergencyFloorPlans.h"
#import "OnsiteService.h"

@interface EventInfoDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetLostNFound;
- (NSArray*)GetLostNFoundWithID:(id)strID;
- (NSArray  *)SetLostNFound:(NSData*)objData;

- (NSArray*)GetEmergencyHospitals;
- (NSArray*)GetEmergencyHospitalsWithID:(id)strID;
- (NSArray*)SetEmergencyHospitals:(NSData*)objData;

- (NSArray*)GetEmergencyOverview;
- (NSArray*)GetEmergencyOverviewWithID:(id)strID;
- (NSArray*)SetEmergencyOverview:(NSData*)objData;

- (NSArray*)GetEmergencyFloorPlans;
- (NSArray*)GetEmergencyFloorPlansWithID:(id)strID;
- (NSArray*)SetEmergencyFloorPlans:(NSData*)objData;

- (NSArray*)SetOnsiteService:(NSData*)objData;

- (NSArray*)GetOnsiteService;
- (NSArray*)GetAttendeesMeals;
- (NSArray*)GetSpecialtyMeals;
- (NSArray*)GetConferenceSecurity;
- (NSArray*)GetLuggage;
- (NSArray*)GetMSITTechLink;


@end
