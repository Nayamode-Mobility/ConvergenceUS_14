//
//  SessionDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 26/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SessionDB.h"

#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "SpeakerDB.h"
#import "NSString+Custom.h"
#import "SessionVideos.h"

@implementation SessionDB
static SessionDB *objSessionDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objSessionDB == nil)
    {
        objSessionDB = [[self alloc] init];
    }
    
    return objSessionDB;
}

- (id)init
{
    if (self = [super init])
    {
        strTrackInstanceID = @"";
        strProductID = @"";
        intSessionTypeID = 0;
        strIndustryID = @"";
        strSpeakerID = @"";
        strSkillLevelID = @"";
        strTimeSlotID = @"";

    }
    
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods
- (NSArray*)GetSessions
{
    strTrackInstanceID = @"";
    strProductID = @"";
    intSessionTypeID = 0;
    strIndustryID = @"";
    strSpeakerID = @"";
    
    //return [self GetSessionsWithSpeakers:YES];
    return [self GetSessionsWithSpeakerAndGrouped:YES];
}

- (NSArray*)GetSessionsWithSessionID:(id)strSessionInstanceID
{
    strTrackInstanceID = @"";
    strProductID = @"";
    intSessionTypeID = 0;
    strIndustryID = @"";
    strSpeakerID = @"";
    
    return [self GetSessionsWithSessionIDAndSpeakers:strSessionInstanceID IncludeSpeaker:YES];
}

- (NSArray*)GetSearch:(NSString *)searchFor
{
    searchFor=[searchFor stringByReplacingOccurrencesOfString:@"'" withString:@""];
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Order By StartDate, StartTime";
    NSString *strSQL = @"Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable ";
    strSQL = [strSQL stringByAppendingString:@"From Sessions "];
    strSQL = [strSQL stringByAppendingString:@"Left Join MySessions "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = MySessions.SessionInstanceID "];
    strSQL = [strSQL stringByAppendingString:@"And MySessions.IsDeleted = 0 "];
    strSQL = [strSQL stringByAppendingString:@"Left Join UserSessionNotes "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionTracks "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SessionTracks.SessionInstanceID "];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC1 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC1.SessionInstanceID "];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC2 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC2.SessionInstanceID "];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Where 1 = 1 "];
    
    NSString *whereCondition=[NSString stringWithFormat:@"And (SessionCode Like '%%%@%%' Or SessionTitle Like '%%%@%%' Or  SessionTypeName Like '%%%@%%') ",searchFor,searchFor,searchFor];
    strSQL = [strSQL stringByAppendingString:whereCondition];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SessionTracks.SessionInstanceID = '%@' ",strTrackInstanceID];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC1.CategoryInstanceID = '%@' ",strProductID];
    }
    
    if(intSessionTypeID)
    {
        strSQL = [strSQL stringByAppendingFormat:@"And Sessions.SessionTypeID = '%d' ",intSessionTypeID];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC2.CategoryInstanceID = '%@' ",strIndustryID];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By StartDate, StartTime, SessionTitle"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            //if(blnIncludeSpeakers == YES)
            //{
            objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:objSession.strSessionInstanceID];
            //}
            //else
            //{
            //    objSession.arrSpeakers = [[NSMutableArray alloc] init];
            //}
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            
			[arrSessions addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)GetSessionsWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:(id)strTrackID ProductID:(id)strProdID SessionTypeID:(id)strSessTypeID IndustryID:(id)strIndID SpeakerID:(id)strSpkrID TimeSlotID:(id)strtimeslotID
{
    if(![strTrackID isEqual:[NSNull null]])
    {
        strTrackInstanceID =  strTrackID;
    }
    
    if(![strProdID isEqual:[NSNull null]])
    {
        strProductID =  strProdID;
    }
    
    //intSessionTypeID =  [strSessTypeID intValue];
    if(![strSessTypeID isEqual:[NSNull null]])
    {
        strSessionTypeID =  strSessTypeID;
    }
    
    if(![strIndID isEqual:[NSNull null]])
    {
        strIndustryID =  strIndID;
    }
    
    if(![strSpkrID isEqual:[NSNull null]])
    {
        strSpeakerID =  strSpkrID;
    }
    
    
    return [self GetSessionsWithSpeakerAndGrouped:YES];
}

- (NSArray*)GetSessionsWithTrackID:(id)strTrackID SkillLevelID:(id)strSkillID SessionTypeID:(id)strSessTypeID IndustryID:(id)strIndID TimeSlotID:(id)strtimeslotID
{
    if(![strTrackID isEqual:[NSNull null]])
    {
        strTrackInstanceID =  strTrackID;
    }
    
    if(![strSkillID isEqual:[NSNull null]])
    {
        strSkillLevelID =  strSkillID;
    }
    
    if(![strSessTypeID isEqual:[NSNull null]])
    {
        strSessionTypeID =  strSessTypeID;
    }
    
    if(![strIndID isEqual:[NSNull null]])
    {
        strIndustryID =  strIndID;
    }
    
    if(![strtimeslotID isEqual:[NSNull null]])
    {
        strTimeSlotID=  strtimeslotID;
    }
    
    
    return [self GetSessionsWithFilters];
}

- (NSArray*)GetSessionsWithFilters
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strCurDate = @"";
    NSString *strNextDate = @"";
    
    NSMutableArray *arrDateHappeningNow = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempHappeningNow = [[NSMutableArray alloc] init];
    
    NSString *strSQL = @"Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable ";
    strSQL = [strSQL stringByAppendingString:@"From Sessions "];
    strSQL = [strSQL stringByAppendingString:@"Left Join MySessions "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = MySessions.SessionInstanceID "];
    strSQL = [strSQL stringByAppendingString:@"And MySessions.IsDeleted = 0 "];
    strSQL = [strSQL stringByAppendingString:@"Left Join UserSessionNotes "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC3 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC3.SessionInstanceID "];
    }
    
    if(![strSkillLevelID isEqual:[NSNull null]] && ![NSString IsEmpty:strSkillLevelID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC1 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC1.SessionInstanceID "];
    }
    
    if(![strSessionTypeID isEqual:[NSNull null]] && ![NSString IsEmpty:strSessionTypeID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC4 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC4.SessionInstanceID "];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC2 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC2.SessionInstanceID "];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Where 1 = 1 "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        //strSQL = [strSQL stringByAppendingFormat:@"And SessionTracks.SessionInstanceID = '%@' ",strTrackInstanceID];
        strSQL = [strSQL stringByAppendingFormat:@"And SC3.CategoryInstanceID = '%@' ",strTrackInstanceID];
    }
    
    if(![strSkillLevelID isEqual:[NSNull null]] && ![NSString IsEmpty:strSkillLevelID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC1.CategoryInstanceID = '%@' ",strSkillLevelID];
    }
    
    if(![strSessionTypeID isEqual:[NSNull null]] && ![NSString IsEmpty:strSessionTypeID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC4.CategoryInstanceID = '%@' ",strSessionTypeID];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC2.CategoryInstanceID = '%@' ",strIndustryID];
    }
    
    if(![strTimeSlotID isEqual:[NSNull null]] && ![NSString IsEmpty:strTimeSlotID shouldCleanWhiteSpace:YES])
    {
        NSArray *arrTimeSlot = [strTimeSlotID componentsSeparatedByString:@"-"];
        strSQL = [strSQL stringByAppendingFormat:@" and ((StartTime >= %@) and (EndTime <= %@))",[arrTimeSlot objectAtIndex:0],[arrTimeSlot objectAtIndex:1]];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By StartDate, StartTime, SessionTitle"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            strNextDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            if(![strNextDate isEqualToString:strCurDate])
            {
                if(![strCurDate isEqualToString:@""] && [arrTempHappeningNow count] > 0)
                {
                    [arrDateHappeningNow addObject:strCurDate];
                    [arrDateHappeningNow addObject:[arrTempHappeningNow copy]];
                    
                    [arrTempHappeningNow removeAllObjects];
                    
                    [arrSessions addObject:[arrDateHappeningNow copy]];
                    [arrDateHappeningNow removeAllObjects];
                }
                
                strCurDate = strNextDate;
            }
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:objSession.strSessionInstanceID];
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            objSession.arrVideos = [self GetSessionVideos:objSession.strSessionInstanceID];
            
            [arrTempHappeningNow addObject:objSession];
			//[arrSessions addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(![strCurDate isEqualToString:@""] && [arrTempHappeningNow count] > 0)
    {
        [arrDateHappeningNow addObject:strCurDate];
        [arrDateHappeningNow addObject:[arrTempHappeningNow copy]];
        
        [arrTempHappeningNow removeAllObjects];
        
        [arrSessions addObject:[arrDateHappeningNow copy]];
        [arrDateHappeningNow removeAllObjects];
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)WhatIsHappeningNow
{
    strTrackInstanceID = @"";
    strProductID = @"";
    intSessionTypeID = 0;
    strIndustryID = @"";
    strSpeakerID = @"";
    
    return [self WhatIsHappeningAndGrouped:NO];
}

- (NSArray*)WhatIsHappeningWithTrackIDAndProductIDAndSessionTypeIDAndIndustryID:(id)strTrackID ProductID:(id)strProdID SessionTypeID:(id)strSessTypeID IndustryID:(id)strIndID speakerID:(id)strSpkrID TimeSlotID:(id)strtimeslotID
{
    if(![strTrackID isEqual:[NSNull null]])
    {
        strTrackInstanceID =  strTrackID;
    }
    
    if(![strProdID isEqual:[NSNull null]])
    {
        strProductID =  strProdID;
    }
    
    //intSessionTypeID =  [strSessTypeID intValue];
    if(![strSessTypeID isEqual:[NSNull null]])
    {
        strSessionTypeID =  strSessTypeID;
    }
    
    if(![strIndID isEqual:[NSNull null]])
    {
        strIndustryID =  strIndID;
    }
    
    if(![strSpkrID isEqual:[NSNull null]])
    {
        strSpeakerID =  strSpkrID;
    }
    
    intSessionTypeID =  [strSessionTypeID intValue];
    
    return [self WhatIsHappeningAndGrouped:NO];
}

- (NSArray*)WhatIsHappeningAndGrouped:(BOOL)blnGroupedByDate;
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strCurDate = @"";
    NSString *strNextDate = @"";

    NSMutableArray *arrDateHappeningNow = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempHappeningNow = [[NSMutableArray alloc] init];
    
    //char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) Then 0 Else 1 As IsAdded From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Where date(StartDate) = date('now') And StartTime > time('now','localtime') And StartTime < time('now','+2 hours','localtime') Order By StartDate, StartTime";
    //char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) Then 0 Else 1 As IsAdded From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Where StartTime > time('now','localtime') And StartTime < time('now','+2 hours','localtime') Order By StartDate, StartTime";
    //char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Order By StartDate, StartTime";
    
    NSString *strSQL = @"Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable ";
    strSQL = [strSQL stringByAppendingString:@"From Sessions "];
    strSQL = [strSQL stringByAppendingString:@"Left Join MySessions "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = MySessions.SessionInstanceID "];
    strSQL = [strSQL stringByAppendingString:@"And MySessions.IsDeleted = 0 "];
    strSQL = [strSQL stringByAppendingString:@"Left Join UserSessionNotes "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionTracks "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SessionTracks.SessionInstanceID "];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC1 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC1.SessionInstanceID "];
    }
    
    if(![strSessionTypeID isEqual:[NSNull null]] && ![NSString IsEmpty:strSessionTypeID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC4 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC4.SessionInstanceID "];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC2 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC2.SessionInstanceID "];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Where 1 = 1 "];
    //strSQL = [strSQL stringByAppendingString:@"And date(StartDate) = date('now') And StartTime > time('now','localtime') And StartTime < time('now','+2 hours','localtime') "];
     strSQL = [strSQL stringByAppendingString:@"and date(StartDate) == date('now') and ((((StartTime - time('now','localtime')) <= 120) and  (StartTime - time('now','localtime'))  > 0) or (((EndTime - time('now','localtime'))  <= 120) and (EndTime - time('now','localtime'))  > 0)) "];
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SessionTracks.SessionInstanceID = '%@' ",strTrackInstanceID];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC1.CategoryInstanceID = '%@' ",strProductID];
    }
    
    //if(intSessionTypeID)
    //{
    //    strSQL = [strSQL stringByAppendingFormat:@"And Sessions.SessionTypeID = '%d' ",intSessionTypeID];
    //}
    if(![strSessionTypeID isEqual:[NSNull null]] && ![NSString IsEmpty:strSessionTypeID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC4.CategoryInstanceID = '%@' ",strSessionTypeID];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC2.CategoryInstanceID = '%@' ",strIndustryID];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By StartDate, StartTime, SessionTitle"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            if(blnGroupedByDate == YES)
            {
                strNextDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
                if(![strNextDate isEqualToString:strCurDate])
                {
                    if(![strCurDate isEqualToString:@""] && [arrTempHappeningNow count] > 0)
                    {
                        [arrDateHappeningNow addObject:strCurDate];
                        [arrDateHappeningNow addObject:[arrTempHappeningNow copy]];
                        
                        [arrTempHappeningNow removeAllObjects];
                        
                        [arrSessions addObject:[arrDateHappeningNow copy]];
                        [arrDateHappeningNow removeAllObjects];
                    }
                    
                    strCurDate = strNextDate;
                }
            }
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            //if(blnIncludeSpeakers == YES)
            //{
            objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:objSession.strSessionInstanceID];
            //}
            //else
            //{
            //    objSession.arrSpeakers = [[NSMutableArray alloc] init];
            //}
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            
			[arrTempHappeningNow addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(blnGroupedByDate == YES)
    {
        if(![strCurDate isEqualToString:@""] && [arrTempHappeningNow count] > 0)
        {
            [arrDateHappeningNow addObject:strCurDate];
            [arrDateHappeningNow addObject:[arrTempHappeningNow copy]];
            
            [arrTempHappeningNow removeAllObjects];
            
            [arrSessions addObject:[arrDateHappeningNow copy]];
            [arrDateHappeningNow removeAllObjects];
        }
    }
    else
    {
        //[arrSessions addObject:[arrTempAgendas copy]];
        //[arrTempAgendas removeAllObjects];
        
        arrSessions = arrTempHappeningNow;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)GetSessionsWithSpeakers:(BOOL)blnIncludeSpeakers
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Order By StartDate, StartTime";
    NSString *strSQL = @"Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable ";
    strSQL = [strSQL stringByAppendingString:@"From Sessions "];
    strSQL = [strSQL stringByAppendingString:@"Left Join MySessions "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = MySessions.SessionInstanceID "];
    strSQL = [strSQL stringByAppendingString:@"And MySessions.IsDeleted = 0 "];
    strSQL = [strSQL stringByAppendingString:@"Left Join UserSessionNotes "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID "];

    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        //strSQL = [strSQL stringByAppendingString:@"Left Join SessionTracks "];
        //strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SessionTracks.SessionInstanceID "];
        
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC3 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC3.SessionInstanceID "];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC1 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC1.SessionInstanceID "];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC2 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC2.SessionInstanceID "];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Where 1 = 1 "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        //strSQL = [strSQL stringByAppendingFormat:@"And SessionTracks.SessionInstanceID = '%@' ",strTrackInstanceID];
        strSQL = [strSQL stringByAppendingFormat:@"And SC3.CategoryInstanceID = '%@' ",strTrackInstanceID];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC1.CategoryInstanceID = '%@' ",strProductID];
    }
    
    if(intSessionTypeID)
    {
        strSQL = [strSQL stringByAppendingFormat:@"And Sessions.SessionTypeID = '%d' ",intSessionTypeID];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC2.CategoryInstanceID = '%@' ",strIndustryID];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By StartDate, StartTime, SessionTitle"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            //if(blnIncludeSpeakers == YES)
            //{
                objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:objSession.strSessionInstanceID];
            //}
            //else
            //{
            //    objSession.arrSpeakers = [[NSMutableArray alloc] init];
            //}
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            
			[arrSessions addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)GetSessionsWithSessionIDAndSpeakers:(id)strSessionInstanceID IncludeSpeaker:(BOOL)blnIncludeSpeakers
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID And MySessions.IsDeleted = 0 Left Join UserSessionNotes On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID Where Sessions.SessionInstanceID = ? ";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            if(blnIncludeSpeakers == YES)
            {
                objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:strSessionInstanceID];
            }
            else
            {
                objSession.arrSpeakers = [[NSMutableArray alloc] init];
            }
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            
			[arrSessions addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)GetSessionsWithSpeakerAndGrouped:(BOOL)blnIncludeSpeakers
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessions = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strCurDate = @"";
    NSString *strNextDate = @"";
    
    NSMutableArray *arrDateHappeningNow = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempHappeningNow = [[NSMutableArray alloc] init];
    
    //char *strSQL = "Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded From Sessions Left Join MySessions On Sessions.SessionInstanceId = MySessions.SessionInstanceID Order By StartDate, StartTime";
    NSString *strSQL = @"Select Sessions.SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, strftime('%Y-%m-%d',StartDate) As StartDate, StartTime, EndTime, LocationURL, Case When IfNull(MySessions.SessionInstanceID,0) = 0 Then 0 Else 1 End As IsAdded, Case When IfNull(UserSessionNotes.SessionInstanceID,0) = 0 Then 0 Else 1 End As NotesAvailable ";
    strSQL = [strSQL stringByAppendingString:@"From Sessions "];
    strSQL = [strSQL stringByAppendingString:@"Left Join MySessions "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = MySessions.SessionInstanceID "];
    strSQL = [strSQL stringByAppendingString:@"And MySessions.IsDeleted = 0 "];
    strSQL = [strSQL stringByAppendingString:@"Left Join UserSessionNotes "];
    strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceId = UserSessionNotes.SessionInstanceID "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        //strSQL = [strSQL stringByAppendingString:@"Left Join SessionTracks "];
        //strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SessionTracks.SessionInstanceID "];
        
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC3 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC3.SessionInstanceID "];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC1 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC1.SessionInstanceID "];
    }
    
    if(![strSessionTypeID isEqual:[NSNull null]] && ![NSString IsEmpty:strSessionTypeID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC4 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC4.SessionInstanceID "];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingString:@"Left Join SessionCategories SC2 "];
        strSQL = [strSQL stringByAppendingString:@"On Sessions.SessionInstanceID = SC2.SessionInstanceID "];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Where 1 = 1 "];
    
    if(![strTrackInstanceID isEqual:[NSNull null]] && ![NSString IsEmpty:strTrackInstanceID shouldCleanWhiteSpace:YES])
    {
        //strSQL = [strSQL stringByAppendingFormat:@"And SessionTracks.SessionInstanceID = '%@' ",strTrackInstanceID];
        strSQL = [strSQL stringByAppendingFormat:@"And SC3.CategoryInstanceID = '%@' ",strTrackInstanceID];
    }
    
    if(![strProductID isEqual:[NSNull null]] && ![NSString IsEmpty:strProductID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC1.CategoryInstanceID = '%@' ",strProductID];
    }
    
    //if(intSessionTypeID)
    //{
    //    strSQL = [strSQL stringByAppendingFormat:@"And Sessions.SessionTypeID = '%d' ",intSessionTypeID];
    //}
    if(![strSessionTypeID isEqual:[NSNull null]] && ![NSString IsEmpty:strSessionTypeID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC4.CategoryInstanceID = '%@' ",strSessionTypeID];
    }
    
    if(![strIndustryID isEqual:[NSNull null]] && ![NSString IsEmpty:strIndustryID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC2.CategoryInstanceID = '%@' ",strIndustryID];
    }
    
    if(![strSpeakerID isEqual:[NSNull null]] && ![NSString IsEmpty:strSpeakerID shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And SC2.CategoryInstanceID = '%@' ",strSpeakerID];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By StartDate, StartTime, SessionTitle"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Session *objSession = [[Session alloc] init];
            
            strNextDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            if(![strNextDate isEqualToString:strCurDate])
            {
                if(![strCurDate isEqualToString:@""] && [arrTempHappeningNow count] > 0)
                {
                    [arrDateHappeningNow addObject:strCurDate];
                    [arrDateHappeningNow addObject:[arrTempHappeningNow copy]];
                    
                    [arrTempHappeningNow removeAllObjects];
                    
                    [arrSessions addObject:[arrDateHappeningNow copy]];
                    [arrDateHappeningNow removeAllObjects];
                }
                
                strCurDate = strNextDate;
            }
            
            objSession.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSession.strSessionStatusID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSession.strSessionStatusName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSession.strSessionTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSession.strSessionTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSession.strJointSessionID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSession.strJointSessionWith = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objSession.strSessionCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objSession.strSessionTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objSession.strSessionAbstract = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objSession.strSessionObjective = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objSession.strPriorityID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objSession.strPriorityName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objSession.strPriorityTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objSession.strPriorityTypeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objSession.strStartDate = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objSession.strStartTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objSession.strEndTime = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objSession.strLocationURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objSession.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objSession.strNotesAvailable = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            if(blnIncludeSpeakers == YES)
            {
                objSession.arrSpeakers = [self GetSessionSpeakersForSessionID:objSession.strSessionInstanceID];
            }
            else
            {
                objSession.arrSpeakers = [[NSMutableArray alloc] init];
            }
            
            objSession.arrResources = [self GetSessionResources:objSession.strSessionInstanceID];
            objSession.arrTracks = [self GetSessionTracks:objSession.strSessionInstanceID];
            objSession.arrSubTracks = [self GetSessionSubTracks:objSession.strSessionInstanceID];
            objSession.arrCategories = [self GetSessionCategories:objSession.strSessionInstanceID];
            objSession.arrRooms = [self GetSessionRooms:objSession.strSessionInstanceID];
            objSession.arrVideos = [self GetSessionVideos:objSession.strSessionInstanceID];
            
            [arrTempHappeningNow addObject:objSession];
			//[arrSessions addObject:objSession];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(![strCurDate isEqualToString:@""] && [arrTempHappeningNow count] > 0)
    {
        [arrDateHappeningNow addObject:strCurDate];
        [arrDateHappeningNow addObject:[arrTempHappeningNow copy]];
        
        [arrTempHappeningNow removeAllObjects];
        
        [arrSessions addObject:[arrDateHappeningNow copy]];
        [arrDateHappeningNow removeAllObjects];
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessions;
}

- (NSArray*)SetSessions:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"SessionList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"SessionList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrSessions = [dictData valueForKey:@"Sessions"];
        NSUInteger intEntriesM = [arrSessions count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteSessions];
            [arrQuery addObject:@"Delete From Sessions"];
            
            Session *objSession = [[Session alloc] init];
            NSMutableDictionary *dictSession;
            
            NSArray *arrSessionRecources;
            NSUInteger intEntriesD = 0;
            NSMutableDictionary *dictSessionResource;
            
            //NSArray *arrSessionTracks;
            //NSMutableDictionary *dictSessionTracks;
            
            //NSArray *arrSessionSubTracks;
            //NSMutableDictionary *dictSessionSubTracks;
            
            NSArray *arrSessionCategories;
            NSMutableDictionary *dictSessionCategories;
            
            NSArray *arrSessionRooms;
            NSMutableDictionary *dictSessionRooms;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictSession = [[NSMutableDictionary alloc] init];
                
                dictSession = [[arrSessions objectAtIndex:i] valueForKey:@"SessionDetails"];
                
                objSession.strSessionInstanceID = [dictSession valueForKey:@"SessionInstanceID"];
                
                if([[Functions ReplaceNUllWithBlank:objSession.strSessionInstanceID] isEqualToString:@""])
                {
                }
                else
                {
//                    objSession.strSessionStatusID = [Functions ReplaceNUllWithZero:[dictSession valueForKey:@"SessionStatusID"]];
//                    objSession.strSessionStatusName = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionStatusName"]];
//                    objSession.strSessionTypeID = [Functions ReplaceNUllWithZero:[dictSession valueForKey:@"SessionTypeID"]];
//                    objSession.strSessionTypeName = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionTypeName"]];
//                    objSession.strJointSessionID = [Functions ReplaceNUllWithZero:[dictSession valueForKey:@"JointSessionID"]];
//                    objSession.strJointSessionWith = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"JointSessionWith"]];
//                    objSession.strSessionCode = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionCode"]];
//                    objSession.strSessionTitle = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionTitle"]];
//                    objSession.strSessionAbstract = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionAbstract"]];
//                    objSession.strSessionObjective = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionObjective"]];
//                    objSession.strPriorityID = [Functions ReplaceNUllWithZero:[dictSession valueForKey:@"Priority"]];
//                    objSession.strPriorityName = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"PriorityName"]];
//                    objSession.strPriorityTypeID = [Functions ReplaceNUllWithZero:[dictSession valueForKey:@"PriorityTypeID "]];
//                    objSession.strPriorityTypeName = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"PriorityTypeName"]];
//                    objSession.strStartDate = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"StartDate"]];
//                    objSession.strStartTime = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"StartTime"]];
//                    objSession.strEndTime = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"EndTime"]];
//                    objSession.strLocationURL = [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"LocationURL"]];
//                    
//                    blnResult = [self AddSession:objSession];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Sessions(SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, StartDate, StartTime, EndTime, LocationURL) Values('%@', %i, '%@', %i, '%@', %i, '%@', '%@', '%@', '%@', '%@', %i, '%@', %i, '%@', '%@', '%@', '%@', '%@')",
                    [dictSession valueForKey:@"SessionInstanceID"],
                    [[Functions ReplaceNUllWithZero:[dictSession valueForKey:@"SessionStatusID"]]intValue],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionStatusName"]],
                    [[Functions ReplaceNUllWithZero:[dictSession valueForKey:@"SessionTypeID"]]intValue],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionTypeName"]],
                    [[Functions ReplaceNUllWithZero:[dictSession valueForKey:@"JointSessionID"]]intValue],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"JointSessionWith"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionCode"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionTitle"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionAbstract"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"SessionObjective"]],
                    [[Functions ReplaceNUllWithZero:[dictSession valueForKey:@"Priority"]] intValue],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"PriorityName"]],
                    [[Functions ReplaceNUllWithZero:[dictSession valueForKey:@"PriorityTypeID "]]intValue],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"PriorityTypeName"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"StartDate"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"StartTime"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"EndTime"]],
                    [Functions ReplaceNUllWithBlank:[dictSession valueForKey:@"LocationURL"]]];
                    
                    [arrQuery addObject:strSQL];
                    
//                    if(blnResult ==  YES)
//                    {
//                        [self DeleteSessionResources:objSession.strSessionInstanceID];
//                        [self DeleteSessionCategories:objSession.strSessionInstanceID];
//                        [self DeleteSessionRooms:objSession.strSessionInstanceID];
//                    }
                    
                    strSQL = [NSString stringWithFormat:@"Delete From SessionResources Where SessionInstanceID = '%@' ",[dictSession valueForKey:@"SessionInstanceID"]];
                    [arrQuery addObject:strSQL];
                    strSQL = [NSString stringWithFormat:@"Delete From SessionCategories Where SessionInstanceID = '%@' ",[dictSession valueForKey:@"SessionInstanceID"]];
                    [arrQuery addObject:strSQL];
                    strSQL = [NSString stringWithFormat:@"Delete From SessionRooms Where SessionInstanceID = '%@' ",[dictSession valueForKey:@"SessionInstanceID"]];
                    [arrQuery addObject:strSQL];
                    
//                    if(blnResult == YES)
//                    {
                        arrSessionRecources = [dictSession valueForKey:@"Resources"];
                        intEntriesD = [arrSessionRecources count];
                        
                        if(intEntriesD > 0)
                        {
                            dictSessionResource = [[NSMutableDictionary alloc] init];
                            
                            SessionResources *objSessionResources = [[SessionResources alloc] init];
                            
                            for (NSUInteger i = 0; i < intEntriesD; i++)
                            {
                                dictSessionResource = [arrSessionRecources objectAtIndex:i];
                                
                                objSessionResources.strResourceID = [dictSessionResource valueForKey:@"ResourceId"];
                                
                                if([Functions ReplaceNUllWithZero:objSessionResources.strResourceID]!=0)
                                {
//                                    objSessionResources.strSessionInstanceID = objSession.strSessionInstanceID;
//                                    objSessionResources.strFileName = [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"FileName"]];
//                                    objSessionResources.strDocType = [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"DocType"]];
//                                    objSessionResources.strDocTypeID = [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"DocTypeID"]];
//                                    objSessionResources.strURL = [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"URL"]];
//                                    objSessionResources.strBriefDescription = [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"BriefDescription"]];
//                                    
//                                    blnResult = [self AddSessionResources:objSessionResources];
                                    
                                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into SessionResources(ResourceID, SessionInstanceID, FileName, DocType, DocTypeID, URL, BriefDescription) Values(%@, '%@', '%@', '%@', %@, '%@', '%@')",
                                    [dictSessionResource valueForKey:@"ResourceId"],
                                    [dictSession valueForKey:@"SessionInstanceID"],
                                    [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"FileName"]],
                                    [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"DocType"]],
                                    [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"DocTypeID"]],
                                    [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"URL"]],
                                    [Functions ReplaceNUllWithBlank:[dictSessionResource valueForKey:@"BriefDescription"]]];
                                    
                                    [arrQuery addObject:strSQL];

                                }
                            }
                        }
                        
                        /*
                        arrSessionTracks = [dictSession valueForKey:@"Tracks"];
                        intEntriesD = [arrSessionTracks count];
                        
                        if(intEntriesD > 0)
                        {
                            dictSessionTracks = [[NSMutableDictionary alloc] init];
                            
                            SessionTracks *objSessionTracks = [[SessionTracks alloc] init];
                            
                            for (NSUInteger i = 0; i < intEntriesD; i++)
                            {
                                dictSessionTracks = [arrSessionTracks objectAtIndex:i];
                                
                                objSessionTracks.strTrackInstanceID = [dictSessionTracks valueForKey:@"TrackInstanceId"];
                                
                                if([[Functions ReplaceNUllWithBlank:objSessionTracks.strTrackInstanceID] isEqualToString:@""])
                                {
                                }
                                else
                                {
                                    objSessionTracks.strSessionInstanceID = objSession.strSessionInstanceID;
                                    objSessionTracks.strTrackName = [Functions ReplaceNUllWithBlank:[dictSessionTracks valueForKey:@"TrackName"]];
                                    
                                    blnResult = [self AddSessionTracks:objSessionTracks];
                                }
                            }
                        }
                        
                        arrSessionSubTracks = [dictSession valueForKey:@"SubTracks"];
                        intEntriesD = [arrSessionSubTracks count];
                        
                        if(intEntriesD > 0)
                        {
                            dictSessionSubTracks = [[NSMutableDictionary alloc] init];
                            
                            SessionSubTracks *objSessionSubTracks = [[SessionSubTracks alloc] init];
                            
                            for (NSUInteger i = 0; i < intEntriesD; i++)
                            {
                                dictSessionSubTracks = [arrSessionSubTracks objectAtIndex:i];
                                
                                objSessionSubTracks.strSubTrackInstanceID = [dictSessionSubTracks valueForKey:@"SubTrackInstanceId"];
                                
                                if([[Functions ReplaceNUllWithBlank:objSessionSubTracks.strSubTrackInstanceID] isEqualToString:@""])
                                {
                                }
                                else
                                {
                                    objSessionSubTracks.strSessionInstanceID = objSession.strSessionInstanceID;
                                    objSessionSubTracks.strSubTrackName = [Functions ReplaceNUllWithBlank:[dictSessionSubTracks valueForKey:@"SubTrackName"]];
                                    
                                    blnResult = [self AddSessionSubTracks:objSessionSubTracks];
                                }
                            }
                        }
                        */
                        
                        arrSessionCategories = [dictSession valueForKey:@"Categories"];
                        intEntriesD = [arrSessionCategories count];
                        
                        if(intEntriesD > 0)
                        {
                            dictSessionCategories = [[NSMutableDictionary alloc] init];
                            
                            SessionCategories *objSessionCategories = [[SessionCategories alloc] init];
                            
                            for (NSUInteger i = 0; i < intEntriesD; i++)
                            {
                                dictSessionCategories = [arrSessionCategories objectAtIndex:i];
                                
                                objSessionCategories.strCategoryInstanceID = [dictSessionCategories valueForKey:@"CategoryInstanceId"];
                                
                                if([[Functions ReplaceNUllWithBlank:objSessionCategories.strCategoryInstanceID] isEqualToString:@""])
                                {
                                }
                                else
                                {
//                                    objSessionCategories.strSessionInstanceID = objSession.strSessionInstanceID;
//                                    objSessionCategories.strCategoryName = [Functions ReplaceNUllWithBlank:[dictSessionCategories valueForKey:@"CategoryName"]];
//                                    
//                                    blnResult = [self AddSessionCategories:objSessionCategories];
                                    
                                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into SessionCategories(CategoryInstanceID , SessionInstanceID, CategoryName) Values('%@', '%@', '%@')",
                                    [dictSessionCategories valueForKey:@"CategoryInstanceId"],
                                    [dictSession valueForKey:@"SessionInstanceID"],
                                    [Functions ReplaceNUllWithBlank:[dictSessionCategories valueForKey:@"CategoryName"]]];
                                    
                                    [arrQuery addObject:strSQL];
                                }
                            }
                        }
                        
                        arrSessionRooms = [dictSession valueForKey:@"Rooms"];
                        intEntriesD = [arrSessionRooms count];
                        
                        if(intEntriesD > 0)
                        {
                            dictSessionRooms = [[NSMutableDictionary alloc] init];
                            
                            SessionRooms *objSessionRooms = [[SessionRooms alloc] init];
                            
                            for (NSUInteger i = 0; i < intEntriesD; i++)
                            {
                                dictSessionRooms = [arrSessionRooms objectAtIndex:i];
                                
                                objSessionRooms.strRoomInstanceID = [dictSessionRooms valueForKey:@"RoomInstanceId"];
                                
                                if([[Functions ReplaceNUllWithBlank:objSessionRooms.strRoomInstanceID] isEqualToString:@""])
                                {
                                }
                                else
                               {
//                                    objSessionRooms.strSessionInstanceID = objSession.strSessionInstanceID;
//                                    objSessionRooms.strRoomName = [Functions ReplaceNUllWithBlank:[dictSessionRooms valueForKey:@"RoomName"]];
//                                    objSessionRooms.strCapacity = [Functions ReplaceNUllWithZero:[dictSessionRooms valueForKey:@"Capacity"]];
//                                    
//                                    blnResult = [self AddSessionRooms:objSessionRooms];
                                    
                                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into SessionRooms(RoomInstanceID , SessionInstanceID, RoomName, Capacity) Values('%@', '%@', '%@', %@)",
                                    [dictSessionRooms valueForKey:@"RoomInstanceId"],
                                    [dictSession valueForKey:@"SessionInstanceID"],
                                    [Functions ReplaceNUllWithBlank:[dictSessionRooms valueForKey:@"RoomName"]],
                                    [Functions ReplaceNUllWithZero:[dictSessionRooms valueForKey:@"Capacity"]]];
                                
                                    [arrQuery addObject:strSQL];
                                
                                }
                            }
                        }

                    NSArray *arrSessionSpeaker = [dictSession valueForKey:@"SpeakerDetails"];
                    intEntriesD = [arrSessionSpeaker count];
                    
                    if(intEntriesD > 0)
                    {
                        NSMutableDictionary *dictSessionSpeakers = [[NSMutableDictionary alloc] init];
                        
                        [arrQuery addObject:[NSString stringWithFormat:@"Delete from SpeakerSessions where SessionInstanceID = '%@'",[dictSession valueForKey:@"SessionInstanceID"]]];
                        for (NSUInteger i = 0; i < intEntriesD; i++)
                        {
                            dictSessionSpeakers = [arrSessionSpeaker objectAtIndex:i];
                            
                                NSString *strSQL = [NSString stringWithFormat:@"Insert Into SpeakerSessions(SpeakerInstanceID , SessionInstanceID)Values('%@', '%@')",[dictSessionSpeakers valueForKey:@"SpeakerInstanceId"],[dictSession valueForKey:@"SessionInstanceID"]];
                                
                                [arrQuery addObject:strSQL];
                        }
                    }
                    
                    
                    // Added and Commented by Nikhil 14/1/14
                    
                    NSArray *arrSessionVideos = [dictSession valueForKey:@"Videos"];
                    intEntriesD = [arrSessionVideos count];
                    
                    if(intEntriesD > 0)
                    {
                        NSMutableDictionary *dictSessionVideos = [[NSMutableDictionary alloc] init];
                        
                        [arrQuery addObject:[NSString stringWithFormat:@"Delete from SessionVideos where SessionInstanceID = '%@'",[dictSession valueForKey:@"SessionInstanceID"]]];
                        
                        for (NSUInteger i = 0; i < intEntriesD; i++)
                        {
                            dictSessionVideos = [arrSessionVideos objectAtIndex:i];
                            
                            NSString *strSQL = [NSString stringWithFormat:@"Insert Into SessionVideos(VideoInstanceId, SessionInstanceId, Title, URL)Values(%@,'%@', '%@', '%@')",[dictSessionVideos valueForKey:@"VideoId"],[dictSession valueForKey:@"SessionInstanceID"],[dictSessionVideos valueForKey:@"VideoTitle"],[dictSessionVideos valueForKey:@"VideoURL"]];
                            
                            [arrQuery addObject:strSQL];
                        }
                    }
                    

                        //[self DeleteSessionTypes];
                        //[self AddSessionTypes];
//                    }
                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_SESSION Version:intVersion];
//        }
        
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_SPEAKER]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteSessions
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Sessions ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strSessionInstanceID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSession:(Session*)objSession
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Sessions(SessionInstanceID, SessionStatusID, SessionStatusName, SessionTypeID, SessionTypeName, JointSessionID, JointSessionWith, SessionCode, SessionTitle, SessionAbstract, SessionObjective, PriorityID, PriorityName, PriorityTypeID, PriorityTypeName, StartDate, StartTime, EndTime, LocationURL) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSession.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, [objSession.strSessionStatusID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objSession.strSessionStatusName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 4, [objSession.strSessionTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 5, [objSession.strSessionTypeName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 6, [objSession.strJointSessionID intValue]);
        sqlite3_bind_text(compiledStmt, 7, [objSession.strJointSessionWith UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objSession.strSessionCode UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objSession.strSessionTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objSession.strSessionAbstract UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objSession.strSessionObjective UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 12, [objSession.strPriorityID intValue]);
        sqlite3_bind_text(compiledStmt, 13, [objSession.strPriorityName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 14, [objSession.strPriorityTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 15, [objSession.strPriorityTypeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objSession.strStartDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objSession.strStartTime UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 18, [objSession.strEndTime UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 19, [objSession.strLocationURL UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_SESSION MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateSession:(Session*)objSession
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Sessions Set ";
    strSQL = [strSQL stringByAppendingFormat:@"SessionStatusID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionStatusName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionTypeID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionTypeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"JointSessionID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"JointSessionWith = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionCode = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionTitle = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionAbstract = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"SessionObjective = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityTypeID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PriorityTypeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"StartDate = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"StartTime = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"EndTime = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LocationURL = ? "];
    
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objSession.strSessionStatusID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objSession.strSessionStatusName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 3, [objSession.strSessionTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 4, [objSession.strSessionTypeName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objSession.strJointSessionID intValue]);
        sqlite3_bind_text(compiledStmt, 6, [objSession.strJointSessionWith UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objSession.strSessionCode UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objSession.strSessionTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objSession.strSessionAbstract UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objSession.strSessionObjective UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 11, [objSession.strPriorityID intValue]);
        sqlite3_bind_text(compiledStmt, 12, [objSession.strPriorityName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 13, [objSession.strPriorityTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 14, [objSession.strPriorityTypeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 15, [objSession.strStartDate UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objSession.strStartTime UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objSession.strEndTime UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 18, [objSession.strLocationURL UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 19, [objSession.strSessionInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSessionResources:(SessionResources*)objSessionResource
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionResources(ResourceID, SessionInstanceID, FileName, DocType, DocTypeID, URL, BriefDescription) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objSessionResource.strResourceID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objSessionResource.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSessionResource.strFileName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objSessionResource.strDocType UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objSessionResource.strDocTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 6, [objSessionResource.strURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objSessionResource.strBriefDescription UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateSessionResources:(SessionResources*)objSessionResource
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update SessionResources Set ";
    strSQL = [strSQL stringByAppendingFormat:@"FileName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"DocType = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"DocTypeID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"URL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ResourceID = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"And SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionResource.strFileName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionResource.strDocType UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 3, [objSessionResource.strDocTypeID intValue]);
        sqlite3_bind_text(compiledStmt, 4, [objSessionResource.strURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objSessionResource.strBriefDescription UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 6, [objSessionResource.strResourceID intValue]);
        sqlite3_bind_int(compiledStmt, 7, [objSessionResource.strSessionInstanceID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteSessionResources:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionResources ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSessionTracks:(SessionTracks*)objSessionTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionTracks(TrackInstanceID , SessionInstanceID, TrackName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionTracks.strTrackInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionTracks.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSessionTracks.strTrackName UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteSessionTracks:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionTracks ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSessionSubTracks:(SessionSubTracks*)objSessionSubTracks
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionSubTracks(SubTrackInstanceID , SessionInstanceID, SubTrackName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionSubTracks.strSubTrackInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionSubTracks.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSessionSubTracks.strSubTrackName UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteSessionSubTracks:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionSubTracks ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSessionCategories:(SessionCategories*)objSessionCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionCategories(CategoryInstanceID , SessionInstanceID, CategoryName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionCategories.strCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionCategories.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSessionCategories.strCategoryName UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteSessionCategories:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionCategories ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddSessionRooms:(SessionRooms*)objSessionRooms
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionRooms(RoomInstanceID , SessionInstanceID, RoomName, Capacity) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objSessionRooms.strRoomInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objSessionRooms.strSessionInstanceID UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objSessionRooms.strRoomName UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 4, [objSessionRooms.strCapacity intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteSessionRooms:(NSString*)strSessionInstanceID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionRooms ";
    strSQL = [strSQL stringByAppendingFormat:@"Where SessionInstanceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (NSMutableArray*)GetSessionResources:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSesssionResources = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ResourceID, SessionInstanceID, FileName, DocType, DocTypeID, URL, BriefDescription From SessionResources Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionResources *objSessionResources = [[SessionResources alloc] init];
            
            objSessionResources.strResourceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionResources.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionResources.strFileName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSessionResources.strDocType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objSessionResources.strDocTypeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objSessionResources.strURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objSessionResources.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            
			//Read the data from the result row
			[arrSesssionResources addObject:objSessionResources];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSesssionResources;
}

- (NSMutableArray*)GetSessionTracks:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSesssionTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select TrackInstanceID, SessionInstanceID, TrackName From SessionTracks Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionTracks *objSessionTracks = [[SessionTracks alloc] init];
            
            objSessionTracks.strTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionTracks.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionTracks.strTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSesssionTracks addObject:objSessionTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSesssionTracks;
}

- (NSMutableArray*)GetSessionSubTracks:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionSubTracks = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select SubTrackInstanceID, SessionInstanceID, SubTrackName From SessionSubTracks Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionSubTracks *objSessionSubTracks = [[SessionSubTracks alloc] init];
            
            objSessionSubTracks.strSubTrackInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionSubTracks.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionSubTracks.strSubTrackName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSessionSubTracks addObject:objSessionSubTracks];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionSubTracks;
}

- (NSMutableArray*)GetSessionCategories:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select CategoryInstanceID, SessionInstanceID, CategoryName From SessionCategories Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionCategories *objSessionCategories = [[SessionCategories alloc] init];
            
            objSessionCategories.strCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionCategories.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionCategories.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSessionCategories addObject:objSessionCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionCategories;
}

- (NSMutableArray*)GetSessionRooms:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionRooms = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select RoomInstanceID, SessionInstanceID, RoomName, Capacity From SessionRooms Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionRooms *objSessionRooms = [[SessionRooms alloc] init];
            
            objSessionRooms.strRoomInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionRooms.strSessionInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionRooms.strRoomName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objSessionRooms.strCapacity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
			//Read the data from the result row
			[arrSessionRooms addObject:objSessionRooms];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionRooms;
}

- (NSMutableArray*)GetSessionVideos:(NSString*)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSessionVideos = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select VideoInstanceId,Title, URL From SessionVideos Where SessionInstanceId = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            SessionVideos *objSessionVideos = [[SessionVideos alloc] init];
            
            objSessionVideos.strVideoInstanceId = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objSessionVideos.strVideoTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objSessionVideos.strVideoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrSessionVideos addObject:objSessionVideos];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSessionVideos;
}

- (NSArray*)GetSessionSpeakersForSessionID:(id)strSessionInstanceID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpeakers = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    SpeakerDB *objSpeakerDB = [[SpeakerDB alloc] init];
    
    char *strSQL = "Select SpeakerSessions.SessionInstanceID, SpeakerSessions.SpeakerInstanceID From SpeakerSessions Inner Join Speakers On SpeakerSessions.SpeakerInstanceID = Speakers.SpeakerInstanceID Where SessionInstanceID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strSessionInstanceID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSArray *arrTemp = [[NSArray alloc] init];
            
            arrTemp = [objSpeakerDB GetSpeakersWithSpeakerIDAndSessionsAndGrouped:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] IncludeSessions:NO Grouped:NO];
            
			//Read the data from the result row
			[arrSpeakers addObject:arrTemp];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpeakers;
}

- (BOOL)AddSessionTypes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into SessionTypes(SessionTypeID, SessionTypeName) ";
    strSQL = [strSQL stringByAppendingString:@"Select Distinct SessionTypeID, SessionTypeName From Sessions"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteSessionTypes
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From SessionTypes";
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
	}
	else
    {
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}
#pragma mark -
@end
