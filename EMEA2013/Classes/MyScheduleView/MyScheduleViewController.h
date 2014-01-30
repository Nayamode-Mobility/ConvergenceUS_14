//
//  MyScheduleViewController.h
//  mgx2013
//
//  Created by Amit Karande on 07/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface MyScheduleViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *myScheduleCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *sessionCollectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *svwMySchedule;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToMyCalendar;

@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) NSArray *arrSessions;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)CheckAndAddToMyCalendar:(id)sender;
@end

