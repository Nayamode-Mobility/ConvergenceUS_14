//
//  SponsorsViewController.h
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SponsorsViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
{
}

@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) NSArray *arrSponsors;
@property (nonatomic, assign) BOOL blnIsExhibitors;
@property (strong, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
@end
