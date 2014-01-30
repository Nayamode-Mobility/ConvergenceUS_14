//
//  ConferenceDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ConferenceDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"

@implementation ConferenceDB
static ConferenceDB *objConferenceDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objConferenceDB == nil)
    {
        objConferenceDB = [[self alloc] init];
    }
    
    return objConferenceDB;
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
- (NSArray*)GetConferences
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrConferences = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ConferenceID, ConferenceName, StartDate, EndDate, TwitterHashTag, YammerHashTag, TwitterURL, FacebookURL, LinkedInURL, Address1, Address2, Address3, Latitude, Longitude From Conferences";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Conference *objConference = [[Conference alloc] init];
            
            objConference.strConferenceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objConference.strConferenceName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objConference.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objConference.strEndDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objConference.strTwitterHashTag = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objConference.strYammerHashTag = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objConference.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objConference.strFacebookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objConference.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objConference.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objConference.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objConference.strAddress3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objConference.strLatitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objConference.strLongitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrConferences addObject:objConference];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrConferences;
}

- (NSArray*)GetConferencesWithConferenceID:(id)strConferenceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrConferences = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ConferenceID, ConferenceName, StartDate, EndDate, TwitterHashTag, YammerHashTag, TwitterURL, FacebookURL, LinkedInURL, Address1, Address2, Address3, Latitude, Longitude From Conferences Where ConferenceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strConferenceID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Conference *objConference = [[Conference alloc] init];
            
            objConference.strConferenceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objConference.strConferenceName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objConference.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objConference.strEndDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objConference.strTwitterHashTag = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objConference.strYammerHashTag = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objConference.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objConference.strFacebookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objConference.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objConference.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objConference.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objConference.strAddress3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objConference.strLatitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objConference.strLongitude = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrConferences addObject:objConference];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrConferences;
}

- (BOOL)SetConferences:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    //NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    //dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    NSMutableArray *arrData = [[NSMutableArray alloc] init];
    arrData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        //int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        //NSArray *arrConferences = [dictData valueForKey:@"ConferenceList"];
        //NSUInteger intEntriesM = [arrConferences count];

        NSArray *arrConferences = arrData;
        NSUInteger intEntriesM = [arrConferences count];
        
        if(intEntriesM > 0)
        {
            Conference *objConference = [[Conference alloc] init];
            NSMutableDictionary *dictConference;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictConference = [[NSMutableDictionary alloc] init];
                
                //dictConference = [[arrConferences objectAtIndex:i] valueForKey:@"ConferenceDetails"];
                dictConference = [arrConferences objectAtIndex:i];
                
                objConference.strConferenceID = [dictConference valueForKey:@"ConferenceID"];
                
                if([Functions ReplaceNUllWithZero:objConference.strConferenceID]!=0)
                {
                    objConference.strConferenceName = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"ConferenceName"]];
                    objConference.strStartDate = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"StartDate"]];
                    objConference.strEndDate = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"EndDate"]];
                    objConference.strTwitterHashTag = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"TwitterHashTag"]];
                    objConference.strYammerHashTag = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"YammerHashTag"]];
                    objConference.strTwitterURL = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"TwitterURL"]];
                    objConference.strFacebookURL = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"FacebookURL"]];
                    objConference.strLinkedInURL = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"LinkedInURL"]];
                    objConference.strAddress1 = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"Address1"]];
                    objConference.strAddress2 = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"Address2"]];
                    objConference.strAddress3 = [Functions ReplaceNUllWithBlank:[dictConference valueForKey:@"Address3 "]];
                    objConference.strLatitude = [Functions ReplaceNUllWithZero:[dictConference valueForKey:@"Latitude"]];
                    objConference.strLongitude = [Functions ReplaceNUllWithZero:[dictConference valueForKey:@"Longitude"]];
                    
                    NSString *strSQL = @"Select ConferenceID From Conferences Where ConferenceID = ?";
                    
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objConference.strConferenceID intValue] Query:strSQL] == NO)
                    {
                        blnResult = [self AddConference:objConference];
                    }
                    else
                    {
                        blnResult = [self UpdateConference:objConference];
                    }
                }
            }
        }
        
        //if(blnResult == YES)
        //{
        //    DB *objDB = [DB GetInstance];
        //    [objDB UpdateScreenWithVersion:strSCREEN_CONFERENCE Version:intVersion];
        //}
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)AddConference:(Conference*)objConference
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Conferences(ConferenceID, ConferenceName, StartDate, EndDate, TwitterHashTag, YammerHashTag, TwitterURL, FacebookURL, LinkedInURL, Address1, Address2, Address3, Latitude, Longitude) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objConference.strConferenceID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objConference.strConferenceName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objConference.strStartDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objConference.strEndDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objConference.strTwitterHashTag UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objConference.strYammerHashTag UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objConference.strTwitterURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objConference.strFacebookURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objConference.strLinkedInURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objConference.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objConference.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objConference.strAddress3 UTF8String], -1, NULL);
        sqlite3_bind_double(compiledStmt, 13, [objConference.strLatitude doubleValue]);
        sqlite3_bind_double(compiledStmt, 14, [objConference.strLongitude doubleValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateConference:(Conference*)objConference
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Conferences Set ";
    strSQL = [strSQL stringByAppendingFormat:@"ConferenceName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"StartDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"EndDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TwitterHashTag = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"YammerHashTag = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TwitterURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"FacebookURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LinkedInURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Latitude = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Longitude = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ConferenceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objConference.strConferenceName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objConference.strStartDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objConference.strEndDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objConference.strTwitterHashTag UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objConference.strYammerHashTag UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objConference.strTwitterURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objConference.strFacebookURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objConference.strLinkedInURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objConference.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objConference.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objConference.strAddress3 UTF8String], -1, NULL);
        sqlite3_bind_double(compiledStmt, 12, [objConference.strLatitude doubleValue]);
        sqlite3_bind_double(compiledStmt, 13, [objConference.strLongitude doubleValue]);
        
        sqlite3_bind_int(compiledStmt, 14, [objConference.strConferenceID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_CONFERENCE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}
#pragma mark -
@end
