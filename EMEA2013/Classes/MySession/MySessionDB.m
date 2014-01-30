//
//  MySessionDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MySessionDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "SessionDB.h"
#import "SpeakerDB.h"
#import "NSString+Custom.h"

@implementation MySessionDB
static MySessionDB *objMySessionDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objMySessionDB == nil)
    {
        objMySessionDB = [[self alloc] init];
    }
    
    return objMySessionDB;
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
- (NSArray*)GetMySessions
{
    return [objMySessionDB GetMySessionsAndGrouped:NO];
}

- (NSArray*)GetMySessionsAndGrouped:(BOOL)blnGroupedByDate;
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strCurDate = @"";
    NSString *strNextDate = @"";
    
    NSMutableArray *arrDateMySessions = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempMySessions = [[NSMutableArray alloc] init];
    
    char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable From Sessions Inner Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Left Join UserSessionNotes On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID Where MYSessions.IsDeleted = 0 Order By StartDate, StartTime, SessionTitle";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            if(blnGroupedByDate == YES)
            {
                strNextDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
                if(![strNextDate isEqualToString:strCurDate])
                {
                    if(![strCurDate isEqualToString:@""] && [arrTempMySessions count] > 0)
                    {
                        [arrDateMySessions addObject:strCurDate];
                        [arrDateMySessions addObject:[arrTempMySessions copy]];
                        
                        [arrTempMySessions removeAllObjects];
                        
                        [arrSessions addObject:[arrDateMySessions copy]];
                        [arrDateMySessions removeAllObjects];
                    }
                    
                    strCurDate = strNextDate;
                }
            }
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:objSession.strSessionInstanceID];
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            
			[arrTempMySessions addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(blnGroupedByDate == YES)
    {
        if(![strCurDate isEqualToString:@""] && [arrTempMySessions count] > 0)
        {
            [arrDateMySessions addObject:strCurDate];
            [arrDateMySessions addObject:[arrTempMySessions copy]];
            
            [arrTempMySessions removeAllObjects];
            
            [arrSessions addObject:[arrDateMySessions copy]];
            [arrDateMySessions removeAllObjects];
        }
    }
    else
    {
        //[arrSessions addObject:[arrTempAgendas copy]];
        //[arrTempAgendas removeAllObjects];
        
        arrSessions = arrTempMySessions;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)GetMySessionsWithSessionID:(id)strSessionInstanceID
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SessionInstanceID From MySessions Where SessionInstanceID = ? And IsDeleted = 0";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
        SessionDB *objSessionDB = [[SessionDB alloc] init];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
			//Read the data from the result row
            NSArray *arrTemp = [[NSArray alloc] init];
            
            arrTemp = [objSessionDB GetSessionsWithSessionIDAndSpeakers:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] IncludeSpeaker:YES];
            
			[arrSessions addObject:arrTemp];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSString*)GetMySessionsJSON
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrMySessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SessionInstanceID, Not IsDeleted From MySessions where IsSynced = 0";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSMutableDictionary *objMySessions = [[NSMutableDictionary alloc] init];
            
            [objMySessions setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] forKey:@"InstanceId"];
            [objMySessions setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] boolValue]] forKey:@"IsAdded"];
            
			[arrMySessions addObject: objMySessions];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    NSString *strMySessions = [arrMySessions JSONRepresentation];
    
	return strMySessions;
}

- (BOOL)SetMySessions:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        [self DeleteMySession:@""];
        
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrSessions = [dictData valueForKey:@"Sessions"];
        NSUInteger intEntriesM = [arrSessions count];
        
        if(intEntriesM > 0)
        {
            MySession *objMySession = [[MySession alloc] init];
            NSMutableDictionary *dictMySession;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictMySession = [[NSMutableDictionary alloc] init];
                
                dictMySession = [[arrSessions objectAtIndex:i] valueForKey:@"SessionDetails"];
                
                objMySession.strSessionInstanceID = [dictMySession valueForKey:@"SessionInstanceID"];
                
                if([[Functions ReplaceNUllWithBlank:objMySession.strSessionInstanceID] isEqualToString:@""])
                {
                }
                else
                {
                    NSString *strSQL = @"Select SessionInstanceID From MySessions Where SessionInstanceID = ?";
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:objMySession.strSessionInstanceID Query:strSQL] == NO)
                    {
                        blnResult = [self AddMySession:objMySession];
                    }
                    else
                    {
                        blnResult = YES;
                    }
                }
            }
        }
        
        if(blnResult == YES)
        {
            DB *objDB = [DB GetInstance];
            [objDB UpdateScreenWithVersion:strSCREEN_MY_SCHEDULE Version:intVersion];
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}

- (BOOL)SyncMySessions:(NSData *)objData
{
    BOOL blnResult = NO;
    
    //NSError *error;
    
    //NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    //dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    //if(error==nil)
    //{
    //NSArray *arrSessions = [dictData valueForKey:@"Sessions"];
    //NSArray *arrSessions = [NSPropertyListSerialization propertyListFromData:objData mutabilityOption:NSPropertyListMutableContainers format:&objFormat errorDescription:NULL];
    NSArray *arrSessions = [NSJSONSerialization JSONObjectWithData:objData options:0 error:nil];
    
    NSUInteger intEntriesM = [arrSessions count];
    
    if(intEntriesM > 0)
    {
        MySession *objMySession = [[MySession alloc] init];
        NSMutableDictionary *dictMySession;
        
        for (NSUInteger i = 0; i < intEntriesM; i++)
        {
            dictMySession = [[NSMutableDictionary alloc] init];
            
            dictMySession = [arrSessions objectAtIndex:i];
            
            objMySession.strSessionInstanceID = [dictMySession valueForKey:@"InstanceId"];
            
            if([[Functions ReplaceNUllWithBlank:objMySession.strSessionInstanceID] isEqualToString:@""])
            {
            }
            else
            {
                NSString *strSQL = @"Select SessionInstanceID From MySessions Where SessionInstanceID = ?";
                DB *objDB = [DB GetInstance];
                if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:objMySession.strSessionInstanceID Query:strSQL] == NO)
                {
                    if([[dictMySession valueForKey:@"IsAdded"] boolValue] == YES)
                    {
                        blnResult = [self AddMySession:objMySession];
                    }
                }
                else
                {
                    if([[dictMySession valueForKey:@"IsAdded"] boolValue] == NO)
                    {
                        blnResult = [self DeleteMySession:objMySession.strSessionInstanceID];
                    }
                }
            }
        }
    }
    //}
    
    return blnResult;
}

- (BOOL)AddSession:(NSString *)strSessionInstanceID
{
    BOOL blnResult = NO;
    
    MySession *objMySession = [[MySession alloc] init];
    
    objMySession.strSessionInstanceID = strSessionInstanceID;
    
    if([[Functions ReplaceNUllWithBlank:objMySession.strSessionInstanceID] isEqualToString:@""])
    {
    }
    else
    {
        NSString *strSQL = @"Select SessionInstanceID From MySessions Where SessionInstanceID = ?";
        DB *objDB = [DB GetInstance];
        if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:objMySession.strSessionInstanceID Query:strSQL] == NO)
        {
            blnResult = [self AddMySession:objMySession isSynced:FALSE];
        }
        else
        {
            NSString *strSQL = @"Select SessionInstanceID From MySessions Where SessionInstanceID = ? and IsSynced=1";
            DB *objDB = [DB GetInstance];
            if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:strSessionInstanceID Query:strSQL] == NO)
            {
                blnResult = [self DeleteMySession:strSessionInstanceID];;
            }
            else
            {
                blnResult = [self UpdateMySession:strSessionInstanceID isSynced:FALSE];
            }
        }
    }
    
    return blnResult;
}

- (BOOL)DeleteSession:(NSString *)strSessionInstanceID
{
    BOOL blnResult;
    NSString *strSQL = @"Select SessionInstanceID From MySessions Where SessionInstanceID = ? and IsSynced=1";
    DB *objDB = [DB GetInstance];
    if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:strSessionInstanceID Query:strSQL] == NO)
    {
        blnResult = [self DeleteMySession:strSessionInstanceID];;
    }
    else
    {
        blnResult = [self UpdateMySession:strSessionInstanceID isSynced:FALSE];
    }
    
    //return [self DeleteMySession:strSessionInstanceID];
    return blnResult;//[self UpdateMySession:strSessionInstanceID];
}
#pragma mark -

#pragma mark Private Methods

// Store in DB when user tap on "Add to My Schedule"
- (BOOL)AddMySession:(MySession*)objMySession isSynced:(BOOL)isSynced
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into MySessions(SessionInstanceID, IsDeleted, IsSynced) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, 0, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objMySession.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, isSynced);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddMySession:(MySession*)objMySession
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into MySessions(SessionInstanceID, IsDeleted) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, 0)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objMySession.strSessionInstanceID UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteMySession:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
    sqlite3 *dbEMEAFY14;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From MySessions ";
    
    if(![NSString IsEmpty:strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    }
    
    if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
    }
    else
    {
        if(![NSString IsEmpty:strSessionInstanceID shouldCleanWhiteSpace:YES])
        {
            sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        }
        
        if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
            blnResult = NO;
        }
        else
        {
            blnResult = YES;
        }
    }
    
    return blnResult;
}

- (BOOL)UpdateMySession:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
    if(![NSString IsEmpty:strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        
        NSString *strSQL = @"Update MySessions Set ";
        strSQL = [strSQL stringByAppendingFormat:@"IsDeleted = Not IfNull(IsDeleted, 0) "];
        strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
        
        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
        }
        else
        {
            sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
            
            if( SQLITE_DONE != sqlite3_step(compiledStmt) )
            {
                NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
                [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
                
                blnResult = NO;
            }
            else
            {
                blnResult = YES;
            }
        }
    }
    
    return blnResult;
}

- (BOOL)UpdateMySession:(NSString*)strSessionInstanceID isSynced:(BOOL)isSynced
{
    BOOL blnResult = NO;
    
    if(![NSString IsEmpty:strSessionInstanceID shouldCleanWhiteSpace:YES])
    {
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        
        NSString *strSQL = @"Update MySessions Set ";
        strSQL = [strSQL stringByAppendingFormat:@"IsDeleted = 1, isSynced = ? "];
        strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
        
        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
        }
        else
        {
            sqlite3_bind_int(compiledStmt, 1, isSynced);
            sqlite3_bind_text(compiledStmt, 2, [strSessionInstanceID UTF8String], -1, NULL);
            
            if( SQLITE_DONE != sqlite3_step(compiledStmt) )
            {
                NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
                [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
                
                blnResult = NO;
            }
            else
            {
                blnResult = YES;
            }
        }
    }
    
    return blnResult;
}

- (NSMutableArray*)GetSessionResources:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSesssionResources = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ResourceID, SessionInstanceID, FileName, DocType, DocTypeID, URL, BriefDescription From SessionResources Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionResources *objSessionResources = [[SessionResources alloc] init];
            
            objSessionResources.strResourceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionResources.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionResources.strFileName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSessionResources.strDocType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSessionResources.strDocTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSessionResources.strURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSessionResources.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            
			//Read the data from the result row
			[arrSesssionResources addObject:objSessionResources];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSesssionResources;
}

- (NSMutableArray*)GetSessionTracks:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSesssionTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select TrackInstanceID, SessionInstanceID, TrackName From SessionTracks Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionTracks *objSessionTracks = [[SessionTracks alloc] init];
            
            objSessionTracks.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionTracks.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionTracks.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSesssionTracks addObject:objSessionTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSesssionTracks;
}

- (NSMutableArray*)GetSessionSubTracks:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionSubTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SubTrackInstanceID, SessionInstanceID, SubTrackName From SessionSubTracks Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionSubTracks *objSessionSubTracks = [[SessionSubTracks alloc] init];
            
            objSessionSubTracks.strSubTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionSubTracks.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionSubTracks.strSubTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSessionSubTracks addObject:objSessionSubTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionSubTracks;
}

- (NSMutableArray*)GetSessionCategories:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryInstanceID, SessionInstanceID, CategoryName From SessionCategories Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionCategories *objSessionCategories = [[SessionCategories alloc] init];
            
            objSessionCategories.strCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionCategories.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionCategories.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSessionCategories addObject:objSessionCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionCategories;
}

- (NSMutableArray*)GetSessionRooms:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionRooms = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select RoomInstanceID, SessionInstanceID, RoomName, Capacity From SessionRooms Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionRooms *objSessionRooms = [[SessionRooms alloc] init];
            
            objSessionRooms.strRoomInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionRooms.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionRooms.strRoomName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSessionRooms.strCapacity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
			//Read the data from the result row
			[arrSessionRooms addObject:objSessionRooms];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionRooms;
}

- (NSArray*)GetSessionSpeakersForSessionID:(id)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpeakers = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    SpeakerDB *objSpeakerDB = [[SpeakerDB alloc] init];
    
    char *strSQL = "Select SpeakerSessions.SessionInstanceID, SpeakerSessions.SpeakerInstanceID From SpeakerSessions Inner Join Speakers On SpeakerSessions.SpeakerInstanceID = Speakers.SpeakerInstanceID Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSArray *arrTemp = [[NSArray alloc] init];
            
            arrTemp = [objSpeakerDB GetSpeakersWithSpeakerIDAndSessionsAndGrouped:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] IncludeSessions:NO Grouped:NO];
            
			//Read the data from the result row
			[arrSpeakers addObject:arrTemp];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MY_SCHEDULE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpeakers;
}
#pragma mark -
@end
