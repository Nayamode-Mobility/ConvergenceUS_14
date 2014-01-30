//
//  LinkedInFeedCustomeCell.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "LinkedInFeedCustomeCell.h"

@implementation LinkedInFeedCustomeCell

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

-(void)setData:(NSDictionary *)cellData
{
    //NSLog(@"%@",cellData);
    NSDictionary *displayData=[cellData objectForKey:@"creator"];
    
    self.lblName.text=[NSString stringWithFormat:@"%@ %@",[displayData objectForKey:@"firstName"],[displayData objectForKey:@"lastName"]];
    self.lblHeadLine.text=[NSString stringWithString:[displayData objectForKey:@"headline"]];
    self.lblTitle.text=[NSString stringWithString:[cellData objectForKey:@"title"]];
    
    NSURL *imageURL = [NSURL URLWithString:[displayData objectForKey:@"pictureUrl"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    [self.imgWho setImage:[UIImage imageWithData:imageData]];
}

@end
