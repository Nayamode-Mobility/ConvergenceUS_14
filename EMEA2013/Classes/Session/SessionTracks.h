//
//  SessionTracks.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionTracks : NSObject
{
    NSString *strTrackInstanceID;
    NSString *strSessionInstanceID;
    NSString *strTrackName;
}

@property (nonatomic,retain) NSString *strTrackInstanceID;
@property (nonatomic,retain) NSString *strSessionInstanceID;
@property (nonatomic,retain) NSString *strTrackName;
@end
