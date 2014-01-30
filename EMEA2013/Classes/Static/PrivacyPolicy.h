//
//  PrivacyPolicy.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyPolicy : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *wvPrivacyPolicy;
}

@property (nonatomic, retain) UIWebView *wvPrivacyPolicy;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)btnBackClicked:(id)sender;
@end
