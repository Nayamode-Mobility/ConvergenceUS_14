//
//  ComposeViewController.h
//  mgx2013
//
//  Created by Amit Karande on 22/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Message.h"

@interface ComposeViewController : UIViewController<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *arrAttendees;
@property (strong, nonatomic) IBOutlet UIScrollView *svwCompose;
@property (strong, nonatomic) IBOutlet UITextField *txtAttendee;
@property (strong, nonatomic) IBOutlet UITextField *txtMessageSubject;
@property (strong, nonatomic) IBOutlet UITextView *txtMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UITableView *tvAttendees;
@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (nonatomic, assign) NSInteger intDraftMessageID;
@property (strong, nonatomic) Message *selectedMessage;

@property (nonatomic, assign) BOOL blnIsInboxMessage;
@property (nonatomic, assign) BOOL blnIsSentboxMessage;
@property (nonatomic, assign) BOOL blnIsDraftMessage;
@property (nonatomic, assign) BOOL blnIsReply;
@property (nonatomic, assign) BOOL blnIsForward;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (nonatomic, retain) NSString *strAttendeeEmail;
@property (nonatomic, retain) NSString *strAttendeeName;
@property (nonatomic) BOOL blnCalledFromAttendeeDetail;

@property (nonatomic, weak) IBOutlet UIView *vwLoading;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *avLoading;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemsFound;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)btnSaveClicked:(id)sender;
- (IBAction)btnSendClicked:(id)sender;
- (IBAction)txtAttendeeTouched:(id)sender;
@end
