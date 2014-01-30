//
//  GlobalSearchViewController.h
//  mgx2013
//
//  Created by Amit Karande on 25/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GlobalSearchViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
}

@property (nonatomic, strong) NSArray *arrAttendees;
@property (strong, nonatomic) NSArray *arrExhibitors;
@property (strong, nonatomic) NSArray *arrSessions;
@property (strong, nonatomic) NSArray *arrSpeaker;
@property (strong, nonatomic) IBOutlet UIView *vwAttendee;
@property (strong, nonatomic) IBOutlet UIView *vwExhibitors;
@property (strong, nonatomic) IBOutlet UIView *vwSessions;
@property (strong, nonatomic) IBOutlet UIView *vwSpeaker;
@property (strong, nonatomic) IBOutlet UICollectionView *colAttendees;
@property (strong, nonatomic) IBOutlet UICollectionView *colExhibitors;
@property (strong, nonatomic) IBOutlet UICollectionView *colSessions;
@property (strong, nonatomic) IBOutlet UICollectionView *colSpeakers;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIScrollView *svwGlobalSearch;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) IBOutlet UILabel *lblExhibitors;
@property (strong, nonatomic) IBOutlet UILabel *lblAttendees;
@property (strong, nonatomic) IBOutlet UILabel *lblSessions;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakers;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
@end
