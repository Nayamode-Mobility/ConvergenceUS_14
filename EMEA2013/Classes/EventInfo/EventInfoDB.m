//
//  EventInfoDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "EventInfoDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "NSString+Custom.h"


@implementation EventInfoDB
static EventInfoDB *objEventInfoDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objEventInfoDB == nil)
    {
        objEventInfoDB = [[self alloc] init];
    }
    
    return objEventInfoDB;
}

- (id)init
{
    return self;
}

- (void)dealloc
{
}
#pragma mark -

#pragma mark Instance Methods (Lost & Found)
- (NSArray*)GetLostNFound
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrLostNFound = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ID, Title, Image1, Image2, Image3, Description, Phone1, Phone2, Phone3, Email1, Email2, Email3, Website, Address From LostNFound Order By ID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            LostNFound *objLostNFound = [[LostNFound alloc] init];
            
            objLostNFound.strID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objLostNFound.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objLostNFound.strImage1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objLostNFound.strImage2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objLostNFound.strImage3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objLostNFound.strDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objLostNFound.strPhone1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objLostNFound.strPhone2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objLostNFound.strPhone3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objLostNFound.strEmail1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objLostNFound.strEmail2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objLostNFound.strEmail3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objLostNFound.strWebsite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objLostNFound.strAddress = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrLostNFound addObject:objLostNFound];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrLostNFound;
}

- (NSArray*)GetLostNFoundWithID:(id)strID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrLostNFound = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ID, Title, Image1, Image2, Image3, Description, Phone1, Phone2, Phone3, Email1, Email2, Email3, Website, Address From LostNFound Where ID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            LostNFound *objLostNFound = [[LostNFound alloc] init];
            
            objLostNFound.strID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objLostNFound.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objLostNFound.strImage1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objLostNFound.strImage2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objLostNFound.strImage3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objLostNFound.strDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objLostNFound.strPhone1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objLostNFound.strPhone2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objLostNFound.strPhone3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objLostNFound.strEmail1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objLostNFound.strEmail2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objLostNFound.strEmail3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objLostNFound.strWebsite = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objLostNFound.strAddress = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrLostNFound addObject:objLostNFound];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrLostNFound;
}

- (NSArray*)SetLostNFound:(NSData*)objData;
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"LostAndFoundList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"LostAndFoundList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];

        //NSArray *arrLostNFound = [dictData valueForKey:@"LostAndFoundList"];
        //arrLostNFound = [[arrLostNFound objectAtIndex:0] valueForKey:@"Details"];
        NSArray *arrLostNFound = [dictData valueForKey:@"Details"];        
        NSUInteger intEntriesM = [arrLostNFound count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteLostNFound];
            [arrQuery addObject:@"Delete From LostNFound"];
            
            LostNFound *objLostNFound = [[LostNFound alloc] init];
            NSMutableDictionary *dictLostNFound;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictLostNFound = [[NSMutableDictionary alloc] init];
                
                //dictLostNFound = [[arrLostNFound objectAtIndex:i] valueForKey:@"Details"];
                dictLostNFound = [arrLostNFound objectAtIndex:i];
                
                objLostNFound.strID = [dictLostNFound valueForKey:@"Id"];
                
                if([Functions ReplaceNUllWithZero:objLostNFound.strID] != 0)
                {
//                    objLostNFound.strTitle = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Title"]];
//                    objLostNFound.strImage1 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Image1"]];
//                    objLostNFound.strImage2 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Image2"]];
//                    objLostNFound.strImage3 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Image3"]];
//                    objLostNFound.strDescription = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Description"]];
//                    objLostNFound.strPhone1 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Phone1"]];
//                    objLostNFound.strPhone2 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Phone2"]];
//                    objLostNFound.strPhone3 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Phone3"]];
//                    objLostNFound.strEmail1 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Email1"]];
//                    objLostNFound.strEmail2 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Email2"]];
//                    objLostNFound.strEmail3 = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Email3"]];
//                    objLostNFound.strWebsite = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"WebSite"]];
//                    objLostNFound.strAddress = [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Address"]];
//                    objLostNFound.strIsOverview = [Functions ReplaceNUllWithZero:[dictLostNFound valueForKey:@"IsOverView"]];
//                    
//                        blnResult = [self AddLostNFound:objLostNFound];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into LostNFound(ID, Title, Image1, Image2, Image3, Description, Phone1, Phone2, Phone3, Email1, Email2, Email3, Website, Address, IsOverView) Values(%@, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %@)",
                    [dictLostNFound valueForKey:@"Id"],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Title"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Image1"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Image2"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Image3"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Description"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Phone1"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Phone2"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Phone3"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Email1"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Email2"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Email3"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"WebSite"]],
                    [Functions ReplaceNUllWithBlank:[dictLostNFound valueForKey:@"Address"]],
                    [Functions ReplaceNUllWithZero:[dictLostNFound valueForKey:@"IsOverView"]]];
                    
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_LOST_FOUND Version:intVersion];
//        }
        
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_LOST_FOUND]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (Emergency Hospitals)
- (NSArray*)GetEmergencyHospitals
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrHospitals = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3 From EmergencyHospitals Order By ID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EmergencyHospitals *objHospitals = [[EmergencyHospitals alloc] init];
            
            objHospitals.strID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objHospitals.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objHospitals.strBriefDescription1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objHospitals.strBriefDescription2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objHospitals.strBriefDescription3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objHospitals.strWebsite1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objHospitals.strWebsite2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objHospitals.strWebsite3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objHospitals.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objHospitals.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objHospitals.strAddress3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objHospitals.strPhone1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objHospitals.strPhone2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objHospitals.strPhone3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrHospitals addObject:objHospitals];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrHospitals;
}

- (NSArray*)GetEmergencyHospitalsWithID:(id)strID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrHospitals = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3 From EmergencyHospitals Where ID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EmergencyHospitals *objHospitals = [[EmergencyHospitals alloc] init];
            
            objHospitals.strID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objHospitals.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objHospitals.strBriefDescription1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objHospitals.strBriefDescription2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objHospitals.strBriefDescription3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objHospitals.strWebsite1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objHospitals.strWebsite2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objHospitals.strWebsite3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objHospitals.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objHospitals.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objHospitals.strAddress3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objHospitals.strPhone1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objHospitals.strPhone2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objHospitals.strPhone3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrHospitals addObject:objHospitals];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrHospitals;
}

- (NSArray*)SetEmergencyHospitals:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"EmergencyList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"EmergencyList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrHospitals = [dictData valueForKey:@"HospitalList"];
        NSUInteger intEntriesM = [arrHospitals count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteEmergencyHospitals];
            [arrQuery addObject: @"Delete From EmergencyHospitals"];
            
            EmergencyHospitals *objHospitals = [[EmergencyHospitals alloc] init];
            NSMutableDictionary *dictHospitals;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictHospitals = [[NSMutableDictionary alloc] init];
                
                //dictHospitals = [[arrHospitals objectAtIndex:i] valueForKey:@"Details"];
                dictHospitals = [arrHospitals objectAtIndex:i];
                
                objHospitals.strID = [dictHospitals valueForKey:@"Id"];
                
                if([Functions ReplaceNUllWithZero:objHospitals.strID] != 0)
                {
//                    objHospitals.strTitle = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Title"]];
//                    objHospitals.strBriefDescription1 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"BriefDescription1"]];
//                    objHospitals.strBriefDescription2 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"BriefDescription2"]];
//                    objHospitals.strBriefDescription3 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"BriefDescription3"]];
//                    objHospitals.strWebsite1 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"WebSite1"]];
//                    objHospitals.strWebsite2 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"WebSite2"]];
//                    objHospitals.strWebsite3 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"WebSIte3"]];
//                    objHospitals.strAddress1 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Address1"]];
//                    objHospitals.strAddress2 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Address2"]];
//                    objHospitals.strAddress3 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Address3"]];
//                    objHospitals.strPhone1 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Phone1"]];
//                    objHospitals.strPhone2 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Phone2"]];
//                    objHospitals.strPhone3 = [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Phone3"]];
//                    
//                        blnResult = [self AddEmergencyHospitals:objHospitals];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into EmergencyHospitals(ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3) Values(%i, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                    [[dictHospitals valueForKey:@"Id"]intValue],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Title"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"BriefDescription1"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"BriefDescription2"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"BriefDescription3"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"WebSite1"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"WebSite2"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"WebSIte3"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Address1"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Address2"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Address3"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Phone1"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Phone2"]],
                    [Functions ReplaceNUllWithBlank:[dictHospitals valueForKey:@"Phone3"]]];
                    
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_EMERGENCY Version:intVersion];
//        }
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_EMERGENCY]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (Emergency Overview)
- (NSArray*)GetEmergencyOverview
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrOverview = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3 From EmergencyOverview Order By ID Limit 1";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EmergencyOverview *objEmergencyOverview = [[EmergencyOverview alloc] init];
            
            objEmergencyOverview.strID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEmergencyOverview.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEmergencyOverview.strBriefDescription1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEmergencyOverview.strBriefDescription2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objEmergencyOverview.strBriefDescription3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objEmergencyOverview.strWebsite1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objEmergencyOverview.strWebsite2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objEmergencyOverview.strWebsite3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objEmergencyOverview.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objEmergencyOverview.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objEmergencyOverview.strAddress3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objEmergencyOverview.strPhone1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objEmergencyOverview.strPhone2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objEmergencyOverview.strPhone3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrOverview addObject:objEmergencyOverview];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrOverview;
}

- (NSArray*)GetEmergencyOverviewWithID:(id)strID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrOverview = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3 From EmergencyOverview Where ID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EmergencyOverview *objEmergencyOverview = [[EmergencyOverview alloc] init];
            
            objEmergencyOverview.strID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEmergencyOverview.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEmergencyOverview.strBriefDescription1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objEmergencyOverview.strBriefDescription2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objEmergencyOverview.strBriefDescription3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objEmergencyOverview.strWebsite1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objEmergencyOverview.strWebsite2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objEmergencyOverview.strWebsite3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objEmergencyOverview.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objEmergencyOverview.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objEmergencyOverview.strAddress3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objEmergencyOverview.strPhone1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objEmergencyOverview.strPhone2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objEmergencyOverview.strPhone3 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            
			[arrOverview addObject:objEmergencyOverview];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrOverview;
}

- (NSArray *)SetEmergencyOverview:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"EmergencyList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"EmergencyList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrOverview = [dictData valueForKey:@"OverviewList"];
        NSUInteger intEntriesM = [arrOverview count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteEmergencyOverview];
            [arrQuery addObject:@"Delete From EmergencyOverview"];
            
            EmergencyOverview *objOverview = [[EmergencyOverview alloc] init];
            NSMutableDictionary *dictOverview;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictOverview = [[NSMutableDictionary alloc] init];
                
                //dictOverview = [[arrOverview objectAtIndex:i] valueForKey:@"Details"];
                dictOverview = [arrOverview objectAtIndex:i];
                
                objOverview.strID = [dictOverview valueForKey:@"Id"];
                
                //if([Functions ReplaceNUllWithZero:objOverview.strID] != 0)
                //{
//                    objOverview.strTitle = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Title"]];
//                    objOverview.strBriefDescription1 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"BriefDescription1"]];
//                    objOverview.strBriefDescription2 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"BriefDescription2"]];
//                    objOverview.strBriefDescription3 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"BriefDescription2"]];
//                    objOverview.strWebsite1 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"WebSite1"]];
//                    objOverview.strWebsite2 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"WebSite2"]];
//                    objOverview.strWebsite3 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"WebSIte3"]];
//                    objOverview.strAddress1 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Address1"]];
//                    objOverview.strAddress2 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Address2"]];
//                    objOverview.strAddress3 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Address3"]];
//                    objOverview.strPhone1 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Phone1"]];
//                    objOverview.strPhone2 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Phone2"]];
//                    objOverview.strPhone3 = [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Phone3"]];
//                    
//                        blnResult = [self AddEmergencyOverview:objOverview];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into EmergencyOverview(ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3) Values(%i, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                    [[dictOverview valueForKey:@"Id"]intValue],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Title"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"BriefDescription1"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"BriefDescription2"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"BriefDescription3"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"WebSite1"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"WebSite2"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"WebSIte3"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Address1"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Address2"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Address3"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Phone1"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Phone2"]],
                    [Functions ReplaceNUllWithBlank:[dictOverview valueForKey:@"Phone3"]]];
                    
                    [arrQuery addObject:strSQL];
                    
                    
//                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_EMERGENCY Version:intVersion];
//        }
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_EMERGENCY]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (Emergency Floorplans)
- (NSArray*)GetEmergencyFloorPlans
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFloorPlans = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select FloorPlanID, FloorPlanName, ImageURL From EmergencyFloorPlans Order By floorPlanID";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EmergencyFloorPlans *objEmergencyFloorPlans = [[EmergencyFloorPlans alloc] init];
            
            objEmergencyFloorPlans.strFloorPlanID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEmergencyFloorPlans.strFloorPlanName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEmergencyFloorPlans.strImageURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrFloorPlans addObject:objEmergencyFloorPlans];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFloorPlans;
}

- (NSArray*)GetEmergencyFloorPlansWithID:(id)strFloorPlanID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrFloorPlans = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select FloorPlanID, FloorPlanName, ImageURL From EmergencyFloorPlans Order By floorPlanID Where FloorPlanID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strFloorPlanID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            EmergencyFloorPlans *objEmergencyFloorPlans = [[EmergencyFloorPlans alloc] init];
            
            objEmergencyFloorPlans.strFloorPlanID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objEmergencyFloorPlans.strFloorPlanName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objEmergencyFloorPlans.strImageURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			[arrFloorPlans addObject:objEmergencyFloorPlans];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrFloorPlans;
}

- (NSArray*)SetEmergencyFloorPlans:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"EmergencyList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"EmergencyList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrFloorPlans = [dictData valueForKey:@"FloorPlanList"];
        NSUInteger intEntriesM = [arrFloorPlans count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteEmergencyFloorPlans];
            [arrQuery addObject:@"Delete From EmergencyFloorPlans"];
            
            EmergencyFloorPlans *objFloorPlans = [[EmergencyFloorPlans alloc] init];
            NSMutableDictionary *dictFloorPlans;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictFloorPlans = [[NSMutableDictionary alloc] init];
                
                //dictFloorPlans = [[arrFloorPlans objectAtIndex:i] valueForKey:@"Details"];
                dictFloorPlans = [arrFloorPlans objectAtIndex:i];
                
                objFloorPlans.strFloorPlanID = [dictFloorPlans valueForKey:@"FloorPlanID"];
                
                if([Functions ReplaceNUllWithZero:objFloorPlans.strFloorPlanID] != 0)
                {
//                    objFloorPlans.strFloorPlanName = [Functions ReplaceNUllWithBlank:[dictFloorPlans valueForKey:@"FloorPlanName"]];
//                    objFloorPlans.strImageURL = [Functions ReplaceNUllWithBlank:[dictFloorPlans valueForKey:@"ImageURL"]];
//                    
//                        blnResult = [self AddEmergencyFloorPlans:objFloorPlans];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into EmergencyFloorPlans(FloorPlanID, FloorPlanName, ImageURL) Values(%i, '%@', '%@')",
                                        [[dictFloorPlans valueForKey:@"FloorPlanID"]intValue],
                                        [Functions ReplaceNUllWithBlank:[dictFloorPlans valueForKey:@"FloorPlanName"]],
                                        [Functions ReplaceNUllWithBlank:[dictFloorPlans valueForKey:@"ImageURL"]]];
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_EMERGENCY Version:intVersion];
//        }
        
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_EMERGENCY]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Instance Methods (Onsite Service)
- (NSArray*)GetOnsiteService
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrOnsiteServices = [[NSMutableArray alloc] init];
    
    NSString *strCurCategory = @"";
    NSString *strNextCategory = @"";
    
    NSMutableArray *arrAlhaOnsiteServices  = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempOnsiteServices  = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL =[NSString stringWithFormat:@"Select * from EventInfoCategories where ParentCategoryId = (select CategoryId from EventInfoCategories where ShortCode = '%@')",strEVENT_INFO_CATEGORY_ONSITE_SERVICES];// "Select CategoryID, Category From EventInfoCategories Where ParentCategoryID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        //sqlite3_bind_int(compiledStmt, 1, intEVENT_INFO_CATEGORY_ONSITE_SERVICES);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            strNextCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            if(![strNextCategory isEqualToString:strCurCategory])
            {
                if(![strCurCategory isEqualToString:@""] && [arrTempOnsiteServices count] > 0)
                {
                    [arrAlhaOnsiteServices addObject:strCurCategory];
                    [arrAlhaOnsiteServices addObject:[arrTempOnsiteServices copy]];
                    
                    //[arrTempOnsiteServices removeAllObjects];
                    
                    [arrOnsiteServices addObject:[arrAlhaOnsiteServices copy]];
                    [arrAlhaOnsiteServices removeAllObjects];
                }
                
                strCurCategory = strNextCategory;
            }
            
            arrTempOnsiteServices = [NSArray arrayWithArray:[self GetOnsiteServiceDetails:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] intValue]]];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(![strCurCategory isEqualToString:@""] && [arrTempOnsiteServices count] > 0)
    {
        [arrAlhaOnsiteServices addObject:strCurCategory];
        [arrAlhaOnsiteServices addObject:[arrTempOnsiteServices copy]];
        
        //[arrTempOnsiteServices removeAllObjects];
        
        [arrOnsiteServices addObject:[arrAlhaOnsiteServices copy]];
        [arrAlhaOnsiteServices removeAllObjects];
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrOnsiteServices;
}

- (NSArray*)GetAttendeesMeals
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendeeMeals = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
  
    NSString *strSQL = @"Select EIC.CategoryID, EIC.Category, EIC.ParentCategoryID, OS.EventInfoDetailID, OS.Title, OS.BriefDescription, OS.DetailDescription From EventInfoCategories EIC Inner Join OnsiteService OS On EIC.CategoryID = OS.EventInfoCategoryID ";
    strSQL = [strSQL stringByAppendingString:@"Where EIC.ParentCategoryID = "];
    strSQL = [strSQL stringByAppendingFormat:@"%d ",intEVENT_INFO_CATEGORY_ATTENDEE_MEALS];
    strSQL = [strSQL stringByAppendingString:@"Order By EIC.CategoryID, OS.EventInfoDetailID"];
    
	sqlite3_stmt *compiledStmt;
	//int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            
            objOnsiteService.strCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objOnsiteService.strCategory = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objOnsiteService.strParentCategoryID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
            objOnsiteService.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objOnsiteService.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objOnsiteService.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objOnsiteService.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            
			[arrAttendeeMeals addObject:objOnsiteService];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MEALS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrAttendeeMeals;
}

- (NSArray*)GetSpecialtyMeals
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrSpecialtyMeals = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select OS.EventInfoDetailID, OS.Title, OS.BriefDescription, OS.DetailDescription From OnsiteService OS ";
    strSQL = [strSQL stringByAppendingString:@"Where OS.EventInfoCategoryID = "];
    strSQL = [strSQL stringByAppendingFormat:@"%d ",intEVENT_INFO_CATEGORY_SPEACIALTY_MEALS];
    strSQL = [strSQL stringByAppendingString:@"Order By OS.EventInfoDetailID"];
    
	sqlite3_stmt *compiledStmt;
	//int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            
            objOnsiteService.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objOnsiteService.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objOnsiteService.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objOnsiteService.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
			[arrSpecialtyMeals addObject:objOnsiteService];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_MEALS MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrSpecialtyMeals;
}

- (NSArray*)GetConferenceSecurity
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrConferenceSecurity = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select OS.EventInfoDetailID, OS.Title, OS.BriefDescription, OS.DetailDescription From OnsiteService OS ";
    strSQL = [strSQL stringByAppendingString:@"Where OS.EventInfoCategoryID = "];
    strSQL = [strSQL stringByAppendingFormat:@"%d ",intEVENT_INFO_CATEGORY_CONFERENCE_SECURITY];
    strSQL = [strSQL stringByAppendingString:@"Order By OS.EventInfoDetailID"];
    
	sqlite3_stmt *compiledStmt;
	//int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            
            objOnsiteService.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objOnsiteService.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objOnsiteService.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objOnsiteService.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
			[arrConferenceSecurity addObject:objOnsiteService];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrConferenceSecurity;
}

- (NSArray*)GetLuggage
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrLuggage = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select OS.EventInfoDetailID, OS.Title, OS.BriefDescription, OS.DetailDescription From OnsiteService OS ";
    strSQL = [strSQL stringByAppendingString:@"Where OS.EventInfoCategoryID = "];
    strSQL = [strSQL stringByAppendingFormat:@"%d ",intEVENT_INFO_CATEGORY_LUGGAGE];
    strSQL = [strSQL stringByAppendingString:@"Order By OS.EventInfoDetailID"];
    
	sqlite3_stmt *compiledStmt;
	//int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            
            objOnsiteService.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objOnsiteService.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objOnsiteService.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objOnsiteService.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
			[arrLuggage addObject:objOnsiteService];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrLuggage;
}

- (NSArray*)GetMSITTechLink
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrMSITTechLink = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    NSString *strSQL = @"Select OS.EventInfoDetailID, OS.Title, OS.BriefDescription, OS.DetailDescription From OnsiteService OS ";
    strSQL = [strSQL stringByAppendingString:@"Where OS.EventInfoCategoryID = "];
    strSQL = [strSQL stringByAppendingFormat:@"%d ",intEVENT_INFO_CATEGORY_MS_IT_TECH_LINKS];
    strSQL = [strSQL stringByAppendingString:@"Order By OS.EventInfoDetailID"];
    
	sqlite3_stmt *compiledStmt;
	//int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String] , -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            
            objOnsiteService.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objOnsiteService.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objOnsiteService.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objOnsiteService.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
			[arrMSITTechLink addObject:objOnsiteService];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];        
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrMSITTechLink;
}

- (NSArray*)SetOnsiteService:(NSData *)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"OnSiteServiceList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"OnSiteServiceList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrOnsiteService = [dictData valueForKey:@"Details"];
        NSUInteger intEntriesM = [arrOnsiteService count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteOnsiteService];
            [arrQuery addObject:@"Delete From OnsiteService"];
            
            
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            NSMutableDictionary *dictOnsiteServcie;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictOnsiteServcie = [[NSMutableDictionary alloc] init];
                
                //dictFloorPlans = [[arrOnsiteService objectAtIndex:i] valueForKey:@"Details"];
                dictOnsiteServcie = [arrOnsiteService objectAtIndex:i];
                
                objOnsiteService.strEventInfoDetailID = [dictOnsiteServcie valueForKey:@"EventInfoDetailId"];
                
                if([Functions ReplaceNUllWithZero:objOnsiteService.strEventInfoDetailID] != 0)
                {
//                    objOnsiteService.strTitle = [Functions ReplaceNUllWithBlank:[dictOnsiteServcie valueForKey:@"Title"]];
//                    objOnsiteService.strBriefDescription = [Functions ReplaceNUllWithBlank:[dictOnsiteServcie valueForKey:@"BriefDescription"]];
//                    objOnsiteService.strDetailDescription = [Functions ReplaceNUllWithBlank:[dictOnsiteServcie valueForKey:@"DetailDescription"]];
//                    objOnsiteService.strEventInfoCategoryID = [Functions ReplaceNUllWithZero:[dictOnsiteServcie valueForKey:@"EventInfoCategoryId"]];
//                    
//                        blnResult = [self AddOnsiteService:objOnsiteService];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into OnsiteService(EventInfoDetailID, Title, BriefDescription, DetailDescription, EventInfoCategoryID) Values(%@, '%@', '%@', '%@', %@)",
                    [dictOnsiteServcie valueForKey:@"EventInfoDetailId"],
                    [Functions ReplaceNUllWithBlank:[dictOnsiteServcie valueForKey:@"Title"]],
                    [Functions ReplaceNUllWithBlank:[dictOnsiteServcie valueForKey:@"BriefDescription"]],
                    [Functions ReplaceNUllWithBlank:[dictOnsiteServcie valueForKey:@"DetailDescription"]],
                    [Functions ReplaceNUllWithZero:[dictOnsiteServcie valueForKey:@"EventInfoCategoryId"]]];
                    
                    [arrQuery addObject:strSQL];
                }
            }
        }
        
//        if(blnResult == YES)
//        {
//            DB *objDB = [DB GetInstance];
//            [objDB UpdateScreenWithVersion:strSCREEN_ONSITE_SERVICE Version:intVersion];
//        }
        
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_ONSITE_SERVICE]];
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark Private Methods (Lost & Found)
- (BOOL)DeleteLostNFound
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From LostNFound ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where ID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddLostNFound:(LostNFound*)objLostNFound
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into LostNFound(ID, Title, Image1, Image2, Image3, Description, Phone1, Phone2, Phone3, Email1, Email2, Email3, Website, Address, IsOverView) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objLostNFound.strID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objLostNFound.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objLostNFound.strImage1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objLostNFound.strImage2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objLostNFound.strImage3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objLostNFound.strDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objLostNFound.strPhone1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objLostNFound.strPhone2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objLostNFound.strPhone3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objLostNFound.strEmail1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objLostNFound.strEmail2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objLostNFound.strEmail3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objLostNFound.strWebsite UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objLostNFound.strAddress UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 15, [objLostNFound.strIsOverview boolValue]);
       
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateLostNFound:(LostNFound*)objLostNFound
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update LostNFound Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Image1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Image2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Image3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Description = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"IsOverView = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objLostNFound.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objLostNFound.strImage1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objLostNFound.strImage2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objLostNFound.strImage3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objLostNFound.strDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objLostNFound.strPhone1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objLostNFound.strPhone2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objLostNFound.strPhone3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objLostNFound.strEmail1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objLostNFound.strEmail2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objLostNFound.strEmail3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objLostNFound.strWebsite UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objLostNFound.strAddress UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 14, [objLostNFound.strIsOverview boolValue]);
        
        sqlite3_bind_int(compiledStmt, 15, [objLostNFound.strID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_LOST_FOUND MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Emergency Hospitals)
- (BOOL)DeleteEmergencyHospitals
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From EmergencyHospitals ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where ID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddEmergencyHospitals:(EmergencyHospitals*)objEmergencyHospitals
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into EmergencyHospitals(ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEmergencyHospitals.strID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objEmergencyHospitals.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objEmergencyHospitals.strBriefDescription1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objEmergencyHospitals.strBriefDescription2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objEmergencyHospitals.strBriefDescription3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objEmergencyHospitals.strWebsite1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objEmergencyHospitals.strWebsite2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objEmergencyHospitals.strWebsite3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objEmergencyHospitals.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objEmergencyHospitals.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objEmergencyHospitals.strAddress3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objEmergencyHospitals.strPhone1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objEmergencyHospitals.strPhone2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objEmergencyHospitals.strPhone3 UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateEmergencyHospitals:(EmergencyHospitals*)objEmergencyHospitals
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update EmergencyHospitals Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone3 = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objEmergencyHospitals.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objEmergencyHospitals.strBriefDescription1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objEmergencyHospitals.strBriefDescription2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objEmergencyHospitals.strBriefDescription3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objEmergencyHospitals.strWebsite1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objEmergencyHospitals.strWebsite2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objEmergencyHospitals.strWebsite3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objEmergencyHospitals.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objEmergencyHospitals.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objEmergencyHospitals.strAddress3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objEmergencyHospitals.strPhone1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objEmergencyHospitals.strPhone2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objEmergencyHospitals.strPhone3 UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 14, [objEmergencyHospitals.strID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Emergency Overview)
- (BOOL)DeleteEmergencyOverview
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From EmergencyOverview ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where ID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddEmergencyOverview:(EmergencyOverview*)objEmergencyOverview
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into EmergencyOverview(ID, title, BriefDescription1, BriefDescription2, BriefDescription3, Website1, Website2, Website3, Address1, Address2, Address3, Phone1, Phone2, Phone3) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEmergencyOverview.strID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objEmergencyOverview.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objEmergencyOverview.strBriefDescription1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objEmergencyOverview.strBriefDescription2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objEmergencyOverview.strBriefDescription3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objEmergencyOverview.strWebsite1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objEmergencyOverview.strWebsite2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objEmergencyOverview.strWebsite3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objEmergencyOverview.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objEmergencyOverview.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objEmergencyOverview.strAddress3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objEmergencyOverview.strPhone1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objEmergencyOverview.strPhone2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objEmergencyOverview.strPhone3 UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateEmergencyOverview:(EmergencyOverview*)objEmergencyOverview
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update EmergencyOverview Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Website3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address3 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Phone3 = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objEmergencyOverview.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objEmergencyOverview.strBriefDescription1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objEmergencyOverview.strBriefDescription2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objEmergencyOverview.strBriefDescription3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objEmergencyOverview.strWebsite1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objEmergencyOverview.strWebsite2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objEmergencyOverview.strWebsite3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objEmergencyOverview.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objEmergencyOverview.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objEmergencyOverview.strAddress3 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objEmergencyOverview.strPhone1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objEmergencyOverview.strPhone2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objEmergencyOverview.strPhone3 UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 14, [objEmergencyOverview.strID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Emergency FloorPlans)
- (BOOL)DeleteEmergencyFloorPlans
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From EmergencyFloorPlans ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where FloorPlanID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strFloorPlanID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddEmergencyFloorPlans:(EmergencyFloorPlans*)objEmergencyFloorPlans
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into EmergencyFloorPlans(FloorPlanID, FloorPlanName, ImageURL) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objEmergencyFloorPlans.strFloorPlanID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objEmergencyFloorPlans.strFloorPlanName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objEmergencyFloorPlans.strImageURL UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateEmergencyFloorPlans:(EmergencyFloorPlans*)objEmergencyFloorPlans
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update EmergencyFloorPlans Set ";
    strSQL = [strSQL stringByAppendingFormat:@"FloorPlanName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ImageURL = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where FloorPlanID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objEmergencyFloorPlans.strFloorPlanName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objEmergencyFloorPlans.strImageURL UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 3, [objEmergencyFloorPlans.strFloorPlanID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EMERGENCY MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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

#pragma mark Private Methods (Onsite Service)
- (NSArray*)GetOnsiteServiceDetails:(int)intCategoryID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrOnsiteServices = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select EventInfoDetailID, Title, BriefDescription, DetailDescription From EventInfoDetails Where CategoryID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, intCategoryID);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            OnsiteService *objOnsiteService = [[OnsiteService alloc] init];
            
            objOnsiteService.strEventInfoDetailID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objOnsiteService.strTitle = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objOnsiteService.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objOnsiteService.strDetailDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            
            [arrOnsiteServices addObject: objOnsiteService];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrOnsiteServices;
}

- (BOOL)DeleteOnsiteService
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From OnsiteService ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where EventInfoDetailID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strEventInfoDetailID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddOnsiteService:(OnsiteService*)objOnsiteService
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into OnsiteService(EventInfoDetailID, Title, BriefDescription, DetailDescription, EventInfoCategoryID) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objOnsiteService.strEventInfoDetailID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objOnsiteService.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objOnsiteService.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objOnsiteService.strDetailDescription UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objOnsiteService.strEventInfoCategoryID intValue]);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateOnsiteService:(OnsiteService*)objOnsiteService
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update OnsiteService Set ";
    strSQL = [strSQL stringByAppendingFormat:@"Title = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"DetailDescription = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"EventInfoCategoryID = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where EventInfoDetailID = ?"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objOnsiteService.strTitle UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objOnsiteService.strBriefDescription UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objOnsiteService.strDetailDescription UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 4, [objOnsiteService.strEventInfoCategoryID intValue]);
        
        sqlite3_bind_int(compiledStmt, 5, [objOnsiteService.strEventInfoDetailID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_ONSITE_SERVICE MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
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
