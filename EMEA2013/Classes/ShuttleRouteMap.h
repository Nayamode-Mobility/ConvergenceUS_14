//
//  ShuttleRouteMap.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode MacMini on 14/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShuttleRouteMap : NSObject
{
    NSString *ShuttleRouteMapId	;
    NSString *MapURL ;
    NSMutableArray *location;
   
}

@property (nonatomic, retain) NSString *ShuttleRouteMapId;
@property (nonatomic, retain) NSString *MapURL;
@property (nonatomic, retain) NSMutableArray *location;

@end
