//
//  ExhibitorDB.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ExhibitorDB.h"
#import "sqlite3.h"
#import "DB.h"
#import "FBJSON.h"
#import "Constants.h"
#import "Functions.h"
#import "NSString+Custom.h"

@implementation ExhibitorDB
static ExhibitorDB *objExhibitorDB = nil;

#pragma mark Shared Methods
+ (id)GetInstance
{
    if (objExhibitorDB == nil)
    {
        objExhibitorDB = [[self alloc] init];
    }
    
    return objExhibitorDB;
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

#pragma mark Instance Methods (Exhibitors)
- (NSArray*)GetExhibitors
{
    strSearch = @"";
    
    return [self GetExhibitorsAndGrouped:YES];
}

- (NSArray*)GetExhibitorsLikeName:(id)strValue
{
    strSearch = strValue;
    
    return [self GetExhibitorsAndGrouped:YES];
}

- (NSArray*)GetSearch:(NSString *)searchFor
{
    searchFor=[searchFor stringByReplacingOccurrencesOfString:@"'" withString:@""];
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrExhibitors = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrTempExhibitors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select ExhibitorID, ExhibitorName, WebsiteURL, LogoURL, CompanyProfile, ExhibitorPhone, BoothNumbers, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, LinkedInURL, TwitterURL, VideoWebCastURL, substr(Upper(ExhibitorName), 1, 1) As Alpha From Exhibitors Order By Upper(ExhibitorName)";
    NSString *strSQL = @"Select Exhibitors.ExhibitorID, Exhibitors.ExhibitorName, Exhibitors.WebsiteURL, Exhibitors.LogoURL, Exhibitors.CompanyProfile, Exhibitors.ExhibitorPhone, Exhibitors.BoothNumbers, Exhibitors.Address1, Exhibitors.Address2, Exhibitors.City, Exhibitors.State, Exhibitors.ZipCode, Exhibitors.PhoneNumbers, Exhibitors.Fax, Exhibitors.Email, Exhibitors.FacebookURL, Exhibitors.LinkedInURL, Exhibitors.TwitterURL, Exhibitors.VideoWebCastURL, substr(Upper(Exhibitors.ExhibitorName), 1, 1) As Alpha, Case When IfNull(AttendeeExhibitors.ExhibitorID,0) = 0 Then 0 When AttendeeExhibitors.IsDeleted = 1 Then 0 Else 1 End As IsAdded From Exhibitors Left Join AttendeeExhibitors On Exhibitors.ExhibitorID = AttendeeExhibitors.ExhibitorID ";
    
    NSString *whereCondition=[NSString stringWithFormat:@"Where Exhibitors.ExhibitorName Like '%%%@%%' Or Exhibitors.WebsiteURL Like '%%%@%%' Or Exhibitors.CompanyProfile Like '%%%@%%' ",searchFor,searchFor,searchFor];
    
    strSQL = [strSQL stringByAppendingString:whereCondition];
    
    strSQL = [strSQL stringByAppendingString:@" Order By Upper(ExhibitorName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Exhibitor *objExhibitor = [[Exhibitor alloc] init];
            
            objExhibitor.strExhibitorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objExhibitor.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objExhibitor.strWebsiteURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objExhibitor.strLogoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objExhibitor.strCompanyProfile = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt,4)];
            objExhibitor.strExhibitorPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objExhibitor.strBoothNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objExhibitor.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objExhibitor.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objExhibitor.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objExhibitor.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objExhibitor.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objExhibitor.strPhoneNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objExhibitor.strFax = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objExhibitor.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objExhibitor.strFacebookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objExhibitor.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objExhibitor.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objExhibitor.strVideoWebCastURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objExhibitor.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            objExhibitor.arrResources = [self GetExhibitorResources:objExhibitor.strExhibitorID];
            objExhibitor.arrCategories = [self GetExhibitorCategories:objExhibitor.strExhibitorID];
            
			[arrTempExhibitors addObject: objExhibitor];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    arrExhibitors = arrTempExhibitors;
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrExhibitors;
}

- (NSArray*)GetExhibitorsAndGrouped:(BOOL)blnGrouped
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrExhibitors = [[NSMutableArray alloc] init];
    
    NSString *strCurAlpha = @"";
    NSString *strNextAlpha = @"";
    
    NSMutableArray *arrAlhaExhibitors = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempExhibitors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select ExhibitorID, ExhibitorName, WebsiteURL, LogoURL, CompanyProfile, ExhibitorPhone, BoothNumbers, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, LinkedInURL, TwitterURL, VideoWebCastURL, substr(Upper(ExhibitorName), 1, 1) As Alpha From Exhibitors Order By Upper(ExhibitorName)";
    NSString *strSQL = @"Select Exhibitors.ExhibitorID, Exhibitors.ExhibitorName, Exhibitors.WebsiteURL, Exhibitors.LogoURL, Exhibitors.CompanyProfile, Exhibitors.ExhibitorPhone, Exhibitors.BoothNumbers, Exhibitors.Address1, Exhibitors.Address2, Exhibitors.City, Exhibitors.State, Exhibitors.ZipCode, Exhibitors.PhoneNumbers, Exhibitors.Fax, Exhibitors.Email, Exhibitors.FacebookURL, Exhibitors.LinkedInURL, Exhibitors.TwitterURL, Exhibitors.VideoWebCastURL, substr(Upper(Exhibitors.ExhibitorName), 1, 1) As Alpha, Case When IfNull(AttendeeExhibitors.ExhibitorID,0) = 0 Then 0 When AttendeeExhibitors.IsDeleted = 1 Then 0 Else 1 End As IsAdded, Exhibitors.ExhibitorCode From Exhibitors Left Join AttendeeExhibitors On Exhibitors.ExhibitorID = AttendeeExhibitors.ExhibitorID ";
    if(![NSString IsEmpty:strSearch shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorName Like '%%%@%%' ",strSearch];
    }
    
    strSQL = [strSQL stringByAppendingString:@"Order By Upper(ExhibitorName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Exhibitor *objExhibitor = [[Exhibitor alloc] init];
            
            if(blnGrouped == YES)
            {
                strNextAlpha = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
                if(![strNextAlpha isEqualToString:strCurAlpha])
                {
                    if(![strCurAlpha isEqualToString:@""] && [arrTempExhibitors count] > 0)
                    {
                        [arrAlhaExhibitors addObject:strCurAlpha];
                        [arrAlhaExhibitors addObject:[arrTempExhibitors copy]];
                        
                        [arrTempExhibitors removeAllObjects];
                        
                        [arrExhibitors addObject:[arrAlhaExhibitors copy]];
                        [arrAlhaExhibitors removeAllObjects];
                    }
                    
                    strCurAlpha = strNextAlpha;
                }
            }
            
            objExhibitor.strExhibitorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objExhibitor.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objExhibitor.strWebsiteURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objExhibitor.strLogoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objExhibitor.strCompanyProfile = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt,4)];
            objExhibitor.strExhibitorPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objExhibitor.strBoothNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objExhibitor.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objExhibitor.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objExhibitor.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objExhibitor.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objExhibitor.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objExhibitor.strPhoneNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objExhibitor.strFax = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objExhibitor.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objExhibitor.strFacebookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objExhibitor.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objExhibitor.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objExhibitor.strVideoWebCastURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objExhibitor.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            objExhibitor.strExhibitorCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 21)];
            
            objExhibitor.arrResources = [self GetExhibitorResources:objExhibitor.strExhibitorID];
            objExhibitor.arrCategories = [self GetExhibitorCategories:objExhibitor.strExhibitorID];
            
			[arrTempExhibitors addObject: objExhibitor];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(blnGrouped == YES)
    {
        if(![strCurAlpha isEqualToString:@""] && [arrTempExhibitors count] > 0)
        {
            [arrAlhaExhibitors addObject:strCurAlpha];
            [arrAlhaExhibitors addObject:[arrTempExhibitors copy]];
            
            [arrTempExhibitors removeAllObjects];
            
            [arrExhibitors addObject:[arrAlhaExhibitors copy]];
            [arrAlhaExhibitors removeAllObjects];
        }
    }
    else
    {
        //[arrExhibitors addObject:[arrTempExhibitors copy]];
        //[arrTempExhibitors removeAllObjects];
        
        arrExhibitors = arrTempExhibitors;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrExhibitors;
}

- (NSArray*)GetExhibitorsWithExhibitorID:(id)strExhibitorID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrExhibitors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select Exhibitors.ExhibitorID, Exhibitors.ExhibitorName, Exhibitors.WebsiteURL, Exhibitors.LogoURL, Exhibitors.CompanyProfile, Exhibitors.ExhibitorPhone, Exhibitors.BoothNumbers, Exhibitors.Address1, Exhibitors.Address2, Exhibitors.City, Exhibitors.State, Exhibitors.ZipCode, Exhibitors.PhoneNumbers, Exhibitors.Fax, Exhibitors.Email, Exhibitors.FacebookURL, Exhibitors.LinkedInURL, Exhibitors.TwitterURL, Exhibitors.VideoWebCastURL, Case When IfNull(AttendeeExhibitors.ExhibitorID,0) = 0 Then 0 Else 1 End As IsAdded From Exhibitors Left Join AttendeeExhibitors On Exhibitors.ExhibitorID = AttendeeExhibitors.ExhibitorID Where ExhibitorID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
        sqlite3_bind_int(compiledStmt, 1, [strExhibitorID intValue]);
        
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Exhibitor *objExhibitor = [[Exhibitor alloc] init];
            
            objExhibitor.strExhibitorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objExhibitor.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objExhibitor.strWebsiteURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objExhibitor.strLogoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objExhibitor.strCompanyProfile = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt,4)];
            objExhibitor.strExhibitorPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objExhibitor.strBoothNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objExhibitor.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objExhibitor.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objExhibitor.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objExhibitor.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objExhibitor.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objExhibitor.strPhoneNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objExhibitor.strFax = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objExhibitor.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objExhibitor.strFacebookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objExhibitor.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objExhibitor.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objExhibitor.strVideoWebCastURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objExhibitor.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
            
            objExhibitor.arrResources = [self GetExhibitorResources:objExhibitor.strExhibitorID];
            objExhibitor.arrCategories = [self GetExhibitorCategories:objExhibitor.strExhibitorID];
            
			[arrExhibitors addObject:objExhibitor];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrExhibitors;
}

- (NSArray*)SetExhibitor:(NSData*)objData
{
    BOOL blnResult = NO;
    
    NSError *error;
    
    NSMutableArray *arrQuery = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"ExhibitorList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"ExhibitorList"];
    }
    
    if(error==nil)
    {
        int intVersion = [[dictData valueForKey:strKEY_VERSION_NO] intValue];
        
        NSArray *arrExhibitors = [dictData valueForKey:@"ExhibitorList"];
        NSUInteger intEntriesM = [arrExhibitors count];
        
        if(intEntriesM > 0)
        {
            //[self DeleteExhibitors];
            NSString *strSQL = @"Delete From Exhibitors";
            [arrQuery addObject:strSQL];
            
            Exhibitor *objExhibitor = [[Exhibitor alloc] init];
            NSMutableDictionary *dictExhibitor;
            
            NSArray *arrExhibitorRecources;
            NSUInteger intEntriesD = 0;
            NSMutableDictionary *dictExhibitorResources;
            
            NSArray *arrExhibitorCategories;
            NSMutableDictionary *dictExhibitorCategories;
            
            for (NSUInteger i = 0; i < intEntriesM; i++)
            {
                dictExhibitor = [[NSMutableDictionary alloc] init];
                
                dictExhibitor = [[arrExhibitors objectAtIndex:i] valueForKey:@"ExhibitorDetails"];
                
                objExhibitor.strExhibitorID = [dictExhibitor valueForKey:@"ExhibitorId"];
                
                if([Functions ReplaceNUllWithZero:objExhibitor.strExhibitorID]!=0)
                {
                    //                    objExhibitor.strExhibitorName = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ExhibitorName"]];
                    //                    objExhibitor.strWebsiteURL = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"WebsiteURL"]];
                    //                    objExhibitor.strLogoURL = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"LogoURL"]];
                    //                    objExhibitor.strCompanyProfile = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"CompanyProfile"]];
                    //                    objExhibitor.strExhibitorPhone = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ExhibitorPhone"]];
                    //                    objExhibitor.strBoothNumbers = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"BoothNumbers"]];
                    //                    objExhibitor.strAddress1 = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"Address1"]];
                    //                    objExhibitor.strAddress2 = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"Address2"]];
                    //                    objExhibitor.strCity = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"City"]];
                    //                    objExhibitor.strState = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"State"]];
                    //                    objExhibitor.strZipCode = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ZipCode"]];
                    //                    objExhibitor.strPhoneNumbers = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"PhoneNumbers"]];
                    //                    objExhibitor.strFax = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"FAX"]];
                    //                    objExhibitor.strEmail = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"Email"]];
                    //                    objExhibitor.strFacebookURL = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"FacebookURL"]];
                    //                    objExhibitor.strTwitterURL = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"TwitterURL"]];
                    //                    objExhibitor.strLinkedInURL = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"LinkedInURL"]];
                    //                    objExhibitor.strVideoWebCastURL = [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"VideoWebCastURL"]];
                    //                    blnResult = [self AddExhibitor:objExhibitor];
                    
                    NSString *strSQL = [NSString stringWithFormat:@"Insert Into Exhibitors(ExhibitorID, ExhibitorName, WebsiteURL, LogoURL, CompanyProfile, ExhibitorPhone, BoothNumbers, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, LinkedInURL, TwitterURL, VideoWebCastURL,ExhibitorCode) Values(%i, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",
                                        [[dictExhibitor valueForKey:@"ExhibitorId"]intValue],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ExhibitorName"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"WebsiteURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"LogoURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"CompanyProfile"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ExhibitorPhone"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"BoothNumbers"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"Address1"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"Address2"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"City"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"State"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ZipCode"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"PhoneNumbers"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"FAX"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"Email"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"FacebookURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"TwitterURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"LinkedInURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"VideoWebCastURL"]],
                                        [Functions ReplaceNUllWithBlank:[dictExhibitor valueForKey:@"ExhibitorCode"]]];
                    
                    [arrQuery addObject:strSQL];
                    
                    //[self DeleteExhibitorResources:objExhibitor.strExhibitorID];
                    strSQL = [NSString stringWithFormat:@"Delete From ExhibitorResources Where ExhibitorID = %@",[dictExhibitor valueForKey:@"ExhibitorId"]];
                    [arrQuery addObject:strSQL];
                    
                    //[self DeleteExhibitorCategories:objExhibitor.strExhibitorID];
                    strSQL = [NSString stringWithFormat:@"Delete From ExhibitorCategories Where ExhibitorID = %@",[dictExhibitor valueForKey:@"ExhibitorId"]];
                    [arrQuery addObject:strSQL];
                    
                    
                    //                    if(blnResult ==YES)
                    //                    {
                    arrExhibitorRecources = [dictExhibitor valueForKey:@"Resources"];
                    intEntriesD = [arrExhibitorRecources count];
                    
                    if(intEntriesD > 0)
                    {
                        dictExhibitorResources = [[NSMutableDictionary alloc] init];
                        
                        ExhibitorResources *objExhibitorResources = [[ExhibitorResources alloc] init];
                        
                        for (NSUInteger i = 0; i < intEntriesD; i++)
                        {
                            dictExhibitorResources = [arrExhibitorRecources objectAtIndex:i];
                            
                            objExhibitorResources.strExhibitorResourceID = [dictExhibitorResources valueForKey:@"ExhibitorResourceId"];
                            
                            if([Functions ReplaceNUllWithZero:objExhibitorResources.strExhibitorResourceID]!=0)
                            {
                                //                                    objExhibitorResources.strExhibitorID = objExhibitor.strExhibitorID;
                                //                                    objExhibitorResources.strFileName = [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"FileName"]];
                                //                                    objExhibitorResources.strDocType = [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"DocType"]];
                                //                                    objExhibitorResources.strURL = [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"URL"]];
                                //                                    objExhibitorResources.strBriefDescription = [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"BriefDescription"]];
                                //
                                //                                    blnResult = [self AddExhibitorResources:objExhibitorResources];
                                
                                NSString *strSQL = [NSString stringWithFormat:@"Insert Into ExhibitorResources(ExhibitorResourceID , ExhibitorID, FileName, DocType, URL, BriefDescription) Values(%@, %@, '%@', '%@', '%@', '%@')",
                                                    [Functions ReplaceNUllWithZero:objExhibitorResources.strExhibitorResourceID],
                                                    [dictExhibitor valueForKey:@"ExhibitorId"],
                                                    [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"FileName"]],
                                                    [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"DocType"]],
                                                    [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"URL"]],
                                                    [Functions ReplaceNUllWithBlank:[dictExhibitorResources valueForKey:@"BriefDescription"]]];
                                
                                [arrQuery addObject:strSQL];
                            }
                        }
                    }
                    
                    arrExhibitorCategories = [dictExhibitor valueForKey:@"Categories"];
                    intEntriesD = [arrExhibitorCategories count];
                    
                    if(intEntriesD > 0)
                    {
                        dictExhibitorCategories = [[NSMutableDictionary alloc] init];
                        
                        ExhibitorCategories *objExhibitorCategories = [[ExhibitorCategories alloc] init];
                        
                        for (NSUInteger i = 0; i < intEntriesD; i++)
                        {
                            dictExhibitorCategories = [arrExhibitorCategories objectAtIndex:i];
                            
                            objExhibitorCategories.strParentCategoryInstanceID = [dictExhibitorCategories valueForKey:@"ParentCategoryInstanceID"];
                            
                            if([[Functions ReplaceNUllWithBlank:objExhibitorCategories.strParentCategoryInstanceID] isEqualToString:@""])
                            {
                            }
                            else
                            {
                                //                                    objExhibitorCategories.strExhibitorID = objExhibitor.strExhibitorID;
                                
                                NSArray *arrCategories = [Functions ReplaceNUllWithBlank:[dictExhibitorCategories valueForKey:@"Categoryname"]];
                                //                                    objExhibitorCategories.strCategoryName = [arrCategories componentsJoinedByString:@","];
                                //
                                //                                        blnResult = [self AddExhibitorCategories:objExhibitorCategories];
                                
                                NSString *strSQL = [NSString stringWithFormat:@"Insert Into ExhibitorCategories(ParentCategoryInstanceID, ExhibitorID, CategoryName) Values('%@', %@, '%@')",
                                                    [dictExhibitorCategories valueForKey:@"ParentCategoryInstanceID"],
                                                    [dictExhibitor valueForKey:@"ExhibitorId"],
                                                    [arrCategories componentsJoinedByString:@","]];
                                
                                [arrQuery addObject:strSQL];
                            }
                        }
                    }
                    //                    }
                }
            }
        }
        
//        if(blnResult == YES)
//        {
           // DB *objDB = [DB GetInstance];
           // [objDB UpdateScreenWithVersion:strSCREEN_EXHIBITOR Version:intVersion];
        [arrQuery addObject:[NSString stringWithFormat:@"Update ScreenVersion Set ScreenVersion = %i Where ScreenName = '%@'",intVersion,strSCREEN_EXHIBITOR]];
//        }
        
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
    }
    
    return arrQuery;
}
#pragma mark -

#pragma mark  Instance Methods (Attendee Exhibitors)
- (NSArray*)GetAttendeeExhibitors
{
    strSearch = @"";
    return [self GetAttendeeExhibitorsAndGrouped:YES];
}

- (NSArray*)GetAttendeeExhibitorsLikeName:(id)strValue
{
    strSearch = strValue;
    
    return [self GetAttendeeExhibitorsAndGrouped:YES];
}

- (NSArray*)GetAttendeeExhibitorsAndGrouped:(BOOL)blnGrouped;
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrExhibitors = [[NSMutableArray alloc] init];
    
    NSString *strCurAlpha = @"";
    NSString *strNextAlpha = @"";
    
    NSMutableArray *arrAlhaExhibitors = [[NSMutableArray alloc] init];
    NSMutableArray *arrTempExhibitors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    //char *strSQL = "Select Exhibitors.ExhibitorID, Exhibitors.ExhibitorName, Exhibitors.WebsiteURL, Exhibitors.LogoURL, Exhibitors.CompanyProfile, Exhibitors.ExhibitorPhone, Exhibitors.BoothNumbers, Exhibitors.Address1, Exhibitors.Address2, Exhibitors.City, Exhibitors.State, Exhibitors.ZipCode, Exhibitors.PhoneNumbers, Exhibitors.Fax, Exhibitors.Email, Exhibitors.FacebookURL, Exhibitors.LinkedInURL, Exhibitors.TwitterURL, Exhibitors.VideoWebCastURL, substr(Upper(Exhibitors.ExhibitorName), 1, 1) As Alpha From Exhibitors Inner Join AttendeeExhibitors On Exhibitors.ExhibitorID = AttendeeExhibitors.ExhibitorID Order By Upper(ExhibitorName)";
    //char *strSQL = "Select ExhibitorID, ExhibitorName, WebsiteURL, LogoURL, CompanyProfile, ExhibitorPhone, BoothNumbers, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, LinkedInURL, TwitterURL, VideoWebCastURL, substr(Upper(ExhibitorName), 1, 1) As Alpha From Exhibitors  Order By Upper(ExhibitorName)";
    NSString *strSQL = @"Select Exhibitors.ExhibitorID, Exhibitors.ExhibitorName, Exhibitors.WebsiteURL, Exhibitors.LogoURL, Exhibitors.CompanyProfile, Exhibitors.ExhibitorPhone, Exhibitors.BoothNumbers, Exhibitors.Address1, Exhibitors.Address2, Exhibitors.City, Exhibitors.State, Exhibitors.ZipCode, Exhibitors.PhoneNumbers, Exhibitors.Fax, Exhibitors.Email, Exhibitors.FacebookURL, Exhibitors.LinkedInURL, Exhibitors.TwitterURL, Exhibitors.VideoWebCastURL, substr(Upper(Exhibitors.ExhibitorName), 1, 1) As Alpha, Case When IfNull(AttendeeExhibitors.ExhibitorID,0) = 0 Then 0 When AttendeeExhibitors.IsDeleted = 1 Then 0 Else 1 End As IsAdded From Exhibitors Inner Join AttendeeExhibitors On Exhibitors.ExhibitorID = AttendeeExhibitors.ExhibitorID Where AttendeeExhibitors.IsDeleted = 0 ";
    if(![NSString IsEmpty:strSearch shouldCleanWhiteSpace:YES])
    {
        strSQL = [strSQL stringByAppendingFormat:@"And Exhibitors.ExhibitorName Like '%%%@%%' ",strSearch];
    }
    strSQL = [strSQL stringByAppendingString:@"Order By Upper(ExhibitorName)"];
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            Exhibitor *objExhibitor = [[Exhibitor alloc] init];
            
            if(blnGrouped == YES)
            {
                strNextAlpha = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 19)];
                if(![strNextAlpha isEqualToString:strCurAlpha])
                {
                    if(![strCurAlpha isEqualToString:@""] && [arrTempExhibitors count] > 0)
                    {
                        [arrAlhaExhibitors addObject:strCurAlpha];
                        [arrAlhaExhibitors addObject:[arrTempExhibitors copy]];
                        
                        [arrTempExhibitors removeAllObjects];
                        
                        [arrExhibitors addObject:[arrAlhaExhibitors copy]];
                        [arrAlhaExhibitors removeAllObjects];
                    }
                    
                    strCurAlpha = strNextAlpha;
                }
            }
            
            objExhibitor.strExhibitorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objExhibitor.strExhibitorName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objExhibitor.strWebsiteURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objExhibitor.strLogoURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objExhibitor.strCompanyProfile = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt,4)];
            objExhibitor.strExhibitorPhone = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            objExhibitor.strBoothNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 6)];
            objExhibitor.strAddress1 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 7)];
            objExhibitor.strAddress2 = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 8)];
            objExhibitor.strCity = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 9)];
            objExhibitor.strState = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 10)];
            objExhibitor.strZipCode = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 11)];
            objExhibitor.strPhoneNumbers = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 12)];
            objExhibitor.strFax = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 13)];
            objExhibitor.strEmail = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 14)];
            objExhibitor.strFacebookURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 15)];
            objExhibitor.strTwitterURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 16)];
            objExhibitor.strLinkedInURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 17)];
            objExhibitor.strVideoWebCastURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 18)];
            objExhibitor.strIsAdded = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 20)];
            
            objExhibitor.arrResources = [self GetExhibitorResources:objExhibitor.strExhibitorID];
            objExhibitor.arrCategories = [self GetExhibitorCategories:objExhibitor.strExhibitorID];
            
			[arrTempExhibitors addObject: objExhibitor];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_ATTENDEE_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
    if(blnGrouped == YES)
    {
        if(![strCurAlpha isEqualToString:@""] && [arrTempExhibitors count] > 0)
        {
            [arrAlhaExhibitors addObject:strCurAlpha];
            [arrAlhaExhibitors addObject:[arrTempExhibitors copy]];
            
            [arrTempExhibitors removeAllObjects];
            
            [arrExhibitors addObject:[arrAlhaExhibitors copy]];
            [arrAlhaExhibitors removeAllObjects];
        }
    }
    else
    {
        //[arrExhibitors addObject:[arrTempExhibitors copy]];
        //[arrTempExhibitors removeAllObjects];
        
        arrExhibitors = arrTempExhibitors;
    }
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrExhibitors;
}

- (NSString*)GetAttendeeExhibitorsJSON
{
    sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrAttendeeExhibitors = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select AttendeeExhibitors.ExhibitorCode, AttendeeExhibitors.IsDeleted From AttendeeExhibitors where AttendeeExhibitors.IsSynced = 0";
   
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if (outval == SQLITE_OK)
    {
		//Loop through the results and add them to the feeds array
		while (sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            NSMutableDictionary *objExhibitor = [[NSMutableDictionary alloc] init];
            
            [objExhibitor setObject:[Functions GetGUID] forKey:@"Id"];
            [objExhibitor setObject:[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)] forKey:@"ExhibitorCode"];
            [objExhibitor setObject:[NSNumber numberWithBool:[[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)] boolValue]] forKey:@"IsDelete"];
            
			[arrAttendeeExhibitors addObject: objExhibitor];
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
    
    NSString *strAttendeeExhibitors = [arrAttendeeExhibitors JSONRepresentation];
    
	return strAttendeeExhibitors;
}
#pragma mark -

#pragma mark Private Methods
- (BOOL)DeleteExhibitors
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From Exhibitors ";
    //strSQL = [strSQL stringByAppendingFormat:@"Where strExhibitorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        //sqlite3_bind_int(compiledStmt, 1, [strVenueID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddExhibitor:(Exhibitor*)objExhibitor
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into Exhibitors(ExhibitorID, ExhibitorName, WebsiteURL, LogoURL, CompanyProfile, ExhibitorPhone, BoothNumbers, Address1, Address2, City, State, ZipCode, PhoneNumbers, Fax, Email, FacebookURL, LinkedInURL, TwitterURL, VideoWebCastURL) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objExhibitor.strExhibitorID intValue]);
        sqlite3_bind_text(compiledStmt, 2, [objExhibitor.strExhibitorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objExhibitor.strWebsiteURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objExhibitor.strLogoURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objExhibitor.strCompanyProfile UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objExhibitor.strExhibitorPhone UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objExhibitor.strBoothNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objExhibitor.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objExhibitor.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objExhibitor.strCity UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objExhibitor.strState UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objExhibitor.strZipCode UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objExhibitor.strPhoneNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objExhibitor.strFax UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 15, [objExhibitor.strEmail UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objExhibitor.strFacebookURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objExhibitor.strLinkedInURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 18, [objExhibitor.strTwitterURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 19, [objExhibitor.strVideoWebCastURL UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateExhibitor:(Exhibitor*)objExhibitor
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update Exhibitors Set ";
    strSQL = [strSQL stringByAppendingFormat:@"ExhibitorName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"WebsiteURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LogoURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"CompanyProfile = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ExhibitorPhone = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BoothNumbers = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address1 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Address2 = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"City = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"State = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"ZipCode = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"PhoneNumbers = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Fax = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"Email = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"FacebookURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"TwitterURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"LinkedInURL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"VideoWebCastURL = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorID = ?"];
    
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objExhibitor.strExhibitorName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objExhibitor.strWebsiteURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objExhibitor.strLogoURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objExhibitor.strCompanyProfile UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 5, [objExhibitor.strExhibitorPhone UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 6, [objExhibitor.strBoothNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 7, [objExhibitor.strAddress1 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 8, [objExhibitor.strAddress2 UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 9, [objExhibitor.strCity UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 10, [objExhibitor.strState UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 11, [objExhibitor.strZipCode UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 12, [objExhibitor.strPhoneNumbers UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 13, [objExhibitor.strFax UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 14, [objExhibitor.strEmail UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 15, [objExhibitor.strFacebookURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 16, [objExhibitor.strTwitterURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 17, [objExhibitor.strLinkedInURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 18, [objExhibitor.strVideoWebCastURL UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 19, [objExhibitor.strExhibitorID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddExhibitorResources:(ExhibitorResources*)objExhibitorResources
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into ExhibitorResources(ExhibitorResourceID , ExhibitorID, FileName, DocType, URL, BriefDescription) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?, ?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [objExhibitorResources.strExhibitorResourceID intValue]);
        sqlite3_bind_int(compiledStmt, 2, [objExhibitorResources.strExhibitorID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objExhibitorResources.strFileName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objExhibitorResources.strDocType UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 5, [objExhibitorResources.strURL intValue]);
        sqlite3_bind_text(compiledStmt, 6, [objExhibitorResources.strBriefDescription UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateExhibitorResources:(ExhibitorResources*)objExhibitorResources
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update ExhibitorResources Set ";
    strSQL = [strSQL stringByAppendingFormat:@"FileName = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"DocType = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"URL = ?, "];
    strSQL = [strSQL stringByAppendingFormat:@"BriefDescription = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorResourceID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objExhibitorResources.strFileName UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 2, [objExhibitorResources.strDocType UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 3, [objExhibitorResources.strURL UTF8String], -1, NULL);
        sqlite3_bind_text(compiledStmt, 4, [objExhibitorResources.strBriefDescription UTF8String], -1, NULL);
        
        sqlite3_bind_int(compiledStmt, 5, [objExhibitorResources.strExhibitorResourceID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteExhibitorResources:(NSString*)strExhibitorID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From ExhibitorResources ";
    strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [strExhibitorID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)AddExhibitorCategories:(ExhibitorCategories*)objExhibitorCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Insert Into ExhibitorCategories(ParentCategoryInstanceID, ExhibitorID, CategoryName) ";
    strSQL = [strSQL stringByAppendingString:@"Values(?, ?, ?)"];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objExhibitorCategories.strParentCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 2, [objExhibitorCategories.strExhibitorID intValue]);
        sqlite3_bind_text(compiledStmt, 3, [objExhibitorCategories.strCategoryName UTF8String], -1, NULL);
        
		if(SQLITE_DONE != sqlite3_step(compiledStmt))
        {
            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)UpdateExhibitorCategories:(ExhibitorCategories*)objExhibitorCategories
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Update ExhibitorCategories Set ";
    strSQL = [strSQL stringByAppendingFormat:@"CategoryName = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"Where ParentCategoryInstanceID = ? "];
    strSQL = [strSQL stringByAppendingFormat:@"And ExhibitorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_text(compiledStmt, 1, [objExhibitorCategories.strCategoryName UTF8String], -1, NULL);
        
        sqlite3_bind_text(compiledStmt, 2, [objExhibitorCategories.strParentCategoryInstanceID UTF8String], -1, NULL);
        sqlite3_bind_int(compiledStmt, 3, [objExhibitorCategories.strExhibitorID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating update statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (BOOL)DeleteExhibitorCategories:(NSString*)strExhibitorID
{
    BOOL blnResult = NO;
    
	sqlite3 *dbEMEAFY14;
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    sqlite3_stmt *compiledStmt;
    
    NSString *strSQL = @"Delete From ExhibitorCategories ";
    strSQL = [strSQL stringByAppendingFormat:@"Where ExhibitorID = ? "];
    
	if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
	else
    {
        sqlite3_bind_int(compiledStmt, 1, [strExhibitorID intValue]);
        
		if( SQLITE_DONE != sqlite3_step(compiledStmt) )
        {
            NSLog(@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14));
            [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while creating delete statement. %s",sqlite3_errmsg(dbEMEAFY14)]];
            
			blnResult = NO;
		}
		else
        {
			blnResult = YES;
		}
    }
    
    return blnResult;
}

- (NSMutableArray*)GetExhibitorResources:(NSString*)strExhibitorID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrExhibitorResources = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ExhibitorResourceID, ExhibitorID, FileName, DocType, URL, BriefDescription From ExhibitorResources Where ExhibitorID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strExhibitorID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            ExhibitorResources *objExhibitorResources = [[ExhibitorResources alloc] init];
            
            objExhibitorResources.strExhibitorResourceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objExhibitorResources.strExhibitorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objExhibitorResources.strFileName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            objExhibitorResources.strDocType = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 3)];
            objExhibitorResources.strURL = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 4)];
            objExhibitorResources.strBriefDescription = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 5)];
            
			//Read the data from the result row
			[arrExhibitorResources addObject:objExhibitorResources];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrExhibitorResources;
}

- (NSMutableArray*)GetExhibitorCategories:(NSString*)strExhibitorID
{
	sqlite3 *dbEMEAFY14;
    
	NSMutableArray *arrExhibitorCategories = [[NSMutableArray alloc] init];
    
	dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
    
    char *strSQL = "Select ParentCategoryInstanceID, ExhibitorID, CategoryName From ExhibitorCategories Where ExhibitorID = ?";
    
	sqlite3_stmt *compiledStmt;
	int outval = sqlite3_prepare_v2(dbEMEAFY14, strSQL, -1, &compiledStmt, NULL);
    
	if(outval == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStmt, 1, [strExhibitorID UTF8String], -1, NULL);
        
		//Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStmt) == SQLITE_ROW)
        {
            ExhibitorCategories *objExhibitorCategories = [[ExhibitorCategories alloc] init];
            
            objExhibitorCategories.strParentCategoryInstanceID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 0)];
            objExhibitorCategories.strExhibitorID = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 1)];
            objExhibitorCategories.strCategoryName = [NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStmt, 2)];
            
			//Read the data from the result row
			[arrExhibitorCategories addObject:objExhibitorCategories];
		}
	}
	else
    {
        NSLog(@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14));
        [ExceptionHandler AddExceptionForScreen:strSCREEN_EXHIBITOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:[NSString stringWithFormat:@"Error while selecting query: %s",sqlite3_errmsg(dbEMEAFY14)]];
	}
    
	sqlite3_reset(compiledStmt);
	//Release the compiled statement from memory
	sqlite3_finalize(compiledStmt);
    
	return arrExhibitorCategories;
}
#pragma mark -
@end
