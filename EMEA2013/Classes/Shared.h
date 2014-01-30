//
//  Shared.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 16/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shared : NSObject
{
    NSString *strPListPath;
    NSString *strLiveIDAuthenticationToken;
    NSString *strDeviceToken;
    BOOL blnFirstTimeUse;
    BOOL blnIsInternetAvailable;
}
@property(strong,nonatomic) NSMutableDictionary *dictServerBatchVersion;
@property(strong,nonatomic) NSMutableDictionary *dictSqlQuery;

+ (id)GetInstance;

- (void)SetPListPath:(NSString*)strValue;
- (NSString*)GetPListPath;

- (void)SetLiveIDAuthenticationToken:(NSString*)strValue;
- (NSString*)GetLiveIDAuthenticationToken;

- (void)SetDeviceToken:(NSString*)strValue;
- (NSString*)GetDeviceToken;

- (void)SetFirstTimeUse:(BOOL)blnValue;
- (BOOL)GetFirstTimeUse;
- (void)SetIsInternetAvailable:(BOOL)blnValue;
- (BOOL)GetIsInternetAvailable;

- (void)ExecuteSQLforArray:(NSArray*)arrQueries;

@end
