//
//  SpeakerSessions.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeakerSessions : NSObject
{
    NSString *strSpeakerInstanceID;
    NSString *strSessionInstanceID;
}

@property (nonatomic, retain) NSString *strSpeakerInstanceID;
@property (nonatomic, retain) NSString *strSessionInstanceID;
@end
