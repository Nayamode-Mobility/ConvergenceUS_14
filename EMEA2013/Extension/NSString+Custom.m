//
//  NSString+Custom.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

+ (BOOL)IsEmpty:(NSString *)strValue shouldCleanWhiteSpace:(BOOL)blnCleanWhileSpace
{
    if ((NSNull *)strValue == [NSNull null])
    {
        return YES;
    }
   
    if (strValue == nil)
    {
        return YES;
    }
    else if ([strValue length] == 0)
    {
        return YES;
    }
    
    if (blnCleanWhileSpace)
    {
        strValue = [strValue stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([strValue length] == 0)
        {
            return YES;
        }
    }
    
    return NO;  
}

@end
