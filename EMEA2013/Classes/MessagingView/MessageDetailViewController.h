//
//  MessageDetailViewController.h
//  mgx2013
//
//  Created by Amit Karande on 28/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Message.h"

@interface MessageDetailViewController : UIViewController

@property (strong, nonatomic) Message *selectedMessage;
@property (nonatomic, assign) BOOL blnIsInboxMessage;
@property (nonatomic, assign) BOOL blnIsSentboxMessage;
@property (nonatomic, assign) BOOL blnIsDraftMessage;

@property (strong, nonatomic) IBOutlet UILabel *lblFrom;
@property (strong, nonatomic) IBOutlet UILabel *lblTo;
@property (strong, nonatomic) IBOutlet UILabel *lblSubject;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIView *vwButtons;
@property (strong, nonatomic) IBOutlet UIButton *btnReply;
@property (strong, nonatomic) IBOutlet UIButton *btnForward;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIScrollView *svwMessageDetail;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)ReplyClicked:(id)sender;
- (IBAction)ForwardClicked:(id)sender;
- (IBAction)DeleteClicked:(id)sender;

@end
