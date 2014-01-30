//
//  OnsiteService.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnsiteService : NSObject
{
    NSString *strCategoryID;
    NSString *strParentCategoryID;
    NSString *strCategory;

    NSString *strEventInfoDetailID;
    NSString *strTitle;
    NSString *strBriefDescription;
    NSString *strDetailDescription;
    NSString *strEventInfoCategoryID;
    
    NSArray *arrOnsiteServiceDetails;
}

@property (nonatomic, retain) NSString *strCategoryID;
@property (nonatomic, retain) NSString *strParentCategoryID;
@property (nonatomic, retain) NSString *strCategory;

@property (nonatomic, retain) NSString *strEventInfoDetailID;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strBriefDescription;
@property (nonatomic, retain) NSString *strDetailDescription;
@property (nonatomic, retain) NSString *strEventInfoCategoryID;

@property (nonatomic, retain) NSArray *arrOnsiteServiceDetails;
@end
