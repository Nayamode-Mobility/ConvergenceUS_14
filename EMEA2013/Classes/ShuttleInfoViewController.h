//
//  ShuttleInfoViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode MacMini on 10/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncUp.h"

@interface ShuttleInfoViewController : UIViewController
{
NSMutableArray *arrShuttleInfo;
   
}



- (IBAction)shuttleInfoBackbtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backshuttleBtn;


@end
