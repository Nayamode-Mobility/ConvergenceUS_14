//
//  EventInfoDetails.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 11/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventInfoDetails : NSObject
{
    NSString *strEventInfoDetailID;
    NSString *strCategoryID;
    NSString *strCategory;
    NSString *strTitle;
    NSString *strBriefDescription;
    NSString *strDetailDescription;
}

@property (nonatomic, retain) NSString *strEventInfoDetailID;
@property (nonatomic, retain) NSString *strCategoryID;
@property (nonatomic, retain) NSString *strCategory;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strBriefDescription;
@property (nonatomic, retain) NSString *strDetailDescription;
@end
