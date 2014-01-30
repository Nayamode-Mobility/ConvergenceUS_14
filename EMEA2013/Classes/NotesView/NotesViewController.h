//
//  NotesViewController.h
//  mgx2013
//
//  Created by Amit Karande on 16/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Session.h"
#import "SessionNoteViewController.h"

@interface NotesViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
}

@property (nonatomic, assign) IBOutlet UILabel *lblPageTitle;

@property (strong, nonatomic) IBOutlet UICollectionView *colNotes;
@property (strong, nonatomic) NSArray *arrNotes;
@property (nonatomic, retain) Session *sessionData;
@property (nonatomic, retain) NSString *strSessionInstanceID;
@property (nonatomic, assign) NSInteger intSelectedIndex;

@property (nonatomic, assign) IBOutlet UIButton *btnSyncNotes;
@property (nonatomic, assign) IBOutlet UIButton *btnTakeNotes;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property  (nonatomic, retain) IBOutlet UIView *vwLoading;
@property  (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)SyncNotes:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
@end
