//
//  Venue.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Announcement : NSObject

@property (nonatomic, retain) NSString *strAnnouncementId;
@property (nonatomic, retain) NSString *strAnnouncementTopic;
@property (nonatomic, retain) NSString *strAnnouncementMessage;
@property (nonatomic, retain) NSString *strTimeDiff;
@property (nonatomic, retain) NSString *strCreatedDate;
@property (nonatomic, retain) NSString *strNotifyDate;


@end
