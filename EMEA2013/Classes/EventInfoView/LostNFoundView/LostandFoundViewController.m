//
//  LostandFoundViewController.m
//  mgx2013
//
//  Created by Amit Karande on 08/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "LostandFoundViewController.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "EventInfoDB.h"
#import "LostNFound.h"
#import "Functions.h"
#import "MapView.h"
#import "NSString+Custom.h"

@interface LostandFoundViewController ()

@end

@implementation LostandFoundViewController
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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshLostandFound) name:@"SyncUpCompleted" object:nil];
    
	// Do any additional setup after loading the view.
    if (self.arrLostNFound == nil) {
        self.arrLostNFound = [[NSArray alloc] init];
    }
    
    EventInfoDB *objEventInfoDB = [EventInfoDB GetInstance];
    self.arrLostNFound = [objEventInfoDB GetLostNFound];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_LOST_FOUND];
    
    //[UIView addTouchEffect:self.view];
    [self populateData];
    
}

-(void) populateData{
    if ([self.arrLostNFound count]>1) {
        LostNFound *objOverview = [self.arrLostNFound objectAtIndex:0];
        self.lblOverViewDescription.text = objOverview.strDescription;
        
        CGSize expectedLabelSize = [self.lblOverViewDescription.text sizeWithFont:self.lblOverViewDescription.font
                                          constrainedToSize:CGSizeMake(280,1000)
                                              lineBreakMode:NSLineBreakByWordWrapping];
        self.lblOverViewDescription.numberOfLines = 0;
        self.lblOverViewDescription.frame = CGRectMake(self.lblOverViewDescription.frame.origin.x, self.lblOverViewDescription.frame.origin.y, 280, expectedLabelSize.height);
        [self.svwOverview setContentSize:CGSizeMake(320, (self.lblOverViewDescription.frame.origin.y + expectedLabelSize.height))];
        
        LostNFound *objDetail = [self.arrLostNFound objectAtIndex:1];
        NSURL *imgURL = [NSURL URLWithString:objDetail.strImage1];
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
        [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                   NSData *data,
                                                                                                                   NSError *error){
            if (!error)
            {
                self.imgLogo.image = [UIImage imageWithData:data];
            }
        }];
        
        self.lblDescription.text = objDetail.strDescription;
        CGSize expectedLabelSizeDescription = [self.lblDescription.text sizeWithFont:self.lblDescription.font
                                                                constrainedToSize:CGSizeMake(280,2000)
                                                                    lineBreakMode:NSLineBreakByWordWrapping];
        self.lblDescription.numberOfLines = 0;
        self.lblDescription.frame = CGRectMake(self.lblDescription.frame.origin.x, self.lblDescription.frame.origin.y, 280, expectedLabelSizeDescription.height);
        
        self.lblPhone.text = objDetail.strPhone1;
        self.lblAddress.text = objDetail.strAddress;
        self.lblWebsite.text = objDetail.strWebsite;
        
        self.vwInfo.frame = CGRectMake(self.vwInfo.frame.origin.x, (self.lblDescription.frame.origin.y+ expectedLabelSizeDescription.height +5), self.vwInfo.frame.size.width, self.vwInfo.frame.size.height);
        
        [self.svwDetail setContentSize:CGSizeMake(320, (self.vwInfo.frame.origin.y + self.vwInfo.frame.size.height + 10))];
    }
}

-(void)viewDidLayoutSubviews
{
    
    [self.svwLostnFound setContentSize:CGSizeMake(640, self.svwLostnFound.frame.size.height)];
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


- (IBAction)MakePhoneCall:(id)sender
{
    [Functions MakePhoneCall:self.lblPhone.text];
}

- (IBAction)OpenWebsite:(id)sender
{
    [Functions OpenWebsite:self.lblWebsite.text];
}

- (void)RefreshLostandFound
{
    if (self.arrLostNFound == nil)
    {
        self.arrLostNFound = [[NSArray alloc] init];
    }
    
    EventInfoDB *objEventInfoDB = [EventInfoDB GetInstance];
    self.arrLostNFound = [objEventInfoDB GetLostNFound];
    
    [self populateData];
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[svwLostnFound contentOffset].x);
    if([self.svwLostnFound contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [self.svwLostnFound setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (IBAction)OpenMapView:(id)sender
{
    [self loadMapView:sender];
}

- (void)loadMapView:(id)sender
{
    LostNFound *objDetail = [self.arrLostNFound objectAtIndex:1];
    NSString *strAddress = objDetail.strAddress;
    
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

    NSString *strPostalCode = [arrAddress objectAtIndex:3];
    strPostalCode = [strPostalCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *arrPostalCode = [strPostalCode componentsSeparatedByString:@" "];
    
    vcMapView.strPlace = [arrAddress objectAtIndex:2];
    
    vcMapView.strCity = [arrAddress objectAtIndex:2];
    vcMapView.strState = [arrPostalCode objectAtIndex:0];
    vcMapView.strPostalCode = [arrPostalCode objectAtIndex:1];
    vcMapView.strStreetAddress = [arrAddress objectAtIndex:0];
    vcMapView.strCountry = [arrAddress objectAtIndex:4];
    
    vcMapView.strLat = @"";
    vcMapView.strLon = @"";
    vcMapView.blnLatLonAvailable = NO;
    
    [[self navigationController] pushViewController:vcMapView animated:YES];
}
@end
