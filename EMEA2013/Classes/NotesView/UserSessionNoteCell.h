//
//  UserSessionNoteCell.h
//  mgx2013
//
//  Created by Amit Karande on 16/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSessionNoteCell : UICollectionViewCell
{
}

@property (strong, nonatomic) IBOutlet UILabel *lblCode;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblNoteTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblNoteDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblDate1;
@property (strong, nonatomic) IBOutlet UILabel *lblDate2;
@property (strong, nonatomic) IBOutlet UILabel *lblDate3;

@property (nonatomic, assign) IBOutlet UIView *vwLine;
@end
