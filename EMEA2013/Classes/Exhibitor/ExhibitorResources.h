//
//  ExhibitorResources.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitorResources : NSObject
{
    NSString *strExhibitorResourceID;
    NSString *strExhibitorID;
    NSString *strFileName;
    NSString *strDocType;
    NSString *strURL;
    NSString *strBriefDescription;
}

@property (nonatomic, retain) NSString *strExhibitorResourceID;
@property (nonatomic, retain) NSString *strExhibitorID;
@property (nonatomic, retain) NSString *strFileName;
@property (nonatomic, retain) NSString *strDocType;
@property (nonatomic, retain) NSString *strURL;
@property (nonatomic, retain) NSString *strBriefDescription;
@end
