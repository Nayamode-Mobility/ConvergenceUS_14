//
//  MSDPN.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "MSDPN.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Functions.h"

@interface MSDPN ()

@end

@implementation MSDPN

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *strURL = @"<html><body><font style='color: #000000; font-size: 13px; font-family: SegoeWP;'><p class='blurb'><font style='color: #000000; font-size: 13px; font-family: SegoeWP-Bold;'>Notice to Data Subjects</font></p><p class='blurb'>Any Microsoft employee or contingent staff information that may be collected on this system will be used by Microsoft Corporation and its affiliates and subsidiaries (Microsoft') for the purpose of administering and carrying out the employment or personnel relationship and other legitimate business purposes. Information may be transferred to, and stored and processed in, the United States or in any other country/region in which Microsoft or its affiliates, subsidiaries, or agents maintain facilities. Microsoft abides by the Safe Harbor framework as set forth by the U.S. Department of Commerce regarding the collection, use, and retention of data from the European Union and by the principles and practices described in any regional data protection notice. Microsoft may share information with other companies that provide services on our behalf. Microsoft may also access and/or disclose information if we believe such action is necessary to (a) comply with the law or legal process served on Microsoft, (b) protect and defend the rights or property of Microsoft (including the enforcement of our agreements), or (c) act in urgent circumstances to protect the personal safety of Microsoft employees or contingent staff, users of Microsoft services, or members of the public.</p><p class='blurb'><font style='color: #000000; font-size: 13px; font-family: SegoeWP-Bold;'>Notice to Data Handlers</font></p><p class='blurb'>Personal information on this system may be accessed and used for legitimate Microsoft business-related purposes only. Personal information includes any information that permits an individual to be identified or contacted (such as name, postal address, e-mail address, phone number, financial information or account numbers, Social Security number, or any other government-issued ID numbers). Any person who uses, transfers, or stores personal information must ensure that information is securely protected in accordance with the <a href='http://itweb/security/policy/pages/infoclass.aspx'>Information Classification and Handling Standard</a> and handled in accordance with (i) any additional notices posted on this site or tool, (ii) all applicable agreements (for example, a Microsoft Corporation Employee Agreement signed by Microsoft employees, an Employee Information Confidentiality Agreement signed by human resources employees, and the data-protection language and confidentially provisions in your contracts with Microsoft if you are a Microsoft contingent staff or vendor), and (iii) any other applicable corporate policies, standards, and guidelines. Information regarding corporate privacy and security policies, standards, and guidelines is available on the <a href='http://privacy.microsoft.com/en-us/default.mspx'>Microsoft Corporate Privacy Portal</a>.</p></font></body></html>";
    
    [self.wvMDPN setOpaque:NO];
	[self.wvMDPN setBackgroundColor:[UIColor clearColor]];
    [self.wvMDPN loadHTMLString:strURL baseURL:nil];
    self.wvMDPN.delegate = self;
    
    [Analytics AddAnalyticsForScreen:strSCREEN_MDPN];
    
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

- (IBAction)btnBackCLicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
@end
