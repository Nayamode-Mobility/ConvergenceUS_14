//
//  TwitterPostViewController.h
//  mgx2013
//
//  Created by Amit Karande on 06/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>

@interface TwitterPostViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UITextView *txtTweet;
@property (strong, nonatomic) IBOutlet UIButton *btnPostTweet;

@property (weak, nonatomic) IBOutlet UIView *vwLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnPostTweetClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
