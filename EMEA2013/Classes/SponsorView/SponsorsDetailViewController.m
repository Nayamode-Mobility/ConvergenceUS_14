//
//  SponsorsDetailViewController.m
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import "SponsorsDetailViewController.h"
#import "DeviceManager.h"
#import "Functions.h"
#import "Shared.h"
#import "SponsorCategories.h"
#import "SessionResourceCell.h"
#import "ExhibitorResources.h"
#import "AttendeeDB.h"
#import "Constants.h"
#import "Functions.h"
#import "User.h"
#import "ExhibitorCategories.h"
#import "ExhibitorResources.h"
#import "NSString+Custom.h"
#import "NSURLConnection+Tag.h"
#import "FacebookViewController.h"
#import "TwitterViewController.h"
#import "LinkedInViewController.h"
#import "MapView.h"
#import "NSString+Custom.h"
#import "AppDelegate.h"

@interface SponsorsDetailViewController ()

@end

@implementation SponsorsDetailViewController
@synthesize strData, myScrollView, vwDropdownMenu, blnViewExpanded, sponsorData;
@synthesize lblAddress, lblAddressLine1, lblAddressLine2, imgLogo, lblCompanyInformation, lblCompanyLocation, lblCompanyName, lblPhone, lblEmail, lblWebsite, lblBoothLocation, lblSelectedItem, lblInfo;
@synthesize objConnection, objData;

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
    
    [[[self btnAddToFav] layer] setBorderWidth:2.0f];
    [[[self btnAddToFav] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnAddToFav] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnAddToFav] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnRemoveFromFav] layer] setBorderWidth:2.0f];
    [[[self btnRemoveFromFav] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRemoveFromFav] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRemoveFromFav] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    blnViewExpanded = NO;
    if (self.blnIsExhibitors)
    {
        [[self btnAddToFav] setHidden:NO];
        self.lblHeaderTitle.text = @"EXHIBITORS";
        self.lblTitle.text = @"exhibitor detail";
        [self populateExhibitorrData];
    }
    else
    {
        [[self btnAddToFav] setHidden:YES];
        self.lblHeaderTitle.text = @"SPONSORS";
        self.lblTitle.text = @"sponsor detail";
        [self populateSponsorData];
    }
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SPONSOR];
    
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

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:13/255.0 blue:122/255.0 alpha:1.0]];
}

- (void) populateExhibitorrData
{
    lblCompanyName.text = [NSString stringWithFormat:@"Company: %@",self.exhibitorData.strExhibitorName];
    
    lblCompanyInformation.text = self.exhibitorData.strCompanyProfile;
    
    lblBoothLocation.text = @"";
    if(![NSString IsEmpty:self.exhibitorData.strBoothNumbers shouldCleanWhiteSpace:YES])
    {
        lblBoothLocation.text = [NSString stringWithFormat:@"Booth: %@",self.exhibitorData.strBoothNumbers];
    }
    
    lblAddressLine1.text = self.exhibitorData.strAddress1;
    lblAddressLine2.text = self.exhibitorData.strAddress2;
    lblCompanyLocation.text = self.exhibitorData.strCity;
    
    NSLog([[self.exhibitorData strIsAdded] boolValue]?@"YES":@"NO");
    
    self.btnAddToFav.hidden = [[self.exhibitorData strIsAdded] boolValue];
    self.btnRemoveFromFav.hidden = ![[self.exhibitorData strIsAdded] boolValue];
    
    NSString *strAddress = @"";
    if(![NSString IsEmpty:self.exhibitorData.strAddress1 shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.exhibitorData.strAddress1];
        strAddress = [strAddress stringByAppendingString:@"\r"];
    }
    
    if(![NSString IsEmpty:self.exhibitorData.strAddress2 shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.exhibitorData.strAddress2];
        strAddress = [strAddress stringByAppendingString:@"\r"];
    }
    
    if(![NSString IsEmpty:self.exhibitorData.strCity shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.exhibitorData.strCity];
    }
    
    if(![NSString IsEmpty:self.exhibitorData.strState shouldCleanWhiteSpace:YES])
    {
        if(![NSString IsEmpty:self.exhibitorData.strCity shouldCleanWhiteSpace:YES])
        {
            strAddress = [strAddress stringByAppendingString:@", "];
        }
        strAddress = [strAddress stringByAppendingString:self.exhibitorData.strState];
    }
    
    if(![NSString IsEmpty:self.exhibitorData.strState shouldCleanWhiteSpace:YES] | ![NSString IsEmpty:self.exhibitorData.strCity shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:@"\r"];
    }
    
    if(![NSString IsEmpty:self.exhibitorData.strZipCode shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.exhibitorData.strZipCode];
    }
    
    lblAddress.text = strAddress;
    [lblAddress sizeToFit];
    
    lblWebsite.text = self.exhibitorData.strWebsiteURL;
    lblEmail.text =self.exhibitorData.strEmail;
    
    self.imgLogo.image = [UIImage imageNamed:@"company.png"];
    if(![NSString IsEmpty:self.exhibitorData.strLogoURL shouldCleanWhiteSpace:YES])
    {
        NSURL *imgURL = [NSURL URLWithString:self.exhibitorData.strLogoURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                UIImage *img = [[UIImage alloc] initWithData:data];;
                [self.imgLogo setImage:img];
                
            }
        }];
    }
    
    
    CGSize expectedLabelSize = [self.exhibitorData.strCompanyProfile sizeWithFont:self.lblCompanyInformation.font
                                                                constrainedToSize:CGSizeMake(280,1000)
                                
                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    lblCompanyInformation.frame = CGRectMake(lblCompanyInformation.frame.origin.x, lblCompanyInformation.frame.origin.y, 280, expectedLabelSize.height);
    
    int intY= 100;
    for (ExhibitorCategories *objExhibitorCategory in self.exhibitorData.arrCategories)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, intY, 280, 21)];
        label.text = objExhibitorCategory.strParentCategoryInstanceID;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:(104.0/255.0) green:(33.0/255.0) blue:0 alpha:1.0];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [self.svwCategories addSubview:label];
        
        intY = intY + 20;
        
        NSArray *arr = [objExhibitorCategory.strCategoryName componentsSeparatedByString:@","];
        for (NSString *strTemp in arr)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, intY, 280, 21)];
            label.text = strTemp;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [self.svwCategories addSubview:label];
            intY = intY + 20;
        }
        intY = intY + 10;
    }
    
    [self.svwCategories setContentSize:CGSizeMake(320, (intY+20))];
    //self.arrResources = self.exhibitorData.arrResources;
    //[self.colResources reloadData];
    
    if ([DeviceManager IsiPad])
    {
        self.lblTitle.text = self.exhibitorData.strExhibitorName;
        self.txtCompanyInformation.text = [NSString stringWithFormat:@"Profile: %@",self.exhibitorData.strCompanyProfile];
        [self.svwSponsors setContentSize:CGSizeMake(160, 648)];
        [self.svwResources setFrame:CGRectMake(0, 0, 0, 0)];
    }
    else
    {
        self.vwShare.frame = CGRectMake(20, (expectedLabelSize.height + lblCompanyInformation.frame.origin.y), self.vwShare.frame.size.width, self.vwShare.frame.size.height);
        
        [self.svwDetail setContentSize:CGSizeMake(320, (self.vwShare.frame.size.height + self.vwShare.frame.origin.y))];
        [self.svwSponsors setContentSize:CGSizeMake(640, self.svwSponsors.frame.size.height)];
        [self.svwResources setFrame:CGRectMake(0, 0, 0, 0)];
    }
}

-(void) populateSponsorData
{
    lblCompanyName.text = [NSString stringWithFormat:@"Name: %@",self.sponsorData.strSponsorName];

    lblCompanyInformation.text = self.sponsorData.strCompanyProfile;
    
    lblBoothLocation.text = [NSString stringWithFormat:@"Level: %@",self.sponsorData.strSponsorLevelName];
    
    lblAddressLine1.text = self.sponsorData.strAddress1;
    lblAddressLine2.text = self.sponsorData.strAddress2;
    lblCompanyLocation.text = self.sponsorData.strCity;
    
    NSString *strAddress = @"";
    if(![NSString IsEmpty:self.sponsorData.strAddress1 shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.sponsorData.strAddress1];
        strAddress = [strAddress stringByAppendingString:@"\r"];
    }
    
    if(![NSString IsEmpty:self.sponsorData.strAddress2 shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.sponsorData.strAddress2];
        strAddress = [strAddress stringByAppendingString:@"\r"];
    }

    if(![NSString IsEmpty:self.sponsorData.strCity shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.sponsorData.strCity];
    }
    
    if(![NSString IsEmpty:self.sponsorData.strState shouldCleanWhiteSpace:YES])
    {
        if(![NSString IsEmpty:self.sponsorData.strCity shouldCleanWhiteSpace:YES])
        {
            strAddress = [strAddress stringByAppendingString:@", "];
        }
        strAddress = [strAddress stringByAppendingString:self.sponsorData.strState];
    }
    
    if(![NSString IsEmpty:self.sponsorData.strState shouldCleanWhiteSpace:YES] | ![NSString IsEmpty:self.sponsorData.strCity shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:@"\r"];
    }
    
    if(![NSString IsEmpty:self.sponsorData.strZipCode shouldCleanWhiteSpace:YES])
    {
        strAddress = [strAddress stringByAppendingString:self.sponsorData.strZipCode];
    }
    
    lblAddress.text = strAddress;
    [lblAddress sizeToFit];
    
    lblWebsite.text = self.sponsorData.strWebsiteURL;
    lblEmail.text =self.sponsorData.strEmail;
    
    self.imgLogo.image = [UIImage imageNamed:@"company.png"];
    if(![NSString IsEmpty:self.sponsorData.strLogoURL shouldCleanWhiteSpace:YES])
    {
        NSURL *imgURL = [NSURL URLWithString:self.sponsorData.strLogoURL];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
        NSData *data,
        NSError *error)
        {
            if (!error)
            {
                UIImage *img = [[UIImage alloc] initWithData:data];;
                [self.imgLogo setImage:img];
            }
        }];
    }
    
    
    
    CGSize expectedLabelSize = [self.sponsorData.strCompanyProfile sizeWithFont:self.lblCompanyInformation.font
                                                              constrainedToSize:CGSizeMake(280,1000)
                                
                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    lblCompanyInformation.frame = CGRectMake(lblCompanyInformation.frame.origin.x, lblCompanyInformation.frame.origin.y, 280, expectedLabelSize.height);
    
    int intY= 100;
    for (SponsorCategories *objSponsorCategory in self.sponsorData.arrCategories)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, intY, 280, 21)];
        label.text = objSponsorCategory.strParentCategoryInstanceID;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:(104.0/255.0) green:(33.0/255.0) blue:0 alpha:1.0];
        [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        [self.svwCategories addSubview:label];
        intY = intY + 20;

        NSArray *arr = [objSponsorCategory.strCategoryName componentsSeparatedByString:@","];
        for (NSString *strTemp in arr)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, intY, 280, 21)];
            label.text = strTemp;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            [self.svwCategories addSubview:label];
            intY = intY + 20;
        }
        intY = intY + 10;
    }
    
    [self.svwCategories setContentSize:CGSizeMake(320, (intY+20))];
    self.arrResources = self.sponsorData.arrResources;
    //[self addDummyResources];
    [self.colResources reloadData];
    
    if ([DeviceManager IsiPad])
    {
        self.lblTitle.text = self.sponsorData.strSponsorName;
        self.txtCompanyInformation.text = [NSString stringWithFormat:@"Profile: %@",self.sponsorData.strCompanyProfile];
    }
    else
    {
        self.vwShare.frame = CGRectMake(20, (expectedLabelSize.height + lblCompanyInformation.frame.origin.y), self.vwShare.frame.size.width, self.vwShare.frame.size.height);
        
        [self.svwDetail setContentSize:CGSizeMake(320, (self.vwShare.frame.size.height + self.vwShare.frame.origin.y))];
    }
}

- (IBAction)btnSocialMediaClicked:(id)sender {
    
        //Shared *objShared = [Shared GetInstance];
        
    if (!APP.netStatus) {
        NETWORK_ALERT();
        return;
    }
    UIStoryboard *storyboard;
    if([DeviceManager IsiPad] == YES)
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
    }
    
    if (sender == self.btnTwitter) {
        TwitterViewController *vcTwitter = [storyboard instantiateViewControllerWithIdentifier:@"idTwitter"];
        [[self navigationController] pushViewController:vcTwitter animated:YES];
    }
    else if(sender == self.btnFacebook){
        FacebookViewController *vcFacebook = [storyboard instantiateViewControllerWithIdentifier:@"idFacebook"];
        [[self navigationController] pushViewController:vcFacebook animated:YES];
    }
    else if(sender == self.btnLinkedIn){
        LinkedInViewController *vcLinkedIn = [storyboard instantiateViewControllerWithIdentifier:@"idLinkedIn"];
        [[self navigationController] pushViewController:vcLinkedIn animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews
{
    if ([DeviceManager IsiPad])
    {
        [self.myScrollView setContentSize:CGSizeMake(1550, self.myScrollView.frame.size.height)];
    }
}

- (IBAction)AddToFav:(id)sender
{
    BOOL blnResult = NO;    
    
    if (self.blnIsExhibitors)
    {
        AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
        //blnResult = [objAttendeeDB AddExhibitor:self.exhibitorData.strExhibitorID];
       
        blnResult = [objAttendeeDB AddExhibitorWithExhibitorObj:self.exhibitorData];
        
        if(blnResult == YES)
        {
            self.btnAddToFav.hidden = YES;
            self.btnRemoveFromFav.hidden = NO;
        }
//        User *objUser = [User GetInstance];
//        
//        NSString *strURL = strAPI_URL;
//        strURL = [strURL stringByAppendingString:strAPI_EXHIBITOR_ADD_EXHIBITOR];
//        
//        NSURL *URL = [NSURL URLWithString:strURL];
//        
//        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
//        [objRequest setHTTPMethod:@"POST"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        
//        [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
//        //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
//        [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
//        [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
//        
//        [objRequest addValue:self.exhibitorData.strExhibitorID forHTTPHeaderField:@"ExhibitorCode"];
//        [objRequest addValue:[Functions GetGUID] forHTTPHeaderField:@"LocalId"];
//        
//        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_ADD_EXHIBITOR];
    }
}

- (IBAction)RemoveToFav:(id)sender
{
    BOOL blnResult = NO;
    
    if (self.blnIsExhibitors)
    {
        AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
        blnResult = [objAttendeeDB DeleteExhibitor:self.exhibitorData.strExhibitorID];
        
        if(blnResult == YES)
        {
            self.btnAddToFav.hidden = NO;
            self.btnRemoveFromFav.hidden = YES;
        }
//        User *objUser = [User GetInstance];
//        
//        NSString *strURL = strAPI_URL;
//        //strURL = [strURL stringByAppendingString:strAPI_EXHIBITOR_DELETE_EXHIBITOR];
//        strURL = [strURL stringByAppendingString:strAPI_EXHIBITOR_DELETE_EXHIBITOR_BY_CODE];
//        
//        NSURL *URL = [NSURL URLWithString:strURL];
//        
//        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
//        [objRequest setHTTPMethod:@"POST"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        
//        [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
//        //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
//        [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
//        [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
//        
//        [objRequest addValue:self.exhibitorData.strExhibitorID forHTTPHeaderField:@"ExhibitorCode"];
//        [objRequest addValue:[Functions GetGUID] forHTTPHeaderField:@"LocalId"];
//        
//        //objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_DELETE_EXHIBITOR];
//        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_DELETE_EXHIBITOR_BY_CODE];
    }
}

- (void)loadMapView:(id)sender
{
    if (self.blnIsExhibitors)
    {
        if([NSString IsEmpty:self.exhibitorData.strCity shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.exhibitorData.strState shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.exhibitorData.strZipCode shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.exhibitorData.strAddress1 shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.exhibitorData.strAddress2 shouldCleanWhiteSpace:YES])
        {
            return;
        }
    }
    else
    {
        if([NSString IsEmpty:self.sponsorData.strCity shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.sponsorData.strState shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.sponsorData.strZipCode shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.sponsorData.strAddress1 shouldCleanWhiteSpace:YES] && [NSString IsEmpty:self.sponsorData.strAddress2 shouldCleanWhiteSpace:YES])
        {
            return;
        }
    }
    
    MapView *vcMapView;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcMapView = [storyboard instantiateViewControllerWithIdentifier:@"idMapView"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcMapView = [storyboard instantiateViewControllerWithIdentifier:@"idMapView"];
    }
    
    if (self.blnIsExhibitors)
    {
        vcMapView.strPlace = self.exhibitorData.strExhibitorName;
        
        vcMapView.strCity = self.exhibitorData.strCity;
        vcMapView.strState = self.exhibitorData.strState;
        vcMapView.strPostalCode = self.exhibitorData.strZipCode;
        vcMapView.strStreetAddress = [NSString stringWithFormat:@"%@, %@",self.exhibitorData.strAddress1,self.exhibitorData.strAddress2];
        vcMapView.strCountry = @"";
    }
    else
    {
        vcMapView.strPlace = self.sponsorData.strSponsorName;
        
        vcMapView.strCity = self.sponsorData.strCity;
        vcMapView.strState = self.sponsorData.strState;
        vcMapView.strPostalCode = self.sponsorData.strZipCode;
        vcMapView.strStreetAddress = [NSString stringWithFormat:@"%@, %@",self.sponsorData.strAddress1,self.sponsorData.strAddress2];
        vcMapView.strCountry = @"";
    }
    
    vcMapView.strLat = @"";
    vcMapView.strLon = @"";
    vcMapView.blnLatLonAvailable = NO;
    
    [[self navigationController] pushViewController:vcMapView animated:YES];
}

- (IBAction)OpenMapView:(id)sender
{
    [self loadMapView:sender];
}

- (IBAction)btnBackClicked:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showDropdownMenu:(id)sender
{
    if (blnViewExpanded) {
        [self ShrinkView];
    }
    else{
        [self expandView];
    }
}

- (IBAction)MakePhoneCall:(id)sender
{
    if (self.blnIsExhibitors)
    {
        [Functions MakePhoneCall:self.exhibitorData.strPhoneNumbers];
    }
    else
    {
        [Functions MakePhoneCall:self.sponsorData.strPhoneNumbers];
    }
}

- (IBAction)OpenWebsite:(id)sender
{
    if (self.blnIsExhibitors)
    {
        [Functions OpenWebsite:self.exhibitorData.strWebsiteURL];
    }
    else
    {
        [Functions OpenWebsite:self.sponsorData.strWebsiteURL];
    }
}

- (IBAction)OpenMail:(id)sender
{
    if(self.blnIsExhibitors)
    {
        if(![NSString IsEmpty:self.exhibitorData.strEmail shouldCleanWhiteSpace:YES])
        {
            if([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
                NSString *Subject = @"";
                
                NSString *Body = @"";
         
                [mailer setToRecipients: [[NSArray alloc] initWithObjects:self.exhibitorData.strEmail, nil]];
                [mailer setSubject:Subject];
                [mailer setMessageBody:Body isHTML:YES];
                mailer.mailComposeDelegate = self;
                
                [self presentViewController:mailer animated:YES completion:Nil];
            }
            else
            {
                [Functions OpenMailWithReceipient:self.exhibitorData.strEmail];
            }
        }
    }
    else
    {
        if(![NSString IsEmpty:self.sponsorData.strEmail shouldCleanWhiteSpace:YES])
        {
            if([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
                NSString *Subject = @"";
                
                NSString *Body = @"";
                
                [mailer setToRecipients: [[NSArray alloc] initWithObjects:self.sponsorData.strEmail, nil]];
                [mailer setSubject:Subject];
                [mailer setMessageBody:Body isHTML:YES];
                mailer.mailComposeDelegate = self;
                
                [self presentViewController:mailer animated:YES completion:Nil];
            }
            else
            {
                [Functions OpenMailWithReceipient:self.sponsorData.strEmail];
            }
        }
    }
}

- (void)expandView
{
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 200);
        
    } completion:nil];
    blnViewExpanded = YES;
}

- (void)ShrinkView
{
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 0);
    } completion:nil];
    blnViewExpanded = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.textLabel.text = [_menuItems objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"Area %d",indexPath.item];
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrResources count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SessionResourceCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SessionResourceCell" forIndexPath:indexPath];
    
    if([self.arrResources count] > 0)
    {
        ExhibitorResources *objExhibitorResources = [self.arrResources objectAtIndex:indexPath.row];
        
        cell.lblDocTitle.text = [objExhibitorResources strFileName];
        cell.btnOpenFile.tag = indexPath.row;
        
        if([objExhibitorResources.strDocType isEqualToString:strDOC_TYPE_PDF])
        {
            NSString *strDocType = [[NSBundle mainBundle] pathForResource:strDOC_TYPE_PDF_IMG ofType:@"png"];
            UIImage *imgDocType = [UIImage imageWithContentsOfFile:strDocType];
            
            [cell.imgDocType setImage:imgDocType];
        }
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ExhibitorResources *objExhibitorResources = [self.arrResources objectAtIndex:indexPath.row];
    [Functions OpenWebsite:objExhibitorResources.strURL];
}

-(void)addDummyResources
{
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    for (int i=0; i<30; i++) {
        
        ExhibitorResources *objExhibitorResources = [[ExhibitorResources alloc] init];
        objExhibitorResources.strDocType = @"pdf";
        objExhibitorResources.strURL = @"http://192.168.0.91/LuceneDemoApp/SampleData/Windows%20Phones%20Overview.pdf";
        objExhibitorResources.strFileName = @"convergence ECMA FY14 event info file.pdf";
        [arrTemp addObject:objExhibitorResources];
    }
    
    self.arrResources = arrTemp;
}

#pragma mark Mail Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result) {
		case MFMailComposeResultCancelled:
			NSLog(@"%@",@"Message Canceled");
			break;
		case MFMailComposeResultSaved:
            NSLog(@"%@",@"Message Saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"%@",@"Message Sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"%@",@"Message Failed");
			break;
		default:
			NSLog(@"%@",@"Message Not Sent");
		break;	}
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}
#pragma mark -

#pragma mark Connections Events
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ExceptionHandler AddExceptionForScreen:strSCREEN_SPONSOR MethodName:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)] Exception:error.description];
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
    
    NSString *strData1 = [[NSString alloc]initWithData:objData encoding:NSUTF8StringEncoding];
    //NSLog(@"Response: %@",strData);
    
    switch (intTag)
    {
        case OPER_ADD_EXHIBITOR:
        {
            if ([strData1 isEqualToString:@"true"])
            {
                self.btnAddToFav.hidden = YES;
                self.btnRemoveFromFav.hidden = NO;
            }
        }
            break;
        case OPER_DELETE_EXHIBITOR:
        {
            if ([strData1 isEqualToString:@"true"])
            {
                self.btnAddToFav.hidden = NO;
                self.btnRemoveFromFav.hidden = YES;
            }
        }
            break;
        case OPER_DELETE_EXHIBITOR_BY_CODE:
        {
            if ([strData1 isEqualToString:@"true"])
            {
                self.btnAddToFav.hidden = NO;
                self.btnRemoveFromFav.hidden = YES;
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -
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
