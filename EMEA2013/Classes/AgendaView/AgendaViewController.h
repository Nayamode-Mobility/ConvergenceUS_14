//
//  AgendaViewController.h
//  MGXTestApp
//
//  Created by Amit Karande on 28/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet UICollectionView *agendaCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *agendaDetailTableView;

@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) NSArray *arrAgendas;

- (IBAction)btnBackClicked:(id)sender;
@end
