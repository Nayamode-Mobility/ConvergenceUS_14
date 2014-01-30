//
//  InternetAccessViewController.h
//  mgx2013
//
//  Created by Amit Karande on 16/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetAccessViewController : UIViewController
{
    NSArray *internetdata;
    NSMutableDictionary *dictData1;
    NSMutableDictionary *dictData2;
    NSMutableDictionary *dictData3;
    NSMutableDictionary *dictData;

}

@property (strong, nonatomic) IBOutlet UIScrollView *svwInternetAccess;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)MakePhoneCall:(id)sender;
- (void)addClicked:(id)sender;
- (void)phoneClicked:(id)sender;
-(void)GetInternetAccessData;
@end
