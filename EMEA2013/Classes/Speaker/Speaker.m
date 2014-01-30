//
//  Speaker.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Speaker.h"

@implementation Speaker
#pragma mark Synthesize
@synthesize strSpeakerInstanceID, strFirstName, strLastName, strTitle, strEmail, strCompany, strSpeakerPhoto, strBiography, strExecutive,
            strSpeakerType, strSpeakerTypeName, strPriorityTypeID, strPriorityTypeName, strPriorityID, strPriorityName, strExternalStatus,
            strInvitationDate, strInvitationStatus, strTrackInstanceID, strTrackName, arrSessions;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
