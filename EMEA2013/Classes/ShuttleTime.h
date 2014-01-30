//
//  ShuttleTime.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 16/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuttleTime : NSObject
{
    NSString *ShuttleScheduleDetailId;
    NSString *FormattedTime;
    NSString *Detail;
}

@property (nonatomic, retain) NSString *ShuttleScheduleDetailId;
@property (nonatomic, retain) NSString *FormattedTime;
@property (nonatomic, retain) NSString *Detail;

@end
