//
//  DB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "DB.h"

@implementation DB

static DB *objDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objDB == nil)
    {
        objDB = [[self alloc] init];
    }
    
    return objDB;
}

- (id)init
{
    if (self = [super init])
    {
        strDatabasePath = @"";
        dbEMEAFY14 = nil;
    }
    
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods
- (void)SetDatabasePath: (NSString *)strPath
{
    strDatabasePath = strPath;
}

- (NSString*)GetDatabasePath
{
    NSLog(@"%@",strDatabasePath);
    return strDatabasePath;
}

- (sqlite3*)OpenDatabase
{
	static BOOL blnFirst = YES;
    
	if (blnFirst || dbEMEAFY14 == NULL)
    {
		blnFirst = NO;
        
		if (!sqlite3_open([[self GetDatabasePath] UTF8String], &dbEMEAFY14) == SQLITE_OK)
        {
            NSLog(@"Attempted to open database at path %@, but failed",[self GetDatabasePath]);
			NSLog(@"Failed to open database with message %s.", sqlite3_errmsg(dbEMEAFY14));
            
            [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Failed to open database with message %s.", sqlite3_errmsg(dbEMEAFY14)]];
            
            //Even though the open failed, call close to properly clean up resources.
            sqlite3_close(dbEMEAFY14);
		}
		else
        {
			//Modify cache size so we don't overload memory. 50 * 1.5kb
			[self execute: @"PRAGMA CACHE_SIZE=1000"];
            
			//Default to UTF-8 encoding
			[self execute: @"PRAGMA encoding = \"UTF-8\""];
            
			//Turn on full auto-vacuuming to keep the size of the database down
			//This setting can be changed per database using the setAutoVacuum instance method
			[self execute: @"PRAGMA auto_vacuum=1"];
            
			//Turn off synchronous update. This is recommended here:
			//http://www.sqlite.org/cvstrac/wiki?p=FtsOne
			[self execute: @"PRAGMA synchronous=NORMAL"];
		}
	}
    
	return dbEMEAFY14;
}

- (BOOL)UpdateScreenWithVersion:(NSString*)strScreenName Version:(NSUInteger)intValue
{
    BOOL blnResult = NO;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];    
    
    char *strSQL = "Update ScreenVersion Set ScreenVersion = ? Where ScreenName = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, intValue);
        sqlite3_bind_text(compiledStmt, 2, [strScreenName UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		if(sqlite3_step(compiledStmt) == SQLITE_DONE)
        {
            blnResult = YES;
		}
        else
        {
            NSLog(@"Error while updating data: %s", sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while updating data: %s",sqlite3_errmsg(dbEMEAFY14)]];
            
            blnResult = NO;
        }
	}
	else
    {
        NSLog(@"Error while updating query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while updating data: %s",sqlite3_errmsg(dbEMEAFY14)]];
        
        blnResult = NO;
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    return blnResult;
}

- (NSUInteger)GetVersionForScreen:(NSString *)strScreenName
{
    NSUInteger intVersion = 0;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];    
    
    char *strSQL = "Select ScreenVersion From ScreenVersion Where ScreenName = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strScreenName UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
        int outval=sqlite3_step(compiledStmt);
		if(outval== SQLITE_ROW)
        {
            intVersion = sqlite3_column_int(compiledStmt, 0);
		}
        else
        {
            NSLog(@"Error while selecting data. %s", sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
        
            intVersion = 0;
        }
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
        
        intVersion = 0;        
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    return intVersion;
}

- (NSDictionary*)GetVersionForScreens:(NSArray *)arrScreenNames
{
    NSUInteger intVersion = 0;
    NSMutableDictionary *dictBatchVersion = [[NSMutableDictionary alloc] init];
    
    NSUInteger intI = 0;
    for(intI = 0; intI < [arrScreenNames count]; intI++)
    {
        [dictBatchVersion setObject:@"0" forKey:[arrScreenNames objectAtIndex:intI]];
    }
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strScreenNames = [arrScreenNames componentsJoinedByString:@"', '"];
    strScreenNames = [NSString stringWithFormat:@"'%@'",strScreenNames];
    
    NSString *strSQL = @"Select ScreenName, ScreenVersion From ScreenVersion Where ScreenName In (";
    strSQL = [strSQL stringByAppendingString:strScreenNames];
    strSQL = [strSQL stringByAppendingString:@")"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
        //int outval = sqlite3_step(compiledStmt);
		//if(outval == SQLITE_ROW)
        //{
            //Loop through the results and add them to the feeds array
            while (sqlite3_step(compiledStmt) == SQLITE_ROW)
            {
                intVersion = sqlite3_column_int(compiledStmt, 1);
                [dictBatchVersion  setObject:[NSNumber numberWithInteger:intVersion] forKey:[NSString stringWithFormat:@"%s",sqlite3_column_text(compiledStmt, 0)]];
            }
		//}
        //else
        //{
        //    NSLog(@"Error while selecting data. %s", sqlite3_errmsg(dbEMEAFY14));
        //    [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
        //
        //    intVersion = 0;
        //}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
        
        intVersion = 0;
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    return dictBatchVersion;
}

- (BOOL)CheckIfRecordAvailableWithIntKeyWithQuery:(int)intKey Query:(NSString*)strSQL;
{
    BOOL blnIsAvailable  = NO;
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2([self OpenDatabase], [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, intKey);
        
        while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            //Read the data from the result row
            NSString *strValue = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            if(strValue != nil)
            {
                blnIsAvailable = YES;
            }
        }
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
        
        blnIsAvailable = NO;
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    return blnIsAvailable;
}

- (BOOL)CheckIfRecordAvailableWithStringKeyWithQuery:(NSString *)strKey Query:(NSString *)strSQL
{
    BOOL blnIsAvailable  = NO;
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2([self OpenDatabase], [strSQL UTF8String], -1, &compiledStmt, NULL);

	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strKey UTF8String], -1, NULL);
        
        while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            //Read the data from the result row
            NSString *strValue = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            if(strValue != nil)
            {
                blnIsAvailable = YES;
            }
        }
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];

        blnIsAvailable = NO;
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    return blnIsAvailable;
}


- (void)execute: (NSString *)strSQL
{
	char *error;
    
	if (sqlite3_exec([self OpenDatabase], [strSQL UTF8String], NULL, NULL, &error) != SQLITE_OK)
    {
		NSString *strError = [NSString stringWithFormat: @"Failed to execute SQL '%@' with message '%s'.", strSQL, error];
        NSLog(@"%@",strError);
        [ExceptionHandler AddExceptionForScreen:@"" MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:strError];

		sqlite3_free(error);
	}
}
#pragma mark -
@end
