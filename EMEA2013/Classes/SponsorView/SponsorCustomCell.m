//
//  SponsorCustomCell.m
//  mgx2013
//
//  Created by Amit Karande on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "SponsorCustomCell.h"
#import "CustomCollectionViewCell.h"
#import "Sponsor.h"
#import "NSString+Custom.h"

@implementation SponsorCustomCell
@synthesize totalItems,articleImage,articleTitle, myCollectionView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate arrSponsorList:(NSArray*)arrSponsorList
{
    self.myCollectionView.dataSource = dataSourceDelegate;
    self.myCollectionView.delegate = dataSourceDelegate;
    
    //self.myCollectionView.tag = index;
    //self.totalItems = index;
    
    if (self.sponsorList == nil)
    {
        self.sponsorList = [[NSArray alloc] init];
    }
    self.sponsorList = arrSponsorList;
    [self.myCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.sponsorList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    Sponsor *objSponsor = [self.sponsorList objectAtIndex:indexPath.row];
    
    cell.lblName.text = [NSString stringWithFormat:@"%@",objSponsor.strSponsorName];
    //cell.lblTitle.text = objExhibitor.str;
    //cell.lblCompany.text = objExhibitor.strCompany;
    cell.cellData = objSponsor;
    
    cell.imgLogo.image = nil;
    cell.imgLogo.image = [UIImage imageNamed:@"company.png"];
    if(![NSString IsEmpty:objSponsor.strLogoURL shouldCleanWhiteSpace:YES])
    {
        NSURL *imgURL = [NSURL URLWithString:objSponsor.strLogoURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                //NSLog(@"%@ %@",response.URL.absoluteString,((Sponsor*)cell.cellData).strLogoURL);
                if([response.URL.absoluteString isEqualToString:((Sponsor*)cell.cellData).strLogoURL])
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