//
//  VenueDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "VenueDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"

@implementation VenueDB

static VenueDB *objVenueDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objVenueDB == nil)
    {
        objVenueDB = [[self alloc] init];
    }
    
    return objVenueDB;
}

- (id)init
{
    return self;
}

- (void)dealloc
{
}
#pragma mark -
#pragma mark Instance Methods
- (NSArray*)GetVenues
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrVenues = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select VenueID, City, StreetAddress, State, ZipCode, Latitude, Longitude, ImageURL, VenueName, VenuePhone , VenueWebsite From Venues";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Venue *objVenue = [[Venue alloc] init];
            
            objVenue.strVenueID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objVenue.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objVenue.strStreetAddress = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objVenue.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objVenue.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objVenue.strLatitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objVenue.strLongitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objVenue.strImageURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objVenue.strVenueName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objVenue.strVenuePhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objVenue.strVenueWebsite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            
            objVenue.arrFloorPlans = [self GetVenueFloorPlan:objVenue.strVenueID];
            
			[arrVenues addObject:objVenue];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrVenues;
}

- (NSArray*)GetVenuesWithVenueID:(id)strVenueID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrVenues = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select VenueID, City, StreetAddress, State, ZipCode, Latitude, Longitude, ImageURL, VenueName, VenuePhone, VenueWebsite From Venues Where VenueID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strVenueID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Venue *objVenue = [[Venue alloc] init];
            
            objVenue.strVenueID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objVenue.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objVenue.strStreetAddress = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objVenue.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objVenue.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objVenue.strLatitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objVenue.strLongitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objVenue.strImageURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objVenue.strVenueName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objVenue.strVenuePhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objVenue.strVenueWebsite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];

            objVenue.arrFloorPlans = [self GetVenueFloorPlan:objVenue.strVenueID];
            
			[arrVenues addObject:objVenue];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrVenues;
}

- (NSArray*)SetVenues:(NSData*)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"VenueList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"VenueList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:@"VersionNumber"] intValue];
        
        NSArray *arrVenues = [dictData valueForKey:@"VenueList"];
        NSUInteger intEntriesM = [arrVenues count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteVenues];
            NSString *strSQL = @"Delete From Venues";
            [arrQuery addObject:strSQL];
            
            Venue *objVenue = [[Venue alloc] init];
            NSMutableDictionary *dictVenue;
            
            NSArray *arrVenueFloorPlans;
            NSUInteger intEntriesD = 0;
            NSMutableDictionary *dictVenueFloorPlans;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictVenue = [[NSMutableDictionary alloc] init];
                
                dictVenue = [[arrVenues objectAtIndex:i] valueForKey:@"VenueDetails"];
                
                objVenue.strVenueID = [dictVenue valueForKey:@"VenueId"];
                
                if([Functions ReplaceNUllWithZero:objVenue.strVenueID]!=0)
                {
                    //                    objVenue.strCity = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"City"]];
                    //                    objVenue.strStreetAddress = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"StreetAddress"]];
                    //                    objVenue.strState = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"State"]];
                    //                    objVenue.strZipCode = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"ZipCode"]];
                    //                    objVenue.strLongitude = [Functions ReplaceNUllWithZero:[dictVenue valueForKey:@"Longitude"]];
                    //                    objVenue.strLatitude = [Functions ReplaceNUllWithZero:[dictVenue valueForKey:@"Latitude"]];
                    //                    objVenue.strImageURL = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"ImageURL"]];
                    //                    objVenue.strVenueName = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"VenueName"]];
                    //                    objVenue.strVenueWebsite = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"VenueWebsite"]];
                    //                    objVenue.strVenuePhone = [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"VenuePhone"]];
                    //
                    //                        blnResult = [self AddVenue:objVenue];
                    
                    NSString *strSQL = [NSString stringWithFormat: @"Insert Into Venues(VenueID, City, StreetAddress, State, ZipCode, Latitude, Longitude, ImageURL, VenueName, VenuePhone, VenueWebsite) Values(%i, '%@', '%@', '%@', '%@', %f, %f, '%@', '%@', '%@', '%@')",
                                        [[dictVenue valueForKey:@"VenueId"]intValue],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"City"]],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"StreetAddress"]],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"State"]],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"ZipCode"]],
                                        [[Functions ReplaceNUllWithZero:[dictVenue valueForKey:@"Latitude"]]doubleValue],
                                        [[Functions ReplaceNUllWithZero:[dictVenue valueForKey:@"Longitude"]]doubleValue],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"ImageURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"VenueName"]],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"VenueWebsite"]],
                                        [Functions ReplaceNUllWithBlank:[dictVenue valueForKey:@"VenuePhone"]]];
                    
                    [arrQuery addObject:strSQL];
                    
                    //if(blnResult == YES)
                    //{
                        arrVenueFloorPlans = [dictVenue valueForKey:@"FloorPlans"];
                        intEntriesD = [arrVenueFloorPlans count];
                        
                        if(intEntriesD > 0)
                        {
                            dictVenueFloorPlans = [[NSMutableDictionary alloc] init];
                            
                            VenueFloorPlan *objVenueFloorPlan = [[VenueFloorPlan alloc] init];
                            
                            //[arrQuery addObject:@"Delete From VenueFloorPlans"];
                            [arrQuery addObject:[NSString stringWithFormat:@"Delete From VenueFloorPlans where VenueID = %@", [dictVenue valueForKey:@"VenueId"]]];
                            
                            for (NSUInteger i = 0; i < intEntriesD; i++)
                            {
                                dictVenueFloorPlans = [arrVenueFloorPlans objectAtIndex:i];
                                
                                objVenueFloorPlan.strFloorPlanID = [dictVenueFloorPlans valueForKey:@"FloorPlanId"];
                                
                                if([Functions ReplaceNUllWithZero:objVenueFloorPlan.strFloorPlanID]!=0)
                                {
                                    //                                    objVenueFloorPlan.strVenueID = objVenue.strVenueID;
                                    //                                    objVenueFloorPlan.strImageURL = [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"ImageURL"]];
                                    //                                    objVenueFloorPlan.strBriefDescription = [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"BriefDescription"]];
                                    //                                    objVenueFloorPlan.strDescription = [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"Description"]];
                                    
                                    NSString *strSQLCheck = @"Select FloorPlanID From VenueFloorPlans Where FloorPlanID = ?";
                                    
                                        //blnResult = [self AddVenueFloorPlan:objVenueFloorPlan];
                                        NSString *strSQL = [NSString stringWithFormat: @"Insert Into VenueFloorPlans(FloorPlanID, VenueID, ImageURL, BriefDescription, Description) Values(%i, %i, '%@', '%@', '%@')",
                                                            [[dictVenueFloorPlans valueForKey:@"FloorPlanId"]intValue],
                                                            [[dictVenue valueForKey:@"VenueId"]intValue],
                                                            [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"ImageURL"]],
                                                            [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"BriefDescription"]],
                                                            [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"Description"]]];
                                        
                                        
                                        [arrQuery addObject:strSQL];
                                        
//                                    }
//                                    else
//                                    {
//                                        //blnResult = [self UpdateVenueFloorPlan:objVenueFloorPlan];
//                                        NSString *strSQL = [NSString stringWithFormat: @"Update VenueFloorPlans Set ImageURL = '%@', BriefDescription = '%@', Description = '%@' Where FloorPlanID = %i ",[Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"ImageURL"]],
//                                                            [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"BriefDescription"]],
//                                                            [Functions ReplaceNUllWithBlank:[dictVenueFloorPlans valueForKey:@"Description"]],[[dictVenueFloorPlans valueForKey:@"FloorPlanId"]intValue]];
//                                        [arrQuery addObject:strSQL];
//                                    }
                                }
                            }
                        }
//                    }
                }
            }
        }
        
        //if(blnResult == YES)
        //{
            //DB *objDB = [DB GetInstance];
            //[objDB UpdateScreenWithVersion:strSCREEN_VENUE Version:intVersion];
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_VENUE]];
        //}
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteVenues
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Venues ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where VenueID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strVenueID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddVenue:(Venue*)objVenue
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Venues(VenueID, City, StreetAddress, State, ZipCode, Latitude, Longitude, ImageURL, VenueName, VenuePhone, VenueWebsite) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objVenue.strVenueID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objVenue.strCity UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objVenue.strStreetAddress UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objVenue.strState UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objVenue.strZipCode UTF8String], -1, NULL);
        sqlite3_bind_double(compiledStmt, 6, [objVenue.strLatitude doubleValue]);
        sqlite3_bind_double(compiledStmt, 7, [objVenue.strLongitude doubleValue]);
        sqlite3_bind_text(compiledStmt, 8, [objVenue.strImageURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objVenue.strVenueName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objVenue.strVenuePhone UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objVenue.strVenueWebsite UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateVenue:(Venue*)objVenue
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Venues Set ";
    strSQL = [strSQL stringByAppendingFormat:@"City = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"StreetAddress = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"State = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ZipCode = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Latitude = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Longitude = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ImageURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"VenueName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"VenuePhone = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"VenueWebsite = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where VenueID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objVenue.strCity UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objVenue.strStreetAddress UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objVenue.strState UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objVenue.strZipCode UTF8String], -1, NULL);
        sqlite3_bind_double(compiledStmt, 5, [objVenue.strLatitude doubleValue]);
        sqlite3_bind_double(compiledStmt, 6, [objVenue.strLongitude doubleValue]);
        sqlite3_bind_text(compiledStmt, 7, [objVenue.strImageURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objVenue.strVenueName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objVenue.strVenuePhone UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objVenue.strVenueWebsite UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 11, [objVenue.strVenueID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddVenueFloorPlan:(VenueFloorPlan*)objVenueFloorPlan
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into VenueFloorPlans(FloorPlanID, VenueID, ImageURL, BriefDescription, Description) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objVenueFloorPlan.strFloorPlanID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objVenueFloorPlan.strVenueID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objVenueFloorPlan.strImageURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objVenueFloorPlan.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objVenueFloorPlan.strDescription intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateVenueFloorPlan:(VenueFloorPlan*)objVenueFloorPlan
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update VenueFloorPlans Set ";
    strSQL = [strSQL stringByAppendingFormat:@"ImageURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Description = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where FloorPlanID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objVenueFloorPlan.strImageURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objVenueFloorPlan.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 3, [objVenueFloorPlan.strDescription intValue]);
 
        sqlite3_bind_int(compiledStmt, 4, [objVenueFloorPlan.strFloorPlanID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (NSMutableArray*)GetVenueFloorPlan:(NSString*)strVenueID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrVenueFloorPlans = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select FloorPlanID, VenueID, ImageURL, BriefDescription, Description FROM VenueFloorPlans Where VenueID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strVenueID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            VenueFloorPlan *objVenueFloorPlan = [[VenueFloorPlan alloc] init];
            
            objVenueFloorPlan.strFloorPlanID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objVenueFloorPlan.strVenueID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objVenueFloorPlan.strImageURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objVenueFloorPlan.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objVenueFloorPlan.strDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            
			//Read the data from the result row
			[arrVenueFloorPlans addObject:objVenueFloorPlan];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrVenueFloorPlans;
}
#pragma mark -
@end

