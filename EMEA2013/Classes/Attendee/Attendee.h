//
//  Attendee.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attendee : NSObject
{
    NSString *strAttendeeID;
    NSString *strRegistrantID;
    NSString *strFirstName;
    NSString *strMiddle;
    NSString *strLastName;
    NSString *strAttendeeName;
    NSString *strCompany;
    NSString *strDesignation;
    NSString *strExhibitorName;
    NSString *strEmail;
    NSString *strPUID;
    NSString *strPhotoURL;
    NSString *strBIO;
    NSString *strPhone;
    
    NSString *strIsNotificationEnabled;
    NSString *strIsEmailVisible;
    NSString *strIsPhoneNumberVisible;
    NSString *strIsNameVisible;
    NSString *strIsDesignationVisible;
    NSString *strIsCompanyVisible;
    NSString *strAllowInAppMessaging;
    NSString *strAllowSendMeetingInvite;
    NSString *strIsBiovisible;
    NSString *strIsPhotoVisible;
    
    NSArray *arrExhibitors;
}

@property (nonatomic, retain) NSString *strAttendeeID;
@property (nonatomic, retain) NSString *strRegistrantID;
@property (nonatomic, retain) NSString *strFirstName;
@property (nonatomic, retain) NSString *strMiddle;
@property (nonatomic, retain) NSString *strLastName;
@property (nonatomic, retain) NSString *strAttendeeName;
@property (nonatomic, retain) NSString *strCompany;
@property (nonatomic, retain) NSString *strDesignation;
@property (nonatomic, retain) NSString *strExhibitorName;
@property (nonatomic, retain) NSString *strEmail;
@property (nonatomic, retain) NSString *strPUID;
@property (nonatomic, retain) NSString *strPhotoURL;
@property (nonatomic, retain) NSString *strBIO;
@property (nonatomic, retain) NSString *strPhone;
@property (nonatomic, retain) NSString *strIsNotificationEnabled;
@property (nonatomic, retain) NSString *strIsEmailVisible;
@property (nonatomic, retain) NSString *strIsPhoneNumberVisible;
@property (nonatomic, retain) NSString *strIsNameVisible;
@property (nonatomic, retain) NSString *strIsDesignationVisible;
@property (nonatomic, retain) NSString *strIsCompanyVisible;
@property (nonatomic, retain) NSString *strAllowInAppMessaging;
@property (nonatomic, retain) NSString *strAllowSendMeetingInvite;
@property (nonatomic, retain) NSString *strIsBiovisible;
@property (nonatomic, retain) NSString *strIsPhotoVisible;

@property (nonatomic, retain) NSString *strIsSynced;
@property (nonatomic, retain) NSString *strIsDeleted;

@property (nonatomic, retain) NSArray *arrExhibitors;

@property (nonatomic, retain) NSString *strIsNotesAvailable;
@end
