//
//  SessionDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 26/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Session.h"
#import "SessionResources.h"
#import "SessionTracks.h"
#import "SessionSubTracks.h"
#import "SessionCategories.h"
#import "SessionRooms.h"

@interface SessionDB : NSObject
{
    NSString *strTrackInstanceID;
    NSString *strProductID;
    int intSessionTypeID;
    NSString *strSessionTypeID;
    NSString *strIndustryID;
    NSString *strSpeakerID;
    NSString *strSkillLevelID;
    NSString *strTimeSlotID;

}

+ (id)GetInstance;

- (NSArray*)GetSessions;
- (NSArray*)GetSessionsWithSessionID:(id)strSessionInstanceID;
- (NSArray*)GetSessionsWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:(id)strTrackID ProductID:(id)strProdID SessionTypeID:(id)strSessTypeID IndustryID:(id)strIndID SpeakerID:(id)strSpkrID TimeSlotID:(id)strtimeslotID;
- (NSArray *)GetSessionsWithFilter:(id)strTrackID ProductID:(id)strProdID SessionTypeID:(id)strSessionTypeID IndustryID:(id)strIndID SpeakerID:(id)strSpkrID;
- (NSArray*)GetSearch:(NSString *)searchFor;

- (NSArray*)WhatIsHappeningNow;
- (NSArray*)WhatIsHappeningAndGrouped:(BOOL)blnGroupedByDate;
- (NSArray*)WhatIsHappeningWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:(id)strTrackID ProductID:(id)strProdID SessionTypeID:(id)strSessionTypeID IndustryID:(id)strIndID SpeakerID:(id)strSpkrID TimeSlotID:(id)strtimeslotID;

- (NSArray*)GetSessionsWithSpeakers:(BOOL)blnIncludeSpeakers;
- (NSArray*)GetSessionsWithSessionIDAndSpeakers:(id)strSessionInstanceID IncludeSpeaker:(BOOL)blnIncludeSpeakers;
- (NSArray*)GetSessionsWithSpeakerAndGrouped:(BOOL)blnIncludeSpeakers;

- (NSArray*)SetSessions:(NSData*)objData;

- (NSArray*)GetSessionsWithTrackID:(id)strTrackID SkillLevelID:(id)strSkillID SessionTypeID:(id)strSessTypeID IndustryID:(id)strIndID TimeSlotID:(id)strtimeslotID;
@end
