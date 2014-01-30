//
//  SponsorResource.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SponsorResource : NSObject
{
    NSString *strSponsorResourceID;
    NSString *strSponsorID;
    NSString *strFileName;
    NSString *strDocType;
    NSString *strURL;
    NSString *strBriefDescription;
}

@property (nonatomic,retain) NSString *strSponsorResourceID;
@property (nonatomic,retain) NSString *strSponsorID;
@property (nonatomic,retain) NSString *strFileName;
@property (nonatomic,retain) NSString *strDocType;
@property (nonatomic,retain) NSString *strURL;
@property (nonatomic,retain) NSString *strBriefDescription;
@end
