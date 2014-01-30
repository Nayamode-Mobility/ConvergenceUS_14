//
//  DeviceManager.m
//  BioColor
//
//  Created by Sang.Mac.02 on 22/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager
#pragma mark Methods
+ (BOOL)IsDeviceOrientationLandscape
{
	//NSLog(@"%@",[[UIDevice currentDevice] orientation]);
	if (([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)) 
	{
		return YES;
	}
	else
	{
		return NO;
	}	
}

+ (BOOL)IsDeviceOrientationPortrait
{
	if (([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)) 
	{
		return NO;
	}
	else
	{
		return YES;
	}
}

+ (NSString *)GetDeviceID
{
	//return [[UIDevice currentDevice] uniqueIdentifier];
    return [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
}

+ (BOOL)IsiPad
{
    BOOL blnResult = NO;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        blnResult = YES;
    }
    
    return blnResult;
}

+ (BOOL)IsiPhone
{
    BOOL blnResult = NO;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        blnResult = YES;
    }
    
    return blnResult;
}

+ (BOOL)Is4Inch;
{
    BOOL blnResult = NO;
    
    if([[UIScreen mainScreen] bounds].size.height == 568)
    {
        blnResult = YES;
    }
    
    return blnResult;
}

+ (NSString *)GetDeviceType
{
    NSString *strDeviceType = @"iPad";
    
    if([self IsiPhone])
    {
        strDeviceType = @"iPhone";
    }
    
    return strDeviceType;
}

+ (NSString *)GetDeviceSystemName
{
	return [[UIDevice currentDevice] systemName];	
}

+ (NSString *)GetDeviceName
{
	return [[UIDevice currentDevice] name];	
}

+ (NSString *)GetDeviceSystemVersion
{
	return [[UIDevice currentDevice] systemVersion];	
}
#pragma mark -
@end
