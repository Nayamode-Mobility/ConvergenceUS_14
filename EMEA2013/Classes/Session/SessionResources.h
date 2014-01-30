//
//  SessionResources.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 26/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionResources : NSObject
{
    NSString *strResourceID;
    NSString *strSessionInstanceID;
    NSString *strFileName;
    NSString *strDocType;
    NSString *strDocTypeID;
    NSString *strURL;
    NSString *strBriefDescription;
}

@property (nonatomic,retain) NSString *strResourceID;
@property (nonatomic,retain) NSString *strSessionInstanceID;
@property (nonatomic,retain) NSString *strFileName;
@property (nonatomic,retain) NSString *strDocType;
@property (nonatomic,retain) NSString *strDocTypeID;
@property (nonatomic,retain) NSString *strURL;
@property (nonatomic,retain) NSString *strBriefDescription;
@end
