//
//  PlaceMarker.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PlaceMarker.h"

@interface PlaceMarker ()
@property (nonatomic,retain) NSString *displayTitle;

@end

@implementation PlaceMarker
@synthesize coordinate = _coordinate;

- (id)init:(NSString *)title{
    self = [super init];
    if (self) {
        // Initialization code
        self.displayTitle=title;
    }
    return self;
}
-(void)setCoordinate:(CLLocationCoordinate2D)marker{
    _coordinate=marker;
}

- (NSString *)title
{
    return self.displayTitle;
}
/*
 - (NSString *)subtitle
 {
 return @"Opened: April 21, 1962";
 }*/
@end