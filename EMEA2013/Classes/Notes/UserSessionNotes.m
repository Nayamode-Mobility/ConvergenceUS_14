//
//  UserSessionNotes.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "UserSessionNotes.h"

@implementation UserSessionNotes
#pragma mark Synthesize
@synthesize strNoteID, strLocalID, strTitle, strContent, strCreatedDate, strUpdatedDate, arrSession;
@synthesize strSessionInstanceID, strSessionCode, strSessionTitle;
@synthesize strIsAdded, strIsUpdated, strIsDeleted;
@synthesize strUserEmail;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
