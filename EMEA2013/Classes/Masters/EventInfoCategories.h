//
//  EventInfoCategories.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventInfoCategories : NSObject
{
    NSString *strCategoryID;
    NSString *strParentCategoryID;
    NSString *strCategory;
    NSArray *arrEventInfoDetails;
}

@property (nonatomic, retain) NSString *strCategoryID;
@property (nonatomic, retain) NSString *strParentCategoryID;
@property (nonatomic, retain) NSString *strCategory;
@property (nonatomic, retain) NSArray *arrEventInfoDetails;
@end
