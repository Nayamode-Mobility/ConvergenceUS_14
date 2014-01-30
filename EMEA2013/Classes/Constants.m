//
//  Constants.m
//  iPadAppELC
//
//  Created by Hitesh Merchant on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

/*
NSString *const striPhoneSimulator = @"iPhone Simulator";
NSString *const striPadSimulator = @"iPad Simulator";
NSString *const striPhone = @"iPhone";
NSString *const striPad = @"iPad";
NSString *const striPod = @"iPod touch";
*/

NSString *const strADFS_TO = @"https://corp.sts.microsoft.com/adfs/services/trust/13/UsernameMixed";

//Not with PUID OR PartnerImmutableID
//NSString *const strADFS_APPLY_TO = @"https://activedirectory.windowsazure.com";

//With PUID OR PartnerImmutableID
NSString *const strADFS_APPLY_TO = @"https://mgxacs.accesscontrol.windows.net";

NSString *const strADFS_END_POINT_URL = @"https://corp.sts.microsoft.com/adfs/services/trust/13/UsernameMixed";

NSString *const strAPI_AUTH_TOKEN = @"24174741-7c94-4fd6-9e77-3cbeb4e99fc1";

#ifdef _TEST_ENV
NSString *const strLIVESDK_CLIENT_ID = @"000000004811066E";
#else  // RKL_APPEND_TO_ICU_FUNCTIONS
NSString *const strLIVESDK_CLIENT_ID = @"000000004811066E";
#endif // RKL_APPEND_TO_ICU_FUNCTIONS

#ifdef _TEST_ENV
NSString *const strAPI_URL = @"http://convergenceusapistaging.cloudapp.net/";
#else
NSString *const strAPI_URL = @"http://convergenceusapistaging.cloudapp.net/";
#endif
/*batch urls start*/
NSString *const strAPI_BATCH_GET_VERSION_LIST = @"api/Batch/GetBatchVersionList";
NSString *const strAPI_BATCH_GET_CONVERGENCE_DTL = @"api/Batch/GetAllConvergenceDetails";
NSString *const strAPI_BATCH_GET_SessionBatchDetails = @"api/Batch/GetSessionBatchDetails";
NSString *const strAPI_BATCH_GET_EvaluationBatchDetails = @"api/Batch/GetEvaluationBatchDetails";
NSString *const strAPI_BATCH_GET_EventInfoBatchDetails = @"api/Batch/GetEventInfoBatchDetails";
NSString *const strAPI_BATCH_GET_SponsorBatchDetails = @"api/Batch/GetSponsorBatchDetails";
NSString *const strAPI_BATCH_GET_ExhibitorBatchDetails = @"api/Batch/GetExhibitorBatchDetails";
NSString *const strAPI_BATCH_GET_VenueBatchDetails = @"api/Batch/GetVenueBatchDetails";
NSString *const strAPI_BATCH_GET_AgendaBatchDetails = @"api/Batch/GetAgendaBatchDetails";
NSString *const strAPI_BATCH_GET_AnnouncementBatchDetails = @"api/Batch/GetAnnouncementBatchDetails";
/*batch*/

/*Video*/
NSString *const strAPI_VIDEO_GET_OverallVideos = @"api/Video/GetOverallVideos";
NSString *const strAPI_VIDEO_AddVideoRating = @"api/Video/AddVideoRating";
NSString *const strAPI_VIDEO_AddVideoComment = @"api/Video/AddVideoComment";
NSString *const strAPI_VIDEO_DeleteVideoComment = @"api/Video/DeleteVideoComment";
NSString *const strAPI_VIDEO_Get_VideoBySessionInstanceId = @"api/Video/GetVideoBySessionInstanceId";
/*Video*/

NSString *const strAPI_ATTENDEE_VALIDATE_DOMAIN_ATTENDEE = @"api/Attendee/ValidateDomainAttendee";
NSString *const strAPI_ATTENDEE_VALIDATE_MS_ATTENDEE = @"api/Attendee/ValidateMicrosoftAttendee";

NSString *const strAPI_SPONSOR_GET_SPONSOR_LIST = @"api/Sponsor/GetSponsorList";

NSString *const strAPI_VENUE_GET_VENUE_LIST = @"api/Venue/GetVenueList";

NSString *const strAPI_CONFERENCE_GET_CONFERENCE_LIST = @"api/Conference/GetConferenceList";
NSString *const strAPI_CONFERENCE_GET_AGENDA_LIST = @"api/ConferenceAgenda/GetAgendaList";

NSString *const strAPI_ATTENDEE_GET_ATTENDEE_LIST = @"api/Attendee/GetAttendeeList";
NSString *const strAPI_ATTENDEE_SET_PRIVACY = @"api/Attendee/SetPrivacy";
NSString *const strAPI_ATTENDEE_GET_PRIVACY = @"api/Attendee/GetPrivacySettings";
NSString *const strAPI_ATTENDEE_GET_MESSAGING_LIST = @"api/Attendee/GetInboxandSentMessages";
NSString *const strAPI_ATTENDEE_ADD_MESSAGE = @"api/Attendee/AddMessage";
NSString *const strAPI_ATTENDEE_DELETE_INBOX_MESSAGE = @"api/Attendee/DeleteInboxMessage";
NSString *const strAPI_ATTENDEE_DELETE_SENTBOX_MESSAGE = @"api/Attendee/DeleteSentboxMessage";
NSString *const strAPI_ATTENDEE_AskToSpeakers = @"api/Attendee/AskToSpeakers";
NSString *const strAPI_ATTENDEE_GET_ATTENDEE_FAV_LIST = @"api/Attendee/GetFavouriteAttendeesList";
NSString *const strAPI_ATTENDEE_SAVE_FAV_ATTENDEE = @"api/Attendee/AddFavouriteAttendee";
NSString *const strAPI_ATTENDEE_DELETE_FAV_ATTENDEE = @"api/Attendee/DeleteFavouriteAttendeeByEmail";


NSString *const strAPI_SESSION_GET_SESSION_LIST = @"api/Session/GetSessionList";
NSString *const strAPI_SESSION_GET_SPEAKER_LIST = @"api/Session/GetSpeakerList";
NSString *const strAPI_SESSION_GET_TRACKS_LIST = @"api/Session/GetTrackList";
NSString *const strAPI_SESSION_GET_SUB_TRACKS_LIST = @"api/Session/GetSubTrackList";
NSString *const strAPI_SESSION_GET_CATEGORY_LIST = @"api/Session/GetSessionCategoryList";
NSString *const strAPI_SESSION_GET_ROOMS_LIST = @"api/Session/GetRoomList";
NSString *const strAPI_SESSION_GET_MY_SESSION_LIST = @"api/Session/GetAttendeeScheduleList";
NSString *const strAPI_SESSION_ADD_MY_SESSION_LIST = @"api/Session/AddAttendeeSchedule";
NSString *const strAPI_SESSION_GET_FILTER_LIST = @"api/Session/GetFilterTypeList";
NSString *const strAPI_SESSION_SYNC_MY_SESSION_LIST = @"api/Session/SyncAttendeeSchedule";

NSString *const strAPI_EXHIBITOR_GET_EXHIBITOR_LIST = @"api/Exhibitor/GetExhibitorList";
NSString *const strAPI_EXHIBITOR_GET_ATTENDEE_EXHIBITOR_LIST = @"api/Exhibitor/GetAttendeeExhibitorsList";
NSString *const strAPI_EXHIBITOR_ADD_EXHIBITOR = @"api/Exhibitor/AddExhibitor";
NSString *const strAPI_EXHIBITOR_DELETE_EXHIBITOR = @"api/Exhibitor/DeleteAttendeeExhibitor";
NSString *const strAPI_EXHIBITOR_DELETE_EXHIBITOR_BY_CODE = @"api/Exhibitor/DeleteAttendeeExhibitorByCode";

NSString *const strAPI_EVENT_INFO_GET_EMERGENCY_LIST = @"api/EventInfo/GetEmergencyList";
NSString *const strAPI_EVENT_INFO_GET_SHUTTLE_SCHEDULE_LIST = @"api/EventInfo/GetShuttleScheduleList";
NSString *const strAPI_EVENT_INFO_GET_LOST_FOUND_LIST = @"api/EventInfo/GetLostAndFoundInfoList";
NSString *const strAPI_EVENT_INFO_GET_FAQ_LIST = @"api/EventInfo/GetFAQList";
NSString *const strAPI_EVENT_INFO_GET_ONSITE_SERVICE_LIST = @"api/EventInfo/GetOnSiteServiceList";
NSString *const strAPI_EVENT_INFO_GET_DETAIL_LIST = @"api/EventInfo/GetEventInfoDetailList";
NSString *const strAPI_EVENT_INFO_GET_CATEGORY_LIST = @"api/EventInfo/GetEventInfoCategoryList";

NSString *const strAPI_NOTES_ADD_NOTE = @"api/Notes/SyncNotes";
NSString *const strAPI_NOTES_GET_SESSION_NOTES_LIST = @"api/Notes/GetNotesSessionWise";
NSString *const strAPI_NOTES_GET_USER_NOTES_LIST = @"api/Notes/GetNotesUserWise";
NSString *const strAPI_NOTES_ADD_ATTENDEE_NOTES = @"api/Notes/AddAttendeeNote";
NSString *const strAPI_NOTES_DELETE_ATTENDEE_NOTES = @"api/Notes/DeleteAttendeeNotesByEmail";
NSString *const strAPI_NOTES_SYNC_ATTENDEE_NOTES = @"api/Notes/SyncAttendeeNotes";


NSString *const strAPI_ANNOUNCEMENT_GET_ANNOUNCEMENT_LIST = @"api/Announcement/GetAnnouncementList";

NSString *const strAPI_ANALYITC_ADD_ANALYTIC = @"api/Analytics/AddAnalytic";
NSString *const strAPI_ERROR_LOG_ERROR = @"api/ErrorLog/LogError";

#ifdef _TEST_ENV
NSString *const strAPI_OLD_PHOTOS_UPLOAD = @"http://goconvergence.cloudapp.net/uat/upload/upload";
NSString *const strAPI_OLD_PHOTOS_UPLOAD_THUMB = @"http://goconvergence.cloudapp.net/uat/Upload/UploadThumbnail";
#else
NSString *const strAPI_OLD_PHOTOS_UPLOAD = @"http://goconvergence.cloudapp.net/cms/upload/upload";
NSString *const strAPI_OLD_PHOTOS_UPLOAD_THUMB = @"http://goconvergence.cloudapp.net/cms/Upload/UploadThumbnail";
#endif

NSString *const strAPI_PHOTOS_UPLOAD = @"api/Upload/PostUploadPhoto";//http://goconvergence.cloudapp.net/cms/upload/upload";
NSString *const strAPI_PHOTOS_UPLOAD_THUMB = @"api/Upload/PostUploadThumbnail";//http://goconvergence.cloudapp.net/cms/Upload/UploadThumbnail";
NSString *const strAPI_PHOTOS_GET_RECENT_FOR_DASHBOARD = @"api/PhotoGallery/GetRecentPhotosForDashboard";
NSString *const strAPI_PHOTOS_GET_SEARCH_PHOTO = @"api/PhotoGallery/GetSearchedPhotos";
NSString *const strAPI_PHOTOS_GET_RECENT_PHOTO = @"api/PhotoGallery/GetRecentPhotos";
NSString *const strAPI_PHOTOS_DELETE_PHOTO = @"api/PhotoGallery/DeletePhoto";
NSString *const strAPI_PHOTOS_ADD_PHOTO_LIKE = @"api/PhotoGallery/AddPhotoLike";
NSString *const strAPI_PHOTOS_USERWISE_UPLOAD = @"/api/PhotoGallery/GetUserwiseUploadedPhotoCount";
NSString *const strAPI_PHOTOS_GET_UPLOADS = @"api/PhotoGallery/GetUploadedPhotos";
NSString *const strAPI_PHOTOS_GET_POPULAR_PHOTO =  @"api/PhotoGallery/GetPopularPhotos";
NSString *const strAPI_PHOTOS_ADD_PHOTO_COMMENT = @"api/PhotoGallery/AddPhotoComment";
NSString *const strAPI_PHOTOS_GET_PHOTO_COMMENT_LIST = @"api/PhotoGallery/GetPhotoCommentList";
NSString *const strAPI_PHOTOS_GET_PHOTO_LIKES_COMMENTS_COUNT = @"api/PhotoGallery/GetPhotoLikesCommentsCount";
NSString *const strAPI_PHOTOS_GET_PHOTO_LIKE_STATUS = @"api/PhotoGallery/GetPhotoLikeStatus";
NSString *const strAPI_PHOTOS_UPDATE_PHOTO_LIKE = @"api/PhotoGallery/UpdatePhotoLikeStatus";
NSString *const strAPI_PHOTOS_GET_SEARCH_PHOTO_USERWISE = @"api/PhotoGallery/SearchPhotoUserwise";
NSString *const strAPI_PHOTOS_GET_SEARCH_PHOTO_HASHTAG = @"api/PhotoGallery/GetHashTagPhoto";

NSString *const strLIVESDK_INIT = @"init";
NSString *const strLIVESDK_LOGIN = @"login";
NSString *const strLIVESDK_LOGOUT = @"logout";
NSString *const strLIVESDK_GETME = @"me";

NSString *const strAPP_SETTINGS_SET_PRIVACY = @"SetPrivacy";
NSString *const strAPP_SETTINGS_LIVEID_AUTHENTICATION_TOKEN = @"LiveIDAuthenticationToken";
NSString *const strAPP_SETTINGS_LIVEID_LINK = @"LiveIDLink";
NSString *const strAPP_SETTINGS_ACCOUNT_EMAIL = @"AccountEmail";
NSString *const strAPP_SETTINGS_PUID = @"PUID";
NSString *const strAPP_SETTINGS_PRIMARY_GROUP_SID = @"PrimaryGroupSID";
NSString *const strAPP_SETTINGS_PRIMARY_SID = @"PrimarySID";
NSString *const strAPP_SETTINGS_ALIAS = @"Alias";
NSString *const strAPP_SETTINGS_UPN = @"UPN";
NSString *const strAPP_SETTINGS_USE_BATCH_UPDATE = @"UseBatchUpdate";

//NSInteger const intOPER_VALIDATE_MS_ATTENDEE = 1;
//NSInteger const intOPER_GET_SPONSOR_LIST = 2;

// Set the CLIENT_ID value to be the one you get from http://manage.dev.live.com/

NSString *const strLIVESDK_SCOPES = @"wl.signin wl.basic wl.work_profile wl.emails";

NSString *const strKEY_VERSION_NO = @"VersionNo";

NSString *const strDOC_TYPE_PDF_IMG = @"pdf_icon";
NSString *const strDOC_TYPE_DOC_IMG = @"excel_icon";
NSString *const strDOC_TYPE_XLS_IMG = @"excel_icon";
NSString *const strDOC_TYPE_PPT_IMG = @"powerpoint_icon";

NSString *const strDOC_TYPE_PDF = @"PDF";
NSString *const strDOC_TYPE_DOC = @"DOC";
NSString *const strDOC_TYPE_DOCX = @"DOCX";
NSString *const strDOC_TYPE_XLS = @"XLS";
NSString *const strDOC_TYPE_XLSX = @"XLSX";
NSString *const strDOC_TYPE_PPT = @"PPT";
NSString *const strDOC_TYPE_PPTX = @"PPTX";

NSUInteger const intEVENT_INFO_CATEGORY_ONSITE_SERVICES = 5;
NSUInteger const intEVENT_INFO_CATEGORY_ATTENDEE_MEALS = 8;
NSUInteger const intEVENT_INFO_CATEGORY_SPEACIALTY_MEALS = 9;
NSUInteger const intEVENT_INFO_CATEGORY_CONFERENCE_SECURITY = 10;
NSUInteger const intEVENT_INFO_CATEGORY_LUGGAGE = 11;
NSUInteger const intEVENT_INFO_CATEGORY_MS_IT_TECH_LINKS = 12;
NSUInteger const intEVENT_INFO_CATEGORY_FAQ = 3;
NSUInteger const intEVENT_INFO_CATEGORY_MEALS = 4;

NSString *const strEVENT_INFO_CATEGORY_ONSITE_SERVICES = @"OSS";
//NSString *const strEVENT_INFO_CATEGORY_ATTENDEE_MEALS;
//NSString *const strEVENT_INFO_CATEGORY_SPEACIALTY_MEALS;
//NSString *const strEVENT_INFO_CATEGORY_CONFERENCE_SECURITY;
//NSString *const strEVENT_INFO_CATEGORY_LUGGAGE;
//NSString *const strEVENT_INFO_CATEGORY_MS_IT_TECH_LINKS;
NSString *const strEVENT_INFO_CATEGORY_FAQ = @"FAQ";
NSString *const strEVENT_INFO_CATEGORY_MEALS = @"MEALS";


NSString *const strAPI_EVALUATION_GETEVALUATIONLIST=@"api/Evaluation/GetEvaluationList";
NSString *const strAPI_EVALUATION_GETOVERALLEVALUATIONLIST=@"api/Evaluation/GetOverallEvaluationList";
NSString *const strAPI_EVALUATION_GETSESSIONWISEEVALUATIONLIST=@"api/Evaluation/GetSessionWiseEvaluationList";
NSString *const strAPI_EVALUATION_GETEVALUATIONLISTBYSESSIONINSTANCEID=@"api/Evaluation/GetEvaluationListBySessionInstanceId";
NSString *const strAPI_EVALUATION_GETEVALUATIONLISTBYCATEGORYINSTANCEID=@"api/Evaluation/GetEvaluationListByCategoryInstanceId";
NSString *const strAPI_EVALUATION_SUBMITEVALUATION=@"api/Evaluation/SubmitEvaluation";


// Newly Added

NSString *const strAPI_ATTENDEE_SEARCH_ATTENDEE = @"api/Attendee/SearchAttendeeByLikeMindedFilters";

NSString *const strUSER_DEFAULT_KEY_USER_INFO = @"UserInfo";

NSString *const strSCREEN_AGENDA = @"Agenda";
NSString *const strSCREEN_ANNOUNCEMENT = @"Announcements";
NSString *const strSCREEN_ATTENDEE = @"Attendee";
NSString *const strSCREEN_ATTENDEE_EXHIBITOR = @"AttendeeExhibitors";
NSString *const strSCREEN_CATEGORIES = @"Categories";
NSString *const strSCREEN_CONFERENCE = @"Conference";
NSString *const strSCREEN_CONFERENCE_AGENDA = @"ConferenceAgenda";
NSString *const strSCREEN_EMERGENCY = @"Emergency";
NSString *const strSCREEN_EVALUATION = @"Evaluation";
NSString *const strSCREEN_EVENT_INFO_CATEGORIES = @"EventInfoCategories";
NSString *const strSCREEN_EVENT_INFO_DTL = @"EventInfoDetails";
NSString *const strSCREEN_EXHIBITOR = @"Exhibitors";
NSString *const strSCREEN_FAQ = @"FAQ";
NSString *const strSCREEN_FILTER = @"Filters";
NSString *const strSCREEN_LOST_FOUND = @"LostFound";
NSString *const strSCREEN_MY_CONFERENCE = @"MyConference";
NSString *const strSCREEN_MY_SCHEDULE = @"MySchedule";
NSString *const strSCREEN_ONSITE_SERVICE = @"OnsiteService";
NSString *const strSCREEN_PHOTO = @"Photo";
NSString *const strSCREEN_ROOMS = @"Rooms";
NSString *const strSCREEN_SESSION = @"Session";
NSString *const strSCREEN_SPEAKER = @"Speaker";
NSString *const strSCREEN_SPONSOR = @"Sponsor";
NSString *const strSCREEN_SUB_TRACK = @"SubTracks";
NSString *const strSCREEN_TRACK = @"Tracks";
NSString *const strSCREEN_USER_NOTE = @"UserNotes";
NSString *const strSCREEN_VENUE = @"Venue";

NSString *const strSCREEN_MEALS = @"Meals";
NSString *const strSCREEN_EXPO_MAPS = @"ExpoMaps";

NSString *const strSCREEN_HAPPENING_NOW = @"HappeningNow";

NSString *const strSCREEN_SOCIAL_MEDIA = @"SocialMedia";
NSString *const strSCREEN_SOCIAL_MEDIA_LINKEDIN = @"SocialMediaLinkedIn";
NSString *const strSCREEN_SOCIAL_MEDIA_FACEBOOK = @"SocialMediaFacebook";
NSString *const strSCREEN_SOCIAL_MEDIA_TWITTER = @"SocialMediaTwitter";

NSString *const strSCREEN_INTERNET_ACCESS = @"InternetAccess";
NSString *const strSCREEN_CITY_GUIDE = @"CityGuide";
NSString *const strSCREEN_CITY_GUIDE_MAP = @"CityGuideMap";
NSString *const strSCREEN_SYNC_UP = @"Syncup";
NSString *const strSCREEN_LOGON = @"Logon";
NSString *const strSCREEN_ADFS_LOGON = @"ADFSLogon";
NSString *const strSCREEN_SETTINGS = @"Optin";
NSString *const strSCREEN_GLOBAL_SEARCH = @"GlobalSearch";

NSString *const strSCREEN_ABOUTUS = @"AboutUs";
NSString *const strSCREEN_CONTACTUS = @"ContactUs";
NSString *const strSCREEN_SUPPORT = @"Support";
NSString *const strSCREEN_MDPN = @"MDPN";
NSString *const strSCREEN_TERMS = @"TermsOfUse";
NSString *const strSCREEN_PRIVACY_POLICY = @"PrivacyPolicy";

NSString *const strSCREEN_HOME = @"Home";

NSString *const strNoInternetError = @"You need to have internet connection to proceed further.";
@implementation Constants
@end
