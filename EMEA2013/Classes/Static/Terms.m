//
//  Terms.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "Terms.h"
#import "Constants.h"
#import "DeviceManager.h"

@interface Terms ()

@end

@implementation Terms
#pragma mark Synthesize
@synthesize wvTerms;
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
    
    NSString *strURL = @"http://www.microsoft.com/en-us/legal/intellectualproperty/copyright/default.aspx";
    NSURL *URL = [NSURL URLWithString:strURL];
    NSURLRequest *objRequest = [NSURLRequest requestWithURL:URL];
 
	wvTerms.delegate = self;
	[[wvTerms.subviews objectAtIndex:0] setScrollEnabled:YES];
	[[wvTerms.subviews objectAtIndex:0] setBounces:YES];
    wvTerms.delegate = self;
    
    [wvTerms loadRequest:objRequest];
    
    //[self.view addSubview:wvTerms];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_TERMS];
    
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
        [[UIApplication sharedApplication] openURL:[rq URL]];
        return NO;
    }
    
    return YES;
}
#pragma mark -
@end
