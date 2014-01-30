//
//  ExceptionHandler.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ExceptionHandler.h"
#import "User.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "NSString+Custom.h"

@implementation ExceptionHandler
#pragma mark Methods
+ (void)AddExceptionForScreen:(NSString*)strScreenName MethodName:(NSString*)strMethodName Exception:(NSString*)strException;
{
    NSURLConnection  *objConnection;
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ERROR_LOG_ERROR];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"GET"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //NSLog(@"%@",[objUser GetAccountEmail]);
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:strScreenName forHTTPHeaderField:@"PageName"];
    [objRequest addValue:strMethodName forHTTPHeaderField:@"MethodName"];
    [objRequest addValue:strException forHTTPHeaderField:@"Exception"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES];
}
#pragma mark -
@end
