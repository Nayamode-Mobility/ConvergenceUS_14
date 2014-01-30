//
//  NSURLConnection+Tag.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "NSURLConnection+Tag.h"
#import "Constants.h"

@implementation NSURLConnection (Tag)
static OperConstants tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(OperConstants)tag
{
	self = [[NSURLConnection alloc] initWithRequest:request delegate:delegate startImmediately:startImmediately];
    
	if (self) {
        [self setTag:tag];
	}
	return self;
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate tag:(OperConstants)tag
{
	self = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    
	if (self) {
        [self setTag:tag];
	}
	return self;
}

+ (NSURLConnection*)connectionWithRequest:(NSURLRequest *)request delegate:(id)delegate tag:(OperConstants)tag
{
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [connection setTag:tag];
    return connection;
}

- (void)setTag:(OperConstants)intValue
{
    tag = intValue;
}

- (OperConstants)getTag
{
    return tag;
}

@end
