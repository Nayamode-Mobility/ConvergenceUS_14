//
//  SpeakerDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SpeakerDB.h"

#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "SessionDB.h"
#import "NSString+Custom.h"

@implementation SpeakerDB
static SpeakerDB *objSpeakerDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objSpeakerDB == nil)
    {
        objSpeakerDB = [[self alloc] init];
    }
    
    return objSpeakerDB;
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
- (NSArray*)GetSpeakers
{
    strSearch = @"";
    
    return [self GetSpeakersWithSessionsAndGrouped:YES Grouped:YES];
}

- (NSArray*)GetSpeakersLikeName:(id)strValue
{
    strSearch = strValue;
    
    return [self GetSpeakersWithSessionsAndGrouped:YES Grouped:YES];
}

- (NSArray*)GetSearch:(NSString *)searchFor{
    searchFor=[searchFor stringByReplacingOccurrencesOfString:@"'" withString:@""];
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpeakers = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrTempSpeakers = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select SpeakerInstanceID, FirstName, LastName, Title, Email, Company, SpeakerPhoto, Biography, Executive, SpeakerType, SpeakerTypeName, PriorityTypeID, PriorityTypeName, PriorityID, PriorityName, ExternalStatus, InvitationDate, InvitationStatus, TrackInstanceID, TrackName, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Speakers ";
    
    NSString *whereCondition=[NSString stringWithFormat:@"Where FirstName Like '%%%@%%' Or LastName Like '%%%@%%' Or Company Like '%%%@%%' ",searchFor,searchFor,searchFor];
    
    strSQL = [strSQL stringByAppendingString:whereCondition];
    
    strSQL = [strSQL stringByAppendingString:@"Order By Upper(FirstName), Upper(LastName)"];
    
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Speaker *objSpeaker = [[Speaker alloc] init];
            
            objSpeaker.strSpeakerInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSpeaker.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSpeaker.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSpeaker.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSpeaker.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSpeaker.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSpeaker.strSpeakerPhoto = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSpeaker.strBiography = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSpeaker.strExecutive = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSpeaker.strSpeakerType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSpeaker.strSpeakerTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSpeaker.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSpeaker.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSpeaker.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSpeaker.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSpeaker.strExternalStatus = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSpeaker.strInvitationDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSpeaker.strInvitationStatus = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSpeaker.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSpeaker.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            
            objSpeaker.arrSessions = [[NSMutableArray alloc] init];
            
			[arrTempSpeakers addObject: objSpeaker];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
    arrSpeakers = arrTempSpeakers;
    
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpeakers;
}

- (NSArray*)GetSpeakersWithSpeakerID:(id)strSpeakerInstanceID
{
    return [self GetSpeakersWithSpeakerIDAndSessionsAndGrouped:strSpeakerInstanceID IncludeSessions:YES Grouped:YES];
}

- (NSArray*)GetSpeakersWithSessionsAndGrouped:(BOOL)blnIncludeSessions Grouped:(BOOL)blnGrouped
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpeakers = [[NSMutableArray alloc] init];
    
    NSString *strCurAlpha = @"";
    NSString *strNextAlpha = @"";
    
    NSMutableArray *arrAlhaSpeakers = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempSpeakers = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select SpeakerInstanceID, FirstName, LastName, Title, Email, Company, SpeakerPhoto, Biography, Executive, SpeakerType, SpeakerTypeName, PriorityTypeID, PriorityTypeName, PriorityID, PriorityName, ExternalStatus, InvitationDate, InvitationStatus, TrackInstanceID, TrackName, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Speakers Order By Upper(FirstName), Upper(LastName)";
    NSString *strSQL = @"Select SpeakerInstanceID, FirstName, LastName, Title, Email, Company, SpeakerPhoto, Biography, Executive, SpeakerType, SpeakerTypeName, PriorityTypeID, PriorityTypeName, PriorityID, PriorityName, ExternalStatus, InvitationDate, InvitationStatus, TrackInstanceID, TrackName, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Speakers ";
    if(![NSString IsEmpty:strSearch shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where FirstName Like '%%%@%%' Or LastName Like '%%%@%%' Or Email Like '%%%@%%' Or Company Like '%%%@%%' Or Title Like '%%%@%%' ",strSearch,strSearch,strSearch,strSearch,strSearch];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By Upper(FirstName), Upper(LastName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Speaker *objSpeaker = [[Speaker alloc] init];
            
            if(blnGrouped == YES)
            {
                strNextAlpha = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
                if(![strNextAlpha isEqualToString:strCurAlpha])
                {
                    if(![strCurAlpha isEqualToString:@""] && [arrTempSpeakers count] > 0)
                    {
                        [arrAlhaSpeakers addObject:strCurAlpha];
                        [arrAlhaSpeakers addObject:[arrTempSpeakers copy]];
                        
                        [arrTempSpeakers removeAllObjects];
                        
                        [arrSpeakers addObject:[arrAlhaSpeakers copy]];
                        [arrAlhaSpeakers removeAllObjects];
                    }
                    
                    strCurAlpha = strNextAlpha;
                }
            }
            
            objSpeaker.strSpeakerInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSpeaker.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSpeaker.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSpeaker.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSpeaker.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSpeaker.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSpeaker.strSpeakerPhoto = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSpeaker.strBiography = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSpeaker.strExecutive = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSpeaker.strSpeakerType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSpeaker.strSpeakerTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSpeaker.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSpeaker.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSpeaker.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSpeaker.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSpeaker.strExternalStatus = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSpeaker.strInvitationDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSpeaker.strInvitationStatus = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSpeaker.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSpeaker.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            
            if(blnIncludeSessions == YES)
            {
                objSpeaker.arrSessions = [self GetSpeakerSessionsForSpeakerID:objSpeaker.strSpeakerInstanceID];
            }
            else
            {
                objSpeaker.arrSessions = [[NSMutableArray alloc] init];
            }
            
			[arrTempSpeakers addObject: objSpeaker];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
    if(blnGrouped == YES)
    {
        if(![strCurAlpha isEqualToString:@""] && [arrTempSpeakers count] > 0)
        {
            [arrAlhaSpeakers addObject:strCurAlpha];
            [arrAlhaSpeakers addObject:[arrTempSpeakers copy]];
            
            [arrTempSpeakers removeAllObjects];
            
            [arrSpeakers addObject:[arrAlhaSpeakers copy]];
            [arrAlhaSpeakers removeAllObjects];
        }
    }
    else
    {
        //[arrSpeakers addObject:[arrTempSpeakers copy]];
        //[arrTempSpeakers removeAllObjects];
        
        arrSpeakers = arrTempSpeakers;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpeakers;
}

- (NSArray*)GetSpeakersWithSpeakerIDAndSessionsAndGrouped:(id)strSpeakerInstanceID IncludeSessions:(BOOL)blnIncludeSessions Grouped:(BOOL)blnGrouped
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpeakers = [[NSMutableArray alloc] init];
    
    NSString *strCurAlpha = @"";
    NSString *strNextAlpha = @"";
    
    NSMutableArray *arrAlhaSpeakers = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempSpeakers = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SpeakerInstanceID, FirstName, LastName, Title, Email, Company, SpeakerPhoto, Biography, Executive, SpeakerType, SpeakerTypeName, PriorityTypeID, PriorityTypeName, PriorityID, PriorityName, ExternalStatus, InvitationDate, InvitationStatus, TrackInstanceID, TrackName, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Speakers Where SpeakerInstanceID = ? Order By Upper(FirstName), Upper(LastName)";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSpeakerInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Speaker *objSpeaker = [[Speaker alloc] init];
            
            if(blnGrouped == YES)
            {
                strNextAlpha = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
                if(![strNextAlpha isEqualToString:strCurAlpha])
                {
                    if(![strCurAlpha isEqualToString:@""] && [arrTempSpeakers count] > 0)
                    {
                        [arrAlhaSpeakers addObject:strCurAlpha];
                        [arrAlhaSpeakers addObject:[arrTempSpeakers copy]];
                        
                        [arrTempSpeakers removeAllObjects];
                        
                        [arrSpeakers addObject:[arrAlhaSpeakers copy]];
                        [arrAlhaSpeakers removeAllObjects];
                    }
                    strCurAlpha = strNextAlpha;
                }
            }
            
            objSpeaker.strSpeakerInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSpeaker.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSpeaker.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSpeaker.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSpeaker.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSpeaker.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSpeaker.strSpeakerPhoto = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSpeaker.strBiography = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSpeaker.strExecutive = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSpeaker.strSpeakerType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSpeaker.strSpeakerTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSpeaker.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSpeaker.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSpeaker.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSpeaker.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSpeaker.strExternalStatus = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSpeaker.strInvitationDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSpeaker.strInvitationStatus = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSpeaker.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSpeaker.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            
            if(blnIncludeSessions == YES)
            {
                objSpeaker.arrSessions = [self GetSpeakerSessionsForSpeakerID:objSpeaker.strSpeakerInstanceID];
            }
            else
            {
                objSpeaker.arrSessions = [[NSMutableArray alloc] init];
            }
            
			[arrTempSpeakers addObject:objSpeaker];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
    if(blnGrouped == YES)
    {
        if(![strCurAlpha isEqualToString:@""] && [arrTempSpeakers count] > 0)
        {
            [arrAlhaSpeakers addObject:strCurAlpha];
            [arrAlhaSpeakers addObject:[arrTempSpeakers copy]];
            
            [arrTempSpeakers removeAllObjects];
            
            [arrSpeakers addObject:[arrAlhaSpeakers copy]];
            [arrAlhaSpeakers removeAllObjects];
        }
    }
    else
    {
        //[arrSpeakers addObject:[arrTempSpeakers copy]];
        //[arrTempSpeakers removeAllObjects];
        
        arrSpeakers = arrTempSpeakers;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpeakers;
}

- (NSArray*)SetSpeakers:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"SpeakerList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"SpeakerList"];
    }
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrSpeakers = [dictData valueForKey:@"Speakers"];
        NSUInteger intEntriesM = [arrSpeakers count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteSpeakers];
            
            [arrQuery addObject:@"Delete From Speakers"];
            
            Speaker *objSpeaker = [[Speaker alloc] init];
            NSMutableDictionary *dictSpeaker;
            
            NSArray *arrSpeakerSessions;
            NSUInteger intEntriesD = 0;
            NSMutableDictionary *dictSpeakerSessions;
            
            
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictSpeaker = [[NSMutableDictionary alloc] init];
                
                dictSpeaker = [[arrSpeakers objectAtIndex:i] valueForKey:@"SpeakerDetails"];
                
                objSpeaker.strSpeakerInstanceID = [dictSpeaker valueForKey:@"SpeakerInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objSpeaker.strSpeakerInstanceID] isEqualToString:@""])
                {
                }
                else
                {
                    //                    objSpeaker.strFirstName = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"FirstName"]];
                    //                    objSpeaker.strLastName = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"LastName"]];
                    //                    objSpeaker.strTitle = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Title"]];
                    //                    objSpeaker.strEmail = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Email"]];
                    //                    objSpeaker.strCompany = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Company"]];
                    //                    objSpeaker.strSpeakerPhoto = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"SpeakerPhoto"]];
                    //                    objSpeaker.strBiography = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Biography"]];
                    //                    objSpeaker.strExecutive = [Functions ReplaceNUllWithZero:[dictSpeaker valueForKey:@"Executive"]];
                    //                    objSpeaker.strSpeakerType = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"SpeakerType"]];
                    //                    objSpeaker.strSpeakerTypeName = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"SpeakerTypeName"]];
                    //                    objSpeaker.strPriorityTypeID = [Functions ReplaceNUllWithZero:[dictSpeaker valueForKey:@"PriorityTypeID "]];
                    //                    objSpeaker.strPriorityTypeName = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"PriorityTypeName"]];
                    //                    objSpeaker.strPriorityID = [Functions ReplaceNUllWithZero:[dictSpeaker valueForKey:@"PriorityID"]];
                    //                    objSpeaker.strPriorityName = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"PriorityName"]];
                    //                    objSpeaker.strExternalStatus = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"ExternalStatus"]];
                    //                    objSpeaker.strInvitationDate = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"InvitationDate"]];
                    //                    objSpeaker.strInvitationStatus = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"InvitationStatus"]];
                    //                    objSpeaker.strTrackInstanceID = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"TrackInstanceId"]];
                    //                    objSpeaker.strTrackName = [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"TrackName"]];
                    //
                    //                        blnResult = [self AddSpeaker:objSpeaker];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Speakers(SpeakerInstanceID, FirstName, LastName, Title, Email, Company, SpeakerPhoto, Biography, Executive, SpeakerType, SpeakerTypeName, PriorityTypeID, PriorityTypeName, PriorityID, PriorityName, ExternalStatus, InvitationDate, InvitationStatus, TrackInstanceID, TrackName) Values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %hhd, %d, '%@', %i, '%@', %d, '%@', '%@', '%@', '%@', '%@', '%@')",
                                        [dictSpeaker valueForKey:@"SpeakerInstanceId"],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"FirstName"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"LastName"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Title"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Email"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Company"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"SpeakerPhoto"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"Biography"]],
                                        [[Functions ReplaceNUllWithZero:[dictSpeaker valueForKey:@"Executive"]] boolValue],
                                        [[Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"SpeakerType"]]intValue],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"SpeakerTypeName"]],
                                        [[Functions ReplaceNUllWithZero:[dictSpeaker valueForKey:@"PriorityTypeID "]]intValue],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"PriorityTypeName"]],
                                        [[Functions ReplaceNUllWithZero:[dictSpeaker valueForKey:@"PriorityID"]] intValue],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"PriorityName"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"ExternalStatus"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"InvitationDate"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"InvitationStatus"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"TrackInstanceId"]],
                                        [Functions ReplaceNUllWithBlank:[dictSpeaker valueForKey:@"TrackName"]]];
                    
                    [arrQuery addObject:strSQL];
                    //if(blnResult ==  YES)
                    //{
                    //[self DeleteSpeakerSessions:objSpeaker.strSpeakerInstanceID];
                    //}
                    
                    strSQL = [NSString stringWithFormat:@"Delete From SpeakerSessions Where SpeakerInstanceID = '%@'", [dictSpeaker valueForKey:@"SpeakerInstanceId"]];
                    [arrQuery addObject:strSQL];
                    
                    //if(blnResult == YES)
                    //{
//                    arrSpeakerSessions = [dictSpeaker valueForKey:@"SessionDetails"];
//                    intEntriesD = [arrSpeakerSessions count];
//                    
//                    if(intEntriesD > 0)
//                    {
//                        dictSpeakerSessions = [[NSMutableDictionary alloc] init];
//                        
//                        SpeakerSessions *objSpeakerSessions = [[SpeakerSessions alloc] init];
//                        
//                        for (NSUInteger i = 0; i < intEntriesD; i++)
//                        {
//                            dictSpeakerSessions = [arrSpeakerSessions objectAtIndex:i];
//                            
//                            objSpeakerSessions.strSessionInstanceID = [dictSpeakerSessions valueForKey:@"SessionInstanceID"];
//                            
//                            if([Functions ReplaceNUllWithZero:objSpeakerSessions.strSessionInstanceID]!=0)
//                            {
//                                //objSpeakerSessions.strSpeakerInstanceID = objSpeaker.strSpeakerInstanceID;
//                                
//                                //blnResult = [self AddSpeakerSessions:objSpeakerSessions];
//                                
//                                NSString *strSQL = [NSString stringWithFormat:@"Insert Into SpeakerSessions(SpeakerInstanceID , SessionInstanceID)Values('%@', '%@')",[dictSpeaker valueForKey:@"SpeakerInstanceId"],[dictSpeakerSessions valueForKey:@"SessionInstanceID"]];
//                                [arrQuery addObject:strSQL];
//                                
//                            }
//                        }
//                    }
                    //                    }
                }
            }
        }
        
//        if(blnResult == YES)
//        {
           // DB *objDB = [DB GetInstance];
//[objDB UpdateScreenWithVersion:strSCREEN_SPEAKER Version:intVersion];
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_SPEAKER]];
//        }
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteSpeakers
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Speakers ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where SpeakerInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strSpeakerInstanceID intValue]);
        
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

- (BOOL)AddSpeaker:(Speaker*)objSpeaker
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Speakers(SpeakerInstanceID, FirstName, LastName, Title, Email, Company, SpeakerPhoto, Biography, Executive, SpeakerType, SpeakerTypeName, PriorityTypeID, PriorityTypeName, PriorityID, PriorityName, ExternalStatus, InvitationDate, InvitationStatus, TrackInstanceID, TrackName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSpeaker.strSpeakerInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSpeaker.strFirstName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSpeaker.strLastName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objSpeaker.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objSpeaker.strEmail UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objSpeaker.strCompany UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objSpeaker.strSpeakerPhoto UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objSpeaker.strBiography UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 9, [objSpeaker.strExecutive  boolValue]);
        sqlite3_bind_int(compiledStmt, 10, [objSpeaker.strSpeakerType intValue]);
        sqlite3_bind_text(compiledStmt, 11, [objSpeaker.strSpeakerTypeName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 12, [objSpeaker.strPriorityTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 13, [objSpeaker.strPriorityTypeName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 14, [objSpeaker.strPriorityID intValue]);
        sqlite3_bind_text(compiledStmt, 15, [objSpeaker.strPriorityName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objSpeaker.strExternalStatus UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objSpeaker.strInvitationDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 18, [objSpeaker.strInvitationStatus UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 19, [objSpeaker.strTrackInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 20, [objSpeaker.strTrackName UTF8String], -1, NULL);
        
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

- (BOOL)UpdateSpeaker:(Speaker*)objSpeaker
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Speakers Set ";
    strSQL = [strSQL stringByAppendingFormat:@"FirstName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LastName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Company = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SpeakerPhoto = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Biography = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Executive = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SpeakerType = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SpeakerTypeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityTypeID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityTypeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ExternalStatus = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"InvitationDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"InvitationStatus = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TrackInstanceID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TrackName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where SpeakerInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSpeaker.strFirstName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSpeaker.strLastName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSpeaker.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objSpeaker.strEmail UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objSpeaker.strCompany UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objSpeaker.strSpeakerPhoto UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objSpeaker.strBiography UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 8, [objSpeaker.strExecutive  boolValue]);
        sqlite3_bind_int(compiledStmt, 9, [objSpeaker.strSpeakerType intValue]);
        sqlite3_bind_text(compiledStmt, 10, [objSpeaker.strSpeakerTypeName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 11, [objSpeaker.strPriorityTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 12, [objSpeaker.strPriorityTypeName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 13, [objSpeaker.strPriorityID intValue]);
        sqlite3_bind_text(compiledStmt, 14, [objSpeaker.strPriorityName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 15, [objSpeaker.strExternalStatus UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objSpeaker.strInvitationDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objSpeaker.strInvitationStatus UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 18, [objSpeaker.strTrackInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 19, [objSpeaker.strTrackName UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 20, [objSpeaker.strSpeakerInstanceID UTF8String], -1, NULL);
        
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

- (BOOL)AddSpeakerSessions:(SpeakerSessions*)objSpeakerSessions
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SpeakerSessions(SpeakerInstanceID , SessionInstanceID) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSpeakerSessions.strSpeakerInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSpeakerSessions.strSessionInstanceID UTF8String], -1, NULL);
        
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

- (BOOL)DeleteSpeakerSessions:(NSString*)strSpeakerInstanceID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SpeakerSessions ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SpeakerInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [strSpeakerInstanceID UTF8String], -1, NULL);
        
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

- (NSArray*)GetSpeakerSessionsForSpeakerID:(id)strSpeakerInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    SessionDB *objSessionDB = [[SessionDB alloc] init];
    
    char *strSQL = "Select SpeakerSessions.SpeakerInstanceID, SpeakerSessions.SessionInstanceID From SpeakerSessions Inner Join Sessions On SpeakerSessions.SessionInstanceID = Sessions.SessionInstanceID Where SpeakerInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSpeakerInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSArray *arrTemp = [[NSArray alloc] init];
            
            arrTemp = [objSessionDB GetSessionsWithSessionIDAndSpeakers:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] IncludeSpeaker:YES];
            
			//Read the data from the result row
			[arrSessions addObject:arrTemp];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}
#pragma mark -
@end
