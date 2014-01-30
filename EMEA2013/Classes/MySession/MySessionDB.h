//
//  MySessionDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MySession.h"

@interface MySessionDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetMySessions;
- (NSArray*)GetMySessionsAndGrouped:(BOOL)blnGroupedByDate;
- (NSArray*)GetMySessionsWithSessionID:(id)strSessionInstanceID;
- (NSString*)GetMySessionsJSON;
- (BOOL)SetMySessions:(NSData*)objData;
- (BOOL)SyncMySessions:(NSData*)objData;

- (BOOL)AddSession:(NSString*)strSessionInstanceID;
- (BOOL)DeleteSession:(NSString*)strSessionInstanceID;
- (BOOL)UpdateMySession:(NSString*)strSessionInstanceID;

- (BOOL)AddMySession:(MySession*)objMySession isSynced:(BOOL)isSynced;
- (BOOL)UpdateMySession:(NSString*)strSessionInstanceID isSynced:(BOOL)isSynced;

@end
