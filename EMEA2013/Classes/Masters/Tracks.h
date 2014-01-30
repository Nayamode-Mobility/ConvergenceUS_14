//
//  Tracks.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tracks : NSObject
{
    NSString *strTrackInstanceID;
    NSString *strTrackName;
}

@property (nonatomic, retain) NSString *strTrackInstanceID;
@property (nonatomic, retain) NSString *strTrackName;
@end
