//
//  Agenda.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 23/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Agenda : NSObject
{
    NSString *strConferenceAgendaID;
    NSString *strTitle;
    NSString *strBriefDescription;
    NSString *strDescription;    
    NSString *strStartDate;
    NSString *strEndDate;
    NSString *strAgendaDate;
}

@property (nonatomic, retain) NSString *strConferenceAgendaID;
@property (nonatomic, retain) NSString *strTitle;
@property (nonatomic, retain) NSString *strBriefDescription;
@property (nonatomic, retain) NSString *strDescription;
@property (nonatomic, retain) NSString *strStartDate;
@property (nonatomic, retain) NSString *strEndDate;
@property (nonatomic, retain) NSString *strAgendaDate;
@end
