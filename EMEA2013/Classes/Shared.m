//
//  Shared.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 16/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Shared.h"
#import "DB.h"

@implementation Shared

static Shared *objShared = nil;

@synthesize dictSqlQuery;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objShared == nil)
    {
        objShared = [[self alloc] init];
    }

    return objShared;
}

- (id)init
{
    if (self = [super init])
    {
        strPListPath = @"";
        strLiveIDAuthenticationToken = @"";
        strDeviceToken  = @"";
    }

    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods

- (void)ExecuteSQLforArray:(NSArray*)arrQueries
{
    sqlite3 *dbEMEAFY14;
    
    dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
        for (NSString *strSQL in arrQueries)
        {
            
            if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
            {
                NSLog(@"Error while creating insert statement. %s %@",sqlite3_errmsg(dbEMEAFY14),strSQL);
            }
            else
            {
                if(SQLITE_DONE != sqlite3_step(compiledStmt))
                {
                    NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
                }
            }
        }
}

- (void)SetPListPath:(NSString *)strValue
{
    strPListPath = strValue;
}

- (NSString*)GetPListPath
{
    return strPListPath;
}

- (void)SetLiveIDAuthenticationToken:(NSString *)strValue
{
    strLiveIDAuthenticationToken = strValue;
}

- (NSString*)GetLiveIDAuthenticationToken
{
    return strLiveIDAuthenticationToken;
}

- (void)SetDeviceToken:(NSString *)strValue
{
    strDeviceToken = strValue;
}

- (NSString*)GetDeviceToken
{
    return strDeviceToken;
}
- (void)SetFirstTimeUse:(BOOL)blnValue
{
    blnFirstTimeUse = blnValue;
}

- (BOOL)GetFirstTimeUse
{
    return blnFirstTimeUse;
}

- (void)SetIsInternetAvailable:(BOOL)blnValue
{
    blnIsInternetAvailable = blnValue;
}

- (BOOL)GetIsInternetAvailable
{
    return blnIsInternetAvailable;
}
#pragma mark -
@end
