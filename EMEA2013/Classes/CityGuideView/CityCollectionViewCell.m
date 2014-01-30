//
//  CityCollectionViewCell.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "CityCollectionViewCell.h"

@interface CityCollectionViewCell ()
@property (nonatomic,retain) NSDictionary *cellData;


@end
@implementation CityCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setData:(NSDictionary *)displayDetails{
    self.imgSelected.hidden=YES;
    self.cellData=displayDetails;
    self.imgIcon.image=[UIImage imageNamed:[displayDetails objectForKey:@"icon"]];
    [self.lblTitle setText:[displayDetails objectForKey:@"Title"]];
    
}
-(NSDictionary *)getCellData{
    return self.cellData;
}

@end
