//
//  Functions.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Functions : NSObject
{
}

+ (id)ReplaceNUllWithBlank:(id)value;
+ (id)ReplaceNUllWithZero:(id)value;

+ (BOOL)DeviceHasPhone;
+ (void)MakePhoneCall:(id)value;

+ (void)OpenWebsite:(NSString*)strValue;

+ (void)OpenSMS;
+ (void)OpenSMSWithReceipient:(NSString*)strReceipient;

+ (void)OpenMail;
+ (void)OpenMailWithSubject:(NSString*)strSubject;
+ (void)OpenMailWithSubjectAndBody:(NSString*)strSubject body:(NSString*)strBody;
+ (void)OpenMailWithReceipient:(NSString*)strReceipient;
+ (void)OpenMailWithReceipientWithSubject:(NSString*)strReceipient subject:(NSString*)strSubject;
+ (void)OpenMailWithReceipientWithSubjectAndBody:(NSString*)strReceipient subject:(NSString*)strSubject body:(NSString*)strBody;

+ (NSString *)URLEncode:(NSString*)strValue;

+ (NSString*)GetGUID;

+ (UIViewController *)GetTopViewController:(UIViewController *)objRootViewController;
+ (UIViewController *)HasViewController:(UINavigationController *)objRootViewController ViewController:(UIViewController*)objVC;

@end
