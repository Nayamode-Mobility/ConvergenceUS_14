//
//  Support.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface Support : UIViewController <MFMailComposeViewControllerDelegate>
{
}
- (IBAction)btnBackClicked:(id)sender;

- (IBAction)SendEmail:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
@end
