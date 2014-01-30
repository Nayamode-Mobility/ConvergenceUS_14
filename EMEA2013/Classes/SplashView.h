//
//  ViewController.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashView : UIViewController
{
    IBOutlet UIActivityIndicatorView *avLoading;
}

@property (nonatomic, retain) UIActivityIndicatorView *avLoading;

- (void)CopyDB;
- (void)CopyPList;

- (void)loadLogin;
- (void)loadHome;
- (void)loadSyncup;
@end
