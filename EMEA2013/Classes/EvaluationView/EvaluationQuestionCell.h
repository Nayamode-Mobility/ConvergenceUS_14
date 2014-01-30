//
//  EvaluationQuestionCell.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EvaluationQuestionCellDelegate <NSObject>
- (void)userInetaction:(NSDictionary*)data;
- (void)answerTextControl:(UITextView*)sender;
@end

@interface EvaluationQuestionCell : UITableViewCell<UITextViewDelegate>{
}
@property (nonatomic, weak) id <EvaluationQuestionCellDelegate> Delegate;
@property (strong, nonatomic) IBOutlet UILabel *txtQuestion;
@property (strong, nonatomic) IBOutlet UITextView *txtQuestion1;
-(void)setQuestionData:(NSDictionary *)qData;
-(CGFloat)getHeight;

@end
