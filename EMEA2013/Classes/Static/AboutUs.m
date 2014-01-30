//
//  AboutUs.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "AboutUs.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Support.h"
#import "Functions.h"

@interface AboutUs ()

@end

@implementation AboutUs
#pragma mark Synthesize
@synthesize wvAboutUs;
#pragma mark -

#pragma mark View Events
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
    
    NSString *strFile = [[NSBundle mainBundle] pathForResource:@"Aboutus" ofType:@"html"];
    NSString *strHTML  = [NSString stringWithContentsOfFile:strFile encoding:NSUTF8StringEncoding error:nil];
    
	wvAboutUs.delegate = self;
	[[wvAboutUs.subviews objectAtIndex:0] setScrollEnabled:YES];
	[[wvAboutUs.subviews objectAtIndex:0] setBounces:YES];
    
    [wvAboutUs loadHTMLString:strHTML baseURL:nil];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_ABOUTUS];
    
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
        return UIInterfaceOrientationMaskAll;
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

- (void)loadSupport
{
    Support *vcSupport;
    
    if([DeviceManager IsiPad] == YES)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle: nil];
        vcSupport = [storyboard instantiateViewControllerWithIdentifier:@"idSupport"];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcSupport = [storyboard instantiateViewControllerWithIdentifier:@"idSupport"];
    }
    
    [[self navigationController] pushViewController:vcSupport animated:YES];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq navigationType:(UIWebViewNavigationType)nt
{
    if (nt == UIWebViewNavigationTypeLinkClicked)
    {
        if([[NSString stringWithFormat:@"%@",[rq URL]] isEqualToString:@"http://support/"])
        {
            [self loadSupport];
        }
        else
        {
            //[[UIApplication sharedApplication] openURL:[rq URL]];
             [Functions OpenWebsite:[NSString stringWithFormat:@"%@",[rq URL]]];
        }

        return NO;
    }
    
    return YES;
}
#pragma mark -
@end
