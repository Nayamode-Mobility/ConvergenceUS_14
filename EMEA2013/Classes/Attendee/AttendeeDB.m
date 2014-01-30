//
//  AttendeeDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AttendeeDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "NSString+Custom.h"
#import "Filters.h"
#import "Exhibitor.h"

@implementation AttendeeDB
static AttendeeDB *objAttendeeDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objAttendeeDB == nil)
    {
        objAttendeeDB = [[self alloc] init];
    }
    
    return objAttendeeDB;
}

- (id)init
{
    if (self = [super init])
    {
        strSearch = @"";
    }
    
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods (Attendee)
- (NSArray*)GetSearch:(NSString *)searchFor
{
    searchFor=[searchFor stringByReplacingOccurrencesOfString:@"'" withString:@""];
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendees = [[NSMutableArray alloc] init];
    
    
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Attendees ";
    
    NSString *whereCondition=[NSString stringWithFormat:@"Where FirstName Like '%%%@%%' Or LastName Like '%%%@%%' Or AttendeeName Like '%%%@%%' Or Company Like '%%%@%%' Or Designation Like '%%%@%%' ",
                              searchFor,searchFor,searchFor,searchFor,searchFor];
    
    strSQL = [strSQL stringByAppendingString:whereCondition];
    
    strSQL = [strSQL stringByAppendingString:@"Order By Upper(FirstName), Upper(LastName)"];
    
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            
            
            objAttendee.strAttendeeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAttendee.strRegistrantID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAttendee.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAttendee.strMiddle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAttendee.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAttendee.strAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAttendee.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objAttendee.strDesignation = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objAttendee.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objAttendee.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objAttendee.strPUID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objAttendee.strPhotoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objAttendee.strBIO = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objAttendee.strPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objAttendee.strIsNotificationEnabled = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objAttendee.strIsEmailVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objAttendee.strIsPhoneNumberVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objAttendee.strIsNameVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objAttendee.strIsDesignationVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objAttendee.strIsCompanyVisible   = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objAttendee.strAllowInAppMessaging = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            objAttendee.strAllowSendMeetingInvite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 21)];
            objAttendee.strIsBiovisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 22)];
            objAttendee.strIsPhotoVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 23)];
            
            [arrAttendees addObject: objAttendee];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAttendees;
}

- (NSArray*)GetAttendees
{
    strSearch = @"";
    
    return [self GetAttendeesAndGrouped:YES];
}

- (NSArray*)GetAttendeesList:(NSData *)objData
{
    NSError *error;
    
    NSMutableArray *arrAttendee = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        NSArray *arrAttendees = [dictData valueForKey:@"AttendeeList"];
        NSUInteger intEntriesM = [arrAttendees count];
        
        if(intEntriesM > 0)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            NSMutableDictionary *dictAttendee;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictAttendee = [[NSMutableDictionary alloc] init];
                
                //dictAttendee = [[arrAttendees objectAtIndex:i] valueForKey:@"AttendeeDetails"];
                dictAttendee = [arrAttendees objectAtIndex:i];
                
                objAttendee.strAttendeeID = [dictAttendee valueForKey:@"AttendeeID"];
                
                if([Functions ReplaceNUllWithZero:objAttendee.strAttendeeID]!=0)
                {
                    objAttendee.strRegistrantID = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"RegistrantId"]];
                    objAttendee.strFirstName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"FirstName"]];
                    objAttendee.strMiddle = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Middle"]];
                    objAttendee.strLastName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"LastName"]];
                    objAttendee.strAttendeeName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"AttendeeName"]];
                    objAttendee.strCompany = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Company"]];
                    objAttendee.strDesignation = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Designation"]];
                    objAttendee.strExhibitorName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"ExhibitorName"]];
                    objAttendee.strEmail = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Email"]];
                    objAttendee.strPUID = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"PUID"]];
                    objAttendee.strPhotoURL = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"PhotoURL"]];
                    objAttendee.strBIO = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"BIO"]];
                    objAttendee.strPhone = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Phone"]];
                    objAttendee.strIsNotificationEnabled = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsNotificationEnabled"]];
                    objAttendee.strIsEmailVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsEmailVisible"]];
                    objAttendee.strIsPhoneNumberVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsPhoneNumberVisible"]];
                    objAttendee.strIsNameVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsNameVisible"]];
                    objAttendee.strIsDesignationVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsDesignationVisible"]];
                    objAttendee.strIsCompanyVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsCompanyVisible"]];
                    objAttendee.strAllowInAppMessaging = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"AllowInAppMessaging"]];
                    objAttendee.strAllowSendMeetingInvite = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"AllowSendMeetingInvite"]];
                    objAttendee.strIsBiovisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsBioVisible"]];
                    objAttendee.strIsPhotoVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsPhotoVisible"]];
                    
                    [arrAttendee addObject:objAttendee];
                }
            }
        }
        
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrAttendee;
}

- (NSArray*)GetAttendeesLikeName:(id)strValue
{
    strSearch = strValue;
    
    return [self GetAttendeesAndGrouped:YES];
}

- (NSArray*)GetAttendeesLikeNameAndGrouped:(id)strValue blnGrouped:(BOOL)blnGrouped;
{
    strSearch = strValue;
    
    return [self GetAttendeesAndGrouped:blnGrouped];
}

- (NSArray*)GetAttendeesAndGrouped:(BOOL)blnGrouped
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendees = [[NSMutableArray alloc] init];
    
    NSString *strCurAlpha = @"";
    NSString *strNextAlpha = @"";
    
    NSMutableArray *arrAlhaAttendees = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempAttendees = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Attendees Order By Upper(FirstName), Upper(LastName)";
    NSString *strSQL = @"Select AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Attendees ";
    if(![NSString IsEmpty:strSearch shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where FirstName Like '%%%@%%' Or LastName Like '%%%@%%'",strSearch,strSearch];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By Upper(FirstName), Upper(LastName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            
            if(blnGrouped == YES)
            {
                strNextAlpha = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 24)];
                if(![strNextAlpha isEqualToString:strCurAlpha])
                {
                    if(![strCurAlpha isEqualToString:@""] && [arrTempAttendees count] > 0)
                    {
                        [arrAlhaAttendees addObject:strCurAlpha];
                        [arrAlhaAttendees addObject:[arrTempAttendees copy]];
                        
                        [arrTempAttendees removeAllObjects];
                        
                        [arrAttendees addObject:[arrAlhaAttendees copy]];
                        [arrAlhaAttendees removeAllObjects];
                    }
                    
                    strCurAlpha = strNextAlpha;
                }
            }
            
            objAttendee.strAttendeeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAttendee.strRegistrantID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAttendee.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAttendee.strMiddle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAttendee.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAttendee.strAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAttendee.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objAttendee.strDesignation = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objAttendee.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objAttendee.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objAttendee.strPUID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objAttendee.strPhotoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objAttendee.strBIO = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objAttendee.strPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objAttendee.strIsNotificationEnabled = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objAttendee.strIsEmailVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objAttendee.strIsPhoneNumberVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objAttendee.strIsNameVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objAttendee.strIsDesignationVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objAttendee.strIsCompanyVisible   = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objAttendee.strAllowInAppMessaging = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            objAttendee.strAllowSendMeetingInvite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 21)];
            objAttendee.strIsBiovisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 22)];
            objAttendee.strIsPhotoVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 23)];
            
            [arrTempAttendees addObject: objAttendee];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(blnGrouped == YES)
    {
    if(![strCurAlpha isEqualToString:@""] && [arrTempAttendees count] > 0)
    {
        [arrAlhaAttendees addObject:strCurAlpha];
        [arrAlhaAttendees addObject:[arrTempAttendees copy]];
        
        [arrTempAttendees removeAllObjects];
        
        [arrAttendees addObject:[arrAlhaAttendees copy]];
        [arrAlhaAttendees removeAllObjects];
    }
    }
    else
    {
        //[arrAttendees addObject:[arrTempAttendees copy]];
        //[arrTempAttendees removeAllObjects];
        
        arrAttendees = arrTempAttendees;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAttendees;
}

- (NSArray*)GetAttendeesWithAttendeeID:(id)strAttendeeID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendees = [[NSMutableArray alloc] init];
    
    NSString *strCurAlpha = @"";
    NSString *strNextAlpha = @"";
    
    NSMutableArray *arrAlhaAttendees = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempAttendees = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Attendees Where AttendeeID = ? Order By Upper(FirstName), Upper(LastName)";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strAttendeeID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            
            strNextAlpha = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            if(![strNextAlpha isEqualToString:strCurAlpha])
            {
                if(![strCurAlpha isEqualToString:@""] && [arrTempAttendees count] > 0)
                {
                    [arrAlhaAttendees addObject:strCurAlpha];
                    [arrAlhaAttendees addObject:[arrTempAttendees copy]];
                    
                    [arrTempAttendees removeAllObjects];
                    
                    [arrAttendees addObject:[arrAlhaAttendees copy]];
                    [arrAlhaAttendees removeAllObjects];
                }
                
                strCurAlpha = strNextAlpha;
            }
            
            objAttendee.strAttendeeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAttendee.strRegistrantID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAttendee.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAttendee.strMiddle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAttendee.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAttendee.strAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAttendee.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objAttendee.strDesignation = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objAttendee.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objAttendee.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objAttendee.strPUID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objAttendee.strPhotoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objAttendee.strBIO = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objAttendee.strPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objAttendee.strIsNotificationEnabled = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objAttendee.strIsEmailVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objAttendee.strIsPhoneNumberVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objAttendee.strIsNameVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objAttendee.strIsDesignationVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objAttendee.strIsCompanyVisible   = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objAttendee.strAllowInAppMessaging = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            objAttendee.strAllowSendMeetingInvite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 21)];
            objAttendee.strIsBiovisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 22)];
            objAttendee.strIsPhotoVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 23)];
            
			[arrAttendees addObject:objAttendee];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(![strCurAlpha isEqualToString:@""] && [arrTempAttendees count] > 0)
    {
        [arrAlhaAttendees addObject:strCurAlpha];
        [arrAlhaAttendees addObject:[arrTempAttendees copy]];
        
        [arrTempAttendees removeAllObjects];
        
        [arrAttendees addObject:[arrAlhaAttendees copy]];
        [arrAlhaAttendees removeAllObjects];
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAttendees;
}

- (BOOL)CheckAvailableAttendeeNotes:(NSString*)strAttendeeEmail
{
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select * from AttendeeNotes where AttendeeEmail = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt,1, [strAttendeeEmail UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            return TRUE;
        }
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return FALSE;
}

- (BOOL)SetAttendees:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
     
        NSArray *arrAttendees = [dictData valueForKey:@"AttendeeList"];
        NSUInteger intEntriesM = [arrAttendees count];
        
        if(intEntriesM > 0)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            NSMutableDictionary *dictAttendee;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictAttendee = [[NSMutableDictionary alloc] init];
                
                //dictAttendee = [[arrAttendees objectAtIndex:i] valueForKey:@"AttendeeDetails"];
                dictAttendee = [arrAttendees objectAtIndex:i];
                
                objAttendee.strAttendeeID = [dictAttendee valueForKey:@"AttendeeID"];
                
                if([Functions ReplaceNUllWithZero:objAttendee.strAttendeeID]!=0)
                {
                    objAttendee.strRegistrantID = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"RegistrantId"]];
                    objAttendee.strFirstName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"FirstName"]];
                    objAttendee.strMiddle = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Middle"]];
                    objAttendee.strLastName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"LastName"]];
                    objAttendee.strAttendeeName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"AttendeeName"]];
                    objAttendee.strCompany = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Company"]];
                    objAttendee.strDesignation = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Designation"]];
                    objAttendee.strExhibitorName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"ExhibitorName"]];
                    objAttendee.strEmail = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Email"]];
                    objAttendee.strPUID = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"PUID"]];
                    objAttendee.strPhotoURL = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"PhotoURL"]];
                    objAttendee.strBIO = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"BIO"]];
                    objAttendee.strPhone = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Phone"]];
                    objAttendee.strIsNotificationEnabled = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsNotificationEnabled"]];
                    objAttendee.strIsEmailVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsEmailVisible"]];
                    objAttendee.strIsPhoneNumberVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsPhoneNumberVisible"]];
                    objAttendee.strIsNameVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsNameVisible"]];
                    objAttendee.strIsDesignationVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsDesignationVisible"]];
                    objAttendee.strIsCompanyVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsCompanyVisible"]];
                    objAttendee.strAllowInAppMessaging = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"AllowInAppMessaging"]];
                    objAttendee.strAllowSendMeetingInvite = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"AllowSendMeetingInvite"]];
                    objAttendee.strIsBiovisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsBioVisible"]];
                    objAttendee.strIsPhotoVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsPhotoVisible"]];
                    
                    NSString *strSQL = @"Select AttendeeID From Attendees Where AttendeeID = ?";
                    
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendee.strAttendeeID intValue] Query:strSQL] == NO)
                    {
                        blnResult = [self AddAttendee:objAttendee];
                    }
                    else
                    {
                        blnResult = [self UpdateAttendee:objAttendee];
                    }
                }
            }
        }
        
        if(blnResult == YES)
        {
            DB *objDB = [DB GetInstance];
            [objDB UpdateScreenWithVersion:strSCREEN_ATTENDEE Version:intVersion];
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}

- (BOOL)SetFavAttendees:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        //int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrAttendees = [dictData valueForKey:@"FavouriteAttendeeList"];
        NSUInteger intEntriesM = [arrAttendees count];
        
        if(intEntriesM > 0)
        {
            [self DeleteFavAttendee:0];
            
            Attendee *objAttendee = [[Attendee alloc] init];
            NSMutableDictionary *dictAttendee;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictAttendee = [[NSMutableDictionary alloc] init];
                
                //dictAttendee = [[arrAttendees objectAtIndex:i] valueForKey:@"AttendeeDetails"];
                dictAttendee = [arrAttendees objectAtIndex:i];
                
                objAttendee.strAttendeeID = [dictAttendee valueForKey:@"AttendeeID"];
                
                if([Functions ReplaceNUllWithZero:objAttendee.strAttendeeID]!=0)
                {
                    objAttendee.strRegistrantID = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"RegistrantId"]];
                    objAttendee.strFirstName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"FirstName"]];
                    objAttendee.strMiddle = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Middle"]];
                    objAttendee.strLastName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"LastName"]];
                    objAttendee.strAttendeeName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"AttendeeName"]];
                    objAttendee.strCompany = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Company"]];
                    objAttendee.strDesignation = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Designation"]];
                    objAttendee.strExhibitorName = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"ExhibitorName"]];
                    objAttendee.strEmail = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Email"]];
                    objAttendee.strPUID = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"PUID"]];
                    objAttendee.strPhotoURL = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"PhotoURL"]];
                    objAttendee.strBIO = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"BIO"]];
                    objAttendee.strPhone = [Functions ReplaceNUllWithBlank:[dictAttendee valueForKey:@"Phone"]];
                    objAttendee.strIsNotificationEnabled = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsNotificationEnabled"]];
                    objAttendee.strIsEmailVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsEmailVisible"]];
                    objAttendee.strIsPhoneNumberVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsPhoneNumberVisible"]];
                    objAttendee.strIsNameVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsNameVisible"]];
                    objAttendee.strIsDesignationVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsDesignationVisible"]];
                    objAttendee.strIsCompanyVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsCompanyVisible"]];
                    objAttendee.strAllowInAppMessaging = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"AllowInAppMessaging"]];
                    objAttendee.strAllowSendMeetingInvite = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"AllowSendMeetingInvite"]];
                    objAttendee.strIsBiovisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsBioVisible"]];
                    objAttendee.strIsPhotoVisible = [Functions ReplaceNUllWithZero:[dictAttendee valueForKey:@"IsPhotoVisible"]];
                    objAttendee.strIsSynced = @"0";
                    
//                    NSString *strSQL = @"Select AttendeeID From Attendees Where AttendeeID = ?";
//                    
//                    DB *objDB = [DB GetInstance];
//                    if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendee.strAttendeeID intValue] Query:strSQL] == NO)
//                    {
                        blnResult = [self AddFavAttendee:objAttendee];
//                    }
//                    else
//                    {
//                        blnResult = [self UpdateAttendee:objAttendee];
//                    }
                }
            }
        }
        

    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}

#pragma mark -

#pragma mark Instance Methods (Attendee Exhibitors)
- (BOOL)SetAttendeeExhibitors:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    if(error==nil)
    {
        int intVersion = [[Functions ReplaceNUllWithZero:[dictData valueForKey:strKEY_VERSION_NO]] intValue];
        
        NSArray *arrAttendeeExhibitor = [dictData valueForKey:@"ExhibitorList"];
        NSUInteger intEntriesM = [arrAttendeeExhibitor count];
        
        if(intEntriesM > 0)
        {
            [self DeleteExhibitor:@""];
            
            AttendeeExhibitor *objAttendeeExhibitor = [[AttendeeExhibitor alloc] init];
            NSMutableDictionary *dictAttendeeExhibitor;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictAttendeeExhibitor = [[NSMutableDictionary alloc] init];
                
                dictAttendeeExhibitor = [[arrAttendeeExhibitor objectAtIndex:i] valueForKey:@"ExhibitorDetails"];
                
                objAttendeeExhibitor.strExhibitorID = [dictAttendeeExhibitor valueForKey:@"ExhibitorId"];
                
                if([Functions ReplaceNUllWithZero:objAttendeeExhibitor.strExhibitorID] != 0)
                {
                    NSString *strSQL = @"Select ExhibitorID From AttendeeExhibitors Where ExhibitorID = ?";
                    
                    DB *objDB = [DB GetInstance];
                    if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendeeExhibitor.strExhibitorID intValue] Query:strSQL] == NO)
                    {
                        blnResult = [self AddMyExhibitor:objAttendeeExhibitor isSynced:1];
                    }
                    else
                    {
                        blnResult = YES;
                    }
                }
            }
        }
        
        if(blnResult == YES)
        {
            DB *objDB = [DB GetInstance];
            [objDB UpdateScreenWithVersion:strSCREEN_ATTENDEE_EXHIBITOR Version:intVersion];
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return blnResult;
}

- (BOOL)AddExhibitor:(NSString *)strExhibitorID
{
    BOOL blnResult = NO;
    
    AttendeeExhibitor *objAttendeeExhibitor = [[AttendeeExhibitor alloc] init];
    
    objAttendeeExhibitor.strExhibitorID = strExhibitorID;
    
    if([Functions ReplaceNUllWithZero:objAttendeeExhibitor.strExhibitorID] != 0)
    {
        NSString *strSQL = @"Select ExhibitorID From AttendeeExhibitors Where ExhibitorID = ?";
        
        DB *objDB = [DB GetInstance];
        if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendeeExhibitor.strExhibitorID intValue] Query:strSQL] == NO)
        {
            blnResult = [self AddMyExhibitor:objAttendeeExhibitor isSynced:0];
        }
        else
        {
            NSString *strSQL = @"Select ExhibitorID From AttendeeExhibitors Where ExhibitorID = ? and IsSynced =1";
            
            DB *objDB = [DB GetInstance];
            if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendeeExhibitor.strExhibitorID intValue] Query:strSQL] == NO)
            {
                blnResult = [self DeleteMyExhibitor:[objAttendeeExhibitor.strExhibitorID intValue]];
            }
            else
            {
                blnResult = [self UpdateMyExhibitor:objAttendeeExhibitor];
            }
        }
    }
    
    return blnResult;
}

- (BOOL)AddExhibitorWithExhibitorObj:(Exhibitor *)objExhibitor
{
    BOOL blnResult = NO;
    
    AttendeeExhibitor *objAttendeeExhibitor = [[AttendeeExhibitor alloc] init];
    
    objAttendeeExhibitor.strExhibitorID = objExhibitor.strExhibitorID;
    objAttendeeExhibitor.strExhibitorCode = objExhibitor.strExhibitorCode;
    
    if([Functions ReplaceNUllWithZero:objExhibitor.strExhibitorID] != 0)
    {
        NSString *strSQL = @"Select ExhibitorID From AttendeeExhibitors Where ExhibitorID = ?";
        
        DB *objDB = [DB GetInstance];
        if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendeeExhibitor.strExhibitorID intValue] Query:strSQL] == NO)
        {
            blnResult = [self AddMyExhibitor:objAttendeeExhibitor isSynced:0];
        }
        else
        {
            NSString *strSQL = @"Select ExhibitorID From AttendeeExhibitors Where ExhibitorID = ? and IsSynced =1";
            
            DB *objDB = [DB GetInstance];
            if([objDB CheckIfRecordAvailableWithIntKeyWithQuery:[objAttendeeExhibitor.strExhibitorID intValue] Query:strSQL] == NO)
            {
                blnResult = [self DeleteMyExhibitor:[objAttendeeExhibitor.strExhibitorID intValue]];
            }
            else
            {
                blnResult = [self UpdateMyExhibitor:objAttendeeExhibitor];
            }
        }
    }
    
    return blnResult;
}


- (BOOL)DeleteExhibitor:(NSString *)strExhibitorID
{
    return [self DeleteMyExhibitor:[strExhibitorID intValue]];
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)AddAttendee:(Attendee*)objAttendee
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Attendees(AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendee.strAttendeeID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objAttendee.strRegistrantID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objAttendee.strFirstName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAttendee.strMiddle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAttendee.strLastName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAttendee.strAttendeeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objAttendee.strCompany UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objAttendee.strDesignation UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objAttendee.strExhibitorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objAttendee.strEmail UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 11, [objAttendee.strPUID intValue]);
        sqlite3_bind_text(compiledStmt, 12, [objAttendee.strPhotoURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objAttendee.strBIO UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objAttendee.strPhone UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 15, [objAttendee.strIsNotificationEnabled boolValue]);
        sqlite3_bind_int(compiledStmt, 16, [objAttendee.strIsEmailVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 17, [objAttendee.strIsPhoneNumberVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 18, [objAttendee.strIsNameVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 19, [objAttendee.strIsDesignationVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 20, [objAttendee.strIsCompanyVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 21, [objAttendee.strAllowInAppMessaging boolValue]);
        sqlite3_bind_int(compiledStmt, 22, [objAttendee.strAllowSendMeetingInvite boolValue]);
        sqlite3_bind_int(compiledStmt, 23, [objAttendee.strIsBiovisible boolValue]);
        sqlite3_bind_int(compiledStmt, 24, [objAttendee.strIsPhotoVisible boolValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddFavAttendee:(Attendee*)objAttendee
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into FavouriteAttendees(AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible,IsSynced,IsDeleted) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,0)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendee.strAttendeeID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objAttendee.strRegistrantID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objAttendee.strFirstName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAttendee.strMiddle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAttendee.strLastName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAttendee.strAttendeeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objAttendee.strCompany UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objAttendee.strDesignation UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objAttendee.strExhibitorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objAttendee.strEmail UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 11, [objAttendee.strPUID intValue]);
        sqlite3_bind_text(compiledStmt, 12, [objAttendee.strPhotoURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objAttendee.strBIO UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objAttendee.strPhone UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 15, [objAttendee.strIsNotificationEnabled boolValue]);
        sqlite3_bind_int(compiledStmt, 16, [objAttendee.strIsEmailVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 17, [objAttendee.strIsPhoneNumberVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 18, [objAttendee.strIsNameVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 19, [objAttendee.strIsDesignationVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 20, [objAttendee.strIsCompanyVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 21, [objAttendee.strAllowInAppMessaging boolValue]);
        sqlite3_bind_int(compiledStmt, 22, [objAttendee.strAllowSendMeetingInvite boolValue]);
        sqlite3_bind_int(compiledStmt, 23, [objAttendee.strIsBiovisible boolValue]);
        sqlite3_bind_int(compiledStmt, 24, [objAttendee.strIsPhotoVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 25, [objAttendee.strIsSynced boolValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateFavAttendee:(Attendee*)objAttendee
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update FavouriteAttendee Set ";
    strSQL = [strSQL stringByAppendingString:@"IsDeleted = 1 , IsSynced = 0"];
    strSQL = [strSQL stringByAppendingFormat:@"Where AttendeeID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendee.strAttendeeID intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}


- (BOOL)UpdateAttendee:(Attendee*)objAttendee
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Attendees Set ";
    strSQL = [strSQL stringByAppendingFormat:@"RegistrantID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"FirstName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Middle = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LastName = ?, "];    
    strSQL = [strSQL stringByAppendingFormat:@"AttendeeName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Company = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ExhibitorName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PUID = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PhotoURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BIO = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsNotificationEnabled = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsEmailvisible = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsPhoneNumberVisible = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsNameVisible = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsDesignationVisible = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsCompanyVisible = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"AllowInAppMessaging = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"AllowSendMeetingInvite = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsBiovisible = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsPhotoVisible = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where AttendeeID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendee.strRegistrantID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objAttendee.strFirstName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objAttendee.strMiddle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objAttendee.strLastName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objAttendee.strAttendeeName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objAttendee.strCompany UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objAttendee.strDesignation UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objAttendee.strExhibitorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objAttendee.strEmail UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 10, [objAttendee.strPUID intValue]);
        sqlite3_bind_text(compiledStmt, 11, [objAttendee.strPhotoURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objAttendee.strBIO UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objAttendee.strPhone UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 14, [objAttendee.strIsNotificationEnabled boolValue]);
        sqlite3_bind_int(compiledStmt, 15, [objAttendee.strIsEmailVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 16, [objAttendee.strIsPhoneNumberVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 17, [objAttendee.strIsNameVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 18, [objAttendee.strIsDesignationVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 19, [objAttendee.strIsCompanyVisible boolValue]);
        sqlite3_bind_int(compiledStmt, 20, [objAttendee.strAllowInAppMessaging boolValue]);
        sqlite3_bind_int(compiledStmt, 21, [objAttendee.strAllowSendMeetingInvite boolValue]);
        sqlite3_bind_int(compiledStmt, 22, [objAttendee.strIsBiovisible boolValue]);
        sqlite3_bind_int(compiledStmt, 23, [objAttendee.strIsPhotoVisible boolValue]);
        
        sqlite3_bind_int(compiledStmt, 24, [objAttendee.strAttendeeID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

// Added By Nikhil
- (BOOL)AddMyExhibitor:(AttendeeExhibitor*)objAttendeeExhibitor isSynced:(BOOL)isSynced
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into AttendeeExhibitors(ExhibitorID, IsDeleted, IsSynced, ExhibitorCode) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, 0, ?,?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendeeExhibitor.strExhibitorID intValue]);
        sqlite3_bind_int(compiledStmt, 2, isSynced);
        sqlite3_bind_text(compiledStmt, 3, [objAttendeeExhibitor.strExhibitorCode UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
    
}

- (BOOL)AddMyExhibitor:(AttendeeExhibitor*)objAttendeeExhibitor
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into AttendeeExhibitors(ExhibitorID, IsDeleted) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, 0)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendeeExhibitor.strExhibitorID intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateMyExhibitor:(AttendeeExhibitor*)objAttendeeExhibitor
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update AttendeeExhibitors Set ";
    strSQL = [strSQL stringByAppendingString:@"IsDeleted = 1 , IsSynced = 0"];
    strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objAttendeeExhibitor.strExhibitorID intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteMyExhibitor:(int)intExhibitorID
{
    BOOL blnResult = NO;
    
    if(intExhibitorID != 0)
    {
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        
        NSString *strSQL = @"Delete From AttendeeExhibitors ";
        
        if(intExhibitorID)
        {
            strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorID = ? "];
        }
        
        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
        }
        else
        {
            sqlite3_bind_int(compiledStmt, 1, intExhibitorID);
            
            if( SQLITE_DONE != sqlite3_step(compiledStmt) )
            {
                NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
                [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
                
                blnResult = NO;
            }
            else
            {
                blnResult = YES;
            }
        }
    }
    
    return blnResult;
}

- (BOOL)DeleteFavAttendee:(int)intAttendeeID
{
    BOOL blnResult = NO;
    
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        
        NSString *strSQL = @"Delete From FavouriteAttendees ";
        
        if(intAttendeeID != 0)
        {
            strSQL = [strSQL stringByAppendingFormat:@"Where AttendeeID = ? "];
        }
        
        if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
        }
        else
        {
            sqlite3_bind_int(compiledStmt, 1, intAttendeeID);
            
            if( SQLITE_DONE != sqlite3_step(compiledStmt) )
            {
                NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
                [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
                
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

#pragma mark Find Like Minded Filters
- (NSArray*)GetAttendeesCategoryOfFilterType:(NSString*)strFilterType
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFilters = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = [NSString stringWithFormat:@"SELECT ParentFilter,FilterName FROM FindlIkeMindedFilter where FilterType = '%@'",strFilterType];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String ], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        Filters *objFilters = [[Filters alloc] init];
        
        objFilters.strCategoryID = @"";
        objFilters.strCategory = @"All";
        
        [arrFilters addObject:objFilters];
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            
            
            Filters *objFilters = [[Filters alloc] init];
            
            objFilters.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objFilters.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            
			[arrFilters addObject:objFilters];
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
    
	return arrFilters;
}

- (NSArray*)GetFilteredFindLikeMindedwithCategory1:(id)strCategory1 Category2:(id)strCategory2 Category3:(id)strCategory3 Category4:(id)strCategory4
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendees = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrTempAttendees = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From Attendees Where 1 = 1";
    
    if(![strCategory1 isEqual:[NSNull null]] && ![NSString IsEmpty:strCategory1 shouldCleanWhiteSpace:YES] && ![strCategory1 isEqualToString:@"All"])
    {
        strSQL = [strSQL stringByAppendingString:[NSString stringWithFormat:@" AND Company = '%@'",strCategory1]];
    }
    if(![strCategory2 isEqual:[NSNull null]] && ![NSString IsEmpty:strCategory2 shouldCleanWhiteSpace:YES] && ![strCategory2 isEqualToString:@"All"])
    {
        strSQL = [strSQL stringByAppendingString:[NSString stringWithFormat:@" AND Company = '%@'",strCategory2]];
    }
    if(![strCategory3 isEqual:[NSNull null]] && ![NSString IsEmpty:strCategory3 shouldCleanWhiteSpace:YES] && ![strCategory3 isEqualToString:@"All"])
    {
        strSQL = [strSQL stringByAppendingString:[NSString stringWithFormat:@" AND Company = '%@'",strCategory3]];
    }
    if(![strCategory4 isEqual:[NSNull null]] && ![NSString IsEmpty:strCategory4 shouldCleanWhiteSpace:YES] && ![strCategory4 isEqualToString:@"All"])
    {
        strSQL = [strSQL stringByAppendingString:[NSString stringWithFormat:@" AND Company = '%@'",strCategory4]];
    }
    
    strSQL = [strSQL stringByAppendingString:@" Order By Upper(FirstName), Upper(LastName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            
            objAttendee.strAttendeeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAttendee.strRegistrantID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAttendee.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAttendee.strMiddle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAttendee.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAttendee.strAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAttendee.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objAttendee.strDesignation = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objAttendee.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objAttendee.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objAttendee.strPUID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objAttendee.strPhotoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objAttendee.strBIO = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objAttendee.strPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objAttendee.strIsNotificationEnabled = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objAttendee.strIsEmailVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objAttendee.strIsPhoneNumberVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objAttendee.strIsNameVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objAttendee.strIsDesignationVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objAttendee.strIsCompanyVisible   = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objAttendee.strAllowInAppMessaging = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            objAttendee.strAllowSendMeetingInvite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 21)];
            objAttendee.strIsBiovisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 22)];
            objAttendee.strIsPhotoVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 23)];
            
            [arrTempAttendees addObject: objAttendee];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    
    arrAttendees = arrTempAttendees;
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAttendees;
}


- (NSString*)GetFavAttendeesJSON
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFavAttendee = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select Email, IsDeleted From FavouriteAttendees where IsSynced = 0";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSMutableDictionary *dictFavAttendee = [[NSMutableDictionary alloc] init];
            
            [dictFavAttendee setObject:[Functions GetGUID] forKey:@"Id"];
            [dictFavAttendee setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] forKey:@"FavouriteAttendeeEmail"];
            [dictFavAttendee setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] boolValue]] forKey:@"IsDelete"];
            
			[arrFavAttendee addObject: dictFavAttendee];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
    NSString *strFavAttendee = [arrFavAttendee JSONRepresentation];
    
	return strFavAttendee;
}

- (NSArray*)GetFavouriteAttendee
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendees = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrTempAttendees = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select AttendeeID, RegistrantID, FirstName, Middle, LastName, AttendeeName, Company, Designation, ExhibitorName, Email, PUID, PhotoURL, BIO, Phone, IsNotificationEnabled, IsEmailvisible, IsPhoneNumberVisible, IsNameVisible, IsDesignationVisible, IsCompanyVisible, AllowInAppMessaging, AllowSendMeetingInvite, IsBiovisible, IsPhotoVisible, Case When Length(FirstName)=0 Then substr(Upper(LastName), 1, 1) Else Substr(Upper(FirstName), 1, 1) End As Alpha From FavouriteAttendees Where IsDeleted = 0";
    
    
    strSQL = [strSQL stringByAppendingString:@" Order By Upper(FirstName), Upper(LastName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Attendee *objAttendee = [[Attendee alloc] init];
            
            objAttendee.strAttendeeID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objAttendee.strRegistrantID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objAttendee.strFirstName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objAttendee.strMiddle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objAttendee.strLastName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objAttendee.strAttendeeName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objAttendee.strCompany = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objAttendee.strDesignation = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objAttendee.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objAttendee.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objAttendee.strPUID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objAttendee.strPhotoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objAttendee.strBIO = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objAttendee.strPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objAttendee.strIsNotificationEnabled = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objAttendee.strIsEmailVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objAttendee.strIsPhoneNumberVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objAttendee.strIsNameVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objAttendee.strIsDesignationVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objAttendee.strIsCompanyVisible   = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            objAttendee.strAllowInAppMessaging = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            objAttendee.strAllowSendMeetingInvite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 21)];
            objAttendee.strIsBiovisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 22)];
            objAttendee.strIsPhotoVisible = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 23)];
            
            [arrTempAttendees addObject: objAttendee];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    
    arrAttendees = arrTempAttendees;
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAttendees;
}

@end
