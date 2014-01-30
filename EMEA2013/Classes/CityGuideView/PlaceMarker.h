//
//  PlaceMarker.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMMarker.h"

@interface PlaceMarker : NSObject<BMMarker>{
}
-(void)setCoordinate:(CLLocationCoordinate2D)marker;
- (id)init:(NSString *)title;
@end

