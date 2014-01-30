//
//  ExhibitorDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Exhibitor.h"
#import "ExhibitorResources.h"
#import "ExhibitorCategories.h"

@interface ExhibitorDB : NSObject
{
    NSString *strSearch;
}

+ (id)GetInstance;

- (NSArray*)GetExhibitors;
- (NSArray*)GetExhibitorsLikeName:(id)strValue;
- (NSArray*)GetExhibitorsWithExhibitorID:(id)strExhibitorID;
- (NSArray*)GetExhibitorsAndGrouped:(BOOL)blnGrouped;
- (NSArray*)GetSearch:(NSString *)searchFor;
- (NSArray*)SetExhibitor:(NSData*)objData;

- (NSArray*)GetAttendeeExhibitors;
- (NSArray*)GetAttendeeExhibitorsLikeName:(id)strValue;
- (NSString*)GetAttendeeExhibitorsJSON;
- (NSArray*)GetAttendeeExhibitorsAndGrouped:(BOOL)blnGrouped;
@end
