//
//  SearchViewController.h
//  mgx2013
//
//  Created by Paul Johnson on 10/25/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SearchViewController : UIViewController <UITextFieldDelegate>
{
}

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;

- (IBAction)btnBackClicked:(id)sender;
@end
