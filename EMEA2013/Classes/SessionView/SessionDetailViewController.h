//
//  SessionDetailViewController.h
//  mgx2013
//
//  Created by Amit Karande on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>


#import "Session.h"
#import "SessionNoteViewController.h"

@interface SessionDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
{
}


// Newly Added

@property (strong, nonatomic) IBOutlet UILabel *videodescLbl;
@property  MPMoviePlayerViewController *objMoviePlalyer;

//************


@property (nonatomic, retain) SessionNoteViewController *objSessionNoteViewController;

@property (nonatomic, retain) Session *sessionData;
@property (nonatomic) NSInteger intTag;
@property (strong, nonatomic) NSArray *arrSessionResources;
@property (strong, nonatomic) NSArray *arrSessionSpeakers;

@property (nonatomic) NSString *strEventID;

@property (strong, nonatomic) IBOutlet UILabel *lblSessionCode;
@property (strong, nonatomic) IBOutlet UILabel *lblSessionTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblRoom;
@property (strong, nonatomic) IBOutlet UILabel *lblTiming;
@property (strong, nonatomic) IBOutlet UILabel *lblAbstract;

@property (strong, nonatomic) IBOutlet UIImageView *imgSpeakerPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerName;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerCompany;

@property (strong, nonatomic) IBOutlet UIImageView *imgLocation;

@property (strong, nonatomic) IBOutlet UIScrollView *svwSessionDetail;

@property (strong, nonatomic) IBOutlet UICollectionView *colSessionResources;

@property (strong, nonatomic) IBOutlet UIView *vwAddToMySchedule;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToMySchedule;

@property (strong, nonatomic) IBOutlet UIView *vwAddToMyCalendar;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToMyCalendar;

@property (strong, nonatomic) IBOutlet UIView *vwRemoveFromMySchedule;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveFromMySchedule;

@property (strong, nonatomic) IBOutlet UIView *vwRemoveFromMyCalendar;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveFromMyCalendar;

@property (strong, nonatomic) IBOutlet UIButton *btnEvaluation;
@property (strong, nonatomic) IBOutlet UIButton *btnTakeNotes;
@property (strong, nonatomic) IBOutlet UIButton *btnViewNotes;

@property (strong, nonatomic) IBOutlet UIButton *btnSessionQA;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (strong, nonatomic) IBOutlet UICollectionView *colTwitterFeeds;
@property (nonatomic, retain) NSMutableArray *arrTweets;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *lblSessionCategories;

@property (strong, nonatomic) IBOutlet UIScrollView *svwSessionOverview;
@property (strong, nonatomic) IBOutlet UIView *vwSessionOverview;

@property (strong, nonatomic) IBOutlet UIButton *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnLinkedIn;
@property (strong, nonatomic) IBOutlet UIButton *btnTwitter;
@property (strong, nonatomic) IBOutlet UIView *vwSocialMedia;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingVenurFloorPlan;
@property (strong, nonatomic) IBOutlet UIView *vwLoadingFeeds;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoadingFeeds;
@property (strong, nonatomic) IBOutlet UILabel *lblNoFeeds;


- (IBAction)btnSocialMediaClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;



- (IBAction)btnSocialMediaClicked:(id)sender;


- (IBAction)AddToMySchedule:(id)sender;
- (IBAction)RemoveFromMySchedule:(id)sender;

- (IBAction)AddToMyCalendar:(id)sender;
- (IBAction)RemoveFromMyCalendar:(id)sender;


@end
