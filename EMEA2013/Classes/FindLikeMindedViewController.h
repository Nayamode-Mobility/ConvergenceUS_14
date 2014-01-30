//
//  FindLikeMindedViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nikhil on 15/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindLikeMindedViewController : UIViewController
{
    NSArray *arrCategory1;
    NSArray *arrCategory2;
    NSArray *arrCategory3;
    NSArray *arrCategory4;
    NSArray *arrCategory5;
    
    IBOutlet UILabel *lblCategory1;
    IBOutlet UILabel *lblCategory2;
    IBOutlet UILabel *lblCategory3;
    IBOutlet UILabel *lblCategory4;
    IBOutlet UILabel *lblCategory5;
    
    IBOutlet UIView *viewTableCategory1;
    IBOutlet UIView *viewTableCategory2;
    IBOutlet UIView *viewTableCategory3;
    IBOutlet UIView *viewTableCategory4;
    IBOutlet UIView *viewTableCategory5;
    
    NSInteger intCategory1_SelectedIndex;
    NSInteger intCategory2_SelectedIndex;
    NSInteger intCategory3_SelectedIndex;
    NSInteger intCategory4_SelectedIndex;
    NSInteger intCategory5_SelectedIndex;
    
    BOOL blnDropdownExpanded;
    
    IBOutlet UIButton *btnSearch;
    
    NSArray *arrAttendees;
    
    IBOutlet UICollectionView *collFindLikeMinded;
    IBOutlet UIScrollView *scrlFindLikeMinded;
}
@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;
@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

-(IBAction)btnCategory_Click:(id)sender;
-(IBAction)btnSearch_Click:(id)sender;

- (IBAction)backBtnClicked:(id)sender;


@end
