//
//  SessionQAViewController.h
//  EMEA2013
//
//  Created by Nikhil on 01/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Session.h"
#import "Speaker.h"
@interface SessionQAViewController : UIViewController<UITextViewDelegate>
{
    
    IBOutlet UILabel *lblSessionTitle;
    IBOutlet UILabel *lblFrom;
    IBOutlet UILabel *lblSelectedSession;
    IBOutlet UITableView *tblSelectList;
    IBOutlet UITextField *txtSubject;
    IBOutlet UITableView *tblSessionList;
    IBOutlet UITextView *txtDescription;
    IBOutlet UIView *viewContent;
    
    IBOutlet UIButton *listButton;
    
    IBOutlet UIView *sendQts;
    IBOutlet UIView *fromSpeakerView;
    
    NSArray *arrList;
    NSArray *sessionArrList;
    
    NSMutableArray *arrSelectedIndex;
    
    NSMutableData *objData;
    BOOL *blFirstLoad;
    IBOutlet UIView *vwdropdwnsessionList;
    
    UITableViewCell *tableViewCell;
    
    
    // Label For TxtView Placeholder
    
    UILabel *lblMessagePlacehold;
}
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) Session *sessionData;
@property (nonatomic, retain) Speaker *speakerData;
@property (nonatomic, readwrite) BOOL blIsFromSession;
@property (nonatomic, assign) BOOL blnDropdownExpanded;
@property (nonatomic, assign) BOOL blnViewExpanded;
@property (strong, nonatomic) IBOutlet UIView *vwDropdownSendQts;
@property (strong, nonatomic) IBOutlet UIButton *lblSessions;
@property (strong, nonatomic) IBOutlet UITableView *sessionsTable;
@property (strong, nonatomic) IBOutlet UILabel *lblspeakerName;


@property (strong, nonatomic) IBOutlet UILabel *lblSession;




-(IBAction)btnSend_Click:(id)sender;
-(IBAction)btnCancel_Click:(id)sender;
-(void)expandViewSendQts:(id)sender;


- (IBAction)dropdown:(id)sender;


-(IBAction)btnBackClicked:(id)sender;

@end
