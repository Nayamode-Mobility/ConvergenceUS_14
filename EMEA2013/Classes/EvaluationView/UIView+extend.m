//
//  UIView+extend.m
//  threempt
//
//

#import "UIView+extend.h"

@implementation UIView(extend)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

@end
