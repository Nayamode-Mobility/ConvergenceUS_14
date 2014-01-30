//
//  Analytics.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Analytics.h"
#import "User.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "NSString+Custom.h"
//#import "NSURLConnection+Tag.h"

@implementation Analytics
#pragma mark Methods
+ (void)AddAnalyticsForScreen:(NSString *)strScreenName
{
    NSURLConnection  *objConnection;
    
    User *objUser = [User GetInstance];

    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ANALYITC_ADD_ANALYTIC];
    
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
    [objRequest addValue:strScreenName forHTTPHeaderField:@"ScreenName"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES];
}
#pragma mark -
@end
