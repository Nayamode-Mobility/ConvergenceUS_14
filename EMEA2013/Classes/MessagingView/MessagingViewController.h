//
//  MessagingViewController.h
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MessagingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UIButton *btnCompose;
@property (strong, nonatomic) NSArray *arrInboxItems;
@property (strong, nonatomic) NSArray *arrSentboxItems;
@property (strong, nonatomic) NSArray *arrDraftItems;
@property (strong, nonatomic) IBOutlet UITableView *tvInbox;
@property (strong, nonatomic) IBOutlet UIScrollView *svwMessaging;
@property (strong, nonatomic) IBOutlet UITableView *tvSentbox;
@property (strong, nonatomic) IBOutlet UITableView *tvDraftbox;

@property (nonatomic, weak) IBOutlet UIView *vwLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

- (IBAction)btnBackClicked:(id)sender;
@end
