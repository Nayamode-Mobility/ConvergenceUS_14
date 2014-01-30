//
//  HappeningNowCustomCollectionViewCell.h
//  mgx2013
//
//  Created by Amit Karande on 05/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HappeningNowCustomCollectionViewCell : UICollectionViewCell<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>
{
}

@property (weak) IBOutlet UIImageView *articleImage;
@property (weak) IBOutlet UILabel *articleTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *arrSessions;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblRoom;
@property (strong, nonatomic) IBOutlet UILabel *lblTiming;
@property (strong, nonatomic) IBOutlet UIButton *btnDetail;

@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableDictionary *dictData;

- (void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDataSource>)dataSourceDelegate arrSessionList:(NSArray*)arrSessionList;
@end
