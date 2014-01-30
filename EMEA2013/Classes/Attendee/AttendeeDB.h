//
//  AttendeeDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Attendee.h"
#import "AttendeeExhibitor.h"
#import "Exhibitor.h"

@interface AttendeeDB : NSObject
{
    NSString *strSearch;   
}

+ (id)GetInstance;

- (NSArray*)GetAttendees;
- (NSArray*)GetAttendeesLikeName:(id)strValue;
- (NSArray*)GetAttendeesLikeNameAndGrouped:(id)strValue blnGrouped:(BOOL)blnGrouped;
- (NSArray*)GetAttendeesWithAttendeeID:(id)strAttendeeID;
- (NSArray*)GetAttendeesAndGrouped:(BOOL)blnGrouped;
- (NSArray*)GetSearch:(NSString *)searchFor;
- (BOOL)SetAttendees:(NSData*)objData;
- (BOOL)SetAttendeeExhibitors:(NSData *)objData;
- (BOOL)SetFavAttendees:(NSData *)objData;

- (BOOL)AddExhibitor:(NSString*)strExhibitorID;
- (BOOL)DeleteExhibitor:(NSString*)strExhibitorID;

- (NSArray*)GetAttendeesCategoryOfFilterType:(NSString*)strFilterType;

- (NSArray*)GetFavouriteAttendee;
- (NSArray*)GetAttendeesList:(NSData *)objData;

- (NSString*)GetFavAttendeesJSON;

- (BOOL)AddFavAttendee:(Attendee*)objAttendee;
- (BOOL)DeleteFavAttendee:(int)intAttendeeID;
- (BOOL)UpdateFavAttendee:(Attendee*)objAttendee;

- (NSArray*)GetFilteredFindLikeMindedwithCategory1:(id)strCategory1 Category2:(id)strCategory2 Category3:(id)strCategory3 Category4:(id)strCategory4;

- (BOOL)CheckAvailableAttendeeNotes:(NSString*)strAttendeeEmail;

- (BOOL)AddExhibitorWithExhibitorObj:(Exhibitor *)objExhibitor;

@end
