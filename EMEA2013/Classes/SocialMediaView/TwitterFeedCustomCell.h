//
//  TwitterFeedCustomCell.h
//  mgx2013
//
//  Created by Amit Karande on 21/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterFeedCustomCell : UICollectionViewCell
{
}

@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UITextView *textLink;
@property (strong, nonatomic) IBOutlet UILabel *lblDatetime;
@property (strong, nonatomic) IBOutlet UIView *vwLine;
@end
