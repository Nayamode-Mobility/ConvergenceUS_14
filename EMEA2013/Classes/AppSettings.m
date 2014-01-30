//
//  AppSettings.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AppSettings.h"
#import "Shared.h"
#import "Constants.h"

@implementation AppSettings
static AppSettings *objAppSettings = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objAppSettings == nil)
    {
        objAppSettings = [[self alloc] init];
    }
    
    return objAppSettings;
}

- (id)init
{
    if (self = [super init])
    {
    }
    
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods (Live ID Autentication Token)
- (void)SetLiveIDAuthenticationToken:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:strValue forKey:strAPP_SETTINGS_LIVEID_AUTHENTICATION_TOKEN];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetLiveIDAuthenticationToken
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strLiveIDAuthenticationToken = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strLiveIDAuthenticationToken = [dictPList valueForKey:strAPP_SETTINGS_LIVEID_AUTHENTICATION_TOKEN];
	}
	
	return strLiveIDAuthenticationToken;
}
#pragma mark -

#pragma mark Instance Methods (Live ID Link)
- (void)SetLiveIDLink:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:strValue forKey:strAPP_SETTINGS_LIVEID_LINK];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetLiveIDLink
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strLiveIDLink = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strLiveIDLink = [dictPList valueForKey:strAPP_SETTINGS_LIVEID_LINK];
	}
	
	return strLiveIDLink;
}
#pragma mark -

#pragma mark Instance Methods (Account Email)
- (void)SetAccountEmail:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:strValue forKey:strAPP_SETTINGS_ACCOUNT_EMAIL];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetAccountEmail
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strAccountEmail = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strAccountEmail = [dictPList valueForKey:strAPP_SETTINGS_ACCOUNT_EMAIL];
	}
	
	return strAccountEmail;
}
#pragma mark -

#pragma mark Instance Methods (PUID)
- (void)SetPUID:(int)intValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSString stringWithFormat:@"%d",intValue] forKey:strAPP_SETTINGS_PUID];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (int)GetPUID
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    int intPUID = 0;
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		intPUID = (int)[dictPList valueForKey:strAPP_SETTINGS_PUID];
	}
	
	return intPUID;
}
#pragma mark -

#pragma mark Instance Methods (Privacy)
- (void)SetPrivacySaved
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSNumber numberWithInteger:1] forKey:strAPP_SETTINGS_SET_PRIVACY];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (BOOL)GetPrivacySaved
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL blnResult = NO;
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		blnResult = [[dictPList valueForKey:strAPP_SETTINGS_SET_PRIVACY] boolValue];
	}
	
	return blnResult;
}

- (void)UnsetPrivacySaved
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSNumber numberWithInteger:0] forKey:strAPP_SETTINGS_SET_PRIVACY];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}
#pragma mark -

#pragma mark Instance Methods (Primary Group SID)
- (void)SetPrimaryGroupSID:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSString stringWithFormat:@"%@",strValue] forKey:strAPP_SETTINGS_PRIMARY_GROUP_SID];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetPrimaryGroupSID
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strPrimaryGroupSID = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strPrimaryGroupSID = [dictPList valueForKey:strAPP_SETTINGS_PRIMARY_GROUP_SID];
	}
	
	return strPrimaryGroupSID;
}
#pragma mark -

#pragma mark Instance Methods (Primary SID)
- (void)SetPrimarySID:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSString stringWithFormat:@"%@",strValue] forKey:strAPP_SETTINGS_PRIMARY_SID];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetPrimarySID
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strPrimarySID = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strPrimarySID = [dictPList valueForKey:strAPP_SETTINGS_PRIMARY_SID];
	}
	
	return strPrimarySID;
}
#pragma mark -

#pragma mark Instance Methods (Alias)
- (void)SetAlias:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSString stringWithFormat:@"%@",strValue] forKey:strAPP_SETTINGS_ALIAS];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetAlias
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strAlias = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strAlias = [dictPList valueForKey:strAPP_SETTINGS_ALIAS];
	}
	
	return strAlias;
}
#pragma mark -

#pragma mark Instance Methods (UPN)
- (void)SetUPN:(NSString *)strValue
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
    Shared *objShared = [Shared GetInstance];
    
	if([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		[dictPList setValue:[NSString stringWithFormat:@"%@",strValue] forKey:strAPP_SETTINGS_UPN];
		[dictPList writeToFile:[objShared GetPListPath] atomically:YES];
	}
}

- (NSString*)GetUPN
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    NSString  *strUPN = @"";
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		strUPN = [dictPList valueForKey:strAPP_SETTINGS_UPN];
	}
	
	return strUPN;
}
#pragma mark -

#pragma mark Instance Methods (Use Batch Update)
- (BOOL)GetUseBatchUpdate
{
	NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL blnResult = NO;
    
    Shared *objShared = [Shared GetInstance];
    
	//Look in Documents for an existing plist file
	if ([fileManger fileExistsAtPath:[objShared GetPListPath]])
	{
		NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
		blnResult = [[dictPList valueForKey:strAPP_SETTINGS_USE_BATCH_UPDATE] boolValue];
	}
	
	return blnResult;
}
#pragma mark -

#pragma mark Instance Methods (General)
- (void)ClearAppSettings
{
    [self SetLiveIDAuthenticationToken:@""];
    [self SetLiveIDLink:@""];
    [self SetAccountEmail:@""];
    [self SetPUID:0];
    [self SetPrimaryGroupSID:@""];
    [self SetPrimarySID:@""];
    [self SetAlias:@""];
    [self SetUPN:@""];
    [self UnsetPrivacySaved];
}
#pragma mark -
@end
