//
//  UIView+viewRecursion.h
//  IndoorNavigation
//
//  Created by Sang.Mac.04 on 02/10/13.
//  Copyright (c) 2013 Sanginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Custom)
- (NSMutableArray*) allSubViews;
+ (void)ChangeAppFont:(UIView *) appView;
+ (void)addTouchEffect:(UIView *) appView;
+ (void)addTouchEffectV1:(UIView *) appView;
+ (void)changetouchcolor:(UIButton *) sender;
+ (void)resettouchcolor: (UIButton*)sender;

+ (void)addTouchEffectV2:(UIView *)appView;

//+ (void)ButtonTouchEvents:(UIButton *)sender event:(UIEvent *)event;
@end
