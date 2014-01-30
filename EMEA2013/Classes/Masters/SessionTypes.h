//
//  SessionTypes.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 22/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionTypes : NSObject
{
    NSString *strSessionTypeID;
    NSString *strSessionTypeName;
}

@property (nonatomic, retain) NSString *strSessionTypeID;
@property (nonatomic, retain) NSString *strSessionTypeName;
@end
