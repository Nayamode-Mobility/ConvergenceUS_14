//
//  LinkedInFeedCustomeCell.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInFeedCustomeCell : UICollectionViewCell
{
}

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblHeadLine;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgWho;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UITextView *txtContent;

@property (strong, nonatomic) IBOutlet UIView *vwLine;

-(void)setData:(NSDictionary *)cellData;
@end
