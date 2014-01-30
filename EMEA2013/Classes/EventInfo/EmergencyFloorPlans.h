//
//  EmergencyFloorPlans.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmergencyFloorPlans : NSObject
{
    NSString *strFloorPlanID;
    NSString *strFloorPlanName;
    NSString *strImageURL;
}

@property (nonatomic, retain) NSString *strFloorPlanID;
@property (nonatomic, retain) NSString *strFloorPlanName;
@property (nonatomic, retain) NSString *strImageURL;
@end
