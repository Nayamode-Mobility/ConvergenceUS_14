//
//  ConferenceDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Conference.h"

@interface ConferenceDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetConferences;
- (NSArray*)GetConferencesWithConferenceID:(id)strConferenceID;
- (BOOL)SetConferences:(NSData*)objData;
@end
