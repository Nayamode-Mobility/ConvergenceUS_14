//
//  ADFSLogin.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 19/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ADFSLogin : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIButton *btnBack;
    IBOutlet UITextField *txtUsername;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnSignin;
    IBOutlet UILabel *lblADFSError;
    IBOutlet UILabel *lblCMSError;
    
    IBOutlet UIView *vwLoading;
    IBOutlet UIActivityIndicatorView *avLoading;
}

@property (nonatomic, retain) UIView *vwLoading;
@property (nonatomic, retain) UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) UIButton *btnBack;
@property (nonatomic, retain) UITextField *txtUsername;
@property (nonatomic, retain) UITextField *txtPassword;
@property (nonatomic, retain) UIButton *btnSignin;
@property (nonatomic, retain) UILabel *lblADFSError;
@property (nonatomic, retain) UILabel *lblCMSError;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

- (void)GetDomainAttendeeInfo:(NSString*)strData;
- (void)loadOptin;
- (void)loadSyncup;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)ADFSSignin:(id)sender;
@end
