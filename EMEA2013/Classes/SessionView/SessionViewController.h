//
//  SessionViewController.h
//  mgx2013
//
//  Created by Amit Karande on 03/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SessionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *sessionCollectionView;
@property (strong, nonatomic) NSArray *arrSessions;
@property (strong, nonatomic) NSArray *arrTracks;
@property (strong, nonatomic) NSArray *arrSessionTypes;
@property (strong, nonatomic) NSArray *arrProducts;
@property (strong, nonatomic) NSArray *arrIndustries;
@property (strong, nonatomic) NSArray *arrSubTracks;
@property (strong, nonatomic) NSArray *arrSpeakers;
@property (strong, nonatomic) NSArray *arrTimeslot;
@property (strong, nonatomic) NSArray *arrSkillLevel;

@property (strong, nonatomic) NSArray *arrDates;
@property (strong, nonatomic) IBOutlet UIView *vwFilterPanel;
@property (nonatomic, assign) BOOL blnViewExpanded;
@property (nonatomic, assign) BOOL blnDropdownExpanded;

@property (strong, nonatomic) IBOutlet UILabel *lblTrack;
@property (strong, nonatomic) IBOutlet UILabel *lblTrackInstanceID;
@property (strong, nonatomic) IBOutlet UITableView *trackTableView;
@property (strong, nonatomic) IBOutlet UIView *vwTracksDropdown;

@property (strong, nonatomic) IBOutlet UILabel *lblProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductID;
@property (strong, nonatomic) IBOutlet UITableView *productTableView;
@property (strong, nonatomic) IBOutlet UIView *vwProductDropdown;

@property (strong, nonatomic) IBOutlet UILabel *lblSessionType;
@property (strong, nonatomic) IBOutlet UILabel *lblSessionTypeID;
@property (strong, nonatomic) IBOutlet UITableView *sessionTypeTableView;
@property (strong, nonatomic) IBOutlet UIView *vwSessionTypeDropdown;

@property (strong, nonatomic) IBOutlet UILabel *lblIndustry;
@property (strong, nonatomic) IBOutlet UILabel *lblIndustryID;
@property (strong, nonatomic) IBOutlet UITableView *industryTableView;
@property (strong, nonatomic) IBOutlet UIView *vwIndustryDropdown;

@property (strong, nonatomic) IBOutlet UILabel *lblSpeaker;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerID;
@property (strong, nonatomic) IBOutlet UITableView *speakerTableView;
@property (strong, nonatomic) IBOutlet UIView *vwspeakerDropdown;


@property (strong, nonatomic) IBOutlet UILabel *lblTimeSlot;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeSlotID;
@property (strong, nonatomic) IBOutlet UITableView *timeSlotTableView;
@property (strong, nonatomic) IBOutlet UIView *vwtimeSlotDropdown;

@property (strong, nonatomic) IBOutlet UILabel *lblAudiance;
@property (strong, nonatomic) IBOutlet UILabel *lblAudianceID;
@property (strong, nonatomic) IBOutlet UITableView *AudianceTableView;
@property (strong, nonatomic) IBOutlet UIView *vwAudianceDropdown;


@property (strong, nonatomic) IBOutlet UILabel *lblSkillLevel;
@property (strong, nonatomic) IBOutlet UILabel *lblSkillLevelID;
@property (strong, nonatomic) IBOutlet UIView *vwSkillLevelDropdown;
@property (strong, nonatomic) IBOutlet UITableView *SkillLeveltableView;

@property (strong, nonatomic) IBOutlet UIButton *btnFilter;

@property (strong, nonatomic) IBOutlet UICollectionView *colSessions;
@property (strong, nonatomic) IBOutlet UIScrollView *svwSessions;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (IBAction)showFilterPanel:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)btnBackCLicked:(id)sender;
@end
