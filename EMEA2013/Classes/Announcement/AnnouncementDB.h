//
//  VenueDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Announcement.h"

@interface AnnouncementDB : NSObject
{
}

+ (id)GetInstance;
+ (NSString *)getLatestTopic;
+ (NSString *)getLatestMessage;

- (NSArray*)GetAnnouncements;
- (NSArray*)GetAnnouncementsWithAnnouncementID:(id)strAnnouncementID;
- (BOOL)SetAnnouncements:(NSData*)objData;

+ (Announcement *)getLatestAnnouncement;
@end
