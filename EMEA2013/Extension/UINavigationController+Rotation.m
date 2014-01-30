//
//  UINavigationController+Rotation.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "UINavigationController+Rotation.h"

@implementation UINavigationController (Rotation)

- (BOOL)shouldAutorotate
{
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
