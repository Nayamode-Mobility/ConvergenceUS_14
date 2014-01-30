//
//  MasterDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Filters.h"
#import "Tracks.h"
#import "SubTracks.h"
#import "Categories.h"
#import "Rooms.h"
#import "EventInfoCategories.h"
#import "EventInfoDetails.h"
#import "SessionTypes.h"

@interface MasterDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetSessionTypes;
- (NSArray*)GetSessionTypesWithSessionTypeID:(id)strSessionTypeID;
- (NSString*)GetSessionTypeID:(id)strSessionTypeName;

- (NSArray*)GetTracks;
- (NSArray*)GetTracksWithTrackInstanceID:(id)strTrackInstanceID;
- (NSString*)GetTrackInstanceID:(id)strTrackName;
- (BOOL)SetTracks:(NSData*)objData;

- (NSArray*)GetProducts;
- (NSArray*)GetProductsWithProductID:(id)strProductID;
- (NSString*)GetProductID:(id)strProduct;

- (NSArray*)GetIndustries;
- (NSArray*)GetIndustrysWithIndustryID:(id)strIndustryID;
- (NSString*)GetIndustryID:(id)strIndustry;
- (NSArray  *)SetFilters:(NSData*)objData;

- (NSArray*)GetSubTracks;
- (NSArray*)GetSubTracksWithSubTrackInstanceID:(id)strSubTrackInstanceID;
- (NSString*)GetSubTrackInstanceID:(id)strSubTrackName;
- (BOOL)SetSubTracks:(NSData*)objData;

- (NSArray*)GetCategories;
- (NSArray*)GetCategoriesWithCategoryInstanceID:(id)strCategoryInstanceID;
- (NSArray *)SetCategories:(NSData*)objData;

- (NSArray*)GetRooms;
- (NSArray*)GetRoomsWithRoomInstanceID:(id)strRoomInstanceID;
- (NSArray*)SetRooms:(NSData*)objData;

- (NSArray*)GetEventInfoCategories;
- (NSArray*)GetEventInfoCategoriesWithCategoryID:(id)strCategoryID;
- (NSArray*)SetEventInfoCategories:(NSData*)objData;

- (NSArray*)GetEventInfoDetails;
- (NSArray*)GetEventInfoDetailsWithID:(id)strEvntInfoDetailID;
- (NSArray  *)SetEventInfoDetails:(NSData*)objData;

- (NSArray*)GetSpeakers;
- (NSArray*)GetSpeakersWithSpeakerID:(id)strSpeakerID;
- (NSString*)GetSpeakerID:(id)strSpeaker;

- (NSArray*)SetFindLikeMindedFilters:(NSData *)objData;

- (NSArray*)GetTimeslot;
- (NSArray*)GetSkillLevel;

-(NSArray*)GetFAQ;
-(NSArray*)GetMeals;
@end
