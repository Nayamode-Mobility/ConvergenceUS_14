//
//  Conference.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Conference.h"

@implementation Conference
#pragma mark Synthesize
@synthesize strConferenceID, strConferenceName, strStartDate, strEndDate, strTwitterHashTag, strYammerHashTag, strTwitterURL,
            strFacebookURL, strLinkedInURL, strAddress1, strAddress2, strAddress3, strLatitude, strLongitude;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
