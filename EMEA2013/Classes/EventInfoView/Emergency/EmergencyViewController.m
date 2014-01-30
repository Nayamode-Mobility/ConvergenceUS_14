//
//  EmergencyViewController.m
//  mgx2013
//
//  Created by Amit Karande on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "EmergencyViewController.h"
#import "DeviceManager.h"
#import "Constants.h"
#import "Functions.h"
#import "EventInfoDB.h"
#import "EmergencyOverview.h"
#import "EmergencyHospitals.h"
#import "EmergencyFloorPlans.h"
#import "NSString+Custom.h"
#import "LargeView.h"
#import "MapView.h"

@interface EmergencyViewController ()
@end

@implementation EmergencyViewController
@synthesize vwDropdownMenu, blnViewExpanded, vwFloorPlanDropdown;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshEmergency) name:@"SyncUpCompleted" object:nil];
    
    [[self avLoadingVenurFloorPlan] startAnimating];
    
    if ([DeviceManager IsiPad])
    {
    }
    else
    {
        [self.svwEmergency setContentSize:CGSizeMake(960, self.svwEmergency.frame.size.height)];
    }
    
    EventInfoDB *objEventInfoDB = [EventInfoDB GetInstance];
    self.emergencyOverviewData = [[objEventInfoDB GetEmergencyOverview] objectAtIndex:0];

    if (self.arrHospitals == nil)
    {
        self.arrHospitals = [[NSArray alloc] init];
    }
    self.arrHospitals = [objEventInfoDB GetEmergencyHospitals];
    
    if (self.arrFloorPlans == nil)
    {
        self.arrFloorPlans = [[NSArray alloc] init];
    }
    self.arrFloorPlans = [objEventInfoDB GetEmergencyFloorPlans];
    
    [self populateOverviewData];
    //[self populateHospitalData];
    
    //[self populateFloorPlanData];
    if ([self.arrHospitals count] > 0)
    {
        [self setHospitalData:0];
    }
    
    if ([self.arrFloorPlans count] > 0)
    {
        [self setFloorPlanData:0];
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.svwFloorPlan addGestureRecognizer:singleTap];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_EMERGENCY];
    
    //[UIView addTouchEffect:self.view];
}



-(void) populateOverviewData
{
    self.lblOverviewTitle.text = self.emergencyOverviewData.strTitle;
    NSInteger intY = self.lblOverviewTitle.frame.origin.y + self.lblOverviewTitle.frame.size.height;
    
    intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strBriefDescription1 intY:intY];
    //intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strBriefDescription2 intY:intY];
    //intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strBriefDescription3 intY:intY];
    
    if ([DeviceManager IsiPad]) {
        self.vwOverviewContact.frame = CGRectMake(0, intY, self.vwOverviewContact.frame.size.width, self.vwOverviewContact.frame.size.height);
        self.lblOverviewAddress.text = self.emergencyOverviewData.strAddress1;
        self.lblOverviewWebsite.text = self.emergencyOverviewData.strWebsite1;
        self.lblOverviewPhone.text = self.emergencyOverviewData.strPhone1;
        [self.svwOverview setFrame:CGRectMake(0, 0, self.svwOverview.frame.size.width , (self.vwOverviewContact.frame.origin.y+self.vwOverviewContact.frame.size.height))];
    }
    else{
        self.vwOverviewContact.frame = CGRectMake(0, intY, self.vwOverviewContact.frame.size.width, self.vwOverviewContact.frame.size.height);
        self.lblOverviewAddress.text = self.emergencyOverviewData.strAddress1;
        self.lblOverviewWebsite.text = self.emergencyOverviewData.strWebsite1;
        self.lblOverviewPhone.text = self.emergencyOverviewData.strPhone1;
        [self.svwOverview setFrame:CGRectMake(0, 100, self.svwOverview.frame.size.width , (self.vwOverviewContact.frame.origin.y+self.vwOverviewContact.frame.size.height))];
        
        //intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strWebsite1 intY:intY];
        //intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strWebsite2 intY:intY];
        //intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strWebsite3 intY:intY];
        /*intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strAddress1 intY:intY];
        intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strAddress2 intY:intY];
        intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strAddress3 intY:intY];
        intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strPhone1 intY:intY];
        intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strPhone2 intY:intY];
        intY = [self addLabel:self.svwOverview strTemp:self.emergencyOverviewData.strPhone2 intY:intY];
        [self.svwOverview setContentSize:CGSizeMake(self.svwOverview.frame.size.width, (intY + 20))];*/
    }
    
}

-(NSInteger)addLabel:(UIView *)view strTemp:(NSString *)strValue intY:(NSInteger)intY
{
    if (strValue.length != 0)
    {
        NSInteger intWidth = 270;
        UILabel *objLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, intY+5, intWidth, 20)];
        objLabel.text = strValue;
        objLabel.numberOfLines = 0;
        objLabel.backgroundColor = [UIColor clearColor];
        [objLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [objLabel sizeToFit];
        
        objLabel.textColor = [UIColor blackColor];
        
        if ([DeviceManager IsiPad])
        {
            objLabel.textColor = [UIColor whiteColor];
        }
        
        //[objLabel setFont:[UIFont fontWithName:[[objLabel font] fontName] size:intFontSize]];
        /*if (bold) {
                [objLabel setFont:[UIFont boldSystemFontOfSize:[[objLabel font] fontWithSize:20]]];
        }*/
        
        [objLabel sizeToFit];
        [view addSubview:objLabel];
        return  objLabel.frame.origin.y + objLabel.frame.size.height;
    }
    else
    {
        return intY;
    }
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

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RefreshEmergency
{
    EventInfoDB *objEventInfoDB = [EventInfoDB GetInstance];
    self.emergencyOverviewData = [[objEventInfoDB GetEmergencyOverview] objectAtIndex:0];
    
    if (self.arrHospitals == nil)
    {
        self.arrHospitals = [[NSArray alloc] init];
    }
    self.arrHospitals = [objEventInfoDB GetEmergencyHospitals];
    
    if (self.arrFloorPlans == nil)
    {
        self.arrFloorPlans = [[NSArray alloc] init];
    }
    self.arrFloorPlans = [objEventInfoDB GetEmergencyFloorPlans];
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
    if (tableView.tag > 0) {
        return [self.arrFloorPlans count];
    }
    else{
        return [self.arrHospitals count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (tableView.tag > 0) {
        EmergencyFloorPlans *objEmergencyFloorPlans = [self.arrFloorPlans objectAtIndex:indexPath.row];
        cell.textLabel.text = objEmergencyFloorPlans.strFloorPlanName;
    }
    else{
        EmergencyHospitals *objEmergencyHospitals = [self.arrHospitals objectAtIndex:indexPath.row];
        cell.textLabel.text = objEmergencyHospitals.strTitle;
    }
    // Configure the cell...
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //[self setFloorPlanData:indexPath.row];
    if (tableView.tag > 0) {
        [self setFloorPlanData:indexPath.row];
    }
    else{
        [self setHospitalData:indexPath.row];
    }
    
}

- (void)expandView:(NSInteger)intTag {
    if (intTag > 0) {
        [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
            vwFloorPlanDropdown.frame = CGRectMake(vwFloorPlanDropdown.frame.origin.x, vwFloorPlanDropdown.frame.origin.y, (vwFloorPlanDropdown.frame.size.width), 200);
            
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
            vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 200);
            
        } completion:nil];
    }
    
    blnViewExpanded = YES;
}

- (void)ShrinkView {
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwDropdownMenu.frame = CGRectMake(vwDropdownMenu.frame.origin.x, vwDropdownMenu.frame.origin.y, (vwDropdownMenu.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwFloorPlanDropdown.frame = CGRectMake(vwFloorPlanDropdown.frame.origin.x, vwFloorPlanDropdown.frame.origin.y, (vwFloorPlanDropdown.frame.size.width), 0);
    } completion:nil];
    blnViewExpanded = NO;
}

- (IBAction)showDropdownMenu:(id)sender {
    if (blnViewExpanded) {
        [self ShrinkView];
    }
    else{
        [self expandView:0];
    }
}

- (IBAction)showFloorDropdownMenu:(id)sender {
    if (blnViewExpanded) {
        [self ShrinkView];
    }
    else{
        [self expandView:1];
    }
}

-(void) setHospitalData:(NSInteger)index
{
    EmergencyHospitals *objEmergencyHospitals = [self.arrHospitals objectAtIndex:index];
    self.lblHospitalTitle.text = objEmergencyHospitals.strTitle;
    self.lblHospitalDescription.text = objEmergencyHospitals.strBriefDescription1;
    
    self.lblHospitalAddress.text = [objEmergencyHospitals.strAddress1 stringByReplacingOccurrencesOfString:@", " withString:@"\r\n"];
    CGRect org = self.lblHospitalAddress.frame;
    self.lblHospitalAddress.numberOfLines = 0;
    [self.lblHospitalAddress sizeToFit];
    org.size.height = self.lblHospitalAddress.frame.size.height;
    self.lblHospitalAddress.frame = org;
    
    self.lblHospitalWebsite.text = objEmergencyHospitals.strWebsite1;
    self.btnOpenWebsite.tag = index;
    
    self.lblHospitalPhone.text = objEmergencyHospitals.strPhone1;
    
    /*NSString *yourString=objEmergencyHospitals.strBriefDescription1;
    UIFont *ft=[UIFont systemFontOfSize:17.0];
    
    CGSize expectedLabelSize = [yourString sizeWithFont:ft
                                      constrainedToSize:CGSizeMake(518, 21)
                                          lineBreakMode:NSLineBreakByWordWrapping];*/
    
    org=self.lblHospitalDescription.frame;
    [self.lblHospitalDescription sizeToFit];
    org.size.height=self.lblHospitalDescription.frame.size.height;
    self.lblHospitalDescription.frame=org;
    
    self.vwHospitalContact.frame = CGRectMake(self.vwHospitalContact.frame.origin.x, (self.lblHospitalDescription.frame.origin.y+self.lblHospitalDescription.frame.size.height), 400, 218);
    self.lblDropDownHospitalTitle.text = objEmergencyHospitals.strTitle;
}

-(void) setFloorPlanData:(NSInteger)index
{
    EmergencyFloorPlans *objEmergencyFloorPlans = [self.arrFloorPlans objectAtIndex:index];
    self.lblDropdownFloorTitle.text = objEmergencyFloorPlans.strFloorPlanName;

    NSURL *imgURL = [NSURL URLWithString:objEmergencyFloorPlans.strImageURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error)
    {
        if (!error)
        {
            self.imgFloorPlan.image = [UIImage imageWithData:data];
        }
        [[self avLoadingVenurFloorPlan] stopAnimating];
    }];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    /*UIScrollView *scroll = (UIScrollView *) gesture.view;
    //UIImageView *img = (UIImageView *)[self.view viewWithTag:scroll.tag+100];
    
    if(self.imgFloorPlan.frame.size.width == self.imgFloorPlan.image.size.width)
    {
        CGSize size = scroll.frame.size;
        [scroll setContentSize:size];
        self.imgFloorPlan.frame = CGRectMake(0, 0, size.width, size.height);
    }
    else
    {
        [scroll setContentSize:self.imgFloorPlan.image.size];
        self.imgFloorPlan.frame = CGRectMake(0, 0, self.imgFloorPlan.image.size.width, self.imgFloorPlan.image.size.height);
    }*/
    
    LargeView *vcLargeView;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];
    }
    
    vcLargeView.imgSource = self.imgFloorPlan.image;
    [[self navigationController] pushViewController:vcLargeView animated:YES];
}

- (IBAction)OpenMapView:(id)sender
{
    [self loadMapView:sender];
}

- (IBAction)OpenWebsite:(id)sender
{
    UIButton *btnWebsite = (UIButton*)sender;
    
    EmergencyHospitals *objEmergencyHospitals = [self.arrHospitals objectAtIndex:btnWebsite.tag];
    [Functions OpenWebsite:objEmergencyHospitals.strWebsite1];
}

- (void)loadMapView:(id)sender
{
    EmergencyHospitals *objEmergencyHospitals = [self.arrHospitals objectAtIndex:0];
    NSString *strAddress = objEmergencyHospitals.strBriefDescription1;
    
    if([NSString IsEmpty:strAddress shouldCleanWhiteSpace:YES])
    {
        return;
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
    
    NSArray *arrAddress = [strAddress componentsSeparatedByString:@","];
    
    vcMapView.strPlace = objEmergencyHospitals.strTitle;
    
    vcMapView.strCity = @"";
    vcMapView.strState = [arrAddress objectAtIndex:1];
    vcMapView.strPostalCode = @"";
    vcMapView.strStreetAddress = [arrAddress objectAtIndex:0];
    vcMapView.strCountry = @"";
    
    vcMapView.strLat = @"41.42739570000001";
    vcMapView.strLon = @"2.14327209999999";
    vcMapView.blnLatLonAvailable = YES;
    
    [[self navigationController] pushViewController:vcMapView animated:YES];
}
@end
