//
//  ExpoMapViewController.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 25/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ExpoMapViewController.h"
#import "SponsorsDetailViewController.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "ExhibitorDB.h"

@interface ExpoMapViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webmap;
@property (nonatomic,retain) NSMutableArray *exhibitorData;

@end

@implementation ExpoMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (IBAction)backClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   // NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hotspots" ofType:@"html" inDirectory:@"/expomap"]];
   // [self.webmap loadRequest:[NSURLRequest requestWithURL:url]];
    
    // New Code
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"hotspots" withExtension:@"html"];
    [self.webmap loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
    self.webmap.delegate=self;
    ExhibitorDB *objExhibitors = [ExhibitorDB GetInstance];
    self.exhibitorData = [[objExhibitors GetExhibitorsAndGrouped:NO] mutableCopy];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_EXPO_MAPS];
    
    //[UIView addTouchEffect:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark webview

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    NSRange nt=[request.URL.absoluteString rangeOfString:@"#" options:NSBackwardsSearch];
    if (nt.location==NSNotFound)
    {
        return YES;
    }
    else
    {
        NSString *subString = [request.URL.absoluteString substringFromIndex:nt.location+1];
        //NSLog(@"%@",subString);
        //UIAlertView *at=[[UIAlertView alloc] initWithTitle:nil message:subString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //[at show];
        UIStoryboard *sb;
        if([DeviceManager IsiPad])
        {
            sb= [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        }
        else
        {
            sb= [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        }
       
        SponsorsDetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"idSponsorDetail"];
        
        vc.blnIsExhibitors = YES;
        NSString *format=[NSString stringWithFormat:@"strBoothNumbers ==\"%@\"",subString];
        
        NSPredicate *filter = [NSPredicate predicateWithFormat:format];
        
        NSArray *filteredContacts = [self.exhibitorData filteredArrayUsingPredicate:filter];
        if ([filteredContacts count]>0)
        {
            if (vc.blnIsExhibitors)
            {
                vc.exhibitorData = [filteredContacts objectAtIndex:0];
            }
            else
            {
                vc.sponsorData = [filteredContacts objectAtIndex:0];
            }
            
            vc.strData = [NSString stringWithFormat:@"Booth Location: %@",subString];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return NO;
    }
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
}
@end
