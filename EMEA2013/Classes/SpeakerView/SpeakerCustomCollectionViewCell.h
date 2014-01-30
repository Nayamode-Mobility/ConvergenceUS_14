//
//  CustomCollectionViewCell.h
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface SpeakerCustomCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, strong) NSArray *speakerList;

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDataSource>)dataSourceDelegate arrSpeakerList:(NSArray*)arrSpeakerList;


@end

