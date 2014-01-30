//
//  UITextField+Custom.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "UITextField+Custom.h"

@implementation UITextField (Custom)
/*
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 8, bounds.size.width - 20, bounds.size.height - 16);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
*/
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
    
    UIView *vwPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 8)];
    self.leftView = vwPadding;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
