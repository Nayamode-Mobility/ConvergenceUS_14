//
//  Sponsor.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Sponsor.h"

@implementation Sponsor
#pragma mark Synthesize
@synthesize strSponsorID, strSponsorName, strWebsiteURL, strLogoURL, strSponsorLevelName, strSponsorLevelID, strAddress1,
            strAddress2, strCity, strState, strZipCode, strPhoneNumbers, strFax, strEmail, strFaceBookURL, strTwitterURL,
            strLinkedInURL, strAllowedAdvertisements, strBoothNumbers, strCompanyProfile, strSponsorPhone, arrResources, arrCategories;
#pragma mark -

- (id)init
{
    return self;
}

- (void)dealloc
{
}
@end
