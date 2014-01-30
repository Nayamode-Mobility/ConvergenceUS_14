//
//  AboutUs.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUs : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *wvAboutUs;
}

@property (nonatomic, retain) IBOutlet UIWebView *wvAboutUs;

- (IBAction)btnBackClicked:(id)sender;
@end
