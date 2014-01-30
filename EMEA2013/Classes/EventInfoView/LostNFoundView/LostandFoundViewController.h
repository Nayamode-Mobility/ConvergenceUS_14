//
//  LostandFoundViewController.h
//  mgx2013
//
//  Created by Amit Karande on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LostandFoundViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblOverViewDescription;
@property (strong, nonatomic) NSArray *arrLostNFound;
@property (strong, nonatomic) IBOutlet UIScrollView *svwLostnFound;
@property (strong, nonatomic) IBOutlet UIScrollView *svwOverview;
@property (strong, nonatomic) IBOutlet UIScrollView *svwDetail;
@property (strong, nonatomic) IBOutlet UIImageView *imgLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIScrollView *vwInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblWebsite;
- (IBAction)MakePhoneCall:(id)sender;
- (IBAction)OpenWebsite:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnOpenWebsite;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)OpenMapView:(id)sender;
@end
