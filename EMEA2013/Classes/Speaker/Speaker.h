//
//  Speaker.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Speaker : NSObject
{
    NSString *strSpeakerInstanceID;
    NSString *strFirstName;
    NSString *strLastName;
    NSString *strTitle;
    NSString *strEmail;
    NSString *strCompany;
    NSString *strSpeakerPhoto;
    NSString *strBiography;
    NSString *strExecutive;
    NSString *strSpeakerType;
    NSString *strSpeakerTypeName;
    NSString *strPriorityTypeID;
    NSString *strPriorityTypeName;
    NSString *strPriorityID;
    NSString *strPriorityName;
    NSString *strExternalStatus;
    NSString *strInvitationDate;
    NSString *strInvitationStatus;
    NSString *strTrackInstanceID;
    NSString *strTrackName;
    
    NSArray *arrSessions;
}

@property (nonatomic, retain) NSString *strSpeakerInstanceID;
@property (nonatomic, retain) NSString *strFirstName;
@property (nonatomic, retain) NSString *strLastName;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strEmail;
@property (nonatomic, retain) NSString *strCompany;
@property (nonatomic, retain) NSString *strSpeakerPhoto;
@property (nonatomic, retain) NSString *strBiography;
@property (nonatomic, retain) NSString *strExecutive;
@property (nonatomic, retain) NSString *strSpeakerType;
@property (nonatomic, retain) NSString *strSpeakerTypeName;
@property (nonatomic, retain) NSString *strPriorityTypeID;
@property (nonatomic, retain) NSString *strPriorityTypeName;
@property (nonatomic, retain) NSString *strPriorityID;
@property (nonatomic, retain) NSString *strPriorityName;
@property (nonatomic, retain) NSString *strExternalStatus;
@property (nonatomic, retain) NSString *strInvitationDate;
@property (nonatomic, retain) NSString *strInvitationStatus;
@property (nonatomic, retain) NSString *strTrackInstanceID;
@property (nonatomic, retain) NSString *strTrackName;

@property (nonatomic, retain) NSArray *arrSessions;
@end
