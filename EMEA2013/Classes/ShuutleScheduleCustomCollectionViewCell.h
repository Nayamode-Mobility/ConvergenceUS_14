//
//  ShuutleScheduleCustomCollectionViewCell.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 17/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface ShuutleScheduleCustomCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
{
    
}

@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDataSource>)dataSourceDelegate arrAgendaList:(NSArray*)arrAgendaList;
@property (nonatomic, strong) NSArray *arrShuttleSchedule;

@end
