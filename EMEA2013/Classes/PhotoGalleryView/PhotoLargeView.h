//
//  PhotoLargeView.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 28/11/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoLargeView : UIViewController <UIScrollViewDelegate>
{
}

@property (nonatomic, weak) IBOutlet UIScrollView *svwLargeView;
@property (nonatomic, weak) IBOutlet UIImageView *imgvLargeView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *avLoading;

@property (nonatomic, retain) NSDictionary *curPict;

- (IBAction)btnBackClicked:(id)sender;
- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint;
@end
