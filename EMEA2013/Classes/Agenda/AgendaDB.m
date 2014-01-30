//
//  AgendaDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AgendaDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"

@implementation AgendaDB
static AgendaDB *objAgendaDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objAgendaDB == nil)
    {
        objAgendaDB = [[self alloc] init];
    }
    
    return objAgendaDB;
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
- (NSArray*)GetAgendas
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAgendas = [[NSMutableArray alloc] init];
    
    NSString *strCurDate = @"";
    NSString *strNextDate = @"";
    
    NSMutableArray *arrDateAgendas = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempAgendas = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ConferenceAgendaID, Title, BriefDescription, Description, StartDate, EndDate, AgendaDate From ConferenceAgenda Order By AgendaDate, StartDate, EndDate";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Agenda *objAgenda = [[Agenda alloc] init];
            
            strNextDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            if(![strNextDate isEqualToString:strCurDate])
            {
                if(![strCurDate isEqualToString:@""] && [arrTempAgendas count] > 0)
                {
                    [arrDateAgendas addObject:strCurDate];
                    [arrDateAgendas addObject:[arrTempAgendas copy]];
                    
                    [arrTempAgendas removeAllObjects];
                    
                    [arrAgendas addObject:[arrDateAgendas copy]];
                    [arrDateAgendas removeAllObjects];
                }
                
                strCurDate = strNextDate;
            }
            
            objAgenda.strConferenceAgendaID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAgenda.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAgenda.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAgenda.strDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAgenda.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAgenda.strEndDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAgenda.strAgendaDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            
			[arrTempAgendas addObject:objAgenda];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(![strCurDate isEqualToString:@""] && [arrTempAgendas count] > 0)
    {
        [arrDateAgendas addObject:strCurDate];
        [arrDateAgendas addObject:[arrTempAgendas copy]];
        
        [arrTempAgendas removeAllObjects];
        
        [arrAgendas addObject:[arrDateAgendas copy]];
        [arrDateAgendas removeAllObjects];
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAgendas;
}

- (NSArray*)GetAgendasWithAgendaID:(id)strAgendaID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAgendas = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ConferenceAgendaID, Title, BriefDescription, Description, StartDate, EndDate, AgendaDate From ConferenceAgenda Where ConferenceAgendaID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strAgendaID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Agenda *objAgenda = [[Agenda alloc] init];
            
            objAgenda.strConferenceAgendaID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAgenda.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAgenda.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAgenda.strDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAgenda.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAgenda.strEndDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAgenda.strAgendaDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            
			[arrAgendas addObject:objAgenda];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAgendas;
}

- (NSArray *)SetAgendas:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"AgendaList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"AgendaList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrAgendas = [dictData valueForKey:@"AgendaList"];
        NSUInteger intEntriesM = [arrAgendas count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteAgendas];
            NSString *strSQL = @"Delete From ConferenceAgenda";
            [arrQuery addObject:strSQL];
            
            Agenda *objAgenda = [[Agenda alloc] init];
            NSMutableDictionary *dictAgenda;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictAgenda = [[NSMutableDictionary alloc] init];
                
                dictAgenda = [[arrAgendas objectAtIndex:i] valueForKey:@"AgendaDetails"];
                
                objAgenda.strConferenceAgendaID = [dictAgenda valueForKey:@"ConferenceAgendaId"];
                
                if([Functions ReplaceNUllWithZero:objAgenda.strConferenceAgendaID]!=0)
                {
                    //                    objAgenda.strTitle = [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"Title"]];
                    //                    objAgenda.strBriefDescription = [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"BriefDescription"]];
                    //                    objAgenda.strDescription = [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"Description"]];
                    //                    objAgenda.strStartDate = [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"StartDate"]];
                    //                    objAgenda.strEndDate = [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"EndDate"]];
                    //                    objAgenda.strAgendaDate = [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"AgendaDate"]];
                    //
                    //                        blnResult = [self AddAgenda:objAgenda];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into ConferenceAgenda(ConferenceAgendaID, Title, BriefDescription, Description, StartDate, EndDate, AgendaDate) Values(%i, '%@', '%@', '%@', '%@', '%@', '%@')",
                                        [[dictAgenda valueForKey:@"ConferenceAgendaId"]intValue],
                                        [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"Title"]],
                                        [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"BriefDescription"]],
                                        [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"Description"]],
                                        [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"StartDate"]],
                                        [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"EndDate"]],
                                        [Functions ReplaceNUllWithBlank:[dictAgenda valueForKey:@"AgendaDate"]]
                                        ];
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
        //if(blnResult == YES)
        //{
           // DB *objDB = [DB GetInstance];
            //[objDB UpdateScreenWithVersion:strSCREEN_AGENDA Version:intVersion];
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_AGENDA]];

        //}
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteAgendas
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From ConferenceAgenda ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where ConferenceAgendaID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strConferenceAgendaID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddAgenda:(Agenda*)objAgenda
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into ConferenceAgenda(ConferenceAgendaID, Title, BriefDescription, Description, StartDate, EndDate, AgendaDate) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAgenda.strConferenceAgendaID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objAgenda.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objAgenda.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAgenda.strDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAgenda.strStartDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAgenda.strEndDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objAgenda.strAgendaDate UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateAgenda:(Agenda*)objAgenda
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update ConferenceAgenda Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Description = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"StartDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"EndDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"AgendaDate = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ConferenceAgendaID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objAgenda.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objAgenda.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objAgenda.strDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAgenda.strStartDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAgenda.strEndDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAgenda.strAgendaDate UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 7, [objAgenda.strConferenceAgendaID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_AGENDA MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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
