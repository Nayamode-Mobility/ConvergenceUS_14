//
//  Conference.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conference : NSObject
{
    NSString *strConferenceID;
    NSString *strConferenceName;
    NSString *strStartDate;
    NSString *strEndDate;
    NSString *strTwitterHashTag;
    NSString *strYammerHashTag;
    NSString *strTwitterURL;
    NSString *strFacebookURL;
    NSString *strLinkedInURL;
    NSString *strAddress1;
    NSString *strAddress2;
    NSString *strAddress3;
    NSString *strLatitude;
    NSString *strLongitude;
}

@property (nonatomic, retain) NSString *strConferenceID;
@property (nonatomic, retain) NSString *strConferenceName;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (nonatomic, retain) NSString *strTwitterHashTag;
@property (nonatomic, retain) NSString *strYammerHashTag;
@property (nonatomic, retain) NSString *strTwitterURL;
@property (nonatomic, retain) NSString *strFacebookURL;
@property (nonatomic, retain) NSString *strLinkedInURL;
@property (nonatomic, retain) NSString *strAddress1;
@property (nonatomic, retain) NSString *strAddress2;
@property (nonatomic, retain) NSString *strAddress3;
@property (nonatomic, retain) NSString *strLatitude;
@property (nonatomic, retain) NSString *strLongitude;
@end
