//
//  MySheduleCustomCollectionViewCell.m
//  mgx2013
//
//  Created by Amit Karande on 07/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MySheduleCustomCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "Session.h"
#import "Constants.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "SessionDB.h"
#import "MySessionDB.h"
#import "Session.h"
#import "Speaker.h"
#import "MasterDB.h"
#import "User.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "AppDelegate.h"

@implementation MySheduleCustomCollectionViewCell
@synthesize objConnection, objData;

id objSender;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setTableViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate arrSessionList:(NSArray *)arrSessionList
{
    self.myCollectionView.dataSource = dataSourceDelegate;
    self.myCollectionView.delegate = self;

    if (self.arrSessions == nil)
    {
        self.arrSessions = [[NSMutableArray alloc] init];
    }
    self.arrSessions = [arrSessionList mutableCopy];
    
    [self.myCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return [self.arrSessions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    //CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    //Session *objSession = [self.arrSessions objectAtIndex:indexPath.row];
    //cell.lblTitle.text = objSession.strSessionTitle;
    //cell.lblName.text = @"";
    //cell.lblDate.text = [self formatDate:objSession.strStartDate sourceFormat:@"yyyy-MM-dd" destinationFormat:@"EEEE, LLLL d"];
    //cell.lblLocation.text = @"";
    //cell.lblCompany.text = objSession.strSessionTitle;
    //cell.lblTiming.text = [NSString stringWithFormat:@"%@ - %@",[self formatDate:objSession.strStartDate sourceFormat:@"HH:mm:ss" destinationFormat:@"HH:mm a"],[self formatDate:objSession.strStartDate sourceFormat:@"HH:mm:ss" destinationFormat:@"HH:mm a"]];

    //return cell;
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
    
    Session *objSession = [self.arrSessions objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = objSession.strSessionTitle;
    cell.tag = indexPath.row;
    cell.btnDetail.tag = indexPath.row;
    
    cell.btnNote.tag = indexPath.row;
    cell.btnTakeNote.tag = indexPath.row;
    
    if([objSession.strNotesAvailable boolValue] == YES)
    {
        cell.btnTakeNote.hidden = YES;
        cell.btnNote.hidden = NO;
    }
    else
    {
        cell.btnTakeNote.hidden = NO;
        cell.btnNote.hidden = YES;
    }
    
    cell.btnRemoveFromMySchedule.hidden = ![[objSession strIsAdded] boolValue];
    cell.btnRemoveFromMySchedule.tag = indexPath.row;
    
    [cell.vwSessionButtons setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
    
    [cell.btnRemoveFromMySchedule addTarget:self action:@selector(RemoveFromMySchedule:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *strSpeakers = @"";
    if([objSession.arrSpeakers count] > 0)
    {
        for (NSUInteger i = 0; i < [objSession.arrSpeakers count]; i++)
        {
            if(![NSString IsEmpty:strSpeakers shouldCleanWhiteSpace:YES])
            {
                strSpeakers = [strSpeakers stringByAppendingString:@", "];
            }
            strSpeakers = [strSpeakers stringByAppendingString:[[[objSession.arrSpeakers objectAtIndex:i] objectAtIndex:0] strFirstName]];
            strSpeakers = [strSpeakers stringByAppendingString:@" "];
            strSpeakers = [strSpeakers stringByAppendingString:[[[objSession.arrSpeakers objectAtIndex:i] objectAtIndex:0] strLastName]];
        }
    }
    cell.lblName.text = strSpeakers;
    
    if ([objSession.arrRooms count] > 0){
        Rooms *objRoom = [objSession.arrRooms objectAtIndex:0];
        cell.lblRoom.text = objRoom.strRoomName;
    }
    cell.lblSessionCode.text = [NSString stringWithFormat:@"Session Code: %@",objSession.strSessionCode];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"HH:mm:ss"];
    NSDate *dtStartTime = [dateFormater dateFromString:objSession.strStartTime];
    NSDate *dtEndTime = [dateFormater dateFromString:objSession.strEndTime];
    
    [dateFormater setDateFormat:@"hh:mm a"];
    NSString *strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
    strTime = [strTime stringByAppendingString:@" - "];
    strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
    cell.lblTiming.text = strTime;
    
    [dateFormater setDateFormat:@"HH:mm"];
    strTime = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtStartTime]];
    strTime = [strTime stringByAppendingString:@" - "];
    strTime = [strTime stringByAppendingString:[NSString stringWithFormat:@"%@",[dateFormater stringFromDate:dtEndTime]]];
   
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *dtStartDate = [dateFormater dateFromString:objSession.strStartDate];
    [dateFormater setDateFormat:@"EEEE dd MMM,"];
    cell.lblDate.text = [NSString stringWithFormat:@"%@ %@",[dateFormater stringFromDate:dtStartDate],strTime];
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(NSString *)formatDate:(NSString *)strDate sourceFormat:(NSString *)sourceFormat destinationFormat:(NSString *)destinationFormat
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:sourceFormat];
    NSDate *dbdate = [dateFormat dateFromString:strDate];
    [dateFormat setDateFormat:destinationFormat];
    NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
    return strFormattedDate;
}

- (IBAction)RemoveFromMySchedule:(id)sender
{
    //Shared *objShared = [Shared GetInstance];
    
//    if (!APP.netStatus) {
//        NETWORK_ALERT();
//        return;
//    }
    objSender = sender;
    
    UIAlertView *confirm = [[UIAlertView alloc]
                            initWithTitle:nil
                            message:@"Do you really want to remove this session from you r schedule?"
                            delegate:self
                            cancelButtonTitle:@"Yes"
                            otherButtonTitles:@"No", nil];
    
    confirm.tag = 1;
    [confirm show];
}

- (void)RemoveFromMySchedule
{
    BOOL blnResult = NO;
    
    //objSender = sender;
    //UIButton *btnRemove = (UIButton*)sender;
    UIButton *btnRemove = (UIButton*)objSender;
    
    Session *objSession = [self.arrSessions objectAtIndex:btnRemove.tag];
    
    NSLog(@"%@",[objSession strSessionInstanceID]);
    NSLog(@"%@",[objSession strSessionTitle]);
    
    MySessionDB *objMySessionDB = [MySessionDB GetInstance];
    blnResult = [objMySessionDB DeleteSession:[objSession strSessionInstanceID]];
    
    [[self.arrSessions objectAtIndex:btnRemove.tag] setStrIsAdded: @"0"];
    [self.arrSessions removeObjectAtIndex:btnRemove.tag];
    
    [self.myCollectionView reloadData];
    
    [self showAlert:nil withMessage:@"Session has been removed from your schedule." withButton:@"OK" withIcon:nil];
    
//    User *objUser = [User GetInstance];
//    
//    NSString *strURL = strAPI_URL;
//    strURL = [strURL stringByAppendingString:strAPI_SESSION_ADD_MY_SESSION_LIST];
//    
//    NSURL *URL = [NSURL URLWithString:strURL];
//    
//    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
//    [objRequest setHTTPMethod:@"POST"];
//    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
//    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
//    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
//    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
//    
//    [objRequest addValue:[objSession strSessionInstanceID] forHTTPHeaderField:@"SessionInstanceId"];
//    [objRequest addValue:@"true" forHTTPHeaderField:@"IsScheduleRemoved"];
//    
//    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_REMOVE_MY_SESSION_LIST];
}

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    objSender = nil;
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
    NSInteger intTag = (int)[connection getTag];
    //NSLog(@"Connection Tag: %d",intTag);
    
    NSString *strData = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_REMOVE_MY_SESSION_LIST:
        {
            if ([strData isEqualToString:@"true"])
            {
                //UIButton *btnRemove = (UIButton*)objSender;
                //[[self.arrSessions objectAtIndex:btnRemove.tag] setStrIsAdded: @"0"];
                //[self.arrSessions removeObjectAtIndex:btnRemove.tag];
                
                //[self.myCollectionView reloadData];
                objSender = nil;
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -

#pragma mark Alert Events
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag != 1)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            [self RemoveFromMySchedule];
        }
            break;
        case 1:
        {
            //Do Nothing
        }
            break;
        default:
            break;
    }
}
#pragma mark  -
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
@end
