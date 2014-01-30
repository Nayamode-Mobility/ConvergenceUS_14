//
//  NotesDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "NotesDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "SessionDB.h"
#import "Constants.h"
#import "Functions.h"
#import "NSString+Custom.h"

@implementation NotesDB
static NotesDB *objNotesDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objNotesDB == nil)
    {
        objNotesDB = [[self alloc] init];
    }
    
    return objNotesDB;
}

- (id)init
{
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods (User Session Notes)
- (NSArray*)GetUserSessionNotes
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrNotes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select IfNull(UserSessionNotes.NoteID, 0) As NoteID, UserSessionNotes.LocalID, IfNull(Sessions.SessionInstanceID, '') As SessionInstanceID, UserSessionNotes.UserEmail, UserSessionNotes.Title, UserSessionNotes.Content, UserSessionNotes.CreatedDate, IfNull(UserSessionNotes.UpdatedDate,UserSessionNotes.CreatedDate) As UpdatedDate, IfNull(Sessions.SessionCode, '') As SessionCode, IfNull(Sessions.SessionTitle, '') As SessionTitle, UserSessionNotes.IsAdded, UserSessionNotes.IsUpdated, UserSessionNotes.IsDeleted From UserSessionNotes Left Join Sessions On UserSessionNotes.SessionInstanceId = Sessions.SessionInstanceID Where UserSessionNotes.IsDeleted = 0 Order By IfNull(UserSessionNotes.UpdatedDate,UserSessionNotes.CreatedDate) Desc, UserSessionNotes.CreatedDate Desc";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            UserSessionNotes *objNotes = [[UserSessionNotes alloc] init];
            
            objNotes.strNoteID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objNotes.strLocalID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objNotes.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objNotes.strUserEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objNotes.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objNotes.strContent = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objNotes.strCreatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objNotes.strUpdatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objNotes.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objNotes.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objNotes.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objNotes.strIsUpdated = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objNotes.strIsDeleted = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            
            if(![NSString IsEmpty:objNotes.strSessionInstanceID shouldCleanWhiteSpace:YES])
            {
                SessionDB *objSessionDB = [SessionDB GetInstance];
                objNotes.arrSession = [objSessionDB GetSessionsWithSessionID:objNotes.strSessionInstanceID];
            }
            
			[arrNotes addObject:objNotes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrNotes;
}

- (NSArray*)GetUserSessionNoteWithID:(id)strNoteID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrNotes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select IfNull(UserSessionNotes.NoteID, 0) As NoteID, UserSessionNotes.LocalID, IfNull(Sessions.SessionInstanceID, '') As SessionInstanceID, UserSessionNotes.UserEmail, UserSessionNotes.Title, UserSessionNotes.Content, UserSessionNotes.CreatedDate, IfNull(UserSessionNotes.UpdatedDate,UserSessionNotes.CreatedDate) As UpdatedDate, IfNull(Sessions.SessionCode, '') As SessionCode, IfNull(Sessions.SessionTitle, '') As SessionTitle, UserSessionNotes.IsAdded, UserSessionNotes.IsUpdated, UserSessionNotes.IsDeleted From UserSessionNotes Left Join Sessions On UserSessionNotes.SessionInstanceId = Sessions.SessionInstanceID Where UserSessionNotes.IsDeleted = 0 Order By IfNull(UserSessionNotes.UpdatedDate,UserSessionNotes.CreatedDate) Desc, UserSessionNotes.CreatedDate Desc";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strNoteID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            UserSessionNotes *objNotes = [[UserSessionNotes alloc] init];
            
            objNotes.strNoteID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objNotes.strLocalID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objNotes.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objNotes.strUserEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objNotes.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objNotes.strContent = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objNotes.strCreatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objNotes.strUpdatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objNotes.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objNotes.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objNotes.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objNotes.strIsUpdated = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objNotes.strIsDeleted = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            
			[arrNotes addObject:objNotes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrNotes;    
}

- (NSArray*)GetUserSessionNoteWithSessionInstanceID:(id)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrNotes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select IfNull(UserSessionNotes.NoteID, 0) As NoteID, UserSessionNotes.LocalID, IfNull(Sessions.SessionInstanceID, '') As SessionInstanceID, UserSessionNotes.UserEmail, UserSessionNotes.Title, UserSessionNotes.Content, UserSessionNotes.CreatedDate, IfNull(UserSessionNotes.UpdatedDate,UserSessionNotes.CreatedDate) As UpdatedDate, IfNull(Sessions.SessionCode, '') As SessionCode, IfNull(Sessions.SessionTitle, '') As SessionTitle, UserSessionNotes.IsAdded, UserSessionNotes.IsUpdated, UserSessionNotes.IsDeleted From UserSessionNotes Left Join Sessions On UserSessionNotes.SessionInstanceId = Sessions.SessionInstanceID Where UserSessionNotes.IsDeleted = 0 And UserSessionNotes.SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        //sqlite3_bind_int(compiledStmt, 1, [strSessionInstanceID UTF8String]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            UserSessionNotes *objNotes = [[UserSessionNotes alloc] init];
            
            objNotes.strNoteID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objNotes.strLocalID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objNotes.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objNotes.strUserEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objNotes.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objNotes.strContent = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objNotes.strCreatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objNotes.strUpdatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objNotes.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objNotes.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objNotes.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objNotes.strIsUpdated = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objNotes.strIsDeleted = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            
			[arrNotes addObject:objNotes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrNotes;
}

- (NSString*)GetMyNotesJSON
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrMyNotes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select UserSessionNotes.LocalID, IfNull(UserSessionNotes.NoteID, 0) As NoteID, IfNull(UserSessionNotes.SessionInstanceID, '') As SessionInstanceID, UserSessionNotes.CreatedDate, UserSessionNotes.UserEmail, UserSessionNotes.Title, UserSessionNotes.Content, UserSessionNotes.IsAdded, UserSessionNotes.IsUpdated, UserSessionNotes.IsDeleted From UserSessionNotes Where IsAdded <> 0 Or IsUpdated <> 0 Or IsDeleted <> 0";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSMutableDictionary *objMyNotes = [[NSMutableDictionary alloc] init];
            
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] forKey:@"LocalId"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] forKey:@"NoteDBId"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)] forKey:@"SessionInstanceId"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)] forKey:@"AddedDateTime"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)] forKey:@"UserEmail"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)] forKey:@"Title"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)] forKey:@"Content"];
            [objMyNotes setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)] boolValue]] forKey:@"IsAdded"];
            [objMyNotes setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)] boolValue]] forKey:@"IsUpdated"];
            [objMyNotes setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)] boolValue]] forKey:@"IsDeleted"];
            
			[arrMyNotes addObject: objMyNotes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    NSString *strMynotes = [arrMyNotes JSONRepresentation];
    
	return strMynotes;
}

- (BOOL)SetUserSessionNotes:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        NSArray *arrUserNotes = (NSArray*)dictData;
        NSUInteger intEntriesM = [arrUserNotes count];
        
        if(intEntriesM > 0)
        {
            [self DeleteMySessioNote:@""];
            UserSessionNotes *objUserSessionNotes = [[UserSessionNotes alloc] init];
            NSMutableDictionary *dictUserSessionNotes;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictUserSessionNotes = [[NSMutableDictionary alloc] init];
                
                dictUserSessionNotes = [arrUserNotes objectAtIndex:i];
                
                objUserSessionNotes.strLocalID = [dictUserSessionNotes valueForKey:@"LocalId"];
                
                if([[Functions ReplaceNUllWithBlank:objUserSessionNotes.strLocalID] isEqualToString:@""])
                {
                }
                else
                {
                    objUserSessionNotes.strNoteID = [dictUserSessionNotes valueForKey:@"NoteDBId"];
                    objUserSessionNotes.strSessionInstanceID = [Functions ReplaceNUllWithBlank:[dictUserSessionNotes valueForKey:@"SessionInstanceId"]];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                    NSDate *dtCreatedDate = [dateFormat dateFromString:[dictUserSessionNotes valueForKey:@"AddedDateTime"]];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strCreatedDate = [dateFormat stringFromDate:dtCreatedDate];
                    
                    //objUserSessionNotes.strCreatedDate = [dictUserSessionNotes valueForKey:@"AddedDateTime"];
                    objUserSessionNotes.strCreatedDate = strCreatedDate;
                    
                    objUserSessionNotes.strUserEmail = [dictUserSessionNotes valueForKey:@"UserEmail"];
                    objUserSessionNotes.strTitle = [dictUserSessionNotes valueForKey:@"Title"];
                    objUserSessionNotes.strContent = [dictUserSessionNotes valueForKey:@"Content"];
                    objUserSessionNotes.strIsAdded = @"0";//[dictUserSessionNotes valueForKey:@"IsAdded"];
                    objUserSessionNotes.strIsUpdated = @"0";//[dictUserSessionNotes valueForKey:@"IsUpdated"];
                    objUserSessionNotes.strIsDeleted = @"0";//[dictUserSessionNotes valueForKey:@"IsDeleted"];
                    
                    NSString *strSQL = @"Select LocalID From UserSessionNotes Where LocalID = ?";
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:objUserSessionNotes.strLocalID Query:strSQL] == NO)
                    {
                        blnResult = [self AddMySessionNote:objUserSessionNotes];
                    }
                    else
                    {
                        blnResult = [self UpdateMySessionNote:objUserSessionNotes];
                    }
                }
            }
        }
    }
   
    return blnResult;
}

- (BOOL)AddUserSessionNote:(UserSessionNotes *)objUserSessionNotes
{
    BOOL blnResult = NO;
    
    if([[Functions ReplaceNUllWithBlank:objUserSessionNotes.strTitle] isEqualToString:@""])
    {
    }
    else
    {
        blnResult = [self AddMySessionNote:objUserSessionNotes];
    }
    
    return blnResult;
}

- (BOOL)UpdateUserSessionNote:(UserSessionNotes *)objUserSessionNotes
{
    BOOL blnResult = NO;
    
    if([[Functions ReplaceNUllWithBlank:objUserSessionNotes.strTitle] isEqualToString:@""])
    {
    }
    else
    {
        blnResult = [self UpdateMySessionNote:objUserSessionNotes];
    }
    
    return blnResult;
}

- (BOOL)UpdateUserSessionNoteAsDeleted:(UserSessionNotes*)objUserSessionNotes
{
    return [self UpdateMySessionNoteAsDeleted:objUserSessionNotes];
}
#pragma mark -

#pragma mark Private Methods (User Session Notes)
- (BOOL)AddMySessionNote:(UserSessionNotes*)objUserSessionNotes
{
    BOOL blnResult = NO;
    int intNoteID = 0;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into UserSessionNotes(LocalID, NoteID, SessionInstanceID, UserEmail, Title, Content, CreatedDate, IsAdded) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objUserSessionNotes.strLocalID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, [objUserSessionNotes.strNoteID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objUserSessionNotes.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objUserSessionNotes.strUserEmail UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objUserSessionNotes.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objUserSessionNotes.strContent UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objUserSessionNotes.strCreatedDate UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 8, [objUserSessionNotes.strIsAdded boolValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            
            blnResult = NO;
            intNoteID = 0;
		}
		else
        {
            blnResult = YES;
			intNoteID = sqlite3_last_insert_rowid(dbEMEAFY14);
		}
    }
    
    objUserSessionNotes.strNoteID = [NSString stringWithFormat:@"%d",intNoteID];
    
    return blnResult;
}

- (BOOL)UpdateMySessionNote:(UserSessionNotes*)objUserSessionNotes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    NSString *strSQL = @"Update UserSessionNotes Set ";
    strSQL = [strSQL stringByAppendingFormat:@"NoteID = ?, "];    
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Content = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"UpdatedDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsAdded = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsUpdated = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsDeleted = ? "];    
    strSQL = [strSQL stringByAppendingFormat:@"Where LocalID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objUserSessionNotes.strNoteID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objUserSessionNotes.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objUserSessionNotes.strContent UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objUserSessionNotes.strUpdatedDate UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objUserSessionNotes.strIsAdded boolValue]);
        sqlite3_bind_int(compiledStmt, 6, [objUserSessionNotes.strIsUpdated boolValue]);
        sqlite3_bind_int(compiledStmt, 7, [objUserSessionNotes.strIsDeleted boolValue]);
        
        sqlite3_bind_text(compiledStmt, 8, [objUserSessionNotes.strLocalID UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
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

- (BOOL)UpdateMySessionNoteAsDeleted:(UserSessionNotes*)objUserSessionNotes
{
    BOOL blnResult = NO;
    
    if([objUserSessionNotes.strIsAdded boolValue] == YES)
    {
        blnResult = [self DeleteMySessioNote:objUserSessionNotes.strLocalID];
    }
    else
    {
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        NSString *strSQL = @"Update UserSessionNotes Set ";
        strSQL = [strSQL stringByAppendingFormat:@"IsAdded = 0, "];
        strSQL = [strSQL stringByAppendingFormat:@"IsUpdated = 0, "];
        strSQL = [strSQL stringByAppendingFormat:@"IsDeleted = 1 "];
        strSQL = [strSQL stringByAppendingFormat:@"Where LocalID = ? "];
        
        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        }
        else
        {
            sqlite3_bind_text(compiledStmt, 1, [objUserSessionNotes.strLocalID UTF8String], -1, NULL);
            
            if(SQLITE_DONE != sqlite3_step(compiledStmt))
            {
                NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
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

- (BOOL)DeleteMySessioNote:(NSString*)strLocalID
{
    BOOL blnResult = NO;
    
    sqlite3 *dbEMEAFY14;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From UserSessionNotes ";
    
    if(![NSString IsEmpty:strLocalID shouldCleanWhiteSpace:YES] == YES)
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where LocalID = ? "];
    }
    
    if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
    }
    else
    {
        if(![NSString IsEmpty:strLocalID shouldCleanWhiteSpace:YES] == YES)
        {
            sqlite3_bind_text(compiledStmt, 1, [strLocalID UTF8String], -1, NULL);
        }
        
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

#pragma mark Private Methods (Attendee Notes)

- (BOOL)SetAttendeeNotes:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        NSArray *arrUserNotes = (NSArray*)dictData;
        NSUInteger intEntriesM = [arrUserNotes count];
        
        if(intEntriesM > 0)
        {
            [self DeleteAttendeeNote:@""];
            UserSessionNotes *objUserSessionNotes = [[UserSessionNotes alloc] init];
            NSMutableDictionary *dictUserSessionNotes;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictUserSessionNotes = [[NSMutableDictionary alloc] init];
                
                dictUserSessionNotes = [arrUserNotes objectAtIndex:i];
                
                objUserSessionNotes.strLocalID = [dictUserSessionNotes valueForKey:@"LocalId"];
                
                if([[Functions ReplaceNUllWithBlank:objUserSessionNotes.strLocalID] isEqualToString:@""])
                {
                }
                else
                {
                    objUserSessionNotes.strNoteID = [dictUserSessionNotes valueForKey:@"NoteDBId"];
                    objUserSessionNotes.strAttendeeEmailId= [Functions ReplaceNUllWithBlank:[dictUserSessionNotes valueForKey:@"ForAttendeeEmail"]];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
                    NSDate *dtCreatedDate = [dateFormat dateFromString:[dictUserSessionNotes valueForKey:@"AddedDateTime"]];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strCreatedDate = [dateFormat stringFromDate:dtCreatedDate];
                    
                    //objUserSessionNotes.strCreatedDate = [dictUserSessionNotes valueForKey:@"AddedDateTime"];
                    objUserSessionNotes.strCreatedDate = strCreatedDate;
                    
                    objUserSessionNotes.strUserEmail = [dictUserSessionNotes valueForKey:@"UserEmail"];
                    objUserSessionNotes.strTitle = [dictUserSessionNotes valueForKey:@"Title"];
                    objUserSessionNotes.strContent = [dictUserSessionNotes valueForKey:@"Content"];
                    objUserSessionNotes.strIsAdded = @"0";//[dictUserSessionNotes valueForKey:@"IsAdded"];
                    objUserSessionNotes.strIsUpdated = @"0";//[dictUserSessionNotes valueForKey:@"IsUpdated"];
                    objUserSessionNotes.strIsDeleted = @"0";//[dictUserSessionNotes valueForKey:@"IsDeleted"];

                    blnResult = [self AddAttendeeNote:objUserSessionNotes];
                }
            }
        }
    }
    
    return blnResult;
}

- (NSArray*)GetAttendeeNotes:(NSString *)strAttendeEmail
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrNotes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select NoteID, LocalID, AttendeeEmail, UserEmail, Title, Content, CreatedDate, IfNull(UpdatedDate,CreatedDate) As UpdatedDate,IsAdded, IsUpdated,IsDeleted From AttendeeNotes where AttendeeEmail = ?  Order By IfNull(UpdatedDate,CreatedDate) Desc, CreatedDate Desc ";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strAttendeEmail UTF8String], -1, NULL);
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            UserSessionNotes *objNotes = [[UserSessionNotes alloc] init];
            
            objNotes.strNoteID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objNotes.strLocalID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objNotes.strAttendeeEmailId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objNotes.strUserEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objNotes.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objNotes.strContent = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objNotes.strCreatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objNotes.strUpdatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objNotes.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objNotes.strIsUpdated = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objNotes.strIsDeleted = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
                        
			[arrNotes addObject:objNotes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrNotes;
}

- (BOOL)AddAttendeeNote:(UserSessionNotes*)objUserSessionNotes
{
    BOOL blnResult = NO;
    int intNoteID = 0;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into AttendeeNotes(LocalID, NoteID, AttendeeEmail, UserEmail, Title, Content, CreatedDate, IsAdded) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objUserSessionNotes.strLocalID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, [objUserSessionNotes.strNoteID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objUserSessionNotes.strAttendeeEmailId UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objUserSessionNotes.strUserEmail UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objUserSessionNotes.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objUserSessionNotes.strContent UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objUserSessionNotes.strCreatedDate UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 8, [objUserSessionNotes.strIsAdded boolValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            
            blnResult = NO;
            intNoteID = 0;
		}
		else
        {
            blnResult = YES;
			intNoteID = sqlite3_last_insert_rowid(dbEMEAFY14);
		}
    }
    
    objUserSessionNotes.strNoteID = [NSString stringWithFormat:@"%d",intNoteID];
    
    return blnResult;
}

- (NSString*)GetAttendeeNotesJSON
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrMyNotes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];

//    char *strSQL = "Select AttendeeNotes.LocalID, IfNull(AttendeeNotes.NoteID, 0) As NoteID, IfNull(AttendeeNotes.AttendeeEmail, '') As SessionInstanceID, UserSessionNotes.CreatedDate, UserSessionNotes.UserEmail, UserSessionNotes.Title, UserSessionNotes.Content, UserSessionNotes.IsAdded, UserSessionNotes.IsUpdated, UserSessionNotes.IsDeleted From UserSessionNotes Where IsAdded <> 0 Or IsUpdated <> 0 Or IsDeleted <> 0";

    char *strSQL = "Select AttendeeNotes.LocalID, IfNull(AttendeeNotes.NoteID, 0) As NoteID, IfNull(AttendeeNotes.AttendeeEmail, '') As AttendeeEmail, AttendeeNotes.CreatedDate, AttendeeNotes.UserEmail, AttendeeNotes.Title, AttendeeNotes.Content, AttendeeNotes.IsAdded, AttendeeNotes.IsUpdated, AttendeeNotes.IsDeleted From AttendeeNotes Where IsAdded <> 0 Or IsUpdated <> 0 Or IsDeleted <> 0";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSMutableDictionary *objMyNotes = [[NSMutableDictionary alloc] init];
            
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] forKey:@"LocalId"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] forKey:@"NoteDBId"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)] forKey:@"ForAttendeeEmail"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)] forKey:@"AddedDateTime"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)] forKey:@"UserEmail"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)] forKey:@"Title"];
            [objMyNotes setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)] forKey:@"Content"];
            [objMyNotes setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)] boolValue]] forKey:@"IsAdded"];
            [objMyNotes setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)] boolValue]] forKey:@"IsUpdated"];
            [objMyNotes setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)] boolValue]] forKey:@"IsDeleted"];
            
			[arrMyNotes addObject: objMyNotes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    NSString *strMynotes = [arrMyNotes JSONRepresentation];
    
	return strMynotes;
}

- (BOOL)UpdateAttendeeNoteAsDeleted:(UserSessionNotes*)objUserSessionNotes
{
    BOOL blnResult = NO;
    
    if([objUserSessionNotes.strIsAdded boolValue] == YES)
    {
        blnResult = [self DeleteAttendeeNote:objUserSessionNotes.strLocalID];
    }
    else
    {
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        NSString *strSQL = @"Update AttendeeNotes Set ";
        strSQL = [strSQL stringByAppendingFormat:@"IsAdded = 0, "];
        strSQL = [strSQL stringByAppendingFormat:@"IsUpdated = 0, "];
        strSQL = [strSQL stringByAppendingFormat:@"IsDeleted = ? "];
        strSQL = [strSQL stringByAppendingFormat:@"Where LocalID = ? "];
        
        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        }
        else
        {
            sqlite3_bind_int(compiledStmt, 1, [objUserSessionNotes.strIsDeleted boolValue]);
            sqlite3_bind_text(compiledStmt, 2, [objUserSessionNotes.strLocalID UTF8String], -1, NULL);
            
            if(SQLITE_DONE != sqlite3_step(compiledStmt))
            {
                NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
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

- (BOOL)UpdateAttendeeNote:(UserSessionNotes*)objUserSessionNotes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    NSString *strSQL = @"Update AttendeeNotes Set ";
    strSQL = [strSQL stringByAppendingFormat:@"NoteID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Content = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"UpdatedDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsAdded = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsUpdated = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsDeleted = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where LocalID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objUserSessionNotes.strNoteID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objUserSessionNotes.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objUserSessionNotes.strContent UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objUserSessionNotes.strUpdatedDate UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objUserSessionNotes.strIsAdded boolValue]);
        sqlite3_bind_int(compiledStmt, 6, [objUserSessionNotes.strIsUpdated boolValue]);
        sqlite3_bind_int(compiledStmt, 7, [objUserSessionNotes.strIsDeleted boolValue]);
        
        sqlite3_bind_text(compiledStmt, 8, [objUserSessionNotes.strLocalID UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
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

- (BOOL)DeleteNoteOfAttendeeEmailID:(NSString*)strEmailID
{
    BOOL blnResult = NO;
    
    sqlite3 *dbEMEAFY14;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From AttendeeNotes Where AttendeeEmail = ?";
    
    if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
    }
    else
    {
        if(![NSString IsEmpty:strEmailID shouldCleanWhiteSpace:YES] == YES)
        {
            sqlite3_bind_text(compiledStmt, 1, [strEmailID UTF8String], -1, NULL);
        }
        
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

- (BOOL)DeleteAttendeeNote:(NSString*)strLocalID
{
    BOOL blnResult = NO;
    
    sqlite3 *dbEMEAFY14;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From AttendeeNotes ";
    
    if(![NSString IsEmpty:strLocalID shouldCleanWhiteSpace:YES] == YES)
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where LocalID = ? "];
    }
    
    if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
    }
    else
    {
        if(![NSString IsEmpty:strLocalID shouldCleanWhiteSpace:YES] == YES)
        {
            sqlite3_bind_text(compiledStmt, 1, [strLocalID UTF8String], -1, NULL);
        }
        
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

#pragma mark -
@end
