//
//  Exhibitor.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Exhibitor.h"

@implementation Exhibitor
#pragma mark Synthesize
@synthesize strExhibitorID, strExhibitorName, strWebsiteURL, strLogoURL, strCompanyProfile, strExhibitorPhone, strBoothNumbers,
            strAddress1, strAddress2, strCity, strState, strZipCode, strPhoneNumbers, strFax, strEmail, strFacebookURL, strLinkedInURL,
            strTwitterURL, strVideoWebCastURL, arrResources, arrCategories, strIsAdded;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
