//
//  ExceptionHandler.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionHandler : NSObject
{
}

+ (void)AddExceptionForScreen:(NSString*)strScreenName MethodName:(NSString*)strMethodName Exception:(NSString*)strException;
@end
