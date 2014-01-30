//
//  UINavigationController+Rotation.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Rotation)

- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
