//
//  SponsorCustomCell.h
//  mgx2013
//
//  Created by Amit Karande on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsorCustomCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, strong) NSArray *sponsorList;

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDataSource>)dataSourceDelegate arrSponsorList:(NSArray*)arrSponsorList;


@end

