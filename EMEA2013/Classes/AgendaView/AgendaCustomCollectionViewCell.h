//
//  AgendaCustomCollectionViewCell.h
//  mgx2013
//
//  Created by Amit Karande on 04/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaCustomCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
{
}

@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *arrAgendas;

@property (strong, nonatomic) IBOutlet UITextView *txtText;

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDataSource>)dataSourceDelegate arrAgendaList:(NSArray*)arrAgendaList;
@end

