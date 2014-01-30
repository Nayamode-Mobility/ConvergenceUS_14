//
//  EvaluationViewController.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "EvaluationViewController.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Functions.h"
#import "Shared.h"
#import "User.h"
#import "NSString+Custom.h"
#import "AppDelegate.h"

@interface EvaluationViewController ()
{
  NSURLConnection *apiConn;
    NSURLConnection *submitConn;
    KBKeyboardHandler *keyboard;
    //CGRect tableSize;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (strong, nonatomic) IBOutlet UITableView *tblEvaluation;
@property (nonatomic,retain)NSMutableArray *plistData;
@property (nonatomic, retain) NSMutableData *objData;

@end

@implementation EvaluationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSString *path = [[NSBundle mainBundle] bundlePath];
    //NSString *finalPath = [path stringByAppendingPathComponent:@"EvalutionList.plist"];
    //self.plistData = [NSMutableArray arrayWithContentsOfFile:finalPath];
    self.loader.hidden=YES;
    if (self.sessionid ==nil) {
        //self.sessionid=@"7d19abdc-c314-e311-b39a-00155d5066d7" ;
    }
    
    self.tblEvaluation.hidden=YES;
    [self getQuestionData ];
    keyboard = [[KBKeyboardHandler alloc] init];
    keyboard.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [self.tblEvaluation addGestureRecognizer:tap];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_EVALUATION];
    
    //[UIView addTouchEffect:self.view];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    keyboard.delegate = nil;
    keyboard = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if([DeviceManager IsiPad] == YES)
    {
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (IBAction)iPadMoveBAck:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.plistData count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.plistData count]==indexPath.row)
    {
        //Submit button
        return 60;
    }
    
    NSDictionary *bindData=[self.plistData objectAtIndex:indexPath.row];
   
    /*
    EvaluationQuestionCell *cell  =[[EvaluationQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.frame=CGRectMake(0, 0, 320, 900);
    [cell setQuestionData:bindData];
     */
    
    NSString *yourString=[bindData objectForKey:@"Title"];
    //UIFont *ft=[UIFont systemFontOfSize:17.0];
    UIFont *ft = [UIFont fontWithName:@"SegoeWP" size:17.0f];
    
    CGSize expectedLabelSize;
    if ([DeviceManager IsiPad])
    {
        expectedLabelSize = [yourString sizeWithFont:ft
                                   constrainedToSize:CGSizeMake(997, 1000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
    {
        expectedLabelSize = [yourString sizeWithFont:ft
                                   constrainedToSize:CGSizeMake(320, 1000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    CGFloat RowHeight= expectedLabelSize.height+10;
    //For iPhone
    NSMutableArray *options=[bindData objectForKey:@"Options"];

    if (options!=nil)
    {
        if ([DeviceManager IsiPad])
        {
            int rows=(int)ceilf(((float)[options count])/2);
            return RowHeight+(rows*47)+25;
        }
        else
        {
            return RowHeight+[options count]*47+25;
        }
    }
    else
    {
        return RowHeight+120;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    static NSString *SubmitCellIdentifier = @"TSubmit";
    
    if ([self.plistData count]==indexPath.row)
    {
        //Submit button
        EvaluationSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitCellIdentifier forIndexPath:indexPath];
        cell.Delegate=self;
        
        [[cell.btnsubmit layer] setBorderWidth:2.0f];
        [[cell.btnsubmit layer] setBorderColor:[UIColor whiteColor].CGColor];
        
        [cell.btnsubmit addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
        [cell.btnsubmit addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
        
        //[UIView addTouchEffect:cell.contentView];
        
        return cell;
    }
    else
    {
        EvaluationQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.Delegate=self;
        [cell setQuestionData:[self.plistData objectAtIndex:indexPath.row]];
        
        return cell;
    }
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}*/
-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    if (textboxAnswer!=nil) {
        [textboxAnswer resignFirstResponder];
        textboxAnswer=nil;
    }
}

#pragma mark Cell events
- (void)userInetaction:(NSDictionary*)data{
    //NSLog(@"data received");
    //check QuestionInstanceId
    NSString *updatedQuestion=[data objectForKey:@"QuestionInstanceId"] ;
    int questionindex=-1;
    for (int i =0; i<[self.plistData count]; i++) {
        NSMutableDictionary *q=[self.plistData objectAtIndex:i];
        if ([updatedQuestion isEqualToString:[ q objectForKey:@"QuestionInstanceId"]]) {
            questionindex=i;
            break;
        }
    }
    if (questionindex>-1) {
        //Replace question data
        [self.plistData replaceObjectAtIndex:questionindex withObject:data];
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:questionindex inSection:0];

        NSArray *arr=[NSArray arrayWithObjects:indexpath, nil];
        if (textboxAnswer==nil) {
            [self.tblEvaluation reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
UITextView *textboxAnswer;
- (void)answerTextControl:(UITextView*)sender{
    textboxAnswer=sender;
    //CGRect ss=self.tblEvaluation.frame;
    //ss.size.height=ss.size.height-200;
    //self.tblEvaluation.frame=ss;
    //NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.plistData count]) inSection:0];
    //[self.tblEvaluation scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //[sender becomeFirstResponder];
}
#pragma mark submit event
- (void)submit:(id)sender
{
    if (textboxAnswer!=nil)
    {
        [textboxAnswer resignFirstResponder];
        textboxAnswer=nil;
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            NSString *input=[self captureUserInput];
            
            if (input!=nil)
            {
                [self SubmitEvaluation:input];
            }
        });
    }
    else
    {
        NSString *input=[self captureUserInput];

        if (input!=nil)
        {
            [self SubmitEvaluation:input];
        }
    }
}

#pragma mark API Call
-(void)getQuestionData
{
    self.loader.hidden=NO;
    [self.loader startAnimating];
    User *objUser = [User GetInstance];
   
    NSString *strURL = strAPI_URL;
    if (self.sessionid ==nil)
    {
        strURL = [strURL stringByAppendingString:strAPI_EVALUATION_GETOVERALLEVALUATIONLIST];
    }
    else
    {
        strURL = [strURL stringByAppendingString:strAPI_EVALUATION_GETEVALUATIONLISTBYSESSIONINSTANCEID];
    }
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];

    if (self.sessionid !=nil)
    {
        [objRequest addValue:self.sessionid forHTTPHeaderField:@"SessionInstanceId"];
    }
    
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    apiConn = [[NSURLConnection alloc]initWithRequest:objRequest delegate:self];
}

-(void)SubmitEvaluation:(NSString *)json
{
//    Shared *objShared = [Shared GetInstance];
//    
//    if([objShared GetIsInternetAvailable] == NO)
//    {
//        [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//        return;
//    }
    if (APP.netStatus) {
    self.loader.hidden=NO;
    [self.loader startAnimating];
    User *objUser = [User GetInstance];
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_EVALUATION_SUBMITEVALUATION];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:json forHTTPHeaderField:@"EvaluationJSON"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    
    submitConn = [[NSURLConnection alloc]initWithRequest:objRequest delegate:self];
    }else{
        NETWORK_ALERT();
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.objData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection==submitConn)
    {
        NSString *response=[[NSString alloc]initWithData:self.objData encoding:NSStringEncodingConversionAllowLossy];
        //NSLog(@"%@",response);

        if ([response isEqualToString:@"true"])
        {
            [self showAlert:@"" withMessage:@"Thank you for submitting your evaluation." withButton:@"OK" withIcon:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            //UIAlertView *at=[[UIAlertView alloc]initWithTitle:nil message:@"Oops! Something went wrong and your evaluation could not be submitted. Please contact support on 425.996.7660 if this problem persists." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //[at show];
        }
    }
    else
    {
        NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
        NSError *error;
        dictData = [NSJSONSerialization JSONObjectWithData:self.objData options:kNilOptions error:&error];
        
        NSMutableArray *Evaluations=[dictData objectForKey:@"Evaluations"];
        
        if ([Evaluations count]>0)
        {
            NSString *SurveyId= [[Evaluations objectAtIndex:0] objectForKey:@"SurveyId"];
            
            
            NSMutableArray *questions=[[Evaluations objectAtIndex:0] objectForKey:@"Questions"];
            NSMutableArray *output=[[NSMutableArray alloc] init];
            for (NSMutableDictionary *eachQuestion in questions) {
                NSMutableDictionary *singleQuestion=[NSMutableDictionary dictionaryWithObjectsAndKeys:[eachQuestion objectForKey:@"Title"],@"Title",[eachQuestion objectForKey:@"QuestionInstanceId"] ,@"QuestionInstanceId",@"",@"Answer", nil];
                //NSLog(@"%@",eachQuestion);
                [singleQuestion setObject:[eachQuestion objectForKey:@"QuestionTypeId"] forKey:@"QuestionTypeId"];
                [singleQuestion setObject:SurveyId forKey:@"SurveyId"];
                NSMutableArray *ans=[eachQuestion objectForKey:@"Options"];
                NSMutableArray *showAns=[[NSMutableArray alloc] init];
                for (NSMutableDictionary *eachAns in ans) {
                    NSMutableDictionary *opt=[[NSMutableDictionary alloc] init];
                    [opt setObject:[eachAns objectForKey:@"Option"] forKey:@"Answer"];
                    [opt setObject:[eachAns objectForKey:@"OptionInstanceId"] forKey:@"OptionInstanceId"];
                    [opt setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
                    [showAns addObject:opt];
                }
                if ([showAns count]>0)
                {
                    [singleQuestion setObject:showAns forKey:@"Options"];
                }
                
                // Title,QuestionInstanceId
                [output addObject:singleQuestion];
            }
            //NSLog(@"%@",output);
            if ([output count]>0)
            {
                self.tblEvaluation.hidden=NO;
                self.plistData=output;
                [self.tblEvaluation reloadData];
            }
            
            self.loader.hidden=YES;
            [self.loader stopAnimating];
        }
        else
        {
            self.loader.hidden=YES;
            [self.loader stopAnimating];
        }
    }
}

- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}

-(NSString *)captureUserInput
{
    NSMutableArray *captureinput=[[NSMutableArray alloc] init];
    NSMutableDictionary *Question=[[NSMutableDictionary  alloc] init];
    NSMutableArray *Feedback=[[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *item in self.plistData)
    {
        NSMutableArray *options=[item objectForKey:@"Options"];
        
        //NSMutableDictionary *Question=[[NSMutableDictionary  alloc] init];
        [Question setObject:[item objectForKey:@"SurveyId"] forKey:@"SurveyId"];
        //[Question setObject:[item objectForKey:@"QuestionTypeId"] forKey:@"QuestionTypeId"];
        [Question setObject:self.sessionid==nil?@"":self.sessionid forKey:@"SessionInstanceId"];
        
        //NSMutableArray *Feedback=[[NSMutableArray alloc] init];
        
        if (options==nil)
        {
            //Text Input
            if([NSString IsEmpty:[item objectForKey:@"Answer"] shouldCleanWhiteSpace:YES] == NO)
            {
                NSMutableDictionary *userSelection=[[NSMutableDictionary alloc] init];
                
                [userSelection setObject:[item objectForKey:@"QuestionInstanceId"] forKey:@"QuestionInstanceId"];
                [userSelection setObject:[item objectForKey:@"QuestionTypeId"] forKey:@"QuestionTypeId"];
                [userSelection setObject:[item objectForKey:@"Answer"] forKey:@"Answer"];
                //[userSelection setObject:textboxAnswer.text forKey:@"Answer"];
                
                [Feedback addObject:userSelection];
                //[Question setObject:Feedback forKey:@"Feedback"];
                //[captureinput addObject:Question];
            }
        }else
        {
            NSMutableArray *answerSelected=[[NSMutableArray alloc] init];
            for (NSMutableDictionary *optLoop in options)
            {
                if ([[optLoop objectForKey:@"selected"] boolValue])
                {
                    [answerSelected addObject:[NSString stringWithString:[optLoop objectForKey:@"OptionInstanceId"]]];
                }
            }
            
            if ([answerSelected count]>0)
            {
                NSMutableDictionary *userSelection=[[NSMutableDictionary alloc] init];
                [userSelection setObject:[item objectForKey:@"QuestionInstanceId"] forKey:@"QuestionInstanceId"];
                [userSelection setObject:[item objectForKey:@"QuestionTypeId"] forKey:@"QuestionTypeId"];
                
                NSString *at=[answerSelected componentsJoinedByString:@","];
                [userSelection setObject:at forKey:@"Answer"];
                [Feedback addObject:userSelection];
                
                //[Question setObject:Feedback forKey:@"Feedback"];
                //[captureinput addObject:Question];
            }
        }
    }
    //if ([captureinput count]!=[self.plistData count])
    if ([Feedback count]!=[self.plistData count])
    {
        UIAlertView *allQuestionRequired=[[UIAlertView alloc] initWithTitle:nil message:@"All questions are mandatory. Please answer all the questions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [allQuestionRequired show];
        return nil;
    }

    [Question setObject:Feedback forKey:@"Feedback"];
    [captureinput addObject:Question];
    
    NSMutableDictionary *cp=[[NSMutableDictionary alloc] init];
    [cp setObject:captureinput forKey:@"Evaluation"];
        
    NSError *error1;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cp
                                                       options:0
                                                         error:&error1];
    NSString *JSONString ;
    if (!jsonData)
    {
        NSLog(@"JSON error: %@", error1);
    }
    else
    {
        JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON OUTPUT: %@",JSONString);
    }

    return JSONString;
}

#pragma mark keyboards
- (void)keyboardSizeChanged:(CGSize)delta
{
    // Resize / reposition your views here. All actions performed here
    // will appear animated.
    // delta is the difference between the previous size of the keyboard
    // and the new one.
    // For instance when the keyboard is shown,
    // delta may has width=768, height=264,
    // when the keyboard is hidden: width=-768, height=-264.
    // Use keyboard.frame.size to get the real keyboard size.
    
    // Sample:
    CGRect frame = self.view.frame;
    frame.size.height -= delta.height;
    self.view.frame = frame;
}

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}
@end
