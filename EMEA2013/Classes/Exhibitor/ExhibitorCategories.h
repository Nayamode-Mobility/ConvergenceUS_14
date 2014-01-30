//
//  ExhibitorCategories.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 21/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitorCategories : NSObject
{
    NSString *strParentCategoryInstanceID;
    NSString *strExhibitorID;
    NSString *strCategoryName;
}

@property (nonatomic,retain) NSString *strParentCategoryInstanceID;
@property (nonatomic,retain) NSString *strExhibitorID;
@property (nonatomic,retain) NSString *strCategoryName;
@end
