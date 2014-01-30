//
//  UserSessionNotes.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Session.h"

@interface UserSessionNotes : NSObject
{
    NSString *strNoteID;
    NSString *strLocalID;
    NSString *strTitle;
    NSString *strContent;
    NSString *strCreatedDate;
    NSString *strUpdatedDate;
    
    NSString *strSessionInstanceID;
    NSString *strSessionCode;
    NSString *strSessionTitle;
    
    NSString *strIsAdded;
    NSString *strIsUpdated;
    NSString *strIsDeleted;
    
    NSString *strUserEmail;
    
    NSArray *arrSession;
}

@property (nonatomic, retain) NSString *strNoteID;
@property (nonatomic, retain) NSString *strLocalID;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strContent;
@property (nonatomic, retain) NSString *strCreatedDate;
@property (nonatomic, retain) NSString *strUpdatedDate;

@property (nonatomic, retain) NSString *strSessionInstanceID;
@property (nonatomic, retain) NSString *strSessionCode;
@property (nonatomic, retain) NSString *strSessionTitle;

@property (nonatomic, retain) NSString *strIsAdded;
@property (nonatomic, retain) NSString *strIsUpdated;
@property (nonatomic, retain) NSString *strIsDeleted;

@property (nonatomic, retain) NSString *strUserEmail;
@property (nonatomic, retain) NSString *strAttendeeEmailId;
@property (nonatomic, retain) NSArray *arrSession;
@end
