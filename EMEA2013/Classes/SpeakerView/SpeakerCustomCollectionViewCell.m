//
//  CustomCollectionViewCell.m
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//
#import "SpeakerCustomCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "SpeakersViewController.h"
#import "Speaker.h"
#import "DeviceManager.h"
#import "SpeakerDetailViewController.h"
#import "NSString+Custom.h"

@implementation SpeakerCustomCollectionViewCell
@synthesize totalItems,articleImage,articleTitle, myCollectionView, speakerList;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate arrSpeakerList:(NSArray*)arrSpeakerList
{
    self.myCollectionView.dataSource = dataSourceDelegate;
    self.myCollectionView.delegate = dataSourceDelegate;
    //self.myCollectionView.tag = index;
    //self.totalItems = index;
    if (self.speakerList == nil) {
        self.speakerList = [[NSArray alloc] init];
    }
    self.speakerList = arrSpeakerList;
    [self.myCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.speakerList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    Speaker *objSpeaker = [self.speakerList objectAtIndex:indexPath.row];
    
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@",objSpeaker.strFirstName,objSpeaker.strLastName];
    cell.lblTitle.text = objSpeaker.strTitle;
    cell.lblCompany.text = objSpeaker.strCompany;
    cell.cellData = objSpeaker;
    
    cell.imgLogo.image = nil;
    cell.imgLogo.image = [UIImage imageNamed:@"normal.png"];
    cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    if(![NSString IsEmpty:objSpeaker.strSpeakerPhoto shouldCleanWhiteSpace:YES])
    {
        NSURL *imgURL = [NSURL URLWithString:objSpeaker.strSpeakerPhoto];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                //NSLog(@"%@ %@",response.URL.absoluteString,((Speaker*)cell.cellData).strSpeakerPhoto);
                if([response.URL.absoluteString isEqualToString:((Speaker*)cell.cellData).strSpeakerPhoto])
                {
                cell.imgLogo.backgroundColor = [UIColor clearColor];
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
