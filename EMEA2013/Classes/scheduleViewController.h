//
//  scheduleViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode MacMini on 09/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{


   NSMutableArray *arrShuttleSchedule;

}

@property (strong, nonatomic) IBOutlet UICollectionView *agendaCollectionView;
@property (strong, nonatomic) IBOutlet UITableView *agendaDetailTableView;

@property (nonatomic, assign) NSInteger intSelectedIndex;
@property (strong, nonatomic) NSArray *arrAgendas;

@property (weak, nonatomic) IBOutlet UIButton *backShuttleBtn;

@property (strong, nonatomic) IBOutlet UICollectionView *ShuttleSchedule;

@end
