//
//  Sponsor.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sponsor : NSObject
{
    NSString *strSponsorID;
    NSString *strSponsorName;
    NSString *strWebsiteURL;
    NSString *strLogoURL;
    NSString *strSponsorLevelName;
    NSString *strSponsorLevelID;
    NSString *strAddress1;
    NSString *strAddress2;
    NSString *strCity;
    NSString *strState;
    NSString *strZipCode;
    NSString *strPhoneNumbers;
    NSString *strFax;
    NSString *strEmail;
    NSString *strFaceBookURL;
    NSString *strTwitterURL;
    NSString *strLinkedInURL;
    NSString *strAllowedAdvertisements;
    NSString *strBoothNumbers;
    NSString *strCompanyProfile;
    NSString *strSponsorPhone;
    
    NSArray *arrResources;
    NSArray *arrCategories;
}

@property (nonatomic, retain) NSString *strSponsorID;
@property (nonatomic, retain) NSString *strSponsorName;
@property (nonatomic, retain) NSString *strWebsiteURL;
@property (nonatomic, retain) NSString *strLogoURL;
@property (nonatomic, retain) NSString *strSponsorLevelName;
@property (nonatomic, retain) NSString *strSponsorLevelID;
@property (nonatomic, retain) NSString *strAddress1;
@property (nonatomic, retain) NSString *strAddress2;
@property (nonatomic, retain) NSString *strCity;
@property (nonatomic, retain) NSString *strState;
@property (nonatomic, retain) NSString *strZipCode;
@property (nonatomic, retain) NSString *strPhoneNumbers;
@property (nonatomic, retain) NSString *strFax;
@property (nonatomic, retain) NSString *strEmail;
@property (nonatomic, retain) NSString *strFaceBookURL;
@property (nonatomic, retain) NSString *strTwitterURL;
@property (nonatomic, retain) NSString *strLinkedInURL;
@property (nonatomic, retain) NSString *strAllowedAdvertisements;
@property (nonatomic, retain) NSString *strBoothNumbers;
@property (nonatomic, retain) NSString *strCompanyProfile;
@property (nonatomic, retain) NSString *strSponsorPhone;

@property (nonatomic, retain) NSArray *arrResources;
@property (nonatomic, retain) NSArray *arrCategories;
@end
