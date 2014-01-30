//
//  SpeakerDetailViewController.h
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "Speaker.h"

@interface SpeakerDetailViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) NSString *strData;
@property (nonatomic, strong) NSArray *speakersData;
@property (nonatomic, retain) Speaker *speakerData;

@property (nonatomic, retain) NSString *strSpeakerInstanceID;

@property (strong, nonatomic) IBOutlet UIScrollView *svwSpeakerDetail;
@property (strong, nonatomic) IBOutlet UICollectionView *sessionCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSpeakerTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (strong, nonatomic) IBOutlet UILabel *lblBio;

@property (strong, nonatomic) NSArray *sessionList;
@property (strong, nonatomic) IBOutlet UITextView *txtBiography;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UIImageView *imgEmail;

@property (strong, nonatomic) IBOutlet UICollectionView *colSessions;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

@property (strong, nonatomic) IBOutlet UIButton *sendQts;

- (IBAction)btnBackClick:(id)sender;

- (IBAction)OpenMail:(id)sender;



@end
