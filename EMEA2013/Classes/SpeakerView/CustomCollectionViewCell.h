//
//  CustomCollectionViewCell.h
//  Sponsors
//
//  Created by Amit Karande on 20/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblBooth;
@property (strong, nonatomic) NSObject *cellData;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblRoom;
@property (strong, nonatomic) IBOutlet UILabel *lblTiming;
@property (strong, nonatomic) IBOutlet UIButton *btnDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnNote;
@property (strong, nonatomic) IBOutlet UIButton *btnTakeNote;
@property (strong, nonatomic) IBOutlet UIView *vwLine;
@property (strong, nonatomic) IBOutlet UILabel *lblSessionCode;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementTimeDiff;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementCreated;
@property (strong, nonatomic) IBOutlet UILabel *lblAnnouncementMessage;
@property (strong, nonatomic) IBOutlet UITextView *TxtDesc;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

@property (strong, nonatomic) IBOutlet UIView *vwSessionButtons;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToMySchedule;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveFromMySchedule;
@end
