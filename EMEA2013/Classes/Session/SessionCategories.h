//
//  SessionCategories.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionCategories : NSObject
{
    NSString *strCategoryInstanceID;
    NSString *strSessionInstanceID;
    NSString *strCategoryName;
}

@property (nonatomic,retain) NSString *strCategoryInstanceID;
@property (nonatomic,retain) NSString *strSessionInstanceID;
@property (nonatomic,retain) NSString *strCategoryName;
@end
