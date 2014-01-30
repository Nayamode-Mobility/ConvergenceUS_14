//
//  User.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 17/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "User.h"

static User *objUser = nil;

@implementation User
#pragma mark Singleton Methods
+ (id)GetInstance
{
    if (objUser == nil)
    {
        objUser = [[self alloc] init];
    }
    
    return objUser;
}

+ (void)SetUserObject:(User*)Object;
{
    objUser = Object;
}

- (id)init
{
    if (self = [super init])
    {
        strID = @"";
        strName = @"";
        strFirstName = @"";
        strLastName = @"";
        strLink = @"";
        strGender = @"";
        strPreferredEmail = @"";
        strAccountEmail = @"";
        strPersonalEmail = @"";
        strBusinessEmail = @"";
        strLocale = @"";
        strUpdateTime = @"";
        
        strAlias = @"";
        strPUID = @"";
        strPrimaryGroupSID = @"";
        strPrimarySID = @"";
        strUPN = @"";
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        strID = [decoder decodeObjectForKey:@"ID"];
        strName = [decoder decodeObjectForKey:@"Name"];
        strFirstName = [decoder decodeObjectForKey:@"FirstName"];
        strLastName = [decoder decodeObjectForKey:@"LastName"];
        strLink = [decoder decodeObjectForKey:@"Link"];
        strGender = [decoder decodeObjectForKey:@"Gender"];
        strPreferredEmail = [decoder decodeObjectForKey:@"PreferredEmail"];
        strAccountEmail = [decoder decodeObjectForKey:@"AccountEmail"];
        strBusinessEmail = [decoder decodeObjectForKey:@"BusinessEmail"];
        strLocale = [decoder decodeObjectForKey:@"Locale"];
        strUpdateTime = [decoder decodeObjectForKey:@"UpdateTime"];
        
        strAlias = [decoder decodeObjectForKey:@"Alias"];
        strPUID = [decoder decodeObjectForKey:@"PUID"];
        strPrimaryGroupSID = [decoder decodeObjectForKey:@"PrimaryGroupSID"];
        strPrimarySID = [decoder decodeObjectForKey:@"PrimarySID"];
        strUPN = [decoder decodeObjectForKey:@"UPN"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:strID forKey:@"ID"];
    [encoder encodeObject:strName forKey:@"Name"];
    [encoder encodeObject:strFirstName forKey:@"FirstName"];
    [encoder encodeObject:strLastName forKey:@"LastName"];
    [encoder encodeObject:strLink forKey:@"Link"];
    [encoder encodeObject:strPreferredEmail forKey:@"Gender"];
    [encoder encodeObject:strPreferredEmail forKey:@"PreferredEmail"];
    [encoder encodeObject:strAccountEmail forKey:@"AccountEmail"];
    [encoder encodeObject:strBusinessEmail forKey:@"BusinessEmail"];
    [encoder encodeObject:strLocale forKey:@"Locale"];
    [encoder encodeObject:strUpdateTime forKey:@"UpdateTime"];

    [encoder encodeObject:strAlias forKey:@"Alias"];
    [encoder encodeObject:strPUID forKey:@"PUID"];
    [encoder encodeObject:strPrimaryGroupSID forKey:@"PrimaryGroupSID"];
    [encoder encodeObject:strPrimarySID forKey:@"PrimarySID"];
    [encoder encodeObject:strUPN forKey:@"UPN"];
}

- (void)dealloc
{
}

- (void)SetID:(NSString *)strValue
{
    strID = strValue;
}

- (NSString*)GetID
{
    return strID;
}

- (void)SetName:(NSString *)strValue
{
    strName = strValue;
}

- (NSString*)GetName
{
    return strName;
}

- (void)SetFirstName:(NSString *)strValue
{
    strFirstName = strValue;
}

- (NSString*)GetFirstName
{
    return strFirstName;
}

- (void)SetLastName:(NSString *)strValue
{
    strLastName = strValue;
}

- (NSString*)GetLastName
{
    return strLastName;
}

- (void)SetLink:(NSString *)strValue
{
    strLink = strValue;
}

- (NSString*)GetLink
{
    return strLink;
}

- (void)SetGender:(NSString *)strValue
{
    strGender = strValue;
}

- (NSString*)GetGender
{
    return strGender;
}

- (void)SetPreferredEmail:(NSString *)strValue
{
    strPreferredEmail = strValue;
}

- (NSString*)GetPreferredEmail
{
    return strPreferredEmail;
}

- (void)SetAccountEmail:(NSString *)strValue
{
    strAccountEmail = strValue;
}

- (NSString*)GetAccountEmail
{
    return strAccountEmail;
}

- (void)SetPersonalEmail:(NSString *)strValue
{
    strPersonalEmail = strValue;
}

- (NSString*)GetPersonalEmail
{
    return strPersonalEmail;
}

- (void)SetBusinessEmail:(NSString *)strValue
{
    strBusinessEmail = strValue;
}

- (NSString*)GetBusinessEmail
{
    return strBusinessEmail;
}

- (void)SetLocale:(NSString *)strValue
{
    strLocale = strValue;
}

- (NSString*)GetLocale
{
    return strLocale;
}

- (void)SetUpdatedTime:(NSString *)strValue
{
    strUpdateTime = strValue;
}

- (NSString*)GetUpdateTime
{
    return strUpdateTime;
}

- (void)SetPUID:(NSString *)strValue
{
    strPUID = strValue;
}

- (NSString*)GetPUID
{
    return strPUID;
}

- (void)SetPrimaryGroupSID:(NSString *)strValue
{
    strPrimaryGroupSID = strValue;
}

- (NSString*)GetPrimaryGroupSID
{
    return strPrimaryGroupSID;
}

- (void)SetPrimarySID:(NSString *)strValue
{
    strPrimarySID = strValue;
}

- (NSString*)GetPrimarySID
{
    return strPrimarySID;
}

- (void)SetAlias:(NSString *)strValue
{
    strAlias = strValue;
}

- (NSString*)GetAlias
{
    return strAlias;
}

- (void)SetUPN:(NSString *)strValue
{
    strUPN = strValue;
}

- (NSString*)GetUPN
{
    return strUPN;
}

- (void)ClearUserInfo
{
    strID = @"";
    strName = @"";
    strFirstName = @"";
    strLastName = @"";
    strLink = @"";
    strGender = @"";
    strPreferredEmail = @"";
    strAccountEmail = @"";
    strPersonalEmail = @"";
    strBusinessEmail = @"";
    strLocale = @"";
    strUpdateTime = @"";

    strAlias = @"";
    strPUID = @"";
    strPrimaryGroupSID = @"";
    strPrimarySID = @"";
    strUPN = @"";
}
#pragma mark -
@end
