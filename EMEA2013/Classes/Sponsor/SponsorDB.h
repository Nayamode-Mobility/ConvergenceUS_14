//
//  SponsorDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Sponsor.h"
#import "SponsorResource.h"
#import "SponsorCategories.h"

@interface SponsorDB : NSObject
{
    NSString *strSearch;
}

+ (id)GetInstance;

- (NSArray*)GetSponsors;
- (NSArray*)GetSponsorsLikeName:(id)strValue;
- (NSArray*)GetSponsorsWithSponsorID:(id)strSponsorID;
- (NSArray*)GetSponsorsAndGrouped:(BOOL)blnGrouped;
- (NSArray *)SetSponsors:(NSData*)objData;
@end
