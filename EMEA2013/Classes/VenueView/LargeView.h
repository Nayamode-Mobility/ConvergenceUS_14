//
//  LargeView.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 04/12/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeView : UIViewController <UIScrollViewDelegate>
{
}

@property (nonatomic, weak) IBOutlet UIScrollView *svwLargeView;
@property (nonatomic, weak) IBOutlet UIImageView *imgvLargeView;

@property(nonatomic,retain) UIImage *imgSource;

- (IBAction)btnBackClicked:(id)sender;
- (void)view:(UIView*)view setCenter:(CGPoint)centerPoint;
@end
