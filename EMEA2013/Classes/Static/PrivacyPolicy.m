//
//  PrivacyPolicy.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "PrivacyPolicy.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Functions.h"

@interface PrivacyPolicy ()

@end

@implementation PrivacyPolicy
#pragma mark Synthesize
@synthesize wvPrivacyPolicy;
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
    
    [[self avLoading] startAnimating];
    
    NSString *strURL = @"http://privacy.microsoft.com";
    NSURL *URL = [NSURL URLWithString:strURL];
    NSURLRequest *objRequest = [NSURLRequest requestWithURL:URL];
    
	wvPrivacyPolicy.delegate = self;
	[[wvPrivacyPolicy.subviews objectAtIndex:0] setScrollEnabled:YES];
	[[wvPrivacyPolicy.subviews objectAtIndex:0] setBounces:YES];
    wvPrivacyPolicy.delegate = self;
    
    [wvPrivacyPolicy loadRequest:objRequest];
    
    //[self.view addSubview:wvPrivacyPolicy];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_PRIVACY_POLICY];
    
    //[UIView addTouchEffect:self.view];
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
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[self avLoading] stopAnimating];
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq navigationType:(UIWebViewNavigationType)nt
{
    if (nt == UIWebViewNavigationTypeLinkClicked)
    {
        //[[UIApplication sharedApplication] openURL:[rq URL]];
         [Functions OpenWebsite:[NSString stringWithFormat:@"%@",[rq URL]]];
        return NO;
    }
    
    return YES;
}
#pragma mark -
@end
