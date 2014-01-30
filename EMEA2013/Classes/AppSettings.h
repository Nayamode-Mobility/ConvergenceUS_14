//
//  AppSettings.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject
{
}

+ (id)GetInstance;

- (void)SetLiveIDAuthenticationToken:(NSString*)strValue;
- (NSString*)GetLiveIDAuthenticationToken;

- (void)SetLiveIDLink:(NSString*)strValue;
- (NSString*)GetLiveIDLink;

- (void)SetAccountEmail:(NSString*)strValue;
- (NSString*)GetAccountEmail;

- (void)SetPUID:(int)intValue;
- (int)GetPUID;

- (void)SetPrimaryGroupSID: (NSString*)strValue;
- (NSString*)GetPrimaryGroupSID;

- (void)SetPrimarySID: (NSString*)strValue;
- (NSString*)GetPrimarySID;

- (void)SetAlias: (NSString*)strValue;
- (NSString*)GetAlias;

- (void)SetUPN: (NSString*)strValue;
- (NSString*)GetUPN;

- (void)SetPrivacySaved;
- (BOOL)GetPrivacySaved;

- (BOOL)GetUseBatchUpdate;

- (void)ClearAppSettings;
@end
