//
//  Categories.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject
{
    NSString *strCategoryInstanceID;
    NSString *strParentCategoryInstanceID;
    NSString *strCategoryName;
}

@property (nonatomic, retain) NSString *strCategoryInstanceID;
@property (nonatomic, retain) NSString *strParentCategoryInstanceID;
@property (nonatomic, retain) NSString *strCategoryName;
@end
