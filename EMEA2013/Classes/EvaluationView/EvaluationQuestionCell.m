//
//  EvaluationQuestionCell.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "EvaluationQuestionCell.h"
#import "UIView+extend.h"
@interface EvaluationQuestionCell()
{
}

@property (strong, nonatomic) IBOutlet UITextView *txtAnswer;
@property (strong, nonatomic) IBOutlet UIView *vwOpt1;
@property (strong, nonatomic) IBOutlet UIView *vwOpt2;
@property (strong, nonatomic) IBOutlet UIView *vwOpt4;
@property (strong, nonatomic) IBOutlet UIView *vwOpt3;
@property (strong, nonatomic) IBOutlet UIView *vwAnswer;
@property (strong, nonatomic) IBOutlet UIView *vwOpt5;
@property (strong, nonatomic) IBOutlet UIView *vwOpt6;
@property (nonatomic,retain)  NSMutableDictionary *PageQuestionData;
@property (nonatomic,retain)  NSString *questionType;
@end

@implementation EvaluationQuestionCell
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
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

-(void)setQuestionData:(NSDictionary *)qData
{
    self.PageQuestionData = [qData mutableCopy];

    CGFloat YPoint = self.txtQuestion.frame.origin.x;
    self.txtQuestion.text = [qData objectForKey:@"Title"];
    
    self.txtQuestion1.text=[qData objectForKey:@"Title"];
    self.txtQuestion1.dataDetectorTypes = UIDataDetectorTypeAll;
    self.txtQuestion1.editable = NO;
    
    CGRect org = self.txtQuestion.frame;
    [self.txtQuestion sizeToFit];
    org.size.height = self.txtQuestion.frame.size.height;
    self.txtQuestion.frame = org;
    YPoint = YPoint + [self.txtQuestion bottom];
    
    self.txtQuestion1.text = [qData objectForKey:@"Title"];
    //self.txtQuestion1.text = [NSString stringWithFormat:@"%@\n",[qData objectForKey:@"Title"]];
    [self.txtQuestion1 setContentInset:UIEdgeInsetsMake(-5, 0, 0, 0)];
    //[self.txtQuestion1 setBackgroundColor:[UIColor redColor]];
    self.txtQuestion1.scrollEnabled = NO;
    self.txtQuestion1.dataDetectorTypes = UIDataDetectorTypeAll;
    self.txtQuestion1.editable = NO;
    
    //[self.txtQuestion1 sizeToFit];
    //self.txtQuestion1.frame = self.txtQuestion.frame;
    
    CGRect rect = self.txtQuestion1.frame;
    CGSize size2 = [self.txtQuestion1 sizeThatFits:CGSizeMake(240, FLT_MAX)];
    rect.size.height = size2.height + 5;
    self.txtQuestion1.frame = rect;
    NSMutableArray *options=[qData objectForKey:@"Options"];
    
    self.vwOpt1.hidden=YES;
    self.vwOpt2.hidden=YES;
    self.vwOpt3.hidden=YES;
    self.vwOpt4.hidden=YES;
    self.vwOpt5.hidden=YES;
    self.vwOpt6.hidden=YES;
    self.txtAnswer.hidden=YES;
    self.txtAnswer.userInteractionEnabled=NO;
    //NSLog(@"%f",[self.vwAnswer bottom]);
    
    if ([[qData objectForKey:@"QuestionTypeId"] intValue]==1)
    {
        self.questionType=@"checkbox";
    }
    else if ([[qData objectForKey:@"QuestionTypeId"] intValue]==2)
    {
        self.questionType=@"radiobox";
    }
    else
    {
        self.questionType=@"checkbox";
    }
    
    CGRect answerFrame = self.vwAnswer.frame;
    //answerFrame.origin.y = [self.txtQuestion bottom] + 5;
    answerFrame.origin.y = [self.txtQuestion1 bottom];
    self.vwAnswer.frame = answerFrame;

    if (options==nil) {
        //input
        answerFrame=self.vwAnswer.frame;
        answerFrame.size.height=[self.txtAnswer bottom]+5;
        self.vwAnswer.frame=answerFrame;
        self.txtAnswer.hidden=NO;
        self.txtAnswer.userInteractionEnabled=YES;
        self.txtAnswer.delegate=self;
        [self.txtAnswer setText:[self.PageQuestionData objectForKey:@"Answer"]];
        
    }
    else{
    UIView *contentView;
    //For checkbox or radiobutton;
    for (int i=0;i< [options count]; i++) {
        switch (i) {
            case 0:
                contentView=self.vwOpt1;
                break;
            case 1:
                contentView=self.vwOpt2;
                break;
            case 2:
                contentView=self.vwOpt3;
                break;
            case 3:
                contentView=self.vwOpt4;
                break;
            case 4:
                contentView=self.vwOpt5;
                break;
            case 5:
                contentView=self.vwOpt6;
                break;
            default:
                contentView=self.vwOpt1;
                break;
        }
        contentView.hidden=NO;
        contentView.tag=100+i+1;
        UILabel *lbl=(UILabel *)[contentView viewWithTag:2];
        [lbl setText:[[options objectAtIndex:i] objectForKey:@"Answer"]];
        
        UIButton *button = (UIButton *)[contentView viewWithTag:3];
        [button addTarget:self  action:@selector(QuestionTap:)
         forControlEvents:UIControlEventTouchDown];
        UIImageView *img=(UIImageView *)[contentView viewWithTag:1];
        

        if ([[[options objectAtIndex:i] objectForKey:@"selected"] boolValue]) {
            [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_checked.png",self.questionType]]];
            [button setSelected:YES];
        }
        else{
            [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_unchecked.png",self.questionType]]];
            [button setSelected:NO];
        }

    }
    CGRect answerFrame=self.vwAnswer.frame;
    answerFrame.size.height=[contentView bottom] +100;
    self.vwAnswer.frame=answerFrame;
    }
    
    //NSLog(@"view height %f",[self.vwAnswer bottom]);
}

-(void)QuestionTap:(UIButton *)checkbox{
    //NSLog(@"tap");
    [checkbox setSelected:!checkbox.selected];
    
    UIView *parent=(UIView *)[checkbox superview];
    int i=parent.tag-100-1;
    
    NSMutableArray *options=[self.PageQuestionData objectForKey:@"Options"];
    if ([[self.PageQuestionData objectForKey:@"QuestionTypeId"] intValue]==2){
    //Remove all set this one
    //Only for single select options
    for (int iLoop=0;iLoop< [options count]; iLoop++) {
        NSDictionary *answertemo=[options objectAtIndex:iLoop];
        [answertemo setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    //if single option selected
    }
    NSDictionary *answer=[options objectAtIndex:i];
    if (checkbox.selected) {
        UIImageView *img=(UIImageView *)[parent viewWithTag:1];
        
        [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_checked.png",self.questionType]]];
         [answer setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
    }
    else{
        UIImageView *img=(UIImageView *)[parent viewWithTag:1];
        [img setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_unchecked.png",self.questionType]]];
        [answer setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    if (self.Delegate!=nil) {
        [self.Delegate userInetaction:self.PageQuestionData];
    }
}
-(CGFloat)getHeight{
    return 100;
}

#pragma mark textField
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.Delegate!=nil) {
        [self.Delegate answerTextControl:textView];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.PageQuestionData setValue:[NSString stringWithString:textView.text!=nil?textView.text:@""] forKey:@"Answer"];
    if (self.Delegate!=nil) {
        [self.Delegate userInetaction:self.PageQuestionData];
    }
    return YES;
}
@end
