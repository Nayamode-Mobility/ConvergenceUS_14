//
//  UIView+viewRecursion.m
//  IndoorNavigation
//
//  Created by Sang.Mac.04 on 02/10/13.
//  Copyright (c) 2013 Sanginfo. All rights reserved.
//

#import "UIView+Custom.h"

#define TAG_GRAYVIEW 5671263
@implementation UIView (Custom)

BOOL addedOverLay = NO;

- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:self];
    
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    
    return arr;
}

+ (void)addTouchEffect:(UIView *)appView
{
    for (UIView *v in [appView allSubViews])
    {
        if([v isKindOfClass:[UIButton class]])
        {
            //[((UIButton*)v) addTarget:self action:@selector(ButtonTouchEvents:event:) forControlEvents:UIControlEventAllTouchEvents];
            [((UIButton*)v) addTarget:self action:@selector(changetouchcolor:) forControlEvents:UIControlEventTouchDown];
            [((UIButton*)v) addTarget:self action:@selector(resettouchcolor:) forControlEvents:UIControlEventTouchUpOutside];
            [((UIButton*)v) addTarget:self action:@selector(resettouchcolor:) forControlEvents:UIControlEventTouchUpInside];
            
            //[((UIButton*)v) addTarget:self action:@selector(Shrink:) forControlEvents:UIControlEventTouchDown];
            //[((UIButton*)v) addTarget:self action:@selector(Expand:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

+ (void)addTouchEffectV1:(UIView *)appView
{
    for (UIView *v in [appView allSubViews])
    {
        if([v isKindOfClass:[UIButton class]])
        {
            [((UIButton*)v) addTarget:self action:@selector(Shrink:) forControlEvents:UIControlEventTouchDown];
            //[((UIButton*)v) addTarget:self action:@selector(Expand:) forControlEvents:UIControlEventTouchUpOutside];
            //[((UIButton*)v) addTarget:self action:@selector(Expand:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

+ (void)addTouchEffectV2:(UIView *)appView
{
    for (UIView *v in [appView allSubViews])
    {
        if([v isKindOfClass:[UIButton class]])
        {
            [((UIButton*)v) addTarget:self action:@selector(changeButtonBGColor:) forControlEvents:UIControlEventTouchDown];
            //[((UIButton*)v) addTarget:self action:@selector(resetButtonBGColor:) forControlEvents:UIControlEventTouchUpOutside];
            //[((UIButton*)v) addTarget:self action:@selector(resetButtonBGColor:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

/*
+ (void)ButtonTouchEvents:(UIButton *)sender event:(UIEvent *)event{
     NSLog(@"events %d", event.subtype);
    if(event.type==UIEventTypeTouches){
        if (!addedOverLay) {
             NSLog(@"added %d", event.subtype);
            UIView *grayView = [[UIView alloc] initWithFrame:sender.bounds];
            grayView.backgroundColor = [UIColor blackColor];
            grayView.alpha=0.2f;
            grayView.tag = TAG_GRAYVIEW;
            [sender addSubview:grayView];
            addedOverLay=YES;
        }
 
    }
}*/

+ (void)resettouchcolor:(UIButton*)sender
{
    //NSLog(@"touched reset");
    UIView *grayView = [sender viewWithTag:TAG_GRAYVIEW];
    if (grayView!=nil)
    {
        [grayView removeFromSuperview];
    }
    
    addedOverLay=NO;
}

+ (void)changetouchcolor:(UIButton *)sender
{
    //if([sender.superview isKindOfClass:[UIView class]])
    //{
    //    NSLog(@"%.f",sender.superview.frame.size.width);
    //    NSLog(@"%.f",sender.superview.frame.size.height);
    //    NSLog(@"%.f",sender.superview.frame.origin.x);
    //    NSLog(@"%.f",sender.superview.frame.origin.y);
    //}
    
    //NSLog(@"touched");
    UIView *grayView = [[UIView alloc] initWithFrame:sender.bounds];
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha=0.2f;
    grayView.tag = TAG_GRAYVIEW;
    
    [sender addSubview:grayView];
}


+ (void)ChangeAppFont:(UIView *) appView
{
    for (UIView *v in [appView allSubViews])
    {
        if([v isKindOfClass:[UILabel class]])
        {
            UIFont *currentFont= ((UILabel*)v).font;
            NSString *nameFont= @"OpenSans";//currentFont.fontName;
            NSString *weight = [currentFont.fontName substringFromIndex:[currentFont.fontName length] - 5];
            
            if([weight isEqualToString:@"-Bold"])
            {
                nameFont=[nameFont stringByAppendingString:@"-Bold"];
            }
            else
            {
                //self.font = [UIFont fontWithName:@"SegoeWP"  size:self.font.pointSize];
            }
            ((UILabel*)v).font=[UIFont fontWithName:nameFont size:currentFont.pointSize-1];
        }
        else if([v isKindOfClass:[UIButton class]])
        {
            UIFont *currentFont= ((UIButton*)v).titleLabel.font;
            NSString *nameFont= @"OpenSans";//currentFont.fontName;
            NSString *weight = [currentFont.fontName substringFromIndex:[currentFont.fontName length] - 5];
            
            if([weight isEqualToString:@"-Bold"])
            {
                nameFont=[nameFont stringByAppendingString:@"-Bold"];
            }
            else if([weight isEqualToString:@"edium"])
            {
                nameFont=[nameFont stringByAppendingString:@"-Semibold"];
                
            }
            ((UIButton*)v).titleLabel.font=[UIFont fontWithName:nameFont size:currentFont.pointSize-1];
        }
    }
}

+ (void)Expand:(UIButton *)sender
{
    //Touch Down
    NSLog(@"%@",@"Expand");
    
    UIView *vwTemp = sender.superview;
    
    [UIView transitionWithView:vwTemp duration:1.0 options:UIViewAnimationOptionTransitionNone animations:^(void)
    {
        CGRect newRect = vwTemp.frame;
        
        CGPoint ce = vwTemp.center;
        newRect.size.width = newRect.size.width + 5;
        newRect.size.height = newRect.size.height + 5;
        
        vwTemp.frame = newRect;
        vwTemp.center = ce;
    }
    completion:^(BOOL finished)
    {
    }];
}

+ (void)Shrink:(UIButton *)sender
{
    //Touch Up Inside
    NSLog(@"%@",@"Shrink");
    
    UIView *vwTemp = sender.superview;
    
    [UIView transitionWithView:vwTemp duration:0.0 options:UIViewAnimationOptionTransitionNone animations:^(void)
    {
        CGRect newRect = vwTemp.frame;
        
        CGPoint ce = vwTemp.center;
        newRect.size.width = newRect.size.width - 5;
        newRect.size.height = newRect.size.height - 5;
        
        vwTemp.frame = newRect;
        vwTemp.center = ce;
    }
    completion:^(BOOL finished)
    {
        [self Expand:sender];
    }];
}

+ (void)resetButtonBGColor:(UIButton*)sender
{
    NSLog(@"%@",@"Reset BG");
    //NSLog(@"Reset BG Width: %.2f",sender.frame.size.width);
    //NSLog(@"Reset BG Height: %.2f",sender.frame.size.height);
    [sender setBackgroundColor:[UIColor clearColor]];
}

+ (void)changeButtonBGColor:(UIButton*)sender
{
    NSLog(@"%@",@"Change BG");
    //NSLog(@"Reset BG Width: %.2f",sender.frame.size.width);
    //NSLog(@"Reset BG Height: %.2f",sender.frame.size.height);
    [sender setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self resetButtonBGColor:sender];
                   });
}


@end
