//
//  Login.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

#import "LiveSDK/LiveConnectClient.h"
#import "LiveSDK/LiveConnectSession.h"

@interface Login : UIViewController <LiveAuthDelegate, LiveOperationDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *lblError;
    
    IBOutlet UIButton *btnASFSSignin;
    IBOutlet UIButton *btnMSSignin;
    IBOutlet UIButton *btnHelpEmail;
    
    IBOutlet UIView *vwLoading;
    IBOutlet UIActivityIndicatorView *avLoading;
}

@property (nonatomic, retain) UIView *vwLoading;
@property (nonatomic, retain) UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) LiveConnectClient *liveClient;
@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

@property (nonatomic, retain) UILabel *lblError;

@property (nonatomic, retain) UIButton *btnASFSSignin;
@property (nonatomic, retain) UIButton *btnMSSignin;
@property (nonatomic, retain) UIButton *btnHelpEmail;

- (void)configureLiveClientWithScopes;
- (void)loginWithScopes;
- (void)logout;
- (void)getMe;
- (void)loadOptin;
- (void)loadSyncup;

- (IBAction)MSSignin:(id)sender;
- (IBAction)ADFSSignin:(id)sender;
- (IBAction)SendEmail:(id)sender;
@end
