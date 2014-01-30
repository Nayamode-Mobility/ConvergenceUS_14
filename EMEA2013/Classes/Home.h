//
//  Home.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 27/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LiveSDK/LiveConnectClient.h"
#import "LiveSDK/LiveConnectSession.h"
#import "StyledPullableView.h"
#import "ZBarSDK.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Home : UIViewController <PullableViewDelegate,ZBarReaderDelegate,ABNewPersonViewControllerDelegate>
{
    IBOutlet UIScrollView *svwMain;
    
    IBOutlet UIScrollView *svwExhibitors;
    StyledPullableView *pullUpView;
@private
    NSString *vCardString;
}






@property (strong, nonatomic) IBOutlet UILabel *newlyaddedLabel;


@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avContactExchange;

@property (nonatomic, retain) LiveConnectClient *liveClient;
@property (nonatomic, retain) UIScrollView *svwMain;

- (IBAction)GoToLayer:(id)sender;

-(IBAction)btnInAppScanner_Click:(id)sender;

@property (nonatomic) NSUInteger intNavigateToTag;

- (void)GoToLayerV1:(NSUInteger)intTag;

@end
