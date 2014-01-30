//
//  EvaluationViewController.h
//  mgx2013
//
//  Created by Sang.Mac.04 on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "EvaluationQuestionCell.h"
#import "EvaluationSubmitCell.h"
#import "KBKeyboardHandler.h"

@interface EvaluationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,EvaluationQuestionCellDelegate,EvaluationSubmitCellDelegate,KBKeyboardHandlerDelegate>
{
}

@property (nonatomic,retain) NSString *sessionid;
@end
