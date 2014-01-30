//
//  Attendee.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Attendee.h"

@implementation Attendee
#pragma mark Synthesize
@synthesize strAttendeeID, strRegistrantID, strFirstName, strMiddle, strLastName, strAttendeeName, strCompany, strDesignation,
            strExhibitorName, strEmail, strPUID, strPhotoURL, strBIO, strPhone, strIsNotificationEnabled, strIsEmailVisible,
            strIsNameVisible, strIsDesignationVisible, strIsCompanyVisible, strAllowInAppMessaging, strAllowSendMeetingInvite,
strIsBiovisible, strIsPhotoVisible, strIsPhoneNumberVisible, arrExhibitors,strIsSynced,strIsDeleted,strIsNotesAvailable;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
