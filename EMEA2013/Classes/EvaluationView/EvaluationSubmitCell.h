//
//  EvaluationSubmitCell.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 24/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaluationSubmitCellDelegate <NSObject>
- (void)submit:(id)sender;
@end

@interface EvaluationSubmitCell : UITableViewCell
{
}

@property (nonatomic, weak) id <EvaluationSubmitCellDelegate> Delegate;
@property (nonatomic,retain) IBOutlet UIButton *btnsubmit;
@end
