//
//  AttendeeExhibitor.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 21/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendeeExhibitor : NSObject
{
    NSString *strExhibitorID;
    NSString *strExhibitorCode;
}

@property (nonatomic, retain) NSString *strExhibitorID;
@property (nonatomic, retain) NSString *strExhibitorCode;
@end
