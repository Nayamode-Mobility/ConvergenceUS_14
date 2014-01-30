//
//  HappeningNowViewController.h
//  mgx2013
//
//  Created by Amit Karande on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HappeningNowViewController :UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *agendaCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *agendaDetailTableView;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) NSArray *arrSessions;

@property (strong, nonatomic) NSArray *arrTracks;
@property (strong, nonatomic) NSArray *arrProducts;
@property (strong, nonatomic) NSArray *arrSessionTypes;
@property (strong, nonatomic) NSArray *arrIndustries;
@property (strong, nonatomic) NSArray *arrSpeakers;
@property (strong, nonatomic) NSArray *arrTimeslot;

@property (nonatomic, assign) BOOL blnDropdownExpanded;

@property (strong, nonatomic) IBOutlet UILabel *lblTrack;
@property (strong, nonatomic) IBOutlet UILabel *lblTrackInstanceID;
@property (strong, nonatomic) IBOutlet UIView *vwTracksDropdown;
@property (strong, nonatomic) IBOutlet UITableView *trackTableView;

@property (strong, nonatomic) IBOutlet UILabel *lblProduct;
@property (strong, nonatomic) IBOutlet UILabel *lblProductID;
@property (strong, nonatomic) IBOutlet UIView *vwProductDropdown;
@property (strong, nonatomic) IBOutlet UITableView *productTableView;

@property (strong, nonatomic) IBOutlet UILabel *lblSessionType;
@property (strong, nonatomic) IBOutlet UILabel *lblSessionTypeID;
@property (strong, nonatomic) IBOutlet UIView *vwSessionTypeDropdown;
@property (strong, nonatomic) IBOutlet UITableView *sessionTypeTableView;

@property (strong, nonatomic) IBOutlet UILabel *lblIndustry;
@property (strong, nonatomic) IBOutlet UILabel *lblIndustryID;
@property (strong, nonatomic) IBOutlet UIView *vwIndustryDropdown;
@property (strong, nonatomic) IBOutlet UITableView *industryTableView;

@property (strong, nonatomic) IBOutlet UILabel *lblSpeaker;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerID;
@property (strong, nonatomic) IBOutlet UIView *vwSpeakerDropdown;
@property (strong, nonatomic) IBOutlet UITableView *speakerTableView;

@property (strong, nonatomic) IBOutlet UILabel *lblTimeslot;
@property (strong, nonatomic) IBOutlet UILabel *lblTimeslotID;
@property (strong, nonatomic) IBOutlet UIView *vwTimeslotDropdown;
@property (strong, nonatomic) IBOutlet UITableView *timeslotTableView;

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *svwWhatsNow;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
@end
