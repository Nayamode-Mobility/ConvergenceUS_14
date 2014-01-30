//
//  ContactUs.m
//  mgx2013
//
//  Created by Sang.Mac.02 on 18/09/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "ContactUs.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Functions.h"

@interface ContactUs ()
{
}

@property (strong, nonatomic) IBOutlet UIScrollView *pageScrollview;
@end

@implementation ContactUs
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
    
    if ([DeviceManager IsiPad])
    {
        [self.pageScrollview setContentSize:CGSizeMake(944*2, 570)];
    }
    else
    {
        [self.pageScrollview setContentSize:CGSizeMake(640, 360)];
    }
    
    [Analytics AddAnalyticsForScreen:strSCREEN_CONTACTUS];
    
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

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)openWebsite:(UIButton *)sender
{
    //NSURL *url = [NSURL URLWithString:@"https://www.microsoft.com/dynamics/convergence/"];
    //[[UIApplication sharedApplication] openURL:url];
[Functions OpenWebsite:@"https://www.microsoft.com/dynamics/convergence/"];}

- (IBAction)openfeedback:(UIButton *)sender
{
    //NSURL *url = [NSURL URLWithString:@"mailto:convergenceAsk@microsoft.com"];
    //[[UIApplication sharedApplication] openURL:url];
    
    NSString *strEmail = @"convergenceAsk@microsoft.com";
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        NSString *Subject = @"";
        
        NSString *Body = @"";
        
        [mailer setToRecipients: [[NSArray alloc] initWithObjects:strEmail, nil]];
        [mailer setSubject:Subject];
        [mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
        
        [self presentViewController:mailer animated:YES completion:Nil];
    }
    else
    {
        [Functions OpenMailWithReceipient:strEmail];
    }
}

- (IBAction)openphone1:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"tel://800-533-4780"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openTravelURL:(UIButton *)sender
{
    //NSURL *url = [NSURL URLWithString:@"http://www.convergence.b-beyond.com"];
    //[[UIApplication sharedApplication] openURL:url];
    [Functions OpenWebsite:@"http://www.convergence.b-beyond.com"];
}


- (IBAction)openphone2:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"tel://301-644-4985 "];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)openemail:(UIButton *)sender
{
    //NSURL *url = [NSURL URLWithString:@"mailto:ConvHelp@microsoft.com"];
    //[[UIApplication sharedApplication] openURL:url];
    
    NSString *strEmail = @"ConvHelp@microsoft.com";
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        NSString *Subject = @"";
        
        NSString *Body = @"";
        
        [mailer setToRecipients: [[NSArray alloc] initWithObjects:strEmail, nil]];
        [mailer setSubject:Subject];
        [mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
        
        [self presentViewController:mailer animated:YES completion:Nil];
    }
    else
    {
        [Functions OpenMailWithReceipient:strEmail];
    }
}

- (IBAction)opensupportphone:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"tel://435.996.7660"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)opensupportfax:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"tel://425.869.6811"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)opensupportWebsite:(UIButton *)sender
{
   // NSURL *url = [NSURL URLWithString:@"http://www.nayamode.com"];
  //  [[UIApplication sharedApplication] openURL:url];
    [Functions OpenWebsite:@"http://www.nayamode.com"];
}

- (IBAction)opensupportemail:(UIButton *)sender
{
    //NSURL *url = [NSURL URLWithString:@"mailto:websupport@nayamode.com"];
    //[[UIApplication sharedApplication] openURL:url];
    
    NSString *strEmail = @"websupport@nayamode.com";
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        NSString *Subject = @"";
        
        NSString *Body = @"";
        
        [mailer setToRecipients: [[NSArray alloc] initWithObjects:strEmail, nil]];
        [mailer setSubject:Subject];
        [mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
        
        [self presentViewController:mailer animated:YES completion:Nil];
    }
    else
    {
        [Functions OpenMailWithReceipient:strEmail];
    }
}

- (IBAction)openEmail1:(UIButton *)sender
{
    //NSURL *url = [NSURL URLWithString:@"mailto:ConvHelp@microsoft.com"];
    //[[UIApplication sharedApplication] openURL:url];
    
    NSString *strEmail = @"ConvHelp@microsoft.com";
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        NSString *Subject = @"";
        
        NSString *Body = @"";
        
        [mailer setToRecipients: [[NSArray alloc] initWithObjects:strEmail, nil]];
        [mailer setSubject:Subject];
        [mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
        
        [self presentViewController:mailer animated:YES completion:Nil];
    }
    else
    {
        [Functions OpenMailWithReceipient:strEmail];
    }
}
#pragma mark -

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
@end
