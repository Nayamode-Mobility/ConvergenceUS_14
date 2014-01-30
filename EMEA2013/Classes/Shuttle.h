//
//  Shuttle.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 15/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shuttle : NSObject
{
    NSString *ShuttleScheduleId;
    NSString *ShuttleDate;
    NSString *ShuttleDescription;
    NSMutableArray *ShuttleFormattedTime;

}


@property (nonatomic, retain) NSString *ShuttleScheduleId;
@property (nonatomic, retain) NSString *ShuttleDate;
@property (nonatomic, retain) NSString *ShuttleDescription;
@property (nonatomic, retain) NSMutableArray *ShuttleFormattedTime;

@end
