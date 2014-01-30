//
//  MSDPN.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDPN : UIViewController <UIWebViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UIWebView *wvMDPN;

- (IBAction)btnBackCLicked:(id)sender;
@end
