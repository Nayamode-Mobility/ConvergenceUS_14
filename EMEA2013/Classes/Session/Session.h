//
//  Session.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 25/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject
{
    NSString *strSessionInstanceID;
    NSString *strSessionStatusID;
    NSString *strSessionStatusName;
    NSString *strSessionTypeID;
    NSString *strSessionTypeName;
    NSString *strJointSessionID;
    NSString *strJointSessionWith;
    NSString *strSessionCode;
    NSString *strSessionTitle;
    NSString *strSessionAbstract;
    NSString *strSessionObjective;
    NSString *strPriorityID;
    NSString *strPriorityName;
    NSString *strPriorityTypeID;
    NSString *strPriorityTypeName;
    NSString *strStartDate;
    NSString *strStartTime;
    NSString *strEndTime;
    NSString *strLocationURL;
    
    NSString *strIsAdded;
    NSString *strNotesAvailable;
    
    NSArray *arrSpeakers;
    
    NSArray *arrResources;
    NSArray *arrTracks;
    NSArray *arrSubTracks;
    NSArray *arrCategories;
    NSArray *arrRooms;
}

@property (nonatomic, retain) NSString *strSessionInstanceID;
@property (nonatomic, retain) NSString *strSessionStatusID;
@property (nonatomic, retain) NSString *strSessionStatusName;
@property (nonatomic, retain) NSString *strSessionTypeID;
@property (nonatomic, retain) NSString *strSessionTypeName;
@property (nonatomic, retain) NSString *strJointSessionID;
@property (nonatomic, retain) NSString *strJointSessionWith;
@property (nonatomic, retain) NSString *strSessionCode;
@property (nonatomic, retain) NSString *strSessionTitle;
@property (nonatomic, retain) NSString *strSessionAbstract;
@property (nonatomic, retain) NSString *strSessionObjective;
@property (nonatomic, retain) NSString *strPriorityID;
@property (nonatomic, retain) NSString *strPriorityName;
@property (nonatomic, retain) NSString *strPriorityTypeID;
@property (nonatomic, retain) NSString *strPriorityTypeName;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strStartTime;
@property (nonatomic, retain) NSString *strEndTime;
@property (nonatomic, retain) NSString *strLocationURL;

@property (nonatomic, retain) NSString *strIsAdded;
@property (nonatomic, retain) NSString *strNotesAvailable;

@property (nonatomic, retain) NSArray *arrSpeakers;

@property (nonatomic, retain) NSArray *arrResources;
@property (nonatomic, retain) NSArray *arrTracks;
@property (nonatomic, retain) NSArray *arrSubTracks;
@property (nonatomic, retain) NSArray *arrCategories;
@property (nonatomic, retain) NSArray *arrRooms;
@property (nonatomic, retain) NSArray *arrVideos;
@end
