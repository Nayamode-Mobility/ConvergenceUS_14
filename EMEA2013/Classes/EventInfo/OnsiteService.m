//
//  OnsiteService.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "OnsiteService.h"

@implementation OnsiteService
#pragma mark Synthesize
@synthesize strCategoryID, strParentCategoryID, strCategory;
@synthesize strEventInfoDetailID, strTitle, strBriefDescription, strDetailDescription, strEventInfoCategoryID, arrOnsiteServiceDetails;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
