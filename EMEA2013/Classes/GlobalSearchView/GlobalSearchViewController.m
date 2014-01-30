//
//  GlobalSearchViewController.m
//  mgx2013
//
//  Created by Amit Karande on 25/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#define iPhone_Item_Width 300.0
#define iPhone_Item_Height 180.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 3.0

#import "GlobalSearchViewController.h"
#import "CustomCollectionViewCell.h"
//#import "AttendeeCustomCollectionViewCell.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "NSString+Custom.h"

#import "AttendeeDB.h"
#import "Attendee.h"
#import "AttendeeDetailViewController.h"

#import "ExhibitorDB.h"
#import "Exhibitor.h"
#import "ExhibitorCustomCell.h"
#import "SponsorsDetailViewController.h"

#import "SessionDB.h"
#import "SessionDetailViewController.h"

#import "SpeakerDB.h"
#import "Speaker.h"
#import "SpeakerDetailViewController.h"


@interface GlobalSearchViewController ()

@end

@implementation GlobalSearchViewController

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
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshGlobalSearch) name:@"SyncUpCompleted" object:nil];
    
    [self.svwGlobalSearch setHidden:YES];
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self txtSearch] becomeFirstResponder];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_GLOBAL_SEARCH];
    
    //[UIView addTouchEffect:self.view];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == [self txtSearch])
    {
        //[[self txtSearch] resignFirstResponder];
        [self btnSearchClicked:[self btnSearch]];
    }
    
    return  YES;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (view == self.colAttendees) {
        return [self.arrAttendees count];
    }
    else if(view == self.colExhibitors){
        return [self.arrExhibitors count];
    }
    else if(view == self.colSessions){
        return [self.arrSessions count];
    }
    else if(view == self.colSpeakers){
        return [self.arrSpeaker count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    UICollectionViewCell *cell;
    if (cv==self.colAttendees) {
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
        Attendee *objAttendee = [self.arrAttendees objectAtIndex:indexPath.row];
        
        ((CustomCollectionViewCell *)cell).lblName.text = [NSString stringWithFormat:@"%@ %@",objAttendee.strFirstName,objAttendee.strLastName];
        ((CustomCollectionViewCell *)cell).lblTitle.text = objAttendee.strAttendeeName;
        ((CustomCollectionViewCell *)cell).lblCompany.text = objAttendee.strCompany;
        ((CustomCollectionViewCell *)cell).cellData = objAttendee;
        
        ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageNamed:@"normal.png"];
        if(![NSString IsEmpty:objAttendee.strPhotoURL shouldCleanWhiteSpace:YES])
        {
            NSURL *imgURL = [NSURL URLWithString:objAttendee.strPhotoURL];
            NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
            [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                       NSData *data,
                                                                                                                       NSError *error)
             {
                 if (!error)
                 {
                     ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageWithData:data];
                 }
             }];
        }
    }
    else if(cv == self.colExhibitors){
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
        Exhibitor *objExhibitor = [self.arrExhibitors objectAtIndex:indexPath.row];
        
        ((CustomCollectionViewCell *)cell).lblName.text = [NSString stringWithFormat:@"%@",objExhibitor.strExhibitorName];
        
        ((CustomCollectionViewCell *)cell).lblBooth.text = @"";
        if(![NSString IsEmpty:objExhibitor.strBoothNumbers shouldCleanWhiteSpace:YES])
        {
            ((CustomCollectionViewCell *)cell).lblBooth.text = [NSString stringWithFormat:@"Booth: %@",objExhibitor.strBoothNumbers];
        }
        
        ((CustomCollectionViewCell *)cell).cellData = objExhibitor;
        
        ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageNamed:@"company.png"];
        if(![NSString IsEmpty:objExhibitor.strLogoURL shouldCleanWhiteSpace:YES])
        {
            NSURL *imgURL = [NSURL URLWithString:objExhibitor.strLogoURL];
            NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
            [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                       NSData *data,
                                                                                                                       NSError *error)
             {
                 if (!error)
                 {
                     ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageWithData:data];
                     ((CustomCollectionViewCell *)cell).imgLogo.contentMode = UIViewContentModeScaleAspectFit;
                 }
             }];
        }
    }
    else if(cv == self.colSessions){
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        Session *objSession = [self.arrSessions objectAtIndex:indexPath.row];
        
        ((CustomCollectionViewCell *)cell).lblTitle.text = objSession.strSessionTitle;
    }
    else if(cv == self.colSpeakers){
        cell = [cv dequeueReusableCellWithReuseIdentifier:@"TCell" forIndexPath:indexPath];
        Speaker *objSpeaker = [self.arrSpeaker objectAtIndex:indexPath.row];
        
        ((CustomCollectionViewCell *)cell).lblName.text = [NSString stringWithFormat:@"%@ %@",objSpeaker.strFirstName,objSpeaker.strLastName];
        ((CustomCollectionViewCell *)cell).lblTitle.text = objSpeaker.strTitle;
        ((CustomCollectionViewCell *)cell).lblCompany.text = objSpeaker.strCompany;
        ((CustomCollectionViewCell *)cell).cellData = objSpeaker;
        
        ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageNamed:@"normal.png"];
        if(![NSString IsEmpty:objSpeaker.strSpeakerPhoto shouldCleanWhiteSpace:YES])
        {
            NSURL *imgURL = [NSURL URLWithString:objSpeaker.strSpeakerPhoto];
            NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
            [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                       NSData *data,
                                                                                                                       NSError *error){
                if (!error)
                {
                    ((CustomCollectionViewCell *)cell).imgLogo.image = [UIImage imageWithData:data];
                    ((CustomCollectionViewCell *)cell).imgLogo.contentMode = UIViewContentModeScaleAspectFit;
                }
            }];
        }
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UIStoryboard *storyboard;
    if([DeviceManager IsiPad] == YES)
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
    }
    
    if (collectionView == self.colAttendees) {
        AttendeeDetailViewController *controller;
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idAttendeeDetail"];
        controller.attendeeData =  [self.arrAttendees objectAtIndex:indexPath.row];
        [[self navigationController] pushViewController:controller animated:YES];
    }
    else if(collectionView == self.colExhibitors){
        SponsorsDetailViewController *controller;
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idSponsorDetail"];
        controller.exhibitorData = [self.arrExhibitors objectAtIndex:indexPath.row];
        controller.blnIsExhibitors = YES;
        [[self navigationController] pushViewController:controller animated:YES];
    }
    else if(collectionView == self.colSessions){
        SessionDetailViewController *controller;
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idSessionDetail"];
        controller.sessionData = [self.arrSessions objectAtIndex:indexPath.row];
        [[self navigationController] pushViewController:controller animated:YES];
    }
    else if(collectionView == self.colSpeakers){
        SpeakerDetailViewController *controller;
        controller = [storyboard instantiateViewControllerWithIdentifier:@"idSpeakerDetail"];
        controller.speakerData = [self.arrSpeaker objectAtIndex:indexPath.row];
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RefreshGlobalSearch
{
    if(![NSString IsEmpty:self.txtSearch.text shouldCleanWhiteSpace:YES])
    {
        [self btnSearchClicked:[self btnSearch]];
    }
}

- (IBAction)btnSearchClicked:(id)sender
{
    [[self lblNoItemsFound] setHidden: YES];
    
    //Min. 3 charecters need to be searched
    if(self.txtSearch.text.length < 3)
    {
        if(self.txtSearch.text.length == 0)
        {
           [self.txtSearch resignFirstResponder];
        }
        
        [self showAlert:@"" withMessage:@"Please enter text to search. Minimum text length should be 3." withButton:@"OK" withIcon:nil];
        
        return;
    }
    
    [self.txtSearch resignFirstResponder];
    
    CGRect viewsize;
    int x=0;
    int intItemWidth = 270;
    
    ExhibitorDB *objExhibitorDB = [ExhibitorDB GetInstance];
    self.arrExhibitors = [objExhibitorDB GetSearch:self.txtSearch.text==nil?@"":self.txtSearch.text];
    if ([self.arrExhibitors count] > 0)
    {
        self.vwExhibitors.hidden=NO;
        [self.colExhibitors reloadData];
        viewsize=self.vwExhibitors.frame;
        viewsize.origin.x=x;
        [self.vwExhibitors setFrame:viewsize];
        if ([DeviceManager IsiPhone])
        {
            x=x+320;
            self.lblExhibitors.text = [NSString stringWithFormat:@"EXHIBITOR (%d)",[self.arrExhibitors count]];
            
            
        }
        else
        {
            double itemCount = [self.arrExhibitors count];
            float rows=((float)itemCount)/5;
            rows=ceilf(rows);
            
            viewsize=self.vwExhibitors.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.vwExhibitors setFrame:viewsize];
            
            viewsize=self.colExhibitors.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.colExhibitors setFrame:viewsize];
            
            x = x + ((int)rows)*intItemWidth;
            
            [self.lblExhibitors setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
            self.lblExhibitors.text = [NSString stringWithFormat:@"  EXHIBITOR(%d)",[self.arrExhibitors count]];
            [self.lblExhibitors sizeToFit];
            viewsize=self.lblExhibitors.frame;
            viewsize.size.width=viewsize.size.width+10;
            self.lblExhibitors.frame= viewsize;
        }
        
    }else
    {
        self.vwExhibitors.hidden=YES;
    }
    
    SessionDB *objSessionDB = [SessionDB GetInstance];
    self.arrSessions = [objSessionDB GetSearch:self.txtSearch.text==nil?@"":self.txtSearch.text];
    if ([self.arrSessions count] > 0)
    {
        self.vwSessions.hidden=NO;
        [self.colSessions reloadData];
        viewsize=self.vwSessions.frame;
        viewsize.origin.x=x;
        [self.vwSessions setFrame:viewsize];
        if ([DeviceManager IsiPhone])
        {
            x=x+320;
            self.lblSessions.text =[NSString stringWithFormat:@"SESSION (%d)",[self.arrSessions count]];
            
        }
        else
        {
            double itemCount = [self.arrSessions count];
            float rows=((float)itemCount)/5;
            rows=ceilf(rows);
            
            viewsize=self.vwSessions.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.vwSessions setFrame:viewsize];
            
            viewsize=self.colSessions.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.colSessions setFrame:viewsize];
            
            x = x + ((int)rows)*intItemWidth;
            [self.lblSessions setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
            self.lblSessions.text = [NSString stringWithFormat:@"  SESSION(%d)",[self.arrSessions count]];
            [self.lblSessions sizeToFit];
            viewsize=self.lblSessions.frame;
            viewsize.size.width=viewsize.size.width+10;
            self.lblSessions.frame= viewsize;
        }
    }else
    {
        self.vwSessions.hidden=YES;
    }
    
    SpeakerDB *objSpeakerDB = [SpeakerDB GetInstance];
    self.arrSpeaker = [objSpeakerDB GetSearch:self.txtSearch.text==nil?@"":self.txtSearch.text];
    if ([self.arrSpeaker count] > 0)
    {
        self.vwSpeaker.hidden=NO;
        [self.colSpeakers reloadData];
        viewsize=self.vwSpeaker.frame;
        viewsize.origin.x=x;
        [self.vwSpeaker setFrame:viewsize];
        if ([DeviceManager IsiPhone]) {
            x=x+320;
            self.lblSpeakers.text = [NSString stringWithFormat:@"SPEAKER (%d)",[self.arrSpeaker count]];
            
        }
        else
        {
            double itemCount = [self.arrSpeaker count];
            float rows=((float)itemCount)/5;
            rows=ceilf(rows);
            
            viewsize=self.vwSpeaker.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.vwSpeaker setFrame:viewsize];
            
            viewsize=self.colSpeakers.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.colSpeakers setFrame:viewsize];
            
            x = x + ((int)rows)*intItemWidth;
            [self.lblSpeakers setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
            self.lblSpeakers.text = [NSString stringWithFormat:@"  SPEAKER(%d)",[self.arrSpeaker count]];
            [self.lblSpeakers sizeToFit];
            viewsize=self.lblSpeakers.frame;
            viewsize.size.width=viewsize.size.width+10;
            self.lblSpeakers.frame= viewsize;
        }
    }else
    {
        self.vwSpeaker.hidden=YES;
    }
    
    AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
    self.arrAttendees = [objAttendeeDB GetSearch:self.txtSearch.text==nil?@"":self.txtSearch.text];
    if ([self.arrAttendees count] > 0)
    {
        self.vwAttendee.hidden=NO;
        [self.colAttendees reloadData];
        viewsize=self.vwAttendee.frame;
        viewsize.origin.x=x;
        [self.vwAttendee setFrame:viewsize];
        if ([DeviceManager IsiPhone])
        {
            x=x+320;
            self.lblAttendees.text = [NSString stringWithFormat:@"ATTENDEE (%d)",[self.arrAttendees count]];
            
        }
        else
        {
            double itemCount = [self.arrAttendees count];
            float rows=((float)itemCount)/5;
            rows=ceilf(rows);
            
            viewsize=self.vwAttendee.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.vwAttendee setFrame:viewsize];
            
            viewsize=self.colAttendees.frame;
            viewsize.size.width=((int)rows)*intItemWidth;
            [self.colAttendees setFrame:viewsize];
            
            x = x + ((int)rows)*intItemWidth;
            [self.lblAttendees setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
            self.lblAttendees.text = [NSString stringWithFormat:@"  ATTENDEE(%d)",[self.arrAttendees count]];
            [self.lblAttendees sizeToFit];
            viewsize=self.lblAttendees.frame;
            viewsize.size.width=viewsize.size.width+10;
            self.lblAttendees.frame= viewsize;
        }
    }else
    {
        self.vwAttendee.hidden=YES;
    }
    [self.svwGlobalSearch setContentSize:CGSizeMake(x, self.svwGlobalSearch.frame.size.height)];
    
    if(x == 0)
    {
        [[self lblNoItemsFound] setHidden: NO];
    }
    else
    {
        [[self svwGlobalSearch] setHidden:NO];
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
@end
