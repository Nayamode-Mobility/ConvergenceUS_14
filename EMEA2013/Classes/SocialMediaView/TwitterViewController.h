//
//  TwitterViewController.h
//  mgx2013
//
//  Created by Amit Karande on 21/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TwitterViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *colTwitterTweets;
@property (nonatomic, retain) NSMutableArray *arrTweets;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *btnCompose;

@property (strong, nonatomic) IBOutlet UILabel *lblNoFeeds;
@property (strong, nonatomic) IBOutlet UILabel *lblNoAccess;

@property (weak, nonatomic) IBOutlet UIView *vwLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoadingPP;
@end
