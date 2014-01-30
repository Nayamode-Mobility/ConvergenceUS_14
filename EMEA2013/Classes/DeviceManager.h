//
//  DeviceManager.h
//  BioColor
//
//  Created by Sang.Mac.02 on 22/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DeviceManager : NSObject 
{

}

+ (BOOL)IsDeviceOrientationLandscape;
+ (BOOL)IsDeviceOrientationPortrait;
+ (NSString *)GetDeviceID;
+ (BOOL)IsiPhone;
+ (BOOL)IsiPad;
+ (BOOL)Is4Inch;
+ (NSString *)GetDeviceType;
+ (NSString *)GetDeviceSystemName;
+ (NSString *)GetDeviceName;
+ (NSString *)GetDeviceSystemVersion;

@end