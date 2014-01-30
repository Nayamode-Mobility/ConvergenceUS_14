//
//  Message.m
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Message.h"

@implementation Message
#pragma mark Synthesize
@synthesize strMessageID, strFromAttendeeName, strToAttendeeName, strToAttendee, strFromAttendee, strAttendeeMessage, strMessageSubject, strIsToDelete, strIsFromDelete, strCreatedDate;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
