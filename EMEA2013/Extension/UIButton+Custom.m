//
//  UIButton+Custom.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    NSString *weight = [self.titleLabel.font.fontName substringFromIndex:[self.titleLabel.font.fontName length] - 5];
    if([weight isEqualToString:@"-Bold"])
    {
        self.titleLabel.font = [UIFont fontWithName:@"SegoeWP-Bold" size:self.titleLabel.font.pointSize];
    }
    else
    {
        self.titleLabel.font = [UIFont fontWithName:@"SegoeWP"  size:self.titleLabel.font.pointSize];
    }
    
    //self.showsTouchWhenHighlighted=YES;
}

@end
