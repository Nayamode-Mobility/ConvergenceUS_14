//
//  FacebookViewController.h
//  mgx2013
//
//  Created by Amit Karande on 22/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface FacebookViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, NSURLConnectionDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *colFacebookPosts;
@property (nonatomic, retain) NSMutableArray *arrFBFeeds;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIButton *btnCompose;

@property (strong, nonatomic) IBOutlet UILabel *lblNoFeeds;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoadingPP;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

- (IBAction)btnBackClicked:(id)sender;
@end
