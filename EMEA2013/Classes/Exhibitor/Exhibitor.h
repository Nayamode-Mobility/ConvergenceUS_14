//
//  Exhibitor.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exhibitor : NSObject
{
    NSString *strExhibitorID;
    NSString *strExhibitorName;
    NSString *strWebsiteURL;
    NSString *strLogoURL;
    NSString *strCompanyProfile;
    NSString *strExhibitorPhone;
    NSString *strBoothNumbers;
    NSString *strAddress1;
    NSString *strAddress2;
    NSString *strCity;
    NSString *strState;
    NSString *strZipCode;
    NSString *strPhoneNumbers;
    NSString *strFax;
    NSString *strEmail;
    NSString *strFacebookURL;
    NSString *strLinkedInURL;
    NSString *strTwitterURL;
    NSString *strVideoWebCastURL;
    
    NSString *strIsAdded;
    
    NSArray *arrResources;
    NSArray *arrCategories;
}

@property (nonatomic, retain) NSString *strExhibitorID;
@property (nonatomic, retain) NSString *strExhibitorName;
@property (nonatomic, retain) NSString *strWebsiteURL;
@property (nonatomic, retain) NSString *strLogoURL;
@property (nonatomic, retain) NSString *strCompanyProfile;
@property (nonatomic, retain) NSString *strExhibitorPhone;
@property (nonatomic, retain) NSString *strBoothNumbers;
@property (nonatomic, retain) NSString *strAddress1;
@property (nonatomic, retain) NSString *strAddress2;
@property (nonatomic, retain) NSString *strCity;
@property (nonatomic, retain) NSString *strState;
@property (nonatomic, retain) NSString *strZipCode;
@property (nonatomic, retain) NSString *strPhoneNumbers;
@property (nonatomic, retain) NSString *strFax;
@property (nonatomic, retain) NSString *strEmail;
@property (nonatomic, retain) NSString *strFacebookURL;
@property (nonatomic, retain) NSString *strLinkedInURL;
@property (nonatomic, retain) NSString *strTwitterURL;
@property (nonatomic, retain) NSString *strVideoWebCastURL;

@property (nonatomic, retain) NSString *strIsAdded;
@property (nonatomic, retain) NSString *strExhibitorCode;

@property (nonatomic, retain) NSArray *arrResources;
@property (nonatomic, retain) NSArray *arrCategories;
@end
