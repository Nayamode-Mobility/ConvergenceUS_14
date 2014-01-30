//
//  Functions.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Functions.h"
#import "Shared.h"
#import "Constants.h"
#import "NSString+Custom.h"
#import "AppDelegate.h"

@implementation Functions

+ (id)ReplaceNUllWithBlank:(id)value;
{
    if(value==nil || value == NULL || [value isEqual:[NSNull null]])
    {
        value = @"";
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }

    return value;
}

+ (id)ReplaceNUllWithZero:(id)value;
{
    if(value==nil || value == NULL || [value isEqual:[NSNull null]])
    {
        value = 0;
    }
    
    return value;
}

+ (BOOL)DeviceHasPhone
{
    NSString *strURL = @"tel://";
    NSLog([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: strURL]]?@"YES":@"NO");
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: strURL]];
}

+ (void)MakePhoneCall:(id)value
{
    if(![NSString IsEmpty:value shouldCleanWhiteSpace:YES])
    {
        if([self DeviceHasPhone] == YES)
        {
            NSMutableString *strValue = [NSMutableString stringWithFormat:@"%@",value];
            [strValue setString:[strValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
            [strValue setString:[strValue stringByReplacingOccurrencesOfString:@"." withString:@""]];
            [strValue setString:[strValue stringByReplacingOccurrencesOfString:@"-" withString:@""]];
            
            NSString *strPhoneNo = [@"telprompt://" stringByAppendingString:strValue];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhoneNo]];
        }
    }
}

+ (void)OpenWebsite:(NSString*)strValue
{
//    Shared *objShared = [Shared GetInstance];
//    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        return;
//    }
    if (APP.netStatus) {
    if(![NSString IsEmpty:strValue shouldCleanWhiteSpace:YES])
    {
        NSString *strURL = strValue;
        
        if([strURL rangeOfString:@"http://"].location == NSNotFound && [strURL rangeOfString:@"https://"].location == NSNotFound  )
        {
            strURL = [NSString stringWithFormat:@"%@%@",@"http://",strURL];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    }
    }else{
        NETWORK_ALERT();
        return;
    }
}

+ (void)OpenSMS
{
    NSString *strURL = [NSString stringWithFormat:@"sms://"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strURL]];
}

+ (void)OpenSMSWithReceipient:(NSString *)strReceipient
{
    NSString *strURL = [NSString stringWithFormat:@"sms://%@", strReceipient];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: strURL]];
}

+ (void)OpenMail
{
    NSString* strURL = [NSString stringWithFormat:@"mailto:"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
}

+ (void)OpenMailWithSubject:(NSString *)strSubject
{
    NSString* strURL = [NSString stringWithFormat:@"mailto:?subject=%@",strSubject];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
}

+ (void)OpenMailWithSubjectAndBody:(NSString *)strSubject body:(NSString *)strBody
{
    strBody = [self URLEncode:strBody];
    NSString* strURL = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@",strSubject,strBody];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
}

+ (void)OpenMailWithReceipient:(NSString*)strReceipient
{
    if(![NSString IsEmpty:strReceipient shouldCleanWhiteSpace:YES])
    {
        NSString* strURL = [NSString stringWithFormat:@"mailto://%@",strReceipient];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    }
}

+ (void)OpenMailWithReceipientWithSubject:(NSString *)strReceipient subject:(NSString *)strSubject
{
    if(![NSString IsEmpty:strReceipient shouldCleanWhiteSpace:YES])
    {
        NSString* strURL = [NSString stringWithFormat:@"mailto://subject=%@?%@",strReceipient,strSubject];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    }
}

+ (void)OpenMailWithReceipientWithSubjectAndBody:(NSString *)strReceipient subject:(NSString *)strSubject body:(NSString *)strBody
{
    if(![NSString IsEmpty:strReceipient shouldCleanWhiteSpace:YES])
    {
        strBody = [self URLEncode:strBody];
        NSString* strURL = [NSString stringWithFormat:@"mailto://%@?subject=%@&body=%@",strReceipient,strSubject,strBody];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strURL]];
    }
}

+ (NSString *)URLEncode:(NSString*)strValue
{
    NSString *strEncoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) strValue,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                    kCFStringEncodingUTF8));
    return strEncoded;
}

+ (NSString*)GetGUID
{
    return [[NSUUID UUID] UUIDString];
}

+ (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}

+ (UIViewController *)GetTopViewController:(UINavigationController *)objRootViewController
{
    //NSArray *arrVCs = [objRootViewController viewControllers];
    
    NSInteger intVCs = [[objRootViewController viewControllers] count];
    
    if (intVCs < 2)
    {
        return nil;
    }
    else
    {
        //NSLog(@"%@",[[objRootViewController viewControllers] objectAtIndex:intVCs - 1]);
        return [[objRootViewController viewControllers] objectAtIndex:intVCs - 1];
    }
}

+ (UIViewController *)HasViewController:(UINavigationController *)objRootViewController ViewController:(UIViewController *)objVC
{
    //NSArray *arrVCs = [objRootViewController viewControllers];
    
    //NSInteger intVCs = [[objRootViewController viewControllers] count];
    
    for(UIViewController *vc in [objRootViewController viewControllers])
    {
        if([vc isKindOfClass:[objVC class]])
        {
            return vc;
        }
    }
    
    return nil;
}


@end
