//
//  SpeakerDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Speaker.h"
#import "SpeakerSessions.h"

@interface SpeakerDB : NSObject
{
    NSString *strSearch;
}

+ (id)GetInstance;

- (NSArray*)GetSpeakers;
- (NSArray*)GetSpeakersLikeName:(id)strValue;
- (NSArray*)GetSpeakersWithSpeakerID:(id)strSpeakerInstanceID;
- (NSArray*)GetSpeakersWithSessionsAndGrouped:(BOOL)blnIncludeSessions Grouped:(BOOL)blnGrouped;
- (NSArray*)GetSpeakersWithSpeakerIDAndSessionsAndGrouped:(id)strSpeakerInstanceID IncludeSessions:(BOOL)blnIncludeSessions Grouped:(BOOL)blnGrouped;
- (NSArray*)GetSearch:(NSString *)searchFor;

- (NSArray*)SetSpeakers:(NSData*)objData;
@end
