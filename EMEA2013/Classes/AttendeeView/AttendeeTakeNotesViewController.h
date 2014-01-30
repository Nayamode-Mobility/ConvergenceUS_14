//
//  SessionNoteViewController.h
//  mgx2013
//
//  Created by Amit Karande on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

#import "Session.h"
#import "UserSessionNotes.h"
#import "Attendee.h"

@protocol AttendeeNoteDelegate <NSObject>
@optional
- (void)noteSaved;
@end

@interface AttendeeTakeNotesViewController: UIViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    
    id<AttendeeNoteDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCode;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblRoom;
@property (strong, nonatomic) IBOutlet UILabel *lblTiming;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet UITextView *txtNote;
@property (strong, nonatomic) IBOutlet UITextField *txtNoteTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnAddSessionNote;
@property (strong, nonatomic) IBOutlet UIView *vwButtons;
@property (strong, nonatomic) IBOutlet UIView *vwSession;
@property (strong, nonatomic) IBOutlet UIView *vwText;
@property (strong, nonatomic) IBOutlet UIScrollView *svwNotes;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnMail;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (nonatomic, retain) Session *sessionData;
@property (nonatomic,retain)Attendee *objAttendee;
@property (nonatomic, retain) NSString *strSessionInstanceID;
@property (nonatomic, retain) NSString *strAttendeeEmail;
@property (nonatomic, retain) UserSessionNotes *noteData;
@property (nonatomic) BOOL blnNew;

@property (strong, nonatomic) IBOutlet UILabel *lblNotesPlaceHolder;

@property (nonatomic, strong) id<AttendeeNoteDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)textEditCancel:(id)sender;
- (IBAction)btnDeleteNote:(id)sender;
- (IBAction)btnAddSessionNote:(id)sender;
- (IBAction)OpenMail:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@end
