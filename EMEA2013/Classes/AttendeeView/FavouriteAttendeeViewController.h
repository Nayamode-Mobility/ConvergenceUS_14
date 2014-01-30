//
//  FavouriteAttendeeViewController.h
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 18/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteAttendeeViewController : UIViewController
{
    NSArray *arrFavAttendee;
    
    IBOutlet UICollectionView *collFavAttendees;
}
@property (nonatomic, retain) NSMutableData *objData;
@property (nonatomic, retain) NSURLConnection  *objConnection;

@property (strong, nonatomic) IBOutlet UIView *vwLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;


-(IBAction)btnBack_Click:(id)sender;
-(IBAction)btnSynchFavAttendee_click:(id)sender;
@end
