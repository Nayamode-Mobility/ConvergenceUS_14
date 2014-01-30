//
//  UILabel+Custom.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 24/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

- (void)awakeFromNib
{
    [super awakeFromNib];    
    
    NSString *weight = [self.font.fontName substringFromIndex:[self.font.fontName length] - 5];
    if([weight isEqualToString:@"-Bold"])
    {
        self.font = [UIFont fontWithName:@"SegoeWP-Bold" size:self.font.pointSize];
    }
    else
    {
        self.font = [UIFont fontWithName:@"SegoeWP"  size:self.font.pointSize];
    }

    if([self numberOfLines] > 1)
    {
        CGRect orgSize = self.frame;
        [self sizeToFit];
        self.frame = orgSize;
    }
}

@end
