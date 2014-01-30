//
//  LinkedInViewController.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 22/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LinkedInViewController : UIViewController<UIWebViewDelegate,NSURLConnectionDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UIButton *btnPost;
@property (strong, nonatomic) IBOutlet UILabel *lblNoFeeds;


@property (strong, nonatomic) IBOutlet UITextView *textView;


- (IBAction)PostDiscussion:(id)sender;
@end
