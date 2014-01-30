//
//  SpeakerCell.h
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeakerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblTiming;
@property (strong, nonatomic) IBOutlet UILabel *lblTask;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;

@end
