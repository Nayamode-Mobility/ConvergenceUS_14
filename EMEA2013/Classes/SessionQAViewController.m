//
//  SessionQAViewController.m

//

#import "SessionQAViewController.h"
#import "Speaker.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "NSURLConnection+Tag.h"
#import "User.h"
#import "FBJSON.h"
#import "SessionDB.h"
#import "Speaker.h"


@interface SessionQAViewController ()
{
    SessionDB *sessionDB;
    
}
@property NSString *temp;
@property NSString *messageStr;
@end

@implementation SessionQAViewController
@synthesize temp,blnDropdownExpanded,blnViewExpanded,lblspeakerName,messageStr;

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
 
    self.blIsFromSession = true;
    
    
    sessionDB = [SessionDB GetInstance];
    NSArray * stack = self.navigationController.viewControllers;
    
    arrList = [[NSArray alloc]init];
    for (int i=stack.count-1; i > 0; --i)
    {
        if (stack[i] == self)
        {
            NSLog(@"previous view controller is %@",[stack[i-1] class]);
            temp = NSStringFromClass([stack[i-1] class]);
            break;
        }
        
    }
    
    if (![temp isEqualToString:@"SessionDetailViewController"] ) {
        tblSelectList.frame = CGRectMake(75, 5, tblSelectList.frame.size.width, 0);
        lblSessionTitle.hidden = YES;
         tblSelectList.allowsMultipleSelection = NO;
        
        lblspeakerName.text = [NSString stringWithFormat:@"%@ %@",self.speakerData.strFirstName, self.speakerData.strLastName];
       
        arrList = self.speakerData.arrSessions;
        
        
    }else{
       
        self.vwDropdownSendQts.hidden = YES;
        tblSelectList.allowsMultipleSelection = YES;
         arrList = self.sessionData.arrSpeakers;
      
        
      
        
    }

    
//    sessionArrList = [[NSArray alloc]init];
//    sessionArrList = [sessionDB GetSessionsWithSpeakers:YES];
    
    
    User *objUser = [User GetInstance];
    lblFrom.text = objUser.GetPreferredEmail;
    
    lblSessionTitle.text = self.sessionData.strSessionTitle;
    
    arrSelectedIndex = [[NSMutableArray alloc]init];
    
    
    [txtSubject setDelegate:self];
    
    [txtDescription setDelegate:self];
    
   
    
    // Ne Code For TextView Placeholder

    txtDescription.textColor = [UIColor lightGrayColor];
    txtDescription.delegate = self;
    lblMessagePlacehold = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0,txtDescription.frame.size.width - 10.0, 34.0)];
    [lblMessagePlacehold setText:@"Message (max 3000 characters)"];
    [lblMessagePlacehold setBackgroundColor:[UIColor clearColor]];
    [lblMessagePlacehold setTextColor:[UIColor lightGrayColor]];
    txtDescription.delegate = self;
    
    [txtDescription addSubview:lblMessagePlacehold];
    
    //********************************************************
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


// New Code for Set Txtview for Placeholder

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    txtDescription.text = @"";
    txtDescription.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(txtDescription.text.length == 0){
        txtDescription.textColor = [UIColor lightGrayColor];
       // txtDescription.text = @"Comment";
        [txtDescription resignFirstResponder];

        [lblMessagePlacehold setText:@"Message (max 3000 characters)"];
        
    }
    else
    {
    
    lblMessagePlacehold.text=nil;;
    
    }
}



- (void)keyboardWillHide:(NSNotification *)aNotification
{
    // the keyboard is hiding reset the table's height
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // the keyboard is showing so resize the table's height
    NSTimeInterval animationDuration =
    [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.origin.y = -200;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //if ([temp isEqualToString:@"SessionDetailViewController"] )
        return [arrList count];
    
   // else
        //return [sessionArrList count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //if (tableView == tblSelectList) {
    
    // Configure the cell...
    self.blnDropdownExpanded = NO;
    
    if ([temp isEqualToString:@"SessionDetailViewController"] ) {
        
        Speaker *objSpeaker = (Speaker *)[[arrList objectAtIndex:indexPath.row]objectAtIndex:0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",objSpeaker.strFirstName,objSpeaker.strLastName];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
       
    }
    else
    {
        Session *objSession = (Session *)[[arrList objectAtIndex:indexPath.row]objectAtIndex:0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",objSession.strSessionTitle];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        cell.textLabel.textColor = [UIColor whiteColor];
   
    }
    cell.backgroundColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
    
     cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    //tableViewCell.accessoryView.hidden = NO;
    
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    
    NSLog(@"%@",cellText);
    if (![temp isEqualToString:@"SessionDetailViewController"] ) {
//    self.lblSession.text=cellText;
    tblSelectList.frame = CGRectMake(75, 36, 228, 0);
    }

    
    [arrSelectedIndex addObject:[NSNumber numberWithInt:indexPath.row]];
    tableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
-(IBAction)btnList_Click:(id)sender
{
    
}



- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSend_Click:(id)sender
{
 
    NSIndexPath *path = [tblSelectList indexPathForSelectedRow];
if (!path) {
   messageStr  = @"Please Select Speaker \n";
}

    if ([txtDescription.text isEqualToString:@""] && [txtSubject.text isEqualToString:@""]) {
        
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:[messageStr stringByAppendingString:@"Subject and description required"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
 
        
    }else{
    NSString *strSpeakerInstanceId;
    for (int i =0; i<[arrList count]; i++)
    {
        for (NSNumber *index in arrSelectedIndex)
        {
            if ([NSNumber numberWithInt:i] == index)
            {
                Speaker *objSpeaker = [[arrList objectAtIndex:i] objectAtIndex:0] ;
                if (!strSpeakerInstanceId)
                {
                    strSpeakerInstanceId = objSpeaker.strSpeakerInstanceID;
                }
                else
                {
                    strSpeakerInstanceId = [NSString stringWithFormat:@"%@,%@",strSpeakerInstanceId,objSpeaker.strSpeakerInstanceID];
                }
            }
        }
    }
    
    User *objUser = [User GetInstance];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_AskToSpeakers];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    
    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
    [dictData setObject:txtSubject.text forKey:@"Question"];
    [dictData setObject:txtDescription.text forKey:@"QuestionDescription"];
    [dictData setObject:strSpeakerInstanceId forKey:@"SpeakerInstanceId"];
    [dictData setObject:self.sessionData.strSessionInstanceID forKey:@"SessionInstanceId"];
    
    NSString* strData = [dictData JSONRepresentation];
    NSLog(@"Post Data: %@",strData);
    NSString *postString = [NSString stringWithFormat:@"%@",strData];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [postString length]];
    [objRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [objRequest setHTTPBody: [postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSLog(@"Token:%@\n SessionId:%@",strAPI_AUTH_TOKEN,self.sessionData.strSessionInstanceID);
    NSLog(@"URL: %@",strURL);
    NSLog(@"Body: %@",postString);
    
    self.objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_BATCH_GET_CONVERGENCE_DTL];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ExceptionHandler AddExceptionForScreen:strSCREEN_SYNC_UP MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",strData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [txtSubject resignFirstResponder];
    return YES;
}


-(IBAction)btnCancel_Click:(id)sender{
    [self.view endEditing:YES];
}
- (void)ShrinkDropdownView
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        self.vwDropdownSendQts.frame = CGRectMake(self.vwDropdownSendQts.frame.origin.x, self.vwDropdownSendQts.frame.origin.y, (self.vwDropdownSendQts.frame.size.width), 0);
    } completion:nil];
}

- (IBAction)dropdown:(id)sender {
    
    tblSelectList.frame = CGRectMake(75, 36, 228, 100);
    
    
    if(self.blIsFromSession)
    {
    
        self.blIsFromSession=FALSE;
        
        
        
    }else{
     tblSelectList.frame = CGRectMake(75, 36, 228, 0);
        self.blIsFromSession=true;
    }
  
    
}
-(void)expandViewSendQts:(id)sender{

   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (txtSubject.text.length >= 5 && range.length == 0)
    {
    	return NO; // return NO to not change text
    }
    else
    {return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [txtDescription resignFirstResponder];
    
    return txtDescription.text.length + (text.length - range.length) <= 5;
    
    
}







@end
