//
//  ExhibitorsViewController.h
//  mgx2013
//
//  Created by Amit Karande on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ExhibitorsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *colExhibitorsAlphabets;
@property (strong, nonatomic) IBOutlet UICollectionView *colExhibitors;

@property (strong, nonatomic) NSArray *arrExhibitors;
@property (nonatomic, assign) NSInteger intSelectedIndex;

@property (nonatomic,strong) IBOutlet UIButton *btnMyExhibitors;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
