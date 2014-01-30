//
//  SyncUp.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SyncUp.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "AppSettings.h"
#import "Functions.h"
#import "DeviceManager.h"
#import "Shared.h"
#import "User.h"
#import "DB.h"
#import "optin.h"
#import "Home.h"
#import "FBJSON.h"
#import "NSURLConnection+Tag.h"
#import "SponsorDB.h"
#import "VenueDB.h"
#import "ConferenceDB.h"
#import "AgendaDB.h"
#import "ExhibitorDB.h"
#import "Exhibitor.h"
#import "MasterDB.h"
#import "SpeakerDB.h"
#import "SessionDB.h"
#import "AttendeeDB.h"
#import "MySessionDB.h"
#import "EventInfoDB.h"
#import "NotesDB.h"
#import "AnnouncementDB.h"
#import "MessagingDB.h"
#import "AppDelegate.h"
#import "shuttleInfo.h"
#import "ShuttleRouteMap.h"
#import "Shuttle.h"
#import "ShuttleTime.h"
#import "ShuttleRouteMapLocation.h"
#import "AppDelegate.h"

@interface SyncUp ()
{
    @private
    BOOL blnUseBatchUpdate;
    
    BOOL blnSyncSponsors;
    BOOL blnSyncVenues;
    BOOL blnSyncAgendas;
    BOOL blnSyncExhibitors;
    BOOL blnSyncCategories;
    BOOL blnSyncRooms;
    BOOL blnSyncSpeakers;
    BOOL blnSyncSessions;
    BOOL blnSyncFilters;
    BOOL blnSyncEventInfoCategories;
    BOOL blnSyncEventInfoDetails;
    BOOL blnSyncLostNFound;
    BOOL blnSyncEmergency;
    BOOL blnSyncOnsiteService;
    
    BOOL blnSetSponsorsComplete;
    BOOL blnSetVenuesComplete;
    BOOL blnSetAgendasComplete;
    BOOL blnSetExhibitorsComplete;
    BOOL blnSetCategoriesComplete;
    BOOL blnSetRoomsComplete;
    BOOL blnSetSpeakersComplete;
    BOOL blnSetSessionsComplete;
    BOOL blnSetFiltersComplete;
    BOOL blnSetEventInfoCategoriesComplete;
    BOOL blnSetEventInfoDetailsComplete;
    BOOL blnSetLostNFoundComplete;
    BOOL blnSetEmergencyComplete;
    BOOL blnSetOnsiteServiceComplete;
    BOOL blnSetFindLikeMindedFilters;

}
@end

@implementation SyncUp
#pragma mark Synthesize
@synthesize avLoading;
@synthesize objConnection, objData, dictData, lblText;
#pragma mark -

#pragma mark View Events
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[self avLoading] startAnimating];
    
    //if (dictData == nil)
    //{
    //    dictData = [[NSMutableDictionary alloc] init];
    //}
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SYNC_UP];

    
    //AppDelegate *objAppDelegate = (AppDelegate *)[[[UIApplication sharedApplication] delegate];
    [APP hideBottomPullOutMenu];
    
    [self SyncUp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if([DeviceManager IsiPad] == YES)
    {
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}
#pragma mark -

#pragma mark View Methods
- (void)SyncUp
{
	AppSettings *objAppSettings = [AppSettings GetInstance];
    blnUseBatchUpdate = [objAppSettings GetUseBatchUpdate];
    
    if(blnUseBatchUpdate == NO)
    {
       [self SyncSponsors];
    }
    else
    {
        Shared *objShared = [Shared GetInstance];
        BOOL blnFirstTimeUse = [objShared GetFirstTimeUse];
        
        if(blnFirstTimeUse == YES)
        {
            //[objShared SetFirstTimeUse:NO];//sushma
         
            NSLog(@"Before Batch Convergencve Detail Call");
            [self GetBatchConvegenceDetail];
        }
        else
        {
            NSLog(@"Before Batch Version Call");
            [self GetBatchVersionList];
            //[self SyncSponsors];
        }
    }
}

- (void)loadHome
{
    //AppDelegate *objAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [APP showBottomPullOutMenu];
    
    if(self.blnCalledFromHome == YES)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncUpCompleted" object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        Home *vcHome;
        
        if([DeviceManager IsiPad] == YES)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
            vcHome = [storyboard instantiateViewControllerWithIdentifier:@"idHome"];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
            vcHome = [storyboard instantiateViewControllerWithIdentifier:@"idHome"];
        }
        
        [[self navigationController] pushViewController:vcHome animated:YES];
    }
}
#pragma mark -

#pragma mark View Private Methods (Sync)
- (void)GetBatchVersionList
{
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_BATCH_GET_VERSION_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_BATCH_GET_VERSION_LIST];
}

- (void)GetBatchConvegenceDetail
{
    User *objUser = [User GetInstance];

    NSMutableArray *arrBatchVersions = [[NSMutableArray alloc] init];
    NSMutableDictionary *dictBatchVersions = [[NSMutableDictionary alloc] init];
    
    [dictBatchVersions setObject:@"Exhibitors" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"EventInfo" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"Attendees" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"Agenda" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"Venues" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"Sponsors" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"Evaluation" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    [dictBatchVersions setObject:@"Session" forKey:@"BatchName"];
    [dictBatchVersions setObject:@"0" forKey:@"VersionNo"];
    [arrBatchVersions addObject:[dictBatchVersions copy]];
    [dictBatchVersions removeAllObjects];
    
    NSString *strBatchVersions = [arrBatchVersions JSONRepresentation];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_BATCH_GET_CONVERGENCE_DTL];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:strBatchVersions forHTTPHeaderField:@"BatchVersions"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_BATCH_GET_CONVERGENCE_DTL];
}

- (void)CheckVersionAndUpdateData
{
    NSError *error;
    
   // dictData = [[NSMutableDictionary alloc] init];
   // dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    
    //NSDictionary *dictAllData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    //dictData = [[NSMutableDictionary alloc] init];
    //dictData = [dictAllData valueForKey:@"BatchVersions"];
    
    if(error==nil)
    {
        NSArray *arrBatchVersions = (NSArray *)dictData;
        NSUInteger intEntries = [arrBatchVersions count];
        
        if(intEntries > 0)
        {
            blnSyncSponsors = NO;
            blnSyncVenues = NO;
            blnSyncAgendas = NO;
            blnSyncExhibitors = NO;
            blnSyncCategories = NO;
            blnSyncRooms = NO;
            blnSyncSpeakers = NO;
            blnSyncSessions = NO;
            blnSyncFilters = NO;
            blnSyncEventInfoCategories = NO;
            blnSyncEventInfoDetails = NO;
            blnSyncLostNFound = NO;
            blnSyncEmergency = NO;
            blnSyncOnsiteService = NO;
            
            NSArray *arrScreenNames = [[NSArray alloc] initWithObjects:strSCREEN_SPONSOR, strSCREEN_VENUE, strSCREEN_AGENDA, strSCREEN_EXHIBITOR, strSCREEN_SESSION, strSCREEN_EVENT_INFO_CATEGORIES, nil];
            
            DB *objDB = [DB GetInstance];
            NSDictionary *dictLocalVersion = [objDB GetVersionForScreens:arrScreenNames];
            
            NSUInteger intLocalVersion = 0;
            
            NSDictionary *dictBatch = [[NSDictionary alloc] init];
            
            for (NSUInteger intI = 0; intI < intEntries; intI++)
            {
                dictBatch = [arrBatchVersions objectAtIndex:intI];
                
                NSString *strBatchName = [dictBatch valueForKey:@"BatchName"];
                NSUInteger intCloudVersion = [[dictBatch valueForKey:@"VersionNumber"] integerValue];
                
                if([strBatchName isEqualToString:@"Sponsors"])
                {
                    //blnSyncSponsors = [self IsUpdateReqd:strSCREEN_SPONSOR CloudVersion:intCloudVersion];
                    
                    intLocalVersion = 0;
                    intLocalVersion = [[dictLocalVersion valueForKey:strSCREEN_SPONSOR] integerValue];
                    blnSyncSponsors = [self IsUpdateReqdV1:intLocalVersion CloudVersion:intCloudVersion];
                }
                else if([strBatchName isEqualToString:@"Venues"])
                {
                    //blnSyncVenues = [self IsUpdateReqd:strSCREEN_VENUE CloudVersion:intCloudVersion];

                    intLocalVersion = 0;
                    intLocalVersion = [[dictLocalVersion valueForKey:strSCREEN_VENUE] integerValue];
                    blnSyncVenues = [self IsUpdateReqdV1:intLocalVersion CloudVersion:intCloudVersion];
                }
                else if([strBatchName isEqualToString:@"Agenda"])
                {
                    //blnSyncAgendas = [self IsUpdateReqd:strSCREEN_AGENDA CloudVersion:intCloudVersion];

                    intLocalVersion = 0;
                    intLocalVersion = [[dictLocalVersion valueForKey:strSCREEN_AGENDA] integerValue];
                    blnSyncAgendas = [self IsUpdateReqdV1:intLocalVersion CloudVersion:intCloudVersion];
                }
                else if([strBatchName isEqualToString:@"Exhibitors"])
                {
                    //blnSyncExhibitors = [self IsUpdateReqd:strSCREEN_EXHIBITOR CloudVersion:intCloudVersion];

                    intLocalVersion = 0;
                    intLocalVersion = [[dictLocalVersion valueForKey:strSCREEN_EXHIBITOR] integerValue];
                    blnSyncExhibitors = [self IsUpdateReqdV1:intLocalVersion CloudVersion:intCloudVersion];
                }
                else if([strBatchName isEqualToString:@"Session"])
                {
                    //blnSyncSessions = [self IsUpdateReqd:strSCREEN_SESSION CloudVersion:intCloudVersion];
                    
                    intLocalVersion = 0;
                    intLocalVersion = [[dictLocalVersion valueForKey:strSCREEN_SESSION] integerValue];
                    blnSyncSessions = [self IsUpdateReqdV1:intLocalVersion CloudVersion:intCloudVersion];
                    
                    blnSyncCategories = blnSyncSessions;
                    blnSyncRooms = blnSyncSessions;
                    blnSyncSpeakers = blnSyncSessions;
                    blnSyncFilters = blnSyncSessions;
                }
                else if([strBatchName isEqualToString:@"EventInfo"])
                {
                    //blnSyncEventInfoCategories = [self IsUpdateReqd:strSCREEN_EVENT_INFO_CATEGORIES CloudVersion:intCloudVersion];;
                    
                    intLocalVersion = 0;
                    intLocalVersion = [[dictLocalVersion valueForKey:strSCREEN_EVENT_INFO_CATEGORIES] integerValue];
                    blnSyncEventInfoCategories = [self IsUpdateReqdV1:intLocalVersion CloudVersion:intCloudVersion];
                    
                    blnSyncEventInfoDetails = blnSyncEventInfoCategories;
                    blnSyncLostNFound = blnSyncEventInfoCategories;
                    blnSyncEmergency = blnSyncEventInfoCategories;
                    blnSyncOnsiteService = blnSyncEventInfoCategories;
                }
            }
        }
    }
    else
    {
        [ExceptionHandler AddExceptionForScreen:strSCREEN_SYNC_UP MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
        
        [self loadHome];
    }
}

- (BOOL)IsUpdateReqd:(NSString*)strScreenName CloudVersion:(NSUInteger)intCloudVersion
{
    BOOL blnIsUpdateReqd = NO;
    
    DB *objDB = [DB GetInstance];
    NSUInteger intVersion = [objDB GetVersionForScreen:strScreenName];

    if(intCloudVersion > intVersion)
    {
        blnIsUpdateReqd = YES;
    }
    
    return  blnIsUpdateReqd;
}

- (BOOL)IsUpdateReqdV1:(NSUInteger)intLocalVersion CloudVersion:(NSUInteger)intCloudVersion
{
    BOOL blnIsUpdateReqd = NO;
    
    if(intCloudVersion > intLocalVersion)
    {
        blnIsUpdateReqd = YES;
    }
    
    return  blnIsUpdateReqd;
}

- (void)UpdateData
{
    if(blnSyncSponsors == YES)
    {
        blnSyncSponsors = NO;
        [self SyncSponsors];
    }
    else if(blnSyncVenues == YES)
    {
       blnSyncVenues = NO;
        [self SyncVenues];
    }
    else if(blnSyncAgendas == YES)
    {
        blnSyncAgendas = NO;
        [self SyncAgendas];
    }
    else if(blnSyncExhibitors == YES)
    {
        blnSyncExhibitors = NO;
        [self SyncExhibitors];
    }
    else if(blnSyncCategories == YES)
    {
        blnSyncCategories = NO;
        [self SyncCategories];
    }
    else if(blnSyncRooms == YES)
    {
        blnSyncRooms = NO;
        [self SyncRooms];
    }
    else if(blnSyncSpeakers == YES)
    {
        blnSyncSpeakers = NO;
        [self SyncSpeakers];
    }
    else if(blnSyncSessions == YES)
    {
        blnSyncSessions = NO;
        [self SyncSessions];
    }
    else if(blnSyncFilters == YES)
    {
        blnSyncFilters = NO;
        [self SyncSessionFilters];
    }
    else if(blnSyncEventInfoCategories == YES)
    {
        blnSyncEventInfoCategories = NO;
        [self SyncEventInfoCategories];
    }
    else if(blnSyncEventInfoDetails == YES)
    {
        blnSyncEventInfoDetails = NO;
        [self SyncEventInfoDetails];
    }
    else if(blnSyncLostNFound == YES)
    {
        blnSyncLostNFound = NO;
        [self SyncLostFound];
    }
    else if(blnSyncEmergency == YES)
    {
        blnSyncEmergency = NO;
        [self SyncEmergency];
    }
    else if(blnSyncOnsiteService == YES)
    {
        blnSyncOnsiteService = NO;
        [self SyncOnsiteService];
    }
    else
    {
        [self SyncAnnouncements];
    }
}

- (void)SyncSponsors
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SPONSOR_GET_SPONSOR_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%@",[objUser GetAccountEmail]);
    NSLog(@"%d",[objDB GetVersionForScreen:strSCREEN_SPONSOR]);
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_SPONSOR]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_SPONSOR_LIST];
}

- (void)SyncVenues
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_VENUE_GET_VENUE_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_VENUE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_VENUE_LIST];
}

- (void)SyncAgendas
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_CONFERENCE_GET_AGENDA_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_AGENDA]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_AGENDA_LIST];
}

- (void)SyncConferences
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_CONFERENCE_GET_CONFERENCE_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_CONFERENCE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_CONFERENCE_LIST];
}

- (void)SyncExhibitors
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EXHIBITOR_GET_EXHIBITOR_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_EXHIBITOR]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_EXHIBITOR_LIST];
}

- (void)SyncTracks
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_TRACKS_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_TRACK]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_TRACKS_LIST];
}

- (void)SyncSubTracks
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_SUB_TRACKS_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_SUB_TRACK]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_SUB_TRACKS_LIST];
}

- (void)SyncCategories
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_CATEGORY_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_CATEGORIES]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_CATEGORY_LIST];
}

- (void)SyncRooms
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_ROOMS_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ROOMS]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ROOMS_LIST];
}

- (void)SyncSpeakers
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_SPEAKER_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_SPEAKER]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_SPEAKER_LIST];
}

- (void)SyncSessions
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_SESSION_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_SESSION]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_SESSION_LIST];
}

- (void)SyncAttendees
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_GET_ATTENDEE_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ATTENDEE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ANTENDEE_LIST];
}

- (void)SyncMySessions
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_MY_SESSION_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_MY_SCHEDULE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_MY_SESSION_LIST];
}

- (void)SyncLostFound
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EVENT_INFO_GET_LOST_FOUND_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_LOST_FOUND]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_LOST_FOUND_LIST];
}

- (void)SyncEmergency
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EVENT_INFO_GET_EMERGENCY_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_EMERGENCY]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_EMERGENCY_LIST];
}

- (void)SyncEventInfoCategories
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EVENT_INFO_GET_CATEGORY_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_EVENT_INFO_CATEGORIES]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_EVENT_INFO_CATEGORY_LIST];
}

- (void)SyncOnsiteService
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EVENT_INFO_GET_ONSITE_SERVICE_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ONSITE_SERVICE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ONSITE_SERVICE_LIST];
}

- (void)SyncEventInfoDetails
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EVENT_INFO_GET_DETAIL_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_EVENT_INFO_DTL]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_EVENT_INFO_DTL_LIST];
}

- (void)SyncAttendeeExhibitor
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    ExhibitorDB *objExhibitorDB = [ExhibitorDB GetInstance];
    NSString *strAttendeeExhibitors = [objExhibitorDB GetAttendeeExhibitorsJSON];

    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EXHIBITOR_GET_ATTENDEE_EXHIBITOR_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:strAttendeeExhibitors forHTTPHeaderField:@"ExhibitorJSON"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ATTENDEE_EXHIBITOR]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ATTENDEE_EXHIBITOR_LIST];
}

- (void)SyncSessionFilters
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_SESSION_GET_FILTER_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_FILTER]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_FILTER_LIST];
}

- (void)SyncAnnouncements
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ANNOUNCEMENT_GET_ANNOUNCEMENT_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ANNOUNCEMENT]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ANNOUNCEMENT_LIST];
}

- (void)SyncUserNotes
{
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_NOTES_GET_USER_NOTES_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_USER_NOTE]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_USER_NOTES_LIST];
}

- (void)SyncMessages
{
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_GET_MESSAGING_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[NSString stringWithFormat:@"0"] forHTTPHeaderField:@"MaxMessageId"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_MESSAGING_LIST];
}
#pragma mark -

#pragma mark View Private Methods (DB)
- (void)SetSponsors
{
    Shared *objShared = [Shared GetInstance];
    
    SponsorDB *objSponsorDB = [[SponsorDB alloc] init];
    //BOOL blnResult = [objSponsorDB SetSponsors:objData];
    
    [objShared.dictSqlQuery setObject:[objSponsorDB SetSponsors:objData] forKey:@"Sponsors"];
    blnSetSponsorsComplete = TRUE;
    
    [self CheckStatus];
    //NSLog(blnResult?@"Sponsors: YES":@"Sponsors: NO");
}

- (void)SetVenues
{
    Shared *objShared = [Shared GetInstance];
    
    VenueDB *objVenueDB = [[VenueDB alloc] init];
    //    BOOL blnResult = [objVenueDB SetVenues:objData];
    //    NSLog(blnResult?@"Venues: YES":@"Venues: NO");
    
    //[arrExecuteQuery addObject:[objVenueDB SetVenues:objData]];
    [objShared.dictSqlQuery setObject:[objVenueDB SetVenues:objData] forKey:@"Venues"];
    blnSetVenuesComplete = TRUE;
    
    [self CheckStatus];
    
}

- (void)SetAgendas
{
    Shared *objShared = [Shared GetInstance];
    AgendaDB *objAgendaDB = [[AgendaDB alloc] init];
    //[arrExecuteQuery addObject:[objAgendaDB SetAgendas:objData]];
    [objShared.dictSqlQuery setObject:[objAgendaDB SetAgendas:objData] forKey:@"Agendas"];
    blnSetAgendasComplete = TRUE;
    
    [self CheckStatus];
    
    //BOOL blnResult = [objAgendaDB SetAgendas:objData];
    // NSLog(blnResult?@"Agendas: YES":@"Agendas: NO");
}


-(void)SetApplicationSetting
{
    NSError *error;
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    if([[dictData valueForKey:@"Settings"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"Settings"];
        NSLog(@"ApplicationSetting :yes");

//        NSFileManager *fileManger = [NSFileManager defaultManager];
//        
//        Shared *objShared = [Shared GetInstance];
//        
//        if([fileManger fileExistsAtPath:[objShared GetPListPath]])
//        {
//            NSMutableDictionary *dictPList = [NSMutableDictionary dictionaryWithContentsOfFile:[objShared GetPListPath]];
//            [dictPList setValue:dictData forKey:@"Settings"];
//            [dictPList writeToFile:[objShared GetPListPath] atomically:YES];
//        }
    }
    

}

-(void)GetInternetAccessData{
    NSError *error;
    
    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
    //NSLog(@"shuttle dict data%@",dictData);
    
    if([[dictData valueForKey:@"InternetAccessList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"InternetAccessList"];
        
        
    }
    
    
    NSLog(@"internetAccessData :%@",dictData);
    NSArray *arrInternetInfo = [dictData valueForKey:@"InternetAccessInfo"];
    
    //[APP.arrInternetAccessData addObject:dictData];
    //NSLog(@"internetdata111 is %@",APP.arrInternetAccessData);
    NSLog(@"*****************************************");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:arrInternetInfo forKey:@"InternetAccess"];
    
    
}


-(void)GetShuttleInfo:(NSData*) objShuttleData
{
    
    NSError *error;
   
    dictData = [NSJSONSerialization JSONObjectWithData:objShuttleData options:kNilOptions error:&error];
    //NSLog(@"shuttle dict data%@",dictData);
    
    if([[dictData valueForKey:@"ShuttleInfoList"] isKindOfClass:[NSDictionary class]])
    {
        dictData = [dictData valueForKey:@"ShuttleInfoList"];
        
        NSArray *pathsInfo = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [pathsInfo objectAtIndex:0];
        NSString *pathInfoData = [documentsDirectory stringByAppendingPathComponent:@"ShuttleData.txt"];
        //NSLog(@"recent path %@",pathInfoData);
        [objData writeToFile:pathInfoData atomically:YES];
        
        NSLog(@"shuttle :yes");
    }
    
    APP.dictShuttleData = [[NSMutableDictionary alloc]init];
    
    //AppDelegate * delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    

    NSMutableArray *ShuttleScheduleLArrayobj = [[NSMutableArray alloc]init];
    NSArray *ShuttleScheduleListArray  = [dictData objectForKey:@"ShuttleScheduleList"];
    
    for(NSDictionary *listDict in ShuttleScheduleListArray)
    {
        Shuttle *objShuttle = [[Shuttle alloc]init];
        
      	objShuttle.ShuttleScheduleId = [listDict objectForKey:@"ShuttleScheduleId"];
        
        NSLog(@" Id is %@",objShuttle.ShuttleScheduleId);
        
      	objShuttle.ShuttleDate = [listDict objectForKey:@"ShuttleDate"];
        
        NSLog(@"Shuttle Date is %@",objShuttle.ShuttleDate);
        
      	objShuttle.ShuttleDescription = [listDict objectForKey:@"ShuttleDescription"];
        
        NSLog(@"%@",objShuttle.ShuttleDescription);
        
        //NSLog(@"shuttle description %@",ShuttleDescription);
        objShuttle.ShuttleFormattedTime = [[NSMutableArray alloc]init];
        
      	NSArray  *DetailsArray = [listDict objectForKey:@"Details"];
        for(NSDictionary *detailsDict in DetailsArray){
            
            ShuttleTime *objShuttleTime = [[ShuttleTime alloc]init];
            
			objShuttleTime.ShuttleScheduleDetailId = [detailsDict objectForKey:@"ShuttleScheduleDetailId"];
            NSLog(@" Id is %@",objShuttleTime.ShuttleScheduleDetailId);
			objShuttleTime.FormattedTime = [detailsDict objectForKey:@"FormattedTime"];
            NSLog(@"shuttle time %@",objShuttleTime.FormattedTime);
			objShuttleTime.Detail = [detailsDict objectForKey:@"Detail"];
            NSLog(@"shuttle detail %@",objShuttleTime.Detail);
            NSLog(@"-------------");
            
            [objShuttle.ShuttleFormattedTime addObject:objShuttleTime];
            
           
        }
         [ShuttleScheduleLArrayobj addObject: objShuttle];
        NSLog(@".................");
        
    }
    
    [APP.dictShuttleData setObject:ShuttleScheduleLArrayobj forKey:@"Schedule"];
     NSLog(@"schedule data is %@",APP.dictShuttleData);
    
    //APP.shuttleRouteArrayobj = [[NSMutableArray alloc]init];
    NSMutableArray *shuttleRouteArrayobj = [[NSMutableArray alloc]init];
    NSArray *ShuttleRouteMapListArray = [dictData objectForKey:@"ShuttleRouteMapList"];
    
    for(NSDictionary *RouteMaplistDict in ShuttleRouteMapListArray)
    {
        ShuttleRouteMap *objShuttleRouteMap = [[ShuttleRouteMap alloc]init];
        
      	objShuttleRouteMap.ShuttleRouteMapId	= [RouteMaplistDict objectForKey:@"ShuttleRouteMapId"];
        NSLog(@" Route Id is %@",objShuttleRouteMap.ShuttleRouteMapId);
      	objShuttleRouteMap.MapURL = [RouteMaplistDict objectForKey:@"MapURL"];
        NSLog(@" mapurl is %@",objShuttleRouteMap.MapURL);
        objShuttleRouteMap.location = [[NSMutableArray alloc]init];
        
      	NSArray  *RouteMapLocationArray = [RouteMaplistDict objectForKey:@"Location"];
        
        for(NSDictionary *RouteMapLocationDict in RouteMapLocationArray){
            
            ShuttleRouteMapLocation *objShuttleRouteMapLocation = [[ShuttleRouteMapLocation alloc]init];
			objShuttleRouteMapLocation.LocationName 	= [RouteMapLocationDict objectForKey:@"LocationName"];
            NSLog(@"location is %@",objShuttleRouteMapLocation.LocationName);
            
			objShuttleRouteMapLocation.BriefDescription = [RouteMapLocationDict objectForKey:@"BriefDescription"];
            NSLog(@"brief description is %@",objShuttleRouteMapLocation.BriefDescription);
            
            [objShuttleRouteMap.location addObject: objShuttleRouteMapLocation];
			
        }
        [shuttleRouteArrayobj addObject: objShuttleRouteMap];
    }
    
    [APP.dictShuttleData setObject:shuttleRouteArrayobj forKey:@"RouteMap"];
     NSLog(@"Route data is %@",APP.dictShuttleData);
   
   // [standardDefaults setObject:shuttleRouteArrayobj forKey:@"shuttleRouteArray"];
    //APP.shuttleInfoArrayobj = [[NSMutableArray alloc]init];
    NSMutableArray *shuttleInfoArrayobj = [[NSMutableArray alloc]init];
    
    NSArray *ShuttleInfoListArray = [dictData objectForKey:@"ShuttleInfoList"];
    for(NSDictionary *ShuttleInfoListDict in ShuttleInfoListArray){
        shuttleInfo *objShuttleInfo = [[shuttleInfo alloc]init];
      	objShuttleInfo.strTitle	= [ShuttleInfoListDict objectForKey:@"Title"];
        NSLog(@"info title %@",objShuttleInfo.strTitle);
      	objShuttleInfo.strBriefDescription = [ShuttleInfoListDict objectForKey:@"BriefDescription1"];
         NSLog(@"info description %@",objShuttleInfo.strBriefDescription);
        objShuttleInfo.strBriefDescription2= [ShuttleInfoListDict objectForKey:@"BriefDescription2"];
        objShuttleInfo.Phone1	= [ShuttleInfoListDict objectForKey:@"Phone1"];
        objShuttleInfo.Phone2	= [ShuttleInfoListDict objectForKey:@"Phone2"];
        objShuttleInfo.Phone3	= [ShuttleInfoListDict objectForKey:@"Phone3"];
        objShuttleInfo.Phone1Text	= [ShuttleInfoListDict objectForKey:@"Phone1Text"];
        objShuttleInfo.Phone2Text	= [ShuttleInfoListDict objectForKey:@"Phone2Text"];
        objShuttleInfo.Phone3Text	= [ShuttleInfoListDict objectForKey:@"Phone3Text"];
        objShuttleInfo.Email1= [ShuttleInfoListDict objectForKey:@"Email1"];
        objShuttleInfo.Email2	= [ShuttleInfoListDict objectForKey:@"Email2"];
        objShuttleInfo.Email3	= [ShuttleInfoListDict objectForKey:@"Email3"];
        objShuttleInfo.Email1Text= [ShuttleInfoListDict objectForKey:@"Email1Text"];
        objShuttleInfo.Email2Text	= [ShuttleInfoListDict objectForKey:@"Email2Text"];
        objShuttleInfo.Email3Text	= [ShuttleInfoListDict objectForKey:@"Email3Text"];
        [shuttleInfoArrayobj addObject:objShuttleInfo];
        //NSLog(@"info data %@",APP.shuttleInfoArrayobj);
      
      
       
        
    }
    
    [APP.dictShuttleData setObject:shuttleInfoArrayobj forKey:@"Info"];
    
    NSLog(@"info data is %@",APP.dictShuttleData);
    
 //[standardDefaults setObject:shuttleInfoArrayobj forKey:@"shuttleInfoArray"];
   // [delegate.def synchronize];
    
    
}


- (void)SetConferences
{
    ConferenceDB *objConferenceDB = [[ConferenceDB alloc] init];
    BOOL blnResult = [objConferenceDB SetConferences:objData];
    NSLog(blnResult?@"Conferences: YES":@"Conferences: NO");
}

- (void)SetExhibitor
{
    Shared *objShared = [Shared GetInstance];
    ExhibitorDB *objExhibitorDB = [[ExhibitorDB alloc] init];
    //[arrExecuteQuery addObject:[objExhibitorDB SetExhibitor:objData]];
    [objShared.dictSqlQuery setObject:[objExhibitorDB SetExhibitor:objData] forKey:@"Exhibitor"];
    blnSetExhibitorsComplete = TRUE;
    
    [self CheckStatus];
    
    //    BOOL blnResult = [objExhibitorDB SetExhibitor:objData];
    //    NSLog(blnResult?@"Exhibitors: YES":@"Exhibitors: NO");
}

- (void)SetSessions
{
    Shared *objShared = [Shared GetInstance];
    SessionDB *objSessionDB = [[SessionDB alloc] init];
//    BOOL blnResult = [objSessionDB SetSessions:objData];
//    NSLog(blnResult?@"Sessions: YES":@"Sessions: NO");
    
    //[arrExecuteQuery addObject:[objSessionDB SetSessions:objData]];
    [objShared.dictSqlQuery setObject:[objSessionDB SetSessions:objData] forKey:@"Sessions"];
    blnSetSessionsComplete  = TRUE;
    
    [self CheckStatus];

}

- (void)SetMySessions
{
    MySessionDB *objMySessionDB = [[MySessionDB alloc] init];
    BOOL blnResult = [objMySessionDB SetMySessions:objData];
    NSLog(blnResult?@"My Sessions: YES":@"My Sessions: NO");
}

- (void)SetTracks
{
    MasterDB *objMasterDB = [[MasterDB alloc] init];
    BOOL blnResult = [objMasterDB SetTracks:objData];
    NSLog(blnResult?@"Tracks: YES":@"Tracks: NO");
}

- (void)SetSubTracks
{
    MasterDB *objMasterDB = [[MasterDB alloc] init];
    BOOL blnResult = [objMasterDB SetSubTracks:objData];
    NSLog(blnResult?@"Subtracks: YES":@"Subtracks: NO");
}

- (void)SetFilters
{
    Shared *objShared = [Shared GetInstance];
    //For Tracks, Products, SessionTypes, Industries
    MasterDB *objMasterDB = [[MasterDB alloc] init];
//    BOOL blnResult = [objMasterDB SetFilters:objData];
//    NSLog(blnResult?@"Filters : YES":@"Filters : NO");
    
    //[arrExecuteQuery addObject:[objMasterDB SetFilters:objData]];
    [objShared.dictSqlQuery setObject:[objMasterDB SetFilters:objData] forKey:@"Filters"];
    blnSetFiltersComplete = YES;
    
    [self CheckStatus];

}

- (void)SetFindLikeMindedFilter
{
    Shared *objShared = [Shared GetInstance];
    MasterDB *objMasterDB = [[MasterDB alloc] init];
    [objShared.dictSqlQuery setObject:[objMasterDB SetFindLikeMindedFilters:objData] forKey:@"FindLikeMindedFilter"];
    blnSetFindLikeMindedFilters = YES;
    
    [self CheckStatus];
    
}

- (void)SetCategories
{
    Shared *objShared = [Shared GetInstance];
    MasterDB *objMasterDB = [[MasterDB alloc] init];
    //BOOL blnResult = [objMasterDB SetCategories:objData];
    //NSLog(blnResult?@"Categories: YES":@"Categories: NO");
    
    //[arrExecuteQuery addObject:[objMasterDB SetCategories:objData]];
    [objShared.dictSqlQuery setObject:[objMasterDB SetCategories:objData] forKey:@"Categories"];
    blnSetCategoriesComplete = YES;
    
    [self CheckStatus];

}

- (void)SetRooms
{
    Shared *objShared = [Shared GetInstance];
    MasterDB *objMasterDB = [[MasterDB alloc] init];
//    BOOL blnResult = [objMasterDB SetRooms:objData];
//    NSLog(blnResult?@"Rooms: YES":@"Rooms: NO");
    
    //[arrExecuteQuery addObject:[objMasterDB SetRooms:objData]];
    [objShared.dictSqlQuery setObject:[objMasterDB SetRooms:objData] forKey:@"Rooms"];
    blnSetRoomsComplete = YES;
    
    [self CheckStatus];

}

- (void)SetSpeakers
{
    Shared *objShared = [Shared GetInstance];
    SpeakerDB *objSpeakerDB = [[SpeakerDB alloc] init];
    
    //[arrExecuteQuery addObject:[objSpeakerDB SetSpeakers:objData]];
    [objShared.dictSqlQuery setObject:[objSpeakerDB SetSpeakers:objData] forKey:@"Speakers"];
    blnSetSpeakersComplete = YES;
    
    [self CheckStatus];
    //NSLog(blnResult?@"Speakers YES":@"Speakers: NO");
}

- (void)SetAttendees
{
    Shared *objShared = [Shared GetInstance];
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc] init];
    BOOL blnResult = [objAttendeeDB SetAttendees:objData];
    NSLog(blnResult?@"Attendees: YES":@"Attendees: NO");
}

- (void)SetAttendeeExhibitors
{
    Shared *objShared = [Shared GetInstance];
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc] init];
    BOOL blnResult = [objAttendeeDB SetAttendeeExhibitors:objData];
    NSLog(blnResult?@"Attendee Exhibitor: YES":@"Attendee Exhibitor: NO");
}

- (void)SetEventInfoCategories
{
    Shared *objShared = [Shared GetInstance];
    MasterDB *objMasterDB = [[MasterDB alloc] init];
//    BOOL blnResult = [objMasterDB SetEventInfoCategories:objData];
//    NSLog(blnResult?@"EventInfo Categories: YES":@"EventInfo Categories: NO");
    
    //[arrExecuteQuery addObject:[objMasterDB SetEventInfoCategories:objData]];
    [objShared.dictSqlQuery setObject:[objMasterDB SetEventInfoCategories:objData] forKey:@"EventInfoCategories"];
    blnSetEventInfoCategoriesComplete = YES;
    
    [self CheckStatus];

}

- (void)SetEventInfoDetails
{
    Shared *objShared = [Shared GetInstance];
    MasterDB *objMasterDB = [[MasterDB alloc] init];
//    BOOL blnResult = [objMasterDB SetEventInfoDetails:objData];
//    NSLog(blnResult?@"EventInfo Details: YES":@"EventInfo Details: NO");
    
    //[arrExecuteQuery addObject:[objMasterDB SetEventInfoDetails:objData]];
    [objShared.dictSqlQuery setObject:[objMasterDB SetEventInfoDetails:objData] forKey:@"EventInfoDetails"];
    blnSetEventInfoDetailsComplete = YES;
    
    [self CheckStatus];

}

- (void)SetLostNFound
{
    Shared *objShared = [Shared GetInstance];
    EventInfoDB *objEventInfoDB = [[EventInfoDB alloc] init];
//    BOOL blnResult = [objEventInfoDB SetLostNFound:objData];
//    NSLog(blnResult?@"Lost &  Found: YES":@"Lost &  Found: NO");
    
    //[arrExecuteQuery addObject:[objEventInfoDB SetLostNFound:objData]];
    [objShared.dictSqlQuery setObject:[objEventInfoDB SetLostNFound:objData] forKey:@"LostNFound"];
    blnSetLostNFoundComplete = YES;
    
    [self CheckStatus];

}

- (void)SetEmergency
{
    Shared *objShared = [Shared GetInstance];
    EventInfoDB *objEventInfoDB = [[EventInfoDB alloc] init];
//    BOOL blnResult = [objEventInfoDB SetEmergencyHospitals:objData];
//    NSLog(blnResult?@"Emergency Hospitals: YES":@"Emergency Hospitals: NO");

    //[arrExecuteQuery addObject:[objEventInfoDB SetEmergencyHospitals:objData]];
    [objShared.dictSqlQuery setObject:[objEventInfoDB SetEmergencyHospitals:objData] forKey:@"EmergencyHospitals"];

    //objEventInfoDB = [[EventInfoDB alloc] init];
  // blnResult = [objEventInfoDB SetEmergencyOverview:objData];
    //[arrExecuteQuery addObject:[objEventInfoDB SetEmergencyOverview:objData]];
    [objShared.dictSqlQuery setObject:[objEventInfoDB SetEmergencyOverview:objData] forKey:@"EmergencyOverview"];
    
    //NSLog(blnResult?@"Emergency Overview: YES":@"Emergency Overview: NO");

   // objEventInfoDB = [[EventInfoDB alloc] init];
    //blnResult = [objEventInfoDB SetEmergencyFloorPlans:objData];
    //[arrExecuteQuery addObject:[objEventInfoDB SetEmergencyFloorPlans:objData]];
    [objShared.dictSqlQuery setObject:[objEventInfoDB SetEmergencyFloorPlans:objData] forKey:@"EmergencyFloorPlan"];
    //NSLog(blnResult?@"Emergency Floorplans: YES":@"Emergency Floorplans: NO");
    
    blnSetEmergencyComplete = YES;
    [self CheckStatus];
}

- (void)SetOnsiteService
{
    Shared *objShared = [Shared GetInstance];
    EventInfoDB *objEventInfoDB = [[EventInfoDB alloc] init];
//    BOOL blnResult = [objEventInfoDB SetOnsiteService:objData];
//    NSLog(blnResult?@"Onsite Service: YES":@"Onsite Service: NO");
    
    //[arrExecuteQuery addObject:[objEventInfoDB SetOnsiteService:objData]];
    [objShared.dictSqlQuery setObject:[objEventInfoDB SetOnsiteService:objData] forKey:@"OnsiteService"];
    blnSetOnsiteServiceComplete = YES;
    
    [self CheckStatus];

}

-  (void)SetAnnouncements
{
    AnnouncementDB *objAnnouncementDB = [[AnnouncementDB alloc] init];
    BOOL blnResult = [objAnnouncementDB SetAnnouncements:objData];
    NSLog(blnResult?@"Announcement : YES":@"Announcement : NO");
}

- (void)SetMessages
{
    MessagingDB *objMessagingDB = [[MessagingDB alloc] init];
    BOOL blnResult = [objMessagingDB SetMessages:objData];
    NSLog(blnResult?@"Messages: YES":@"Messages: NO");
}
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ExceptionHandler AddExceptionForScreen:strSCREEN_SYNC_UP MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];

    [self loadHome];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
    
    /*NSInteger intTag = (int)[connection getTag];
    NSNumber *tag = [NSNumber numberWithInteger:intTag];
    
    if([dictData objectForKey:tag] == nil)
    {
        NSMutableData *newData = [[NSMutableData alloc] initWithData:data];
        [dictData setObject:newData forKey:tag];
        return;
   }
    else
    {
        [[dictData objectForKey:tag] appendData:data];
    }*/
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (objData == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Data not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }{
    
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_BATCH_GET_VERSION_LIST:
            {
                NSLog(@"After Batch Version Call");
                [self CheckVersionAndUpdateData];
                
                [self UpdateData];
            }
            break;
        case OPER_BATCH_GET_CONVERGENCE_DTL:
            {
                //sushma
                blnSyncSponsors = NO;
                blnSyncVenues = NO;
                blnSyncAgendas = NO;
                blnSyncExhibitors = NO;
                blnSyncCategories = NO;
                blnSyncRooms = NO;
                blnSyncSpeakers = NO;
                blnSyncSessions = NO;
                blnSyncFilters = NO;
                blnSyncEventInfoCategories = NO;
                blnSyncEventInfoDetails = NO;
                blnSyncLostNFound = NO;
                blnSyncEmergency = NO;
                blnSyncOnsiteService = NO;//sushma
                arrExecuteQuery = [[NSMutableArray alloc]init];
                Shared *objShared = [Shared GetInstance];
                objShared.dictSqlQuery = [[NSMutableDictionary alloc]init];
                
                NSLog(@"After Batch Convergencve Detail Call");
                
//                [self SetSponsors];
//                [self SetVenues];
//                [self SetAgendas];
//                [self SetExhibitor];
//                [self SetCategories];
//                [self SetRooms];
//                [self SetSpeakers];
//                [self SetSessions];
//                [self SetFilters]; //For Tracks, Products, SessionTypes, Industries
//                [self SetEventInfoCategories];
//                [self SetEventInfoDetails];
//                [self SetLostNFound];
//                [self SetEmergency];
//                [self SetOnsiteService];
//                [self SetAnnouncements];
//                [self SetApplicationSetting];
                
                //[self SetAttendees];
                //[self SetAttendeeExhibitors];
                //[self SetTracks];
                //[self SetSubTracks];
                //[self SetMySessions];
                //[self SetMessages];
                //[self SetConferences]; //Not Used
                
                [self GetShuttleInfo:objData];
                [self GetInternetAccessData];
                [NSThread detachNewThreadSelector:@selector(SetSponsors) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetVenues) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetAgendas) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetExhibitor) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetRooms) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetSpeakers) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetSessions) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetFilters) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetEventInfoCategories) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetEventInfoDetails) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetLostNFound) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetEmergency) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetOnsiteService) toTarget:self withObject:nil];
                [NSThread detachNewThreadSelector:@selector(SetFindLikeMindedFilter) toTarget:self withObject:nil];

//                [self loadHome];
            }
            break;
        case OPER_GET_SPONSOR_LIST:
            {
                [self SetSponsors];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncVenues];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_VENUE_LIST:
            {
                [self SetVenues];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncAgendas];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_AGENDA_LIST:
            {
                [self SetAgendas];
                
                if(blnUseBatchUpdate == NO)
                {
                    //[self SyncConferences]; //Not Used
                    [self SyncExhibitors];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_EXHIBITOR_LIST:
            {
                [self SetExhibitor];
                
                if(blnUseBatchUpdate == NO)
                {
                    //[self SyncTracks];
                    [self SyncCategories];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_CATEGORY_LIST:
            {
                [self SetCategories];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncRooms];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_ROOMS_LIST:
            {
                [self SetRooms];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncSpeakers];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_SPEAKER_LIST:
            {
                [self SetSpeakers];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncSessions];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_SESSION_LIST:
            {
                [self SetSessions];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncSessionFilters];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_FILTER_LIST:
            {
                [self SetFilters]; //For Tracks, Products, SessionTypes, Industries
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncEventInfoCategories];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_EVENT_INFO_CATEGORY_LIST:
            {
                [self SetEventInfoCategories];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncEventInfoDetails];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_EVENT_INFO_DTL_LIST:
            {
                [self SetEventInfoDetails];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncLostFound];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_LOST_FOUND_LIST:
            {
                [self SetLostNFound];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncEmergency];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_EMERGENCY_LIST:
            {
                [self SetEmergency];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncOnsiteService];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_ONSITE_SERVICE_LIST:
            {
                [self SetOnsiteService];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncAnnouncements];
                }
                else
                {
                    [self UpdateData];
                }
            }
            break;
        case OPER_GET_ANNOUNCEMENT_LIST:
            {
                [self SetAnnouncements];
                
                if(blnUseBatchUpdate == NO)
                {
                    [self SyncAttendees];
                }
                else
                {
                    [self loadHome];
                }
            }
            break;
        case OPER_GET_ANTENDEE_LIST:
            {
                [self SetAttendees];
                [self SyncAttendeeExhibitor];
            }
            break;
        case OPER_GET_ATTENDEE_EXHIBITOR_LIST:
            {
                [self SetAttendeeExhibitors];
                //[self SyncTracks];
                [self SyncMySessions];
            }
            break;
        case OPER_GET_TRACKS_LIST:
            {
                [self SetTracks];
                [self SyncSubTracks];
            }
            break;
        case OPER_GET_SUB_TRACKS_LIST:
            {
                [self SetSubTracks];
                [self SyncMySessions];
            }
            break;
        case OPER_GET_MY_SESSION_LIST:
            {
                [self SetMySessions];
                [self SyncMessages];
            }
            break;
        case OPER_GET_MESSAGING_LIST:
            {
                [self SetMessages];
                [self loadHome];
            }
            break;
        case OPER_GET_USER_NOTES_LIST:
            {
                //NSError *error;
                //NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
                //NSLog(@"Response: %@",strData);
                //NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
                //dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:&error];
                
             	//[{"LocalId":"3c932a98-a9d0-4047-8e73-080854f244d9","NoteDBId":0,"SessionInstanceId":"dfsdf","AddedDateTime":"9/25/2013 2:11:54 PM","UserEmail":"email address","Title":"sample title","Content":"saplecontent","IsAdded":true,"IsUpdated":false,"IsDeleted":false}]
                
                User *objUser = [User GetInstance];
                NSLog(@"%@",[objUser GetAccountEmail]);
                
                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"yyyy-MM-dd"];
                NSDate *dtDate = [NSDate date];
                NSString *strDate = [dateFormater stringFromDate:dtDate];

                NSMutableDictionary *objTemp = [[NSMutableDictionary alloc] init];
                [objTemp setObject:[Functions GetGUID] forKey:@"LocalId"];
                [objTemp setObject:@2 forKey:@"NoteDBId"];
                [objTemp setObject:@"85a354d7-c414-e311-b39a-00155d5066d7" forKey:@"SessionInstanceId"];
                [objTemp setObject:strDate forKey:@"AddedDateTime"];
                [objTemp setObject:[objUser GetAccountEmail] forKey:@"UserEmail"];
                [objTemp setObject:@"Test Note - Title" forKey:@"Title"];
                [objTemp setObject:@"Test Note - Content" forKey:@"Content"];
                [objTemp setObject:[NSNumber numberWithBool:true] forKey:@"IsAdded"];
                [objTemp setObject:[NSNumber numberWithBool:false] forKey:@"IsUpdated"];
                [objTemp setObject:[NSNumber numberWithBool:false] forKey:@"IsDeleted"];
                
                NSArray *arrtemp = [[NSArray alloc] initWithObjects:objTemp,nil];
                
                //NSString *strTemp = [objTemp JSONRepresentation];
                NSString *strTemp = [arrtemp JSONRepresentation];
                
                NSString *strURL = strAPI_URL;
                strURL = [strURL stringByAppendingString:strAPI_NOTES_ADD_NOTE];
                
                NSURL *URL = [NSURL URLWithString:strURL];
                
                NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
                [objRequest setHTTPMethod:@"POST"];
                [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
                //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
                [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
                [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
                [objRequest addValue:strTemp forHTTPHeaderField:@"NotesJSON"];
               
                objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_NOTE_LIST];
                
                //[self loadHome];
            }
            break;
        case OPER_GET_CONFERENCE_LIST:
            {
                [self SetConferences];
                [self loadHome];
            }
            break;
        default:
            break;
    }
    }
}

-(void)CheckStatus
{
    Shared *objShared = [Shared GetInstance];
    if([objShared GetFirstTimeUse])
    {
        //Shared *objShared = [Shared GetInstance];
        
        if (blnSetSponsorsComplete && blnSetSpeakersComplete && blnSetVenuesComplete && blnSetAgendasComplete && blnSetExhibitorsComplete && blnSetRoomsComplete && blnSetSessionsComplete &&& blnSetFiltersComplete && blnSetEventInfoCategoriesComplete && blnSetEventInfoDetailsComplete && blnSetLostNFoundComplete && blnSetEmergencyComplete && blnSetOnsiteServiceComplete && blnSetFindLikeMindedFilters)
        {
            sqlite3 *dbEMEAFY14;
            
            dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
            
            sqlite3_stmt *compiledStmt;
            
            for (id key in objShared.dictSqlQuery)
            {
                
                NSLog(@"%@",key);
                NSString *  keyStr=key;
                
                [NSThread detachNewThreadSelector:@selector(setKey:) toTarget:self withObject:keyStr];
                
                for (NSString *strSQL in [objShared.dictSqlQuery valueForKey:key])
                {
                    
                    if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
                    {
                        NSLog(@"Error while creating insert statement. %s %@",sqlite3_errmsg(dbEMEAFY14),strSQL);
                    }
                    else
                    {
                        if(SQLITE_DONE != sqlite3_step(compiledStmt))
                        {
                            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
                        }
                    }
                }
                //            }
            }
            
            
            [objShared SetFirstTimeUse:NO];
            [self loadHome];
        }
    }
    else if ((blnSyncSponsors) || (blnSyncVenues) || (blnSyncAgendas) || (blnSyncExhibitors) || (blnSyncSessions && blnSyncCategories && blnSyncRooms && blnSyncSpeakers && blnSyncFilters) || (blnSyncEventInfoCategories && blnSyncEventInfoDetails && blnSyncLostNFound && blnSyncEmergency && blnSyncOnsiteService))
    {
        [objShared SetFirstTimeUse:NO];
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        
        for (id key in objShared.dictSqlQuery)
        {
            for (NSString *strSQL in [objShared.dictSqlQuery valueForKey:key])
            {
                
                if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
                {
                    NSLog(@"Error while creating insert statement. %s %@",sqlite3_errmsg(dbEMEAFY14),strSQL);
                }
                else
                {
                    if(SQLITE_DONE != sqlite3_step(compiledStmt))
                    {
                        NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
                    }
                }
            }
            //            }
        }
        
        
        
        [self loadHome];
    }
}


-(void)setKey:(NSString *)strKey//sushma
{
    lblText.text=[NSString stringWithFormat:@"Loading %@ ",strKey];
    
}

//sushma
/*
-(void)CheckStatus
{
    //
    //    if (blnSetSponsorsComplete && blnSetVenuesComplete && blnSetAgendasComplete && blnSetExhibitorsComplete && blnSetCategoriesComplete && blnSetRoomsComplete && blnSetSpeakersComplete && blnSetSessionsComplete && blnSetFiltersComplete && blnSetEventInfoCategoriesComplete && blnSetEventInfoDetailsComplete && blnSetLostNFoundComplete && blnSetEmergencyComplete && blnSetOnsiteServiceComplete)
    //    {
    //        [self loadHome];
    //    }
    
    Shared *objShared = [Shared GetInstance];
    
    if (blnSetSponsorsComplete && blnSetSpeakersComplete && blnSetVenuesComplete && blnSetAgendasComplete && blnSetExhibitorsComplete && blnSetRoomsComplete && blnSetSessionsComplete &&& blnSetFiltersComplete && blnSetEventInfoCategoriesComplete && blnSetEventInfoDetailsComplete && blnSetLostNFoundComplete && blnSetEmergencyComplete && blnSetOnsiteServiceComplete && blnSetFindLikeMindedFilters)
    {
        sqlite3 *dbEMEAFY14;
        
        dbEMEAFY14 = [[DB GetInstance] OpenDatabase];
        
        sqlite3_stmt *compiledStmt;
        
        for (id key in objShared.dictSqlQuery)
        {
//            if ([key isEqualToString:@"Sessions"] || [key isEqualToString:@"Categories"] || [key isEqualToString:@"Speaker"] || [key isEqualToString:@"Filters"] )
//            {
            
                for (NSString *strSQL in [objShared.dictSqlQuery valueForKey:key])
                {
                    
                    if(sqlite3_prepare_v2(dbEMEAFY14, [strSQL UTF8String], -1, &compiledStmt, NULL) != SQLITE_OK)
                    {
                        NSLog(@"Error while creating insert statement. %s %@",sqlite3_errmsg(dbEMEAFY14),strSQL);
                    }
                    else
                    {
                        if(SQLITE_DONE != sqlite3_step(compiledStmt))
                        {
                            NSLog(@"Error while creating insert statement. %s",sqlite3_errmsg(dbEMEAFY14));
                        }
                    }
                }
//            }
        }
        
        
        
        [self loadHome];
    }
}
*/
#pragma mark -
- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}
@end
