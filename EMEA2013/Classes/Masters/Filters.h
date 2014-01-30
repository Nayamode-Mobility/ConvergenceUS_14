//
//  Filters.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filters : NSObject
{
    NSString *strCategoryID;
    NSString *strCategory;
    NSString *strCategoryName;
}

@property (nonatomic, retain) NSString *strCategoryID;
@property (nonatomic, retain) NSString *strCategory;
@property (nonatomic, retain) NSString *strCategoryName;

@end
