//
//  OnSiteServiceViewController.h
//  mgx2013
//
//  Created by Amit Karande on 11/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnSiteServiceViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *attendeemealsCollectionView;
@property (strong, nonatomic) NSArray *arrAtttendeeMeals;
@property (strong, nonatomic) NSArray *arrSpeacialtyMeals;
@property (strong, nonatomic) NSArray *arrConferenceSecurity;
@property (strong, nonatomic) NSArray *arrLuggage;
@property (strong, nonatomic) NSArray *arrMicrosoftLink;
@property (strong, nonatomic) IBOutlet UIScrollView *svwOnSiteServices;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) NSArray *arrOnSiteServices;
@property (strong, nonatomic) IBOutlet UITableView *tvwOnSiteServices;
@property (strong, nonatomic) IBOutlet UIScrollView *svwDetails;
@property (strong, nonatomic) IBOutlet UIWebView *wvwDetails;

//- (IBAction)optionSelected:(id)sender;
- (IBAction)btnBackClicked:(id)sender;
@end
