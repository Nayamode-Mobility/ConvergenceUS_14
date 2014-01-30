//
//  MessagingDB.m
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MessagingDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "Message.h"

@implementation MessagingDB
static MessagingDB *objMessagingDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objMessagingDB == nil)
    {
        objMessagingDB = [[self alloc] init];
    }
    
    return objMessagingDB;
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
- (NSArray*)GetInboxMessages
{
	return [self GetMessages:@"Inbox"];
}

- (NSArray*)GetSentboxMessages
{
	return [self GetMessages:@"Sentbox"];
}

- (NSArray*)GetDraftMessages
{
	return [self GetMessages:@"Draft"];
}

- (NSArray*)GetMessages:(NSString *)strTableName
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrMessages = [[NSMutableArray alloc] init];
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = [NSString stringWithFormat:@"Select MessageID, FromAttendeeName, ToAttendeeName, ToAttendee, FromAttendee, AttendeeMessage, MessageSubject, IsToDelete, IsFromDelete, CreatedDate From %@ Order By CreatedDate",strTableName];
    
    if ([strTableName isEqualToString:@"Sentbox"]) {
        strSQL = @"Select MessageID, FromAttendeeName, ToAttendeeName, ToAttendee, FromAttendee, AttendeeMessage, MessageSubject, IsToDelete, IsFromDelete, CreatedDate From Sentbox  Where IsSent = 1 Order By CreatedDate";
    }
    
    if ([strTableName isEqualToString:@"Draft"]) {
        strSQL = @"Select MessageID, FromAttendeeName, ToAttendeeName, ToAttendee, FromAttendee, AttendeeMessage, MessageSubject, IsToDelete, IsFromDelete, CreatedDate From Sentbox  Where IsSent = 0 Order By CreatedDate";
    }
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Message *objMessage = [[Message alloc] init];
            
            objMessage.strMessageID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objMessage.strFromAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objMessage.strToAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objMessage.strToAttendee = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objMessage.strFromAttendee = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objMessage.strAttendeeMessage = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objMessage.strMessageSubject = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objMessage.strIsToDelete = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objMessage.strIsFromDelete = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objMessage.strCreatedDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            
			[arrMessages addObject:objMessage];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
    
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrMessages;
}

- (BOOL)SetMessages:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        //int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        //NSLog(@"%@",dictData);
        NSArray *arrInboxItems = [dictData valueForKey:@"InboxItems"];
        [self AddMessages:arrInboxItems TableName:@"Inbox"];
        
        [self DeleteSentMessages];
        NSArray *arrSentboxItems = [dictData valueForKey:@"SentboxItems"];
        [self AddMessages:arrSentboxItems TableName:@"Sentbox"];
        
        NSArray *arrDeletedInboxItems = [dictData valueForKey:@"DeletedInboxItems"];
        [self AddMessages:arrDeletedInboxItems TableName:@"Inbox"];
        
        NSArray *arrDeletedSentboxItems = [dictData valueForKey:@"DeletedSentboxItems"];
        [self AddMessages:arrDeletedSentboxItems TableName:@"Sentbox"];
        
        /*if(blnResult == YES)
        {
            DB *objDB = [DB GetInstance];
            [objDB UpdateScreenWithVersion:strSCREEN_AGENDA Version:intVersion];
        }*/
    }
    
    return blnResult;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)AddMessages:(NSArray *)arrItems TableName:(NSString *)strTableName{
    BOOL blnResult = NO;
    NSUInteger intEntriesM = [arrItems count];
    
    if(intEntriesM > 0)
    {
        Message *objMessage = [[Message alloc] init];
        NSMutableDictionary *dictMessage;
        
        for (NSUInteger i = 0; i < intEntriesM; i++)
        {
            dictMessage = [[NSMutableDictionary alloc] init];
            
            dictMessage = [arrItems objectAtIndex:i];
            
            objMessage.strMessageID = [dictMessage valueForKey:@"MessageId"];
            
            if([Functions ReplaceNUllWithZero:objMessage.strMessageID]!=0)
            {
                objMessage.strFromAttendeeName = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"FromAttendeeName"]];
                objMessage.strToAttendeeName = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"ToAttendeeName"]];
                objMessage.strFromAttendee = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"FromAttendee"]];
                objMessage.strToAttendee = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"ToAttendee"]];
                objMessage.strAttendeeMessage = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"AttendeeMessage"]];
                objMessage.strMessageSubject = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"MessageSubject"]];
                objMessage.strIsFromDelete = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"IsFromDelete"]];
                objMessage.strIsToDelete = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"IsToDelete"]];
                objMessage.strCreatedDate = [Functions ReplaceNUllWithBlank:[dictMessage valueForKey:@"CreatedDate"]];
                
                NSString *strSQL = [NSString stringWithFormat:@"Select MessageID From %@ Where MessageID = ?", strTableName];
                
                DB *objDB = [DB GetInstance];
                if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objMessage.strMessageID intValue] Query:strSQL] == NO)
                {
                    blnResult = [self AddMessage:objMessage TableName:strTableName];
                }
                else
                {
                    blnResult = [self UpdateMessage:objMessage TableName:strTableName];
                }
            }
        }
    }
    return blnResult;
}

- (BOOL) UpdateSentMessage:(NSInteger)intMessageID{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Sentbox Set ";
    strSQL = [strSQL stringByAppendingFormat:@"IsSent = 1 "];
    strSQL = [strSQL stringByAppendingFormat:@"Where MessageID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, intMessageID);
        
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

- (NSInteger)AddDraftMessage:(Message*)objMessage
{
    NSInteger intMessageID = 0;
    if ([self AddMessage:objMessage TableName:@"Draft"])
    {
        sqlite3 *dbEMEAFY14;
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        sqlite3_stmt *compiledStmt;
        NSString *strSQL = @"SELECT MAX(MessageID) FROM Sentbox";
        int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
        if (outval == SQLITE_OK)
        {
            //Loop through the results and add them to the feeds array
            while (sqlite3_step(compiledStmt) == SQLITE_ROW)
            {
                intMessageID = sqlite3_column_int(compiledStmt, 0);
            }
        }
        else
        {
            NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        }
        
        sqlite3_reset(compiledStmt);
        //Release the compiled statement from memory
        sqlite3_finalize(compiledStmt);
    };
    
    return intMessageID;
}

- (BOOL)AddMessage:(Message*)objMesssage TableName:(NSString *)strTableName
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = [NSString stringWithFormat:@"Insert Into %@ ", strTableName];
    if ([strTableName isEqualToString:@"Draft"])
    {
        strSQL = @"Insert Into Sentbox (FromAttendeeName, ToAttendeeName, ToAttendee, FromAttendee, AttendeeMessage, MessageSubject, IsToDelete, IsFromDelete, CreatedDate, IsSent)";
        strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, 0)"];
    }
    else if([strTableName isEqualToString:@"Sentbox"])
    {
        strSQL = [strSQL stringByAppendingString:@"(MessageID, FromAttendeeName, ToAttendeeName, ToAttendee, FromAttendee, AttendeeMessage, MessageSubject, IsToDelete, IsFromDelete, CreatedDate, IsSent)"];
        strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)"];
    }
    else
    {
        strSQL = [strSQL stringByAppendingString:@"(MessageID, FromAttendeeName, ToAttendeeName, ToAttendee, FromAttendee, AttendeeMessage, MessageSubject, IsToDelete, IsFromDelete, CreatedDate)"];
        strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    }
    
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        if ([strTableName isEqualToString:@"Draft"]) {
            sqlite3_bind_text(compiledStmt, 1, [objMesssage.strFromAttendeeName UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 2, [objMesssage.strToAttendeeName UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 3, [objMesssage.strToAttendee UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 4, [objMesssage.strFromAttendee UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 5, [objMesssage.strAttendeeMessage UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 6, [objMesssage.strMessageSubject UTF8String], -1, NULL);
            sqlite3_bind_int(compiledStmt, 7, [objMesssage.strIsToDelete boolValue]);
            sqlite3_bind_int(compiledStmt, 8, [objMesssage.strIsFromDelete boolValue]);
            sqlite3_bind_text(compiledStmt, 9, [objMesssage.strCreatedDate UTF8String], -1, NULL);
        }
        else{
            sqlite3_bind_int(compiledStmt, 1, [objMesssage.strMessageID intValue]);
            sqlite3_bind_text(compiledStmt, 2, [objMesssage.strFromAttendeeName UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 3, [objMesssage.strToAttendeeName UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 4, [objMesssage.strToAttendee UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 5, [objMesssage.strFromAttendee UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 6, [objMesssage.strAttendeeMessage UTF8String], -1, NULL);
            sqlite3_bind_text(compiledStmt, 7, [objMesssage.strMessageSubject UTF8String], -1, NULL);
            sqlite3_bind_int(compiledStmt, 8, [objMesssage.strIsToDelete boolValue]);
            sqlite3_bind_int(compiledStmt, 9, [objMesssage.strIsFromDelete boolValue]);
            sqlite3_bind_text(compiledStmt, 10, [objMesssage.strCreatedDate UTF8String], -1, NULL);
        }
        
        
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

- (BOOL)UpdateMessage:(Message*)objMessage TableName:(NSString *)strTableName
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = [NSString stringWithFormat:@"Update %@ Set ", strTableName];
    strSQL = [strSQL stringByAppendingFormat:@"FromAttendeeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ToAttendeeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ToAttendee = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"FromAttendee = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"AttendeeMessage = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"MessageSubject = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsToDelete = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsFromDelete = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"CreatedDate = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where MessageID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objMessage.strFromAttendeeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objMessage.strToAttendeeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objMessage.strToAttendee UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objMessage.strFromAttendee UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objMessage.strAttendeeMessage UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objMessage.strMessageSubject UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 7, [objMessage.strIsToDelete boolValue]);
        sqlite3_bind_int(compiledStmt, 8, [objMessage.strIsFromDelete boolValue]);
        sqlite3_bind_text(compiledStmt, 9, [objMessage.strCreatedDate UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 10, [objMessage.strMessageID intValue]);
        
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

-(BOOL) DeleteMessage:(NSString *)strMessageID TableName:(NSString *)strTableName{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = [NSString stringWithFormat:@"Delete From %@ ", strTableName];
    strSQL = [strSQL stringByAppendingFormat:@"Where MessageID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [strMessageID intValue]);
        
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

- (BOOL)DeleteSentMessages
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = [NSString stringWithFormat:@"Delete From Sentbox Where IsSent = 1"];

	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
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
