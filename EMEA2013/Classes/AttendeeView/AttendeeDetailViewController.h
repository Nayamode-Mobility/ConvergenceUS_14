//
//  AttendeeDetailViewController.h
//  mgx2013
//
//  Created by Amit Karande on 04/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AttendeeTakeNotesViewController.h"
#import "Attendee.h"

@interface AttendeeDetailViewController : UIViewController <MFMailComposeViewControllerDelegate,AttendeeNoteDelegate>
{
    IBOutlet UIButton *btnTakeNotes;
    IBOutlet UIButton *btnViewNotes;
    
}
@property (nonatomic, retain) Attendee *attendeeData;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblBio;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblMessaging;
@property (strong, nonatomic) IBOutlet UIButton *btnSendMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnFav;
@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

- (IBAction)btnBackCLicked:(id)sender;
- (IBAction)SendMessage:(id)sender;
- (IBAction)OpenMail:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
- (IBAction)OpenMessageing:(id)sender;
- (IBAction)btnAddToContactsClick:(id)sender;
- (IBAction)btnAddToFavClick:(id)sender;
- (IBAction)btnTakeNoteClick:(id)sender;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

@end
