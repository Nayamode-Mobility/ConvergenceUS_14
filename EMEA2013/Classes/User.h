//
//  User.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 17/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>
{
    NSString *strID;
    NSString *strName;
    NSString *strFirstName;
    NSString *strLastName;
    NSString *strLink;
    NSString *strGender;
    NSString *strPreferredEmail;
    NSString *strAccountEmail;
    NSString *strPersonalEmail;
    NSString *strBusinessEmail;
    NSString *strLocale;
    NSString *strUpdateTime;
    
    NSString *strAlias;
    NSString *strPUID;
    NSString *strPrimaryGroupSID;
    NSString *strPrimarySID;
    NSString *strUPN;
}

+ (id)GetInstance;
+ (void)SetUserObject:(User*)Object;

- (void)SetID: (NSString*)strValue;
- (NSString*)GetID;

- (void)SetName: (NSString*)strValue;
- (NSString*)GetName;

- (void)SetFirstName: (NSString*)strValue;
- (NSString*)GetFirstName;

- (void)SetLastName: (NSString*)strValue;
- (NSString*)GetLastName;

- (void)SetLink: (NSString*)strValue;
- (NSString*)GetLink;

- (void)SetGender: (NSString*)strValue;
- (NSString*)GetGender;

- (void)SetPreferredEmail: (NSString*)strValue;
- (NSString*)GetPreferredEmail;

- (void)SetAccountEmail: (NSString*)strValue;
- (NSString*)GetAccountEmail;

- (void)SetPersonalEmail: (NSString*)strValue;
- (NSString*)GetPersonalEmail;

- (void)SetBusinessEmail: (NSString*)strValue;
- (NSString*)GetBusinessEmail;

- (void)SetLocale: (NSString*)strValue;
- (NSString*)GetLocale;

- (void)SetUpdatedTime: (NSString*)strValue;
- (NSString*)GetUpdateTime;

- (void)SetPUID: (NSString*)strValue;
- (NSString*)GetPUID;

- (void)SetPrimaryGroupSID: (NSString*)strValue;
- (NSString*)GetPrimaryGroupSID;

- (void)SetPrimarySID: (NSString*)strValue;
- (NSString*)GetPrimarySID;

- (void)SetAlias: (NSString*)strValue;
- (NSString*)GetAlias;

- (void)SetUPN: (NSString*)strValue;
- (NSString*)GetUPN;

- (void)ClearUserInfo;
@end
