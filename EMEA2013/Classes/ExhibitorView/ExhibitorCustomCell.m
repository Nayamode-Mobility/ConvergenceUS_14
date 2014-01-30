//
//  ExhibitorCustomCell.m
//  mgx2013
//
//  Created by Amit Karande on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ExhibitorCustomCell.h"
#import "CustomCollectionViewCell.h"
#import "Exhibitor.h"
#import "NSString+Custom.h"


@implementation ExhibitorCustomCell
@synthesize totalItems,articleImage,articleTitle, myCollectionView, exhibitorList;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate arrExhibitorList:(NSArray *)arrExhibitorList
{
    self.myCollectionView.dataSource = dataSourceDelegate;
    self.myCollectionView.delegate = dataSourceDelegate;
    
    //self.myCollectionView.tag = index;
    //self.totalItems = index;
    
    if (self.exhibitorList == nil)
    {
        self.exhibitorList = [[NSArray alloc] init];
    }
    
    self.exhibitorList = arrExhibitorList;
    [self.myCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.exhibitorList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    Exhibitor *objExhibitor = [self.exhibitorList objectAtIndex:indexPath.row];
    
    cell.lblName.text = [NSString stringWithFormat:@"%@",objExhibitor.strExhibitorName];

    cell.lblBooth.text = @"";
    if(![NSString IsEmpty:objExhibitor.strBoothNumbers shouldCleanWhiteSpace:YES])
    {
        cell.lblBooth.text = [NSString stringWithFormat:@"Booth: %@",objExhibitor.strBoothNumbers];
    }

    //cell.lblTitle.text = objExhibitor.str;
    //cell.lblCompany.text = objExhibitor.strCompany;
    
    cell.cellData = objExhibitor;
    
    cell.imgLogo.image = nil;
    cell.imgLogo.image = [UIImage imageNamed:@"company.png"];
    if(![NSString IsEmpty:objExhibitor.strLogoURL shouldCleanWhiteSpace:YES])
    {
        NSURL *imgURL = [NSURL URLWithString:objExhibitor.strLogoURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                //NSLog(@"%@ %@",response.URL.absoluteString,((Exhibitor*)cell.cellData).strLogoURL);
                if([response.URL.absoluteString isEqualToString:((Exhibitor*)cell.cellData).strLogoURL])
                {
                cell.imgLogo.image = [UIImage imageWithData:data];
                cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
            }
            }
        }];
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}
@end
