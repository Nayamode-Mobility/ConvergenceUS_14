//
//  KBKeyboardHandler.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 24/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBKeyboardHandlerDelegate

- (void)keyboardSizeChanged:(CGSize)delta;

@end

@interface KBKeyboardHandler : NSObject

- (id)init;

// Put 'weak' instead of 'assign' if you use ARC
@property(nonatomic, assign) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end
