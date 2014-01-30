//
//  NSURLConnection+Tag.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface NSURLConnection (Tag)
{
}

- (void)setTag:(OperConstants)intValue;
- (OperConstants)getTag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(OperConstants)tag;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate tag:(OperConstants)tag;
+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate tag:(OperConstants)tag;
@end
