//
//  DB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"

@interface DB : NSObject
{
    NSString *strDatabasePath;
    sqlite3 *dbEMEAFY14;
}

+ (id)GetInstance;

- (void)SetDatabasePath: (NSString*)strPath;
- (NSString*)GetDatabasePath;
- (BOOL)UpdateScreenWithVersion:(NSString*)strScreenName Version:(NSUInteger)intValue;
- (NSUInteger)GetVersionForScreen:(NSString*)strScreenName;
- (NSDictionary*)GetVersionForScreens:(NSArray *)arrScreenNames;
- (BOOL)CheckIfRecordAvailableWithIntKeyWithQuery:(int)intKey Query:(NSString*)strSQL;
- (BOOL)CheckIfRecordAvailableWithStringKeyWithQuery:(NSString*)strKey Query:(NSString*)strSQL;

- (sqlite3*)OpenDatabase;
@end
