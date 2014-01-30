//
//  PhotoGrid.h
//  mgx2013
//
//  Created by Paul Johnson on 10/24/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoGrid : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *photoCollectionView;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) NSArray *photoList;

@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (nonatomic, retain) NSMutableData *objData;

-(void)refresh;

@end
