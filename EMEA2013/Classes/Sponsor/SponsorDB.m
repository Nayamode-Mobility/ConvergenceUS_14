//
//  SponsorDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SponsorDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "NSString+Custom.h"

@implementation SponsorDB

static SponsorDB *objSponsorDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objSponsorDB == nil)
    {
        objSponsorDB = [[self alloc] init];
    }
    
    return objSponsorDB;
}

- (id)init
{
    if (self = [super init])
    {
        strSearch = @"";
    }
    
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods
- (NSArray*)GetSponsors
{
    strSearch = @"";
    
    return [self GetSponsorsAndGrouped:YES];
}

- (NSArray*)GetSponsorsLikeName:(id)strValue
{
    strSearch = strValue;
    
    return [self GetSponsorsAndGrouped:YES];
}

- (NSArray*)GetSponsorsAndGrouped:(BOOL)blnGrouped
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSponsors = [[NSMutableArray alloc] init];
    
    NSString *strCurLevel = @"";
    NSString *strNextLevel = @"";
    
    NSMutableArray *arrLevelSponsors = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempSponsors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select SponsorID, SponsorName, WebsiteURL, LogoURL, SponsorLevelID, Lower(SponsorLevelName), Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, TwitterURL, LinkedInURL, AllowedAdvertisements, BoothNumbers, CompanyProfile, SponsorPhone From Sponsors Order By SponsorLevelID, Upper(SponsorName)";
    NSString *strSQL = @"Select SponsorID, SponsorName, WebsiteURL, LogoURL, SponsorLevelID, Lower(SponsorLevelName), Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, TwitterURL, LinkedInURL, AllowedAdvertisements, BoothNumbers, CompanyProfile, SponsorPhone From Sponsors ";
    if(![NSString IsEmpty:strSearch shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where SponsorName Like '%%%@%%' ",strSearch];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By SponsorLevelID, Upper(SponsorName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Sponsor *objSponsor = [[Sponsor alloc] init];
            
            if(blnGrouped == YES)
            {
                strNextLevel = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
                if(![strNextLevel isEqualToString:strCurLevel])
                {
                    if(![strCurLevel isEqualToString:@""] && [arrTempSponsors count] > 0)
                    {
                        [arrLevelSponsors addObject:strCurLevel];
                        [arrLevelSponsors addObject:[arrTempSponsors copy]];
                        
                        [arrTempSponsors removeAllObjects];
                        
                        [arrSponsors addObject:[arrLevelSponsors copy]];
                        [arrLevelSponsors removeAllObjects];
                    }
                    
                    strCurLevel = strNextLevel;
                }
            }
            
            objSponsor.strSponsorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSponsor.strSponsorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSponsor.strWebsiteURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSponsor.strLogoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSponsor.strSponsorLevelID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSponsor.strSponsorLevelName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSponsor.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSponsor.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSponsor.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSponsor.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSponsor.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSponsor.strPhoneNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSponsor.strFax = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSponsor.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSponsor.strFaceBookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSponsor.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSponsor.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSponsor.strAllowedAdvertisements = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSponsor.strBoothNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSponsor.strCompanyProfile = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSponsor.strSponsorPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            objSponsor.arrResources = [self GetSponsorResources:objSponsor.strSponsorID];
            objSponsor.arrCategories = [self GetSponsorCategories:objSponsor.strSponsorID];
            
			[arrTempSponsors addObject: objSponsor];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
    if(blnGrouped == YES)
    {
        if(![strCurLevel isEqualToString:@""] && [arrTempSponsors count] > 0)
        {
            [arrLevelSponsors addObject:strCurLevel];
            [arrLevelSponsors addObject:[arrTempSponsors copy]];
            
            [arrTempSponsors removeAllObjects];
            
            [arrSponsors addObject:[arrLevelSponsors copy]];
            [arrLevelSponsors removeAllObjects];
        }
    }
    else
    {
        //[arrSponsors addObject:[arrTempSponsors copy]];
        //[arrTempSponsors removeAllObjects];
        
        arrSponsors = arrTempSponsors;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSponsors;
}

- (NSArray*)GetSponsorsWithSponsorID:(id)strSponsorID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSponsors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SponsorID, SponsorName, WebsiteURL, LogoURL, SponsorLevelID, SponsorLevelName, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, TwitterURL, LinkedInURL, AllowedAdvertisements, BoothNumbers, CompanyProfile, SponsorPhone From Sponsors Where SponsorID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strSponsorID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Sponsor *objSponsor = [[Sponsor alloc] init];
            
            objSponsor.strSponsorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSponsor.strSponsorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSponsor.strWebsiteURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSponsor.strLogoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSponsor.strSponsorLevelID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSponsor.strSponsorLevelName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSponsor.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSponsor.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSponsor.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSponsor.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSponsor.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSponsor.strPhoneNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSponsor.strFax = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSponsor.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSponsor.strFaceBookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSponsor.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSponsor.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSponsor.strAllowedAdvertisements = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSponsor.strBoothNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSponsor.strCompanyProfile = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSponsor.strSponsorPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
         
            objSponsor.arrResources = [self GetSponsorResources:objSponsor.strSponsorID];
            objSponsor.arrCategories = [self GetSponsorCategories:objSponsor.strSponsorID];
            
			[arrSponsors addObject:objSponsor];            
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSponsors;
}


- (NSArray *)SetSponsors:(NSData*)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"SponsorList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"SponsorList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrSponsors = [dictData valueForKey:@"SponsorList"];
        NSUInteger intEntriesM = [arrSponsors count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteSponsors];
            NSString *strSQL = @"Delete From Sponsors";
            [arrQuery addObject:strSQL];
            
            Sponsor *objSponsor = [[Sponsor alloc] init];
            NSMutableDictionary *dictSponsor;
            
            NSArray *arrSponsorRecources;
            NSUInteger intEntriesD = 0;
            NSMutableDictionary *dictSponsorResources;
            
            NSArray *arrSponsorCategories;
            NSMutableDictionary *dictSponsorCategories;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictSponsor = [[NSMutableDictionary alloc] init];
                
                dictSponsor = [[arrSponsors objectAtIndex:i] valueForKey:@"SponsorDetails"];
                
                objSponsor.strSponsorID = [dictSponsor valueForKey:@"SponsorId"];
                
                if([Functions ReplaceNUllWithZero:objSponsor.strSponsorID]!=0)
                {
                    
                    //blnResult = [self AddSponsor:objSponsor];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Sponsors(SponsorID, SponsorName, WebsiteURL, LogoURL, SponsorLevelID, SponsorLevelName, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, FacebookURL, TwitterURL, LinkedInURL, Email, AllowedAdvertisements, BoothNumbers, SponsorPhone, CompanyProfile) Values(%i, '%@','%@', '%@', %i, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %i, '%@', '%@', '%@')",
                                        [[dictSponsor valueForKey:@"SponsorId"] intValue]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"SponsorName"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"WebsiteURL"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"LogoURL"]]
                                        ,[[Functions ReplaceNUllWithZero:[dictSponsor valueForKey:@"SponsorLevelId"]]intValue]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"SponsorLevelName"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"Address1"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"Address2"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"City"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"State"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"ZipCode"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"PhoneNumbers"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"FAX"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"FacebookURL"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"TwitterURL"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"LinkedInURL"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"Email"]]
                                        ,[[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"AllowedAdvertisements"]] intValue]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"BoothNumbers"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"SponsorPhone"]]
                                        ,[Functions ReplaceNUllWithBlank:[dictSponsor valueForKey:@"CompanyProfile"]]] ;
                    
                    
                    [arrQuery addObject:strSQL];
                    
                    strSQL = [NSString stringWithFormat:@"Delete From SponsorResources Where SponsorID = %i",[[dictSponsor valueForKey:@"SponsorId"] intValue]];
                    [arrQuery addObject:strSQL];
                    
                    strSQL = [NSString stringWithFormat:@"Delete From SponsorCategories Where SponsorID = %i",[[dictSponsor valueForKey:@"SponsorId"] intValue]];
                    [arrQuery addObject:strSQL];
                    
                    //                        [self DeleteSponsorResources:objSponsor.strSponsorID];
                    //                        [self DeleteSponsorCategories:objSponsor.strSponsorID];
                    
                    //                    if(blnResult == YES)
                    //                    {
                    arrSponsorRecources = [dictSponsor valueForKey:@"Resources"];
                    intEntriesD = [arrSponsorRecources count];
                    
                    if(intEntriesD > 0)
                    {
                        dictSponsorResources = [[NSMutableDictionary alloc] init];
                        
                        SponsorResource *objSponsorResource = [[SponsorResource alloc] init];
                        
                        for (NSUInteger i = 0; i < intEntriesD; i++)
                        {
                            dictSponsorResources = [arrSponsorRecources objectAtIndex:i];
                            
                            objSponsorResource.strSponsorResourceID = [dictSponsorResources valueForKey:@"SponsorResourceId"];
                            
                            if([Functions ReplaceNUllWithZero:objSponsorResource.strSponsorResourceID]!=0)
                            {
                                NSString *strSQL = [NSString stringWithFormat:@"Insert Into SponsorResources(SponsorREsourceID , SponsorID, FileName, DocType, URL, BriefDescription) Values(%i, %i, '%@', '%@', '%@', '%@')",
                                                    [[dictSponsorResources valueForKey:@"SponsorResourceId"] intValue],
                                                    [objSponsor.strSponsorID intValue],
                                                    [Functions ReplaceNUllWithBlank:[dictSponsorResources valueForKey:@"FileName"]],
                                                    [Functions ReplaceNUllWithBlank:[dictSponsorResources valueForKey:@"DocType"]],
                                                    [Functions ReplaceNUllWithBlank:[dictSponsorResources valueForKey:@"URL"]],
                                                    [Functions ReplaceNUllWithBlank:[dictSponsorResources valueForKey:@"BriefDescription"]] ];
                                
                                //[self AddSponsorResources:objSponsorResource];
                                [arrQuery addObject:strSQL];
                            }
                        }
                    }
                    
                    arrSponsorCategories = [dictSponsor valueForKey:@"Categories"];
                    intEntriesD = [arrSponsorCategories count];
                    
                    if(intEntriesD > 0)
                    {
                        dictSponsorCategories = [[NSMutableDictionary alloc] init];
                        
                        SponsorCategories *objSponsorCategories = [[SponsorCategories alloc] init];
                        
                        for (NSUInteger i = 0; i < intEntriesD; i++)
                        {
                            dictSponsorCategories = [arrSponsorCategories objectAtIndex:i];
                            
                            objSponsorCategories.strParentCategoryInstanceID = [dictSponsorCategories valueForKey:@"ParentCategoryInstanceID"];
                            
                            if([[Functions ReplaceNUllWithBlank:objSponsorCategories.strParentCategoryInstanceID] isEqualToString:@""])
                            {
                            }
                            else
                            {
                                NSArray *arrCategory = [Functions ReplaceNUllWithBlank:[dictSponsorCategories valueForKey:@"Categoryname"]];
                                
                                NSString *strSQL = [NSString stringWithFormat:@"Insert Into SponsorCategories(ParentCategoryInstanceID, SponsorID, CategoryName) Values('%@', %i, '%@')",
                                                    [dictSponsorCategories valueForKey:@"ParentCategoryInstanceID"],
                                                    [objSponsor.strSponsorID intValue],
                                                    [arrCategory componentsJoinedByString:@","]];
                                
                                //[self AddSponsorCategories:objSponsorCategories];
                                
                                [arrQuery addObject:strSQL];
                                
                            }
                        }
                        //                       }
                    }
                }
            }
            
            
            //            NSArray *arrPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
            //            NSString *strDocumentsDirectory = [arrPaths objectAtIndex:0];
            //            NSString *strUserDocumentsPath = [strDocumentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.sqlite", @"EMEAFY14"]];
            
            
            //            FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:strUserDocumentsPath];
            //
            //            [queue inDatabase:^(FMDatabase *db) {
            //
            //                int i = 1;
            //                for (NSString *strQuery in arrSponsor)
            //                {
            //                    [db executeUpdate:strQuery];
            //                    NSLog(@"Sponsor record inserted: %i",i);
            //                    i++;
            //                }
            //
            //            }];
            //
            //            FMDatabaseQueue *queueR = [FMDatabaseQueue databaseQueueWithPath:strUserDocumentsPath];
            //            [queueR inDatabase:^(FMDatabase *db) {
            //
            //                int i = 1;
            //                for (NSString *strQuery in arrResources)
            //                {
            //                    [db executeUpdate:strQuery];
            //                    NSLog(@"Sponsor Resource record inserted: %i",i);
            //                    i++;
            //                }
            //
            //            }];
            //
            //            FMDatabaseQueue *queueC = [FMDatabaseQueue databaseQueueWithPath:strUserDocumentsPath];
            //            [queueC inDatabase:^(FMDatabase *db) {
            //
            //                int i = 1;
            //                for (NSString *strQuery in arrCategories)
            //                {
            //                    [db executeUpdate:strQuery];
            //                    NSLog(@"Sponsor Category record inserted: %i",i);
            //                    i++;
            //                }
            //                
            //            }];
            
            
        }
        
        //if(blnResult == YES)
        //{
            //DB *objDB = [DB GetInstance];
            //[objDB UpdateScreenWithVersion:strSCREEN_SPONSOR Version:intVersion];
            [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_SPONSOR]];
        //}
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteSponsors
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Sponsors ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where SponsorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strSponsorID intValue]);
        
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

- (BOOL)AddSponsor:(Sponsor*)objSponsor
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Sponsors(SponsorID, SponsorName, WebsiteURL, LogoURL, SponsorLevelID, SponsorLevelName, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, FacebookURL, TwitterURL, LinkedInURL, Email, AllowedAdvertisements, BoothNumbers, SponsorPhone, CompanyProfile) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];

	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objSponsor.strSponsorID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objSponsor.strSponsorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSponsor.strWebsiteURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objSponsor.strLogoURL UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objSponsor.strSponsorLevelID intValue]);
        sqlite3_bind_text(compiledStmt, 6, [objSponsor.strSponsorLevelName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objSponsor.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objSponsor.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objSponsor.strCity UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objSponsor.strState UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objSponsor.strZipCode UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objSponsor.strPhoneNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objSponsor.strFax UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objSponsor.strFaceBookURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 15, [objSponsor.strTwitterURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objSponsor.strLinkedInURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objSponsor.strEmail UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 18, [objSponsor.strAllowedAdvertisements intValue]);
        sqlite3_bind_text(compiledStmt, 19, [objSponsor.strBoothNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 20, [objSponsor.strSponsorPhone UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 21, [objSponsor.strCompanyProfile UTF8String], -1, NULL);
        
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

- (BOOL)UpdateSponsor:(Sponsor*)objSponsor
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Sponsors Set ";
    strSQL = [strSQL stringByAppendingFormat:@"SponsorName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"WebsiteURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LogoURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SponsorLevelID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SponsorLevelName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"City = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"State = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ZipCode = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PhoneNumbers = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Fax = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"FacebookURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TwitterURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LinkedInURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"AllowedAdvertisements = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BoothNumbers = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SponsorPhone = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"CompanyProfile = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where SponsorID = ?"];
    

	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSponsor.strSponsorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSponsor.strWebsiteURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSponsor.strLogoURL UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 4, [objSponsor.strSponsorLevelID intValue]);
        sqlite3_bind_text(compiledStmt, 5, [objSponsor.strSponsorLevelName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objSponsor.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objSponsor.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objSponsor.strCity UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objSponsor.strState UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objSponsor.strZipCode UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objSponsor.strPhoneNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objSponsor.strFax UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objSponsor.strFaceBookURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objSponsor.strTwitterURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 15, [objSponsor.strLinkedInURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objSponsor.strEmail UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 17, [objSponsor.strAllowedAdvertisements intValue]);
        sqlite3_bind_text(compiledStmt, 18, [objSponsor.strBoothNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 19, [objSponsor.strSponsorPhone UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 20, [objSponsor.strCompanyProfile UTF8String], -1, NULL);

        sqlite3_bind_int(compiledStmt, 21, [objSponsor.strSponsorID intValue]);
        
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

- (BOOL)AddSponsorResources:(SponsorResource*)objSponsorResource
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SponsorResources(SponsorREsourceID , SponsorID, FileName, DocType, URL, BriefDescription) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objSponsorResource.strSponsorResourceID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objSponsorResource.strSponsorID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objSponsorResource.strFileName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objSponsorResource.strDocType UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objSponsorResource.strURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objSponsorResource.strBriefDescription UTF8String], -1, NULL);
        
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

- (BOOL)UpdateSponsorResources:(SponsorResource*)objSponsorResource
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update SponsorResources Set ";
    strSQL = [strSQL stringByAppendingFormat:@"FileName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"DocType = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"URL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where SponsorREsourceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSponsorResource.strFileName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSponsorResource.strDocType UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSponsorResource.strURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objSponsorResource.strBriefDescription UTF8String], -1, NULL);

        sqlite3_bind_int(compiledStmt, 5, [objSponsorResource.strSponsorResourceID intValue]);
        
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

- (BOOL)DeleteSponsorResources:(NSString*)strSponsorID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SponsorResources ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SponsorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [strSponsorID intValue]);
        
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

- (BOOL)AddSponsorCategories:(SponsorCategories*)objSponsorCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SponsorCategories(ParentCategoryInstanceID, SponsorID, CategoryName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSponsorCategories.strParentCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, [objSponsorCategories.strSponsorID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objSponsorCategories.strCategoryName UTF8String], -1, NULL);
        
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

- (BOOL)UpdateSponsorCategories:(SponsorCategories*)objSponsorCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update SponsorCategories Set ";
    strSQL = [strSQL stringByAppendingFormat:@"CategoryName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ParentCategoryInstanceID = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"And SponsorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSponsorCategories.strCategoryName UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 2, [objSponsorCategories.strParentCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 3, [objSponsorCategories.strSponsorID intValue]);
        
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

- (BOOL)DeleteSponsorCategories:(NSString*)strSponsorID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SponsorCategories ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SponsorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [strSponsorID intValue]);
        
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

- (NSMutableArray*)GetSponsorResources:(NSString*)strSponsorID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSponsorResources = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SponsorResourceID, SponsorID, FileName, DocType, URL, BriefDescription From SponsorResources Where SponsorID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSponsorID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SponsorResource *objSponsorResource = [[SponsorResource alloc] init];
            
            objSponsorResource.strSponsorResourceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSponsorResource.strSponsorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSponsorResource.strFileName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSponsorResource.strDocType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSponsorResource.strURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSponsorResource.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            
			//Read the data from the result row
			[arrSponsorResources addObject:objSponsorResource];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSponsorResources;
}

- (NSMutableArray*)GetSponsorCategories:(NSString*)strSponsorID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSponsorCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ParentCategoryInstanceID, SponsorID, CategoryName From SponsorCategories Where SponsorID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSponsorID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SponsorCategories *objSponsorCategories = [[SponsorCategories alloc] init];
            
            objSponsorCategories.strParentCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSponsorCategories.strSponsorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSponsorCategories.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSponsorCategories addObject:objSponsorCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSponsorCategories;
}
#pragma mark -
@end
