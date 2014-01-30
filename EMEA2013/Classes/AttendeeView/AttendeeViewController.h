//
//  AttendeeViewController.h
//  mgx2013
//
//  Created by Amit Karande on 04/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ZBarSDK.h"

@interface AttendeeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZBarReaderDelegate, ABNewPersonViewControllerDelegate>
{
    
    NSArray *arrAlphabets;
}

@property (strong, nonatomic) IBOutlet UIScrollView *svwAttendees;

@property (strong, nonatomic) IBOutlet UICollectionView *attendeeCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *attendeeFilteredCollectionView;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (nonatomic, strong) NSArray *arrAttendees;
@property (nonatomic, strong) NSArray *arrAttendeesFiltered;
@property (nonatomic, strong) NSArray *arrCategories;

@property (nonatomic, assign) BOOL blnDropdownExpanded;
@property (strong, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) IBOutlet UIView *vwCategoryDropdown;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedCategory;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIButton *btnContactExchange;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;
@property (strong, nonatomic) IBOutlet UICollectionView *colAttendeesAlphabets;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avContactExchange;

@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)showDropdownMenu:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)btnContactExchangeClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end