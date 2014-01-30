//
//  Message.h
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSString *strMessageID;
    NSString *strFromAttendeeName;
    NSString *strToAttendeeName;
    NSString *strToAttendee;
    NSString *strFromAttendee;
    NSString *strAttendeeMessage;
    NSString *strMessageSubject;
    NSString *strIsToDelete;
    NSString *strIsFromDelete;
    NSString *strCreatedDate;
}

@property (nonatomic, retain) NSString *strMessageID;
@property (nonatomic, retain) NSString *strFromAttendeeName;
@property (nonatomic, retain) NSString *strToAttendeeName;
@property (nonatomic, retain) NSString *strToAttendee;
@property (nonatomic, retain) NSString *strFromAttendee;
@property (nonatomic, retain) NSString *strAttendeeMessage;
@property (nonatomic, retain) NSString *strMessageSubject;
@property (nonatomic, retain) NSString *strIsToDelete;
@property (nonatomic, retain) NSString *strIsFromDelete;
@property (nonatomic, retain) NSString *strCreatedDate;

@end
