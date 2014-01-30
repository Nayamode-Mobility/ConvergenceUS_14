//
//  EvaluationSubmitCell.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 24/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "EvaluationSubmitCell.h"

@implementation EvaluationSubmitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSubmitClick:(UIButton *)sender
{
    if (self.Delegate!=nil) {
        [self.Delegate submit:sender];
    }
}

@end
