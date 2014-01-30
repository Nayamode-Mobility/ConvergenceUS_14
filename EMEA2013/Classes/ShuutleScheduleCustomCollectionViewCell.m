//
//  ShuutleScheduleCustomCollectionViewCell.m
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 17/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "ShuutleScheduleCustomCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "Agenda.h"
#import "ShuttleTime.h"



@implementation ShuutleScheduleCustomCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate arrAgendaList:(NSArray *)arrAgendaList
{
    self.myCollectionView.dataSource = dataSourceDelegate;
    self.myCollectionView.delegate = dataSourceDelegate;
    if (self.arrShuttleSchedule == nil) {
        self.arrShuttleSchedule = [[NSArray alloc] init];
    }
    self.arrShuttleSchedule= arrAgendaList;
    [self.myCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.arrShuttleSchedule count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    
    ShuttleTime *objShuttleTime = [self.arrShuttleSchedule objectAtIndex:indexPath.row];
    cell.lblName.text = objShuttleTime.FormattedTime;//[NSString stringWithFormat:@"%@",[self formatDate:objShuttleTime.FormattedTime]];
    
    cell.lblTitle.text = objShuttleTime.description;
    //cell.lblTitle.numberOfLines = 0;
    //[cell.lblTitle sizeToFit];
    
    //cell.lblLocation.text = objAgenda.strBriefDescription;
    //cell.lblLocation.numberOfLines = 0;
    //[cell.lblLocation sizeToFit];
    
    CGRect org = cell.lblTitle.frame;
    org.size.height = cell.lblTitle.frame.size.height;
    cell.lblTitle.frame = org;
    
    cell.lblTitle.text = objShuttleTime.Detail;
    
    cell.vwLine.frame = CGRectMake(0, (org.origin.y + org.size.height + 2), cell.vwLine.frame.size.width, 1.0);
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",indexPath.row);
    //Agenda *objAgenda = [self.arrAgendas objectAtIndex:indexPath.row];
    //NSString *strTitle = objAgenda.strTitle;
    //NSLog(@"%@",strTitle);
    
    //self.txtText.text = strTitle;
    //CGRect rect1 = self.txtText.frame;
    //rect1.size.height = self.txtText.contentSize.height;
    //self.txtText.frame = rect1;
    
    //UIFont *font = [UIFont fontWithName:@"SegoeWP" size:14.0f];
    
    //NSLog(@"%@",self.txtText.text);
    //NSLog(@"%f",self.txtText.frame.size.width);
    //NSLog(@"%f",self.txtText.frame.size.height);
    
    //CGSize expectedLabelSize = [strTitle sizeWithFont:font
    //                            constrainedToSize:CGSizeMake((self.txtText.frame.size.width - 10),1000)
    //                            lineBreakMode:NSLineBreakByWordWrapping];
    
    //NSLog(@"%@ %f",strTitle,expectedLabelSize.height);
    
    //CGSize cellSize = (CGSize) {.width = 280, .height = (expectedLabelSize.height + 80)};
    CGSize cellSize = (CGSize) {.width = 280, .height = 60};
    return cellSize;
}

-(NSString *)formatDate:(NSString *)strDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dbdate = [dateFormat dateFromString:strDate];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
    return strFormattedDate;
}

@end

