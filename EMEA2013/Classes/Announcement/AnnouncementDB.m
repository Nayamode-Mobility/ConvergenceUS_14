//
//  VenueDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AnnouncementDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"

@implementation AnnouncementDB

static AnnouncementDB *objAnnouncementDB = nil;
static NSString *latestTopic;
static NSString *latestMessage;

+ (NSString *)getLatestTopic
{
    return latestTopic;
}


+ (NSString *)getLatestMessage
{
    return latestMessage;
}

// Yes, ugly, but quick

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objAnnouncementDB == nil)
    {
        objAnnouncementDB = [[self alloc] init];
    }
    
    return objAnnouncementDB;
}

- (id)init
{
    return self;
}

- (void)dealloc
{
}

#define CSTRING_OR_NIL(str) (str == NULL) ? "" : str

+(Announcement *)getLatestAnnouncement
{
    sqlite3 *dbEMEAFY14;
    
	Announcement *a = [[Announcement alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select AnnouncementID, AnnouncementTopic, AnnouncementMessage, TimeDiff, CreatedDate, NotifyDate From Announcements";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            
            a.strAnnouncementId = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 0))];
            a.strAnnouncementTopic = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 1))];
            a.strAnnouncementMessage = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 2))];
            a.strTimeDiff = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 3))];
            a.strCreatedDate = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 4))];
            a.strNotifyDate = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 5))];
            
		}
	}
	else
    {
        a = nil;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return a;
}
#pragma mark -

#pragma mark Instance Methods
- (NSArray*)GetAnnouncements
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAnnouncements = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select AnnouncementID, AnnouncementTopic, AnnouncementMessage, TimeDiff, CreatedDate, NotifyDate From Announcements Order By NotifyDate Desc, CreatedDate Desc";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Announcement *objAnnouncement = [[Announcement alloc] init];
            
            objAnnouncement.strAnnouncementId = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 0))];
            objAnnouncement.strAnnouncementTopic = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 1))];
            objAnnouncement.strAnnouncementMessage = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 2))];
            objAnnouncement.strTimeDiff = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 3))];
            objAnnouncement.strCreatedDate = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 4))];
            objAnnouncement.strNotifyDate = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 5))];
            
			[arrAnnouncements addObject:objAnnouncement];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAnnouncements;
}

- (NSArray*)GetAnnouncementsWithAnnouncementID:(id)strAnnouncementID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAnnouncements = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select AnnouncementID, AnnouncementTopic, AnnouncementMessage, TimeDiff, CreatedDate, NotifyDate From Announcements Where AnnouncementID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strAnnouncementID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Announcement *objAnnouncement = [[Announcement alloc] init];
            
            objAnnouncement.strAnnouncementId = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 0))];
            objAnnouncement.strAnnouncementTopic = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 1))];
            objAnnouncement.strAnnouncementMessage = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 2))];
            objAnnouncement.strTimeDiff = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 3))];
            objAnnouncement.strCreatedDate = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 4))];
            objAnnouncement.strNotifyDate = [NSString stringWithUTF8String: CSTRING_OR_NIL((char *)sqlite3_column_text(compiledStmt, 5))];
            
			[arrAnnouncements addObject:objAnnouncement];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAnnouncements;
}

- (BOOL)SetAnnouncements:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([dictData isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"AnnouncementList"];
    }
    
    if(error==nil)
    {
        //NSUInteger intVersion = (NSUInteger)[dictData valueForKey:strKEY_VERSION_NO];
        NSArray *arrAnnouncements = (NSArray *)dictData;
        NSUInteger intEntriesM = [arrAnnouncements count];
        
        if(intEntriesM > 0)
        {
            
            [self DeleteAnnouncements];
       
            Announcement *objAnnouncement = [[Announcement alloc] init];
            NSMutableDictionary *dictAnnouncement;
            
           // NSUInteger intEntriesD = 0;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictAnnouncement = [[NSMutableDictionary alloc] init];
                
                dictAnnouncement = [arrAnnouncements objectAtIndex:i];
                
                objAnnouncement.strAnnouncementId = [dictAnnouncement valueForKey:@"AnnouncementId"];
                objAnnouncement.strAnnouncementMessage = [dictAnnouncement valueForKey:@"AnnouncementMessage"];
                objAnnouncement.strAnnouncementTopic = [dictAnnouncement valueForKey:@"AnnouncementTopic"];
                objAnnouncement.strCreatedDate = [dictAnnouncement valueForKey:@"CreatedDate"];
                objAnnouncement.strNotifyDate = [dictAnnouncement valueForKey:@"NotifyDate"];
                objAnnouncement.strTimeDiff = [dictAnnouncement valueForKey:@"TimeDiff"];
                
                if (i == 0)
                {
                    latestTopic = objAnnouncement.strAnnouncementTopic;
                    latestMessage = objAnnouncement.strAnnouncementMessage;
                }

                if(0 != [Functions ReplaceNUllWithZero:objAnnouncement.strAnnouncementId])
                {
                    objAnnouncement.strAnnouncementId = [Functions ReplaceNUllWithBlank:[dictAnnouncement valueForKey:@"AnnouncementId"]];
                    objAnnouncement.strAnnouncementMessage = [Functions ReplaceNUllWithBlank:[dictAnnouncement valueForKey:@"AnnouncementMessage"]];
                    objAnnouncement.strAnnouncementTopic = [Functions ReplaceNUllWithBlank:[dictAnnouncement valueForKey:@"AnnouncementTopic"]];
                    objAnnouncement.strCreatedDate = [Functions ReplaceNUllWithBlank:[dictAnnouncement valueForKey:@"CreatedDate"]];
                    objAnnouncement.strNotifyDate = [Functions ReplaceNUllWithBlank:[dictAnnouncement valueForKey:@"NotifyDate"]];
                    objAnnouncement.strTimeDiff = [Functions ReplaceNUllWithBlank:[dictAnnouncement valueForKey:@"TimeDiff"]];
                    
                    //NSString *strSQL = @"Select AnnouncementId From Announcements Where AnnouncementId = ?";
                    
                    //DB *objDB = [DB GetInstance];
                    //if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAnnouncement.strAnnouncementId intValue] Query:strSQL] == NO)
                    //{
                        blnResult = [self AddAnnouncement:objAnnouncement];
                    //}
                    //else
                    //{
                    //    blnResult = [self UpdateAnnouncement:objAnnouncement];
                    //}
                }
            }
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
        
    return blnResult;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteAnnouncements
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Announcements ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where AnnouncementId = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strAnnouncementId intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddAnnouncement:(Announcement*)objAnnouncement
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Announcements(AnnouncementId, AnnouncementTopic, AnnouncementMessage, TimeDiff, CreatedDate, NotifyDate) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAnnouncement.strAnnouncementId intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objAnnouncement.strAnnouncementTopic UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objAnnouncement.strAnnouncementMessage UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAnnouncement.strTimeDiff UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAnnouncement.strCreatedDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAnnouncement.strNotifyDate UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateAnnouncement:(Announcement*)objAnnouncement
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Announcements Set ";
    strSQL = [strSQL stringByAppendingFormat:@"AnnouncementTopic = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"AnnouncementMessage = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TimeDiff = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"CreatedDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"NotifyDate = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where AnnouncementId = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAnnouncement.strAnnouncementId intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objAnnouncement.strAnnouncementTopic UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objAnnouncement.strAnnouncementMessage UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAnnouncement.strTimeDiff UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAnnouncement.strCreatedDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAnnouncement.strNotifyDate UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 7, [objAnnouncement.strAnnouncementId intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ANNOUNCEMENT MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

