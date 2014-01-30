//
//  MasterDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MasterDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"

@implementation MasterDB
static MasterDB *objMasterDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objMasterDB == nil)
    {
        objMasterDB = [[self alloc] init];
    }
    
    return objMasterDB;
}

- (id)init
{
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods (Session Types)
- (NSArray*)GetSessionTypes
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionTypes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SessionTypeID, SessionTypeName From SessionTypes";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        SessionTypes *objSessionTypes = [[SessionTypes alloc] init];
        
        objSessionTypes.strSessionTypeID = @"";
        objSessionTypes.strSessionTypeName = @"All";
        
        [arrSessionTypes addObject:objSessionTypes];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionTypes *objSessionTypes = [[SessionTypes alloc] init];
            
            objSessionTypes.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionTypes.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrSessionTypes addObject:objSessionTypes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionTypes;
}

- (NSArray*)GetSessionTypesWithSessionTypeID:(id)strSessionTypeID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionTypes = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SessionTypeID, SessionTypeName From SessionTypes Where SessionTypeID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionTypeID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionTypes *objSessionTypes = [[SessionTypes alloc] init];
            
            objSessionTypes.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionTypes.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
            [arrSessionTypes addObject:objSessionTypes];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionTypes;
}

- (NSString*)GetSessionTypeID:(id)strSessionTypeName
{
	sqlite3 *dbEMEAFY14;
    
	NSString *strSessionTypeID = @"";
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SessionTypeID From SessionTypes Where SessionTypeName = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionTypeName UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return strSessionTypeID;
}
#pragma mark -

#pragma mark Instance Methods (Products)
- (NSArray*)GetProducts
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ProductID, Product From Products Order By ProductID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Filters *objFilters = [[Filters alloc] init];
        
        objFilters.strCategoryID = @"";
        objFilters.strCategory = @"All";
        
        [arrFilters addObject:objFilters];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}

- (NSArray*)GetProductsWithProductID:(id)strProductID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ProductID, Product From Products Where ProductID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strProductID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];        
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}

- (NSString*)GetProductID:(id)strProduct
{
	sqlite3 *dbEMEAFY14;
    
    NSString *strProductID = @"";
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ProductID From Products Where Product = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strProduct UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strProductID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return strProductID;
}

- (NSArray*)GetIndustries
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select IndustryID, Industry From Industries Order By IndustryID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Filters *objFilters = [[Filters alloc] init];
        
        objFilters.strCategoryID = @"";
        objFilters.strCategory = @"All";
        
        [arrFilters addObject:objFilters];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}

- (NSArray*)GetIndustrysWithIndustryID:(id)strIndustryID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select IndustryID, Industry From Industries Where IndustryID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strIndustryID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}

- (NSString*)GetIndustryID:(id)strIndustry
{
	sqlite3 *dbEMEAFY14;
    
    NSString *strProductID = @"";
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select IndustryID From Industries Where Industry = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strIndustry UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strProductID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return strProductID;
}

- (NSArray*)GetTimeslot
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryInstanceId, Category From TimeSlot Order By Category";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Filters *objFilters = [[Filters alloc] init];
        
        objFilters.strCategoryID = @"";
        objFilters.strCategory = @"All";
        
        [arrFilters addObject:objFilters];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}

- (NSArray*)GetSkillLevel
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryInstanceId, Category From SkillLevel Order By Category";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Filters *objFilters = [[Filters alloc] init];
        
        objFilters.strCategoryID = @"";
        objFilters.strCategory = @"All";
        
        [arrFilters addObject:objFilters];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}


- (NSArray*)GetSpeakers
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpeakers = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SpeakerInstanceID, FirstName, LastName From Speakers Order By SpeakerInstanceID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Filters *objFilters = [[Filters alloc] init];
        
        objFilters.strCategoryID = @"";
        objFilters.strCategory = @"All";
        
        [arrSpeakers addObject:objFilters];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objFilters.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
			[arrSpeakers addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpeakers;
}

- (NSArray*)GetSpeakerssWithSpeakerID:(id)strSpeakerID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SpeakerInstanceID, FirstName From Speakers Where SpeakerInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSpeakerID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFilters;
}

- (NSString*)GetSpeakerID:(id)strSpeaker
{
	sqlite3 *dbEMEAFY14;
    
    NSString *strSpeakerID = @"";
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ProductID From Products Where Product = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSpeaker UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strSpeakerID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return strSpeakerID;
}


- (NSArray*)SetFilters:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"FilterTypeList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"FilterTypeList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrFilters = [dictData valueForKey:@"SessionTypeFilters"];
        NSUInteger intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteSessionTypes];
            [arrQuery addObject:@"Delete From SessionTypes"];
            
            Filters *objFilters = [[Filters alloc] init];
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                objFilters.strCategoryID = [dictFilters valueForKey:@"CategoryInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objFilters.strCategoryID] isEqualToString:@""])
                {
                }
                else
                {
                    //objFilters.strCategory = [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]];
                     //   blnResult = [self AddSessionTypes:objFilters];
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into SessionTypes(SessionTypeID, SessionTypeName) Values('%@', '%@')",
                    [dictFilters valueForKey:@"CategoryInstanceId"],
                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]]];
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
        arrFilters = [dictData valueForKey:@"TrackFilters"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteTracks];
            [arrQuery addObject:@"Delete From Tracks"];
            
            Filters *objFilters = [[Filters alloc] init];
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                objFilters.strCategoryID = [dictFilters valueForKey:@"CategoryInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objFilters.strCategoryID] isEqualToString:@""])
                {
                }
                else
                {
//                    objFilters.strCategory = [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]];
//                        blnResult = [self AddTracksV1:objFilters];
                    
                    NSString *strSQL = [NSString stringWithFormat: @"Insert Into Tracks(TrackInstanceID, TrackName) Values('%@', '%@')",
                    [dictFilters valueForKey:@"CategoryInstanceId"],
                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]]];
                    
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
        arrFilters = [dictData valueForKey:@"ProductFilters"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteProducts];
            [arrQuery addObject:@"Delete From Products"];
            
            Filters *objFilters = [[Filters alloc] init];
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                objFilters.strCategoryID = [dictFilters valueForKey:@"CategoryInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objFilters.strCategoryID] isEqualToString:@""])
                {
                }
                else
                {
                    //objFilters.strCategory = [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]];
                     //   blnResult = [self AddProducts:objFilters];
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Products(ProductID, Product) Values('%@', '%@')",
                    [dictFilters valueForKey:@"CategoryInstanceId"],
                     [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]]];
                    [arrQuery addObject:strSQL];
                    
                }
            }
        }
        
        arrFilters = [dictData valueForKey:@"IndustryFilters"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteIndustries];
            [arrQuery addObject:@"Delete From Industries"];
            
            Filters *objFilters = [[Filters alloc] init];
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                objFilters.strCategoryID = [dictFilters valueForKey:@"CategoryInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objFilters.strCategoryID] isEqualToString:@""])
                {
                }
                else
                {
                    //objFilters.strCategory = [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]];
                     //   blnResult = [self AddIndustries:objFilters];
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Industries(IndustryID, Industry) Values('%@', '%@')",
                    [dictFilters valueForKey:@"CategoryInstanceId"],
                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]]];
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
        arrFilters = [dictData valueForKey:@"SkillLevelFilters"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteIndustries];
            [arrQuery addObject:@"Delete From SkillLevel"];
            
            Filters *objFilters = [[Filters alloc] init];
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                objFilters.strCategoryID = [dictFilters valueForKey:@"CategoryInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objFilters.strCategoryID] isEqualToString:@""])
                {
                }
                else
                {
                    //objFilters.strCategory = [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]];
                    //   blnResult = [self AddIndustries:objFilters];
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into SkillLevel(CategoryInstanceId, Category) Values('%@', '%@')",
                                        [dictFilters valueForKey:@"CategoryInstanceId"],
                                        [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]]];
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
        arrFilters = [dictData valueForKey:@"TimeSlotFilters"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteIndustries];
            [arrQuery addObject:@"Delete From SkillLevel"];
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                if([[Functions ReplaceNUllWithBlank:[arrFilters objectAtIndex:i]] isEqualToString:@""])
                {
                }
                else
                {
                    //objFilters.strCategory = [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"Category"]];
                    //   blnResult = [self AddIndustries:objFilters];
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into SkillLevel(CategoryInstanceId, Category) Values('0', '%@')",
                                        [Functions ReplaceNUllWithBlank:[arrFilters objectAtIndex:i]]];
                    [arrQuery addObject:strSQL];
                }
            }
        }

//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_FILTER Version:intVersion];
//        }
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_FILTER]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma Find Like Minded Filters
- (NSArray*)SetFindLikeMindedFilters:(NSData *)objData
{
    
    NSError *error;
    
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"AttendeeLikeMindedFilterList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"AttendeeLikeMindedFilterList"];
    }
    
    if(error==nil)
    {
        [arrQuery addObject:@"Delete From FindLikeMindedFilter"];
        
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrFilters = [dictData valueForKey:@"JobRoles"];
        NSUInteger intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                

                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into FindLikeMindedFilter(FilterName, ParentFilter,FilterType) Values('%@', '%@','JobRoles')",
                                        [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterValue"]],
                                        [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterName"]]];
                    [arrQuery addObject:strSQL];

            }
        }
        
        arrFilters = [dictData valueForKey:@"MyBusiness"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                
                NSString *strSQL = [NSString stringWithFormat:@"Insert Into FindLikeMindedFilter(FilterName, ParentFilter,FilterType) Values('%@', '%@','MyBusiness')",
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterValue"]],
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterName"]]];
                [arrQuery addObject:strSQL];
                
            }
        }

        arrFilters = [dictData valueForKey:@"ImpProducts"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                
                NSString *strSQL = [NSString stringWithFormat:@"Insert Into FindLikeMindedFilter(FilterName, ParentFilter,FilterType) Values('%@', '%@','ImpProducts')",
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterValue"]],
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterName"]]];
                [arrQuery addObject:strSQL];
                
            }
        }

        arrFilters = [dictData valueForKey:@"SellProducts"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                
                NSString *strSQL = [NSString stringWithFormat:@"Insert Into FindLikeMindedFilter(FilterName, ParentFilter,FilterType) Values('%@', '%@','SellProducts')",
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterValue"]],
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterName"]]];
                [arrQuery addObject:strSQL];
                
            }
        }

        arrFilters = [dictData valueForKey:@"EvalProducts"];
        intEntriesM = [arrFilters count];
        
        if(intEntriesM > 0)
        {
            NSMutableDictionary *dictFilters;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFilters = [[NSMutableDictionary alloc] init];
                
                //dictFilters = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictFilters = [arrFilters objectAtIndex:i];
                
                
                NSString *strSQL = [NSString stringWithFormat:@"Insert Into FindLikeMindedFilter(FilterName, ParentFilter,FilterType) Values('%@', '%@','EvalProducts')",
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterValue"]],
                                    [Functions ReplaceNUllWithBlank:[dictFilters valueForKey:@"FilterName"]]];
                [arrQuery addObject:strSQL];
                
            }
        }


        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = 'FindLikeMinded'",intVersion]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (Tracks)
- (NSArray*)GetTracks
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select TrackInstanceID, TrackName From Tracks Order By TrackName";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Tracks *objTracks = [[Tracks alloc] init];
        
        objTracks.strTrackInstanceID = @"";
        objTracks.strTrackName = @"All";
        
        [arrTracks addObject:objTracks];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Tracks *objTracks = [[Tracks alloc] init];
            
            objTracks.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objTracks.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrTracks addObject:objTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrTracks;
}

- (NSArray*)GetTracksWithTrackInstanceID:(id)strTrackInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select TrackInstanceID, TrackName From Tracks Where TrackInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strTrackInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Tracks *objTracks = [[Tracks alloc] init];
            
            objTracks.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objTracks.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrTracks addObject:objTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrTracks;
}

- (NSString*)GetTrackInstanceID:(id)strTrackName
{
	sqlite3 *dbEMEAFY14;
    
	NSString *strTrackInstanceID = @"";
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select TrackInstanceID From Tracks Where TrackName = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strTrackName UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return strTrackInstanceID;
}

- (BOOL)SetTracks:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrTracks = [dictData valueForKey:@"Tracks"];
        NSUInteger intEntriesM = [arrTracks count];
        
        if(intEntriesM > 0)
        {
            Tracks *objTracks = [[Tracks alloc] init];
            NSMutableDictionary *dictTracks;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictTracks = [[NSMutableDictionary alloc] init];
                
                //dictTracks = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictTracks = [arrTracks objectAtIndex:i];
                
                objTracks.strTrackInstanceID = [dictTracks valueForKey:@"TrackInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objTracks.strTrackInstanceID] isEqualToString:@""])
                {
                }
                else
                {
                    objTracks.strTrackName = [Functions ReplaceNUllWithBlank:[dictTracks valueForKey:@"TrackName"]];

                    NSString *strSQL = @"Select TrackInstanceID From Tracks Where TrackInstanceID = ?";
                    
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:objTracks.strTrackInstanceID Query:strSQL] == NO)
                    {
                        blnResult = [self AddTracks:objTracks];
                    }
                    else
                    {
                        blnResult = [self UpdateTracks:objTracks];
                    }
                }
            }
        }
        
        if(blnResult == YES)
        {
            DB *objDB = [DB GetInstance];
            [objDB UpdateScreenWithVersion:strSCREEN_TRACK Version:intVersion];
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}
#pragma mark -

#pragma mark Instance Methods (SubTracks)
- (NSArray*)GetSubTracks
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSubTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SubTrackInstanceID, SubTrackName From SubTracks Order By SubTrackName";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        SubTracks *objSubTracks = [[SubTracks alloc] init];
        
        objSubTracks.strSubTrackInstanceID = @"";
        objSubTracks.strSubTrackName = @"All";
        
        [arrSubTracks addObject:objSubTracks];

		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SubTracks *objSubTracks = [[SubTracks alloc] init];
            
            objSubTracks.strSubTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSubTracks.strSubTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrSubTracks addObject:objSubTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSubTracks;
}

- (NSArray*)GetSubTracksWithSubTrackInstanceID:(id)strSubTrackInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSubTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SubTrackInstanceID, SubTrackName From SubTracks Where SubTrackInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSubTrackInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SubTracks *objSubTracks = [[SubTracks alloc] init];
            
            objSubTracks.strSubTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSubTracks.strSubTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrSubTracks addObject:objSubTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSubTracks;
}

- (NSString*)GetSubTrackInstanceID:(id)strSubTrackName
{
	sqlite3 *dbEMEAFY14;
    
    NSString *strSubTrackInstanceID = @"";
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SubTrackInstanceID  From SubTracks Where SubTrackName = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSubTrackName UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strSubTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return strSubTrackInstanceID;
}

- (BOOL)SetSubTracks:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrSubTracks = [dictData valueForKey:@"SubTracks"];
        NSUInteger intEntriesM = [arrSubTracks count];
        
        if(intEntriesM > 0)
        {
            SubTracks *objSubTracks = [[SubTracks alloc] init];
            NSMutableDictionary *dictSubTracks;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictSubTracks = [[NSMutableDictionary alloc] init];
                
                //dictSubTracks = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictSubTracks = [arrSubTracks objectAtIndex:i];
                
                objSubTracks.strSubTrackInstanceID = [dictSubTracks valueForKey:@"SubTrackInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objSubTracks.strSubTrackInstanceID] isEqualToString:@""])
                {
                }
                else
                {
                    objSubTracks.strSubTrackName = [Functions ReplaceNUllWithBlank:[dictSubTracks valueForKey:@"SubTrackName"]];
                    
                    NSString *strSQL = @"Select SubTrackInstanceID From SubTracks Where SubTrackInstanceID = ?";
                    
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithStringKeyWithQuery:objSubTracks.strSubTrackInstanceID Query:strSQL] == NO)
                    {
                        blnResult = [self AddSubTracks:objSubTracks];
                    }
                    else
                    {
                        blnResult = [self UpdateSubTracks:objSubTracks];
                    }
                }
            }
        }
        
        if(blnResult == YES)
        {
            DB *objDB = [DB GetInstance];
            [objDB UpdateScreenWithVersion:strSCREEN_SUB_TRACK Version:intVersion];
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}
#pragma mark -

#pragma mark Instance Methods (Categories)
- (NSArray*)GetCategories
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryInstanceID, ParentCategoryInstanceID, CategoryName From Categories Order By CategoryName";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Categories *objCategories = [[Categories alloc] init];
            
            objCategories.strCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objCategories.strParentCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objCategories.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrCategories addObject:objCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrCategories;
}

- (NSArray*)GetCategoriesWithCategoryInstanceID:(id)strCategoryInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryInstanceID, ParentCategoryInstanceID, CategoryName From Categories Where CategoryInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strCategoryInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Categories *objCategories = [[Categories alloc] init];
            
            objCategories.strCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objCategories.strParentCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objCategories.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrCategories addObject:objCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrCategories;
}

- (NSArray *)SetCategories:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"CategoryList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"CategoryList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrCategories = [dictData valueForKey:@"Categories"];
        NSUInteger intEntriesM = [arrCategories count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteCategories];
            [arrQuery addObject:@"Delete From Categories"];
            
            Categories *objCategories = [[Categories alloc] init];
            NSMutableDictionary *dictCategories;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictCategories = [[NSMutableDictionary alloc] init];
                dictCategories = [arrCategories objectAtIndex:i];
                
                objCategories.strCategoryInstanceID = [dictCategories valueForKey:@"CategoryInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objCategories.strCategoryInstanceID] isEqualToString:@""])
                {
                }
                else
                {
//                    objCategories.strParentCategoryInstanceID = [Functions ReplaceNUllWithBlank:[dictCategories valueForKey:@"ParentCategoryInstanceId"]];
//                    objCategories.strCategoryName = [Functions ReplaceNUllWithBlank:[dictCategories valueForKey:@"CategoryName"]];
//                    blnResult = [self AddCategories:objCategories];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Categories(CategoryInstanceID, ParentCategoryInstanceId, CategoryName)Values('%@', '%@', '%@')",
                                        [dictCategories valueForKey:@"CategoryInstanceId"],
                                        [Functions ReplaceNUllWithBlank:[dictCategories valueForKey:@"ParentCategoryInstanceId"]],
                                        [Functions ReplaceNUllWithBlank:[dictCategories valueForKey:@"CategoryName"]]];
                    
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
//        if(blnResult == YES)
//        {
            //DB *objDB = [DB GetInstance];
            //[objDB UpdateScreenWithVersion:strSCREEN_CATEGORIES Version:intVersion];
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_CATEGORIES]];
//        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (Rooms)
- (NSArray*)GetRooms
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrRooms = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select RoomInstanceID, RoomName, Capacity From Rooms Order By RoomName";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Rooms *objRooms = [[Rooms alloc] init];
            
            objRooms.strRoomInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objRooms.strRoomName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objRooms.strCapacity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrRooms addObject:objRooms];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrRooms;
}

- (NSArray*)GetRoomsWithRoomInstanceID:(id)strRoomInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrRooms = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select RoomInstanceID, RoomName, Capacity From Rooms Where RoomInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strRoomInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Rooms *objRooms = [[Rooms alloc] init];
            
            objRooms.strRoomInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objRooms.strRoomName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objRooms.strCapacity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrRooms addObject:objRooms];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrRooms;
}

- (NSArray*)SetRooms:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"RoomList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"RoomList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrRooms = [dictData valueForKey:@"Rooms"];
        NSUInteger intEntriesM = [arrRooms count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteRooms];
            [arrQuery addObject:@"Delete From Rooms"];
            
            Rooms *objRooms = [[Rooms alloc] init];
            NSMutableDictionary *dictCategories;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictCategories = [[NSMutableDictionary alloc] init];
                
                //dictCategories = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictCategories = [arrRooms objectAtIndex:i];
                
                objRooms.strRoomInstanceID = [dictCategories valueForKey:@"RoomInstanceId"];
                
                if([[Functions ReplaceNUllWithBlank:objRooms.strRoomInstanceID] isEqualToString:@""])
                {
                }
                else
                {
//                    objRooms.strRoomName = [Functions ReplaceNUllWithBlank:[dictCategories valueForKey:@"RoomName"]];
//                    objRooms.strCapacity = [Functions ReplaceNUllWithZero:[dictCategories valueForKey:@"Capacity"]];
//                    blnResult = [self AddRooms:objRooms];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Rooms(RoomInstanceID, RoomName, Capacity)Values('%@', '%@', %@)",
                    [dictCategories valueForKey:@"RoomInstanceId"],
                    [Functions ReplaceNUllWithBlank:[dictCategories valueForKey:@"RoomName"]],
                    [Functions ReplaceNUllWithZero:[dictCategories valueForKey:@"Capacity"]]];
                    
                    [arrQuery addObject:strSQL];

                }
            }
        }
        
        //if(blnResult == YES)
        //{
           // DB *objDB = [DB GetInstance];
            //[objDB UpdateScreenWithVersion:strSCREEN_ROOMS Version:intVersion];
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_ROOMS]];
        //}
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (EventInfo Categories)
- (NSArray*)GetEventInfoCategories
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrEventInfoCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryID, ParentCategoryID, Category From EventInfoCategories Order By ParentCategoryID, CategoryID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoCategories *objEventInfoCategories = [[EventInfoCategories alloc] init];
            
            objEventInfoCategories.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoCategories.strParentCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoCategories.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrEventInfoCategories addObject:objEventInfoCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrEventInfoCategories;
}

- (NSArray*)GetEventInfoCategoriesWithCategoryID:(id)strCategoryID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrEventInfoCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryID, ParentCategoryID, Category From EventInfoCategories Where CategoryID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strCategoryID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoCategories *objEventInfoCategories = [[EventInfoCategories alloc] init];
            
            objEventInfoCategories.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoCategories.strParentCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoCategories.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrEventInfoCategories addObject:objEventInfoCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrEventInfoCategories;
}

- (NSArray*)SetEventInfoCategories:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"EventInfoList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"EventInfoList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrEventInfoCategories = [dictData valueForKey:@"EventInfoCategories"];
        NSUInteger intEntriesM = [arrEventInfoCategories count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteEventInfoCategories];
            [arrQuery addObject:@"Delete From EventInfoCategories"];
            
            EventInfoCategories *objEventInfoCategories = [[EventInfoCategories alloc] init];
            NSMutableDictionary *dictEventInfoCategories;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictEventInfoCategories = [[NSMutableDictionary alloc] init];
                
                //dictEventInfoCategories = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictEventInfoCategories = [arrEventInfoCategories objectAtIndex:i];
                
                objEventInfoCategories.strCategoryID = [dictEventInfoCategories valueForKey:@"CategoryId"];
                
                if([Functions ReplaceNUllWithZero:objEventInfoCategories.strCategoryID] != 0)
                {
//                    objEventInfoCategories.strParentCategoryID = [Functions ReplaceNUllWithZero:[dictEventInfoCategories valueForKey:@"ParentCategoryId"]];
//                    objEventInfoCategories.strCategory = [Functions ReplaceNUllWithBlank:[dictEventInfoCategories valueForKey:@"Category"]];
//                    
//                        blnResult = [self AddEventInfoCategories:objEventInfoCategories];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into EventInfoCategories(CategoryID, ParentCategoryID, Category,ShortCode) Values(%@, %@, '%@','%@')",
                    [dictEventInfoCategories valueForKey:@"CategoryId"],
                    [Functions ReplaceNUllWithZero:[dictEventInfoCategories valueForKey:@"ParentCategoryId"]],
                    [Functions ReplaceNUllWithBlank:[dictEventInfoCategories valueForKey:@"Category"]],
                    [Functions ReplaceNUllWithBlank:[dictEventInfoCategories valueForKey:@"ShortCode"]]];
                    [arrQuery addObject:strSQL];

                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_EVENT_INFO_CATEGORIES Version:intVersion];
//        }
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_EVENT_INFO_CATEGORIES]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (EventInfo Details)
- (NSArray*)GetEventInfoDetails
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrEventInfoDetails = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select EventInfoDetailID, CategoryID, Category, Title, BriefDescription, DetailDescription From EventInfoDetails Order By EventInfoDetailID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoDetails *objEventInfoDetails = [[EventInfoDetails alloc] init];
            
            objEventInfoDetails.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoDetails.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoDetails.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoDetails.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoDetails.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objEventInfoDetails.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 52)];
            
			[arrEventInfoDetails addObject:objEventInfoDetails];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrEventInfoDetails;
}

- (NSArray*)GetEventInfoDetailsWithID:(id)strEvntInfoDetailID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrEventInfoDetails = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select EventInfoDetailID, CategoryID, Category, Title, BriefDescription, DetailDescription From EventInfoDetails Where EventInfoDetailID = ? Order By EventInfoDetailID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strEvntInfoDetailID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoDetails *objEventInfoDetails = [[EventInfoDetails alloc] init];
            
            objEventInfoDetails.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoDetails.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoDetails.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoDetails.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoDetails.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objEventInfoDetails.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 52)];
            
			[arrEventInfoDetails addObject:objEventInfoDetails];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrEventInfoDetails;
}

- (NSArray*)SetEventInfoDetails:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"EventInfoList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"EventInfoList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrEventInfoDetails = [dictData valueForKey:@"EventInfoDetails"];
        NSUInteger intEntriesM = [arrEventInfoDetails count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteEventInfoDetails];
            [arrQuery addObject:@"Delete From EventInfoDetails"];
            
            EventInfoDetails *objEventInfoDetails = [[EventInfoDetails alloc] init];
            NSMutableDictionary *dictEventInfoDetails;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictEventInfoDetails = [[NSMutableDictionary alloc] init];
                
                //dictEventInfoCategories = [[arrTracks objectAtIndex:i] valueForKey:@"SessionDetails"];
                dictEventInfoDetails = [arrEventInfoDetails objectAtIndex:i];
                
                objEventInfoDetails.strEventInfoDetailID = [dictEventInfoDetails valueForKey:@"EventInfoDetailId"];
                
                if([Functions ReplaceNUllWithZero:objEventInfoDetails.strEventInfoDetailID] != 0)
                {
//                    objEventInfoDetails.strCategoryID = [Functions ReplaceNUllWithZero:[dictEventInfoDetails valueForKey:@"CategoryId"]];
//                    objEventInfoDetails.strCategory = [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"Category"]];
//                    objEventInfoDetails.strTitle = [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"Title"]];
//                    objEventInfoDetails.strBriefDescription = [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"BriefDescription"]];
//                    objEventInfoDetails.strDetailDescription = [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"DetailDescription"]];
//                    
//                        blnResult = [self AddEventInfoDetails:objEventInfoDetails];
                    
                    NSString *strSQL = [NSString stringWithFormat: @"Insert Into EventInfoDetails(EventInfoDetailID, CategoryID, Category, Title, BriefDescription, DetailDescription) Values(%@, %@, '%@', '%@', '%@', '%@')",
                    [dictEventInfoDetails valueForKey:@"EventInfoDetailId"],
                    [Functions ReplaceNUllWithZero:[dictEventInfoDetails valueForKey:@"CategoryId"]],
                    [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"Category"]],
                    [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"Title"]],
                    [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"BriefDescription"]],
                    [Functions ReplaceNUllWithBlank:[dictEventInfoDetails valueForKey:@"DetailDescription"]]];
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_EVENT_INFO_DTL Version:intVersion];
//        }
        
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_EVENT_INFO_DTL]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods (Session Types)
- (BOOL)DeleteSessionTypes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionTypes ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where SessionTypeID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strCategoryID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSessionTypes:(Filters*)objSessionTypes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionTypes(SessionTypeID, SessionTypeName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionTypes.strCategoryID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionTypes.strCategory UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateSessionTypes:(Filters*)objSessionTypes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update SessionTypes Set ";
    strSQL = [strSQL stringByAppendingFormat:@"SessionTypeName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionTypeID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionTypes.strCategory UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionTypes.strCategoryID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Products)
- (BOOL)DeleteProducts
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Products ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where ProductID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strCategoryID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddProducts:(Filters*)objProducts
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Products(ProductID, Product) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objProducts.strCategoryID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objProducts.strCategory UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateProducts:(Filters*)objProducts
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Products Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Product = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ProductID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objProducts.strCategory UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objProducts.strCategoryID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Industries)
- (BOOL)DeleteIndustries
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Industries ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where IndustryID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strCategoryID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddIndustries:(Filters*)objIndustries
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Industries(IndustryID, Industry) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objIndustries.strCategoryID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objIndustries.strCategory UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateIbndustries:(Filters*)objIndustries
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Industries Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Industry = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where IndustryID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objIndustries.strCategory UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objIndustries.strCategoryID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Tracks)
- (BOOL)AddTracks:(Tracks*)objTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Tracks(TrackInstanceID, TrackName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objTracks.strTrackInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objTracks.strTrackName UTF8String], -1, NULL);

		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateTracks:(Tracks*)objTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Tracks Set ";
    strSQL = [strSQL stringByAppendingFormat:@"TrackName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where TrackInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objTracks.strTrackName UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 2, [objTracks.strTrackInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Tracks ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where TrackInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strCategoryID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddTracksV1:(Filters*)objFilters
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Tracks(TrackInstanceID, TrackName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objFilters.strCategoryID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objFilters.strCategory UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateTracksV1:(Filters*)objFilters
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Tracks Set ";
    strSQL = [strSQL stringByAppendingFormat:@"TrackName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where TrackInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objFilters.strCategory UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objFilters.strCategoryID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (SubTracks)
- (BOOL)AddSubTracks:(SubTracks*)objSubTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SubTracks(SubTrackInstanceID, SubTrackName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSubTracks.strSubTrackInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSubTracks.strSubTrackName UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateSubTracks:(SubTracks*)objSubTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update SubTracks Set ";
    strSQL = [strSQL stringByAppendingFormat:@"SubTrackName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where SubTrackInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSubTracks.strSubTrackName UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 2, [objSubTracks.strSubTrackInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SUB_TRACK MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Categories)
- (BOOL)DeleteCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Categories ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where CategoryInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strCategoryInstanceID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddCategories:(Categories*)objCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Categories(CategoryInstanceID, ParentCategoryInstanceId, CategoryName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objCategories.strCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objCategories.strParentCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objCategories.strCategoryName UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateCategories:(Categories*)objCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Categories Set ";
    strSQL = [strSQL stringByAppendingFormat:@"ParentCategoryInstanceId = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"CategoryName = ? "];    
    strSQL = [strSQL stringByAppendingFormat:@"Where CategoryInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objCategories.strParentCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objCategories.strCategoryName UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 3, [objCategories.strCategoryInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Rooms)
- (BOOL)DeleteRooms
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Rooms ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where RoomInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strRoomInstanceID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddRooms:(Rooms*)objRooms
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Rooms(RoomInstanceID, RoomName, Capacity) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objRooms.strRoomInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objRooms.strRoomName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 3, [objRooms.strCapacity intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateRooms:(Rooms*)objRooms
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Rooms Set ";
    strSQL = [strSQL stringByAppendingFormat:@"RoomName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Capacity = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where RoomInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objRooms.strRoomName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, [objRooms.strCapacity intValue]);
        
        sqlite3_bind_text(compiledStmt, 3, [objRooms.strRoomInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ROOMS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (EventInfo Categories)
- (BOOL)DeleteEventInfoCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From EventInfoCategories ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where CategoryID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strCategoryID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddEventInfoCategories:(EventInfoCategories*)objEventInfoCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into EventInfoCategories(CategoryID, ParentCategoryID, Category) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEventInfoCategories.strCategoryID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objEventInfoCategories.strParentCategoryID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objEventInfoCategories.strCategory UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateEventInfoCategories:(EventInfoCategories*)objEventInfoCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update EventInfoCategories Set ";
    strSQL = [strSQL stringByAppendingFormat:@"ParentCategoryID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Category = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where CategoryID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEventInfoCategories.strParentCategoryID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objEventInfoCategories.strCategory UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 3, [objEventInfoCategories.strCategoryID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_CATEGORIES MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (EventInfo Details)
- (BOOL)DeleteEventInfoDetails
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From EventInfoDetails ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where EventInfoDetailID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strEventInfoDetailID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddEventInfoDetails:(EventInfoDetails*)objEventInfoDetails
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into EventInfoDetails(EventInfoDetailID, CategoryID, Category, Title, BriefDescription, DetailDescription) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEventInfoDetails.strEventInfoDetailID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objEventInfoDetails.strCategoryID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objEventInfoDetails.strCategory UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objEventInfoDetails.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objEventInfoDetails.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objEventInfoDetails.strDetailDescription UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateEventInfoDetails:(EventInfoDetails*)objEventInfoDetails
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update EventInfoDetails Set ";
    strSQL = [strSQL stringByAppendingFormat:@"CategoryID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Category = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"DetailDescription = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where CategoryID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEventInfoDetails.strCategoryID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objEventInfoDetails.strCategory UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objEventInfoDetails.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objEventInfoDetails.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objEventInfoDetails.strDetailDescription UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 6, [objEventInfoDetails.strEventInfoDetailID intValue]);
		
        if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

-(NSArray*)GetFAQ
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = [NSString stringWithFormat:@"Select * from EventInfoCategories where ParentCategoryId = (select CategoryId from EventInfoCategories where ShortCode = '%@')",strEVENT_INFO_CATEGORY_FAQ];
    // @"Select CategoryId, ParentCategoryId, Category From EventInfoCategories Where ShortCode = ";
    //strSQL = [strSQL stringByAppendingFormat:@"'%@'",strEVENT_INFO_CATEGORY_FAQ];
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        //Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoCategories *objEventInfoCategories = [[EventInfoCategories alloc] init];
            
            objEventInfoCategories.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoCategories.strParentCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoCategories.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoCategories.arrEventInfoDetails = [self GetEventInfoDetailsWithCategoryID:objEventInfoCategories.strCategoryID];
            [arrCategories addObject:objEventInfoCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_FAQ MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrCategories;
}

-(NSArray*)GetMeals
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = [NSString stringWithFormat:@"Select * from EventInfoCategories where ParentCategoryId = (select CategoryId from EventInfoCategories where ShortCode = '%@')",strEVENT_INFO_CATEGORY_MEALS];
    // @"Select CategoryId, ParentCategoryId, Category From EventInfoCategories Where ShortCode = ";
    //strSQL = [strSQL stringByAppendingFormat:@"'%@'",strEVENT_INFO_CATEGORY_MEALS];
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        //Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoCategories *objEventInfoCategories = [[EventInfoCategories alloc] init];
            
            objEventInfoCategories.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoCategories.strParentCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoCategories.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoCategories.arrEventInfoDetails = [self GetEventInfoDetailsWithCategoryID:objEventInfoCategories.strCategoryID];
            [arrCategories addObject:objEventInfoCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MEALS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrCategories;
}

- (NSArray*)GetEventInfoDetailsWithCategoryID:(id)strEvntInfoCategoryID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrEventInfoDetails = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select EventInfoDetailID, CategoryID, Category, Title, BriefDescription, DetailDescription From EventInfoDetails Where CategoryID = ? Order By EventInfoDetailID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strEvntInfoCategoryID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EventInfoDetails *objEventInfoDetails = [[EventInfoDetails alloc] init];
            
            objEventInfoDetails.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEventInfoDetails.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEventInfoDetails.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEventInfoDetails.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objEventInfoDetails.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objEventInfoDetails.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            
			[arrEventInfoDetails addObject:objEventInfoDetails];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EVENT_INFO_DTL MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrEventInfoDetails;
}
#pragma mark -
@end
