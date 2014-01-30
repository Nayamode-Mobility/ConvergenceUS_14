//
//  SponsorCategories.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 21/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SponsorCategories : NSObject
{
    NSString *strParentCategoryInstanceID;
    NSString *strSponsorID;
    NSString *strCategoryName;
}

@property (nonatomic,retain) NSString *strParentCategoryInstanceID;
@property (nonatomic,retain) NSString *strSponsorID;
@property (nonatomic,retain) NSString *strCategoryName;
@end
