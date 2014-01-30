//
//  Session.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Session.h"

@implementation Session
#pragma mark Synthesize
@synthesize strSessionInstanceID, strSessionStatusID, strSessionStatusName, strSessionTypeID, strSessionTypeName, strJointSessionID,
            strJointSessionWith, strSessionCode, strSessionTitle, strSessionAbstract, strSessionObjective, strPriorityID, strPriorityName,
            strPriorityTypeID, strPriorityTypeName, strStartDate, strStartTime, strEndTime, strLocationURL,
            arrSpeakers, arrResources, arrTracks, arrSubTracks, arrCategories, arrRooms,arrVideos;
@synthesize strIsAdded, strNotesAvailable;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
