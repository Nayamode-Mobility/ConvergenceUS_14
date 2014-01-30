//
//  Rooms.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rooms : NSObject
{
    NSString *strRoomInstanceID;
    NSString *strRoomName;
    NSString *strCapacity;
}

@property (nonatomic, retain) NSString *strRoomInstanceID;
@property (nonatomic, retain) NSString *strRoomName;
@property (nonatomic, retain) NSString *strCapacity;
@end
