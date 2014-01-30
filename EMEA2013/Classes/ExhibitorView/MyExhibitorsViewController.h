//
//  MyExhibitorsViewController.h
//  mgx2013
//
//  Created by Amit Karande on 24/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MyExhibitorsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *colExhibitorsAlphabets;
@property (strong, nonatomic) IBOutlet UICollectionView *colExhibitors;

@property (strong, nonatomic) NSArray *arrExhibitors;
@property (nonatomic, assign) NSInteger intSelectedIndex;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;
@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsAdded;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
