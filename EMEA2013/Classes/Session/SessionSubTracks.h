//
//  SessionSubTracks.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 01/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionSubTracks : NSObject
{
    NSString *strSubTrackInstanceID;
    NSString *strSessionInstanceID;
    NSString *strSubTrackName;
}

@property (nonatomic,retain) NSString *strSubTrackInstanceID;
@property (nonatomic,retain) NSString *strSessionInstanceID;
@property (nonatomic,retain) NSString *strSubTrackName;
@end
