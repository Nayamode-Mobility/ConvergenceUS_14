//
//  ViewController.h
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SpeakersViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *speakerCollectionView;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *speakersData;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end

