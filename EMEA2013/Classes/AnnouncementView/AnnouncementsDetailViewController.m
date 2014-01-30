//
//  VenueDetailViewController.m
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//

#import "AnnouncementsDetailViewController.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "VenueFloorPlan.h"
#import "Functions.h"
#import "FacebookViewController.h"
#import "TwitterViewController.h"
#import "LinkedInViewController.h"

@interface AnnouncementsDetailViewController ()

@end

@implementation AnnouncementsDetailViewController
@synthesize strData, lblSelectedItem, venueScrollView, vwDropdownMenu, blnViewExpanded;
@synthesize imgLogo, lblPhone, lblEmail, lblTimings, lblTitle, announcementData, arrFloorPlans, imgFlooPlan;
@synthesize mapView, vwBMap;
@synthesize lblAnnouncementTimeDiff;
@synthesize lblAnnouncementTopic;
@synthesize lblAnnouncementMessage;


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
    [self populateData];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_ANNOUNCEMENT];
    
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

-(void) populateData{
    if ([DeviceManager IsiPad])
    {
        lblAnnouncementMessage.text = self.announcementData.strAnnouncementMessage;
        lblAnnouncementTimeDiff.text = self.announcementData.strTimeDiff;
        lblAnnouncementTopic.text = self.announcementData.strAnnouncementTopic;
  //      [lblAnnouncementMessage sizeToFit];
       
    }
    else
    {

        lblAnnouncementMessage.text = self.announcementData.strAnnouncementMessage;
        lblAnnouncementTimeDiff.text = self.announcementData.strTimeDiff;
        lblAnnouncementTopic.text = self.announcementData.strAnnouncementTopic;

        self.lblAnnouncementMessage.numberOfLines = 0;
        [self.lblAnnouncementMessage sizeToFit];
    }

//lblAnnouncementMessage.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis sodales erat, sed mattis nunc mollis ut. Maecenas sed eleifend leo. In hac habitasse platea dictumst. Praesent non magna purus. Fusce tempus neque eget est aliquam, nec sodales justo iaculis. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum ornare, diam eu tempor malesuada, felis arcu tincidunt nulla, in ultricies felis elit a ipsum. Ut eu tempor lectus, ut commodo magna. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vestibulum dapibus, mi at tristique condimentum, enim tellus dapibus nulla, sit amet ornare diam libero nec metus. Praesent ultrices urna at elit pharetra convallis. Duis mollis iaculis urna, vitae rhoncus libero bibendum sed. Curabitur ac lacus convallis, facilisis augue id, adipiscing est. Vestibulum quis nisi eget nulla sollicitudin adipiscing in sit amet eros. Fusce elit leo, luctus non vulputate quis, pharetra ac augue. Etiam quis vestibulum urna. Nulla ultricies eros vestibulum mi mattis posuere. Vestibulum ornare convallis orci, sit amet adipiscing lectus euismod et. In interdum pretium lobortis. Sed eget tellus nisl. Vestibulum accumsan ipsum eu arcu luctus, et venenatis ante sodales. Fusce pharetra pharetra nulla in hendrerit. Mauris sollicitudin nisl vitae tempus vestibulum. Curabitur ac ligula justo. Ut quis tincidunt eros. Curabitur viverra tortor vitae faucibus vestibulum. Aenean tempor eget nisi eu egestas. Nulla ornare urna ut tellus tincidunt rhoncus. Mauris a bibendum felis, non egestas nisl. Mauris in est at mauris suscipit ornare ut eget libero. Maecenas et justo eget ipsum consequat laoreet. Sed erat lectus, placerat ac elit ut, mollis convallis sem. Donec porttitor tristique elit in tempor. Suspendisse elit elit, consequat et sem quis, pretium euismod sapien. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor tellus sit amet dolor aliquam, in commodo urna venenatis. Praesent et mi lacinia, molestie leo eu, tincidunt tellus. Donec mauris dolor, scelerisque dictum mi eget, semper bibendum mauris. Nullam a hendrerit nibh. Praesent eu nisi ligula. Aliquam ut ante dapibus, euismod nisl ac, pellentesque nisl. Quisque vulputate eu libero sed porttitor. Mauris fringilla porttitor metus, a adipiscing enim. Quisque tristique, turpis in feugiat hendrerit, arcu magna tincidunt libero, eu placerat orci lacus non magna. Quisque tincidunt est nec odio semper, et hendrerit sem aliquam. Nullam molestie arcu in eros dictum, eget lobortis urna vestibulum. Nam sed egestas arcu. Nulla lobortis fringilla nibh. Duis convallis eros rutrum orci pulvinar viverra. Maecenas libero erat, eleifend nec ligula a, egestas blandit lectus. Sed turpis quam, gravida non enim vitae, blandit sodales neque.";

     [lblAnnouncementMessage sizeToFit];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [self.venueScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.venueScrollView.frame.size.height)];
    self.messageScrollview.contentSize = CGSizeMake(self.messageScrollview.frame.size.width, lblAnnouncementMessage.frame.origin.x + lblAnnouncementMessage.frame.size.height);
    self.vwSocialMedia.frame = CGRectMake(20, (self.lblAnnouncementMessage.frame.origin.y + self.lblAnnouncementMessage.frame.size.height + 10), self.vwSocialMedia.frame.size.width, self.vwSocialMedia.frame.size.height);

    /*if ([DeviceManager IsiPad])
     {
        [self.svwSpeakerDetail setContentSize:CGSizeMake(1536, self.svwSpeakerDetail.frame.size.height)];
    }*/
}

- (IBAction)btnSocialMediaClicked:(id)sender
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
    
    if (sender == self.btnTwitter)
    {
        TwitterViewController *vcTwitter = [storyboard instantiateViewControllerWithIdentifier:@"idTwitter"];
        [[self navigationController] pushViewController:vcTwitter animated:YES];
    }
    else if(sender == self.btnFacebook)
    {
        FacebookViewController *vcFacebook = [storyboard instantiateViewControllerWithIdentifier:@"idFacebook"];
        [[self navigationController] pushViewController:vcFacebook animated:YES];
    }
    else if(sender == self.btnLinkedIn)
    {
        LinkedInViewController *vcLinkedIn = [storyboard instantiateViewControllerWithIdentifier:@"idLinkedIn"];
        [[self navigationController] pushViewController:vcLinkedIn animated:YES];
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showDropdownMenu:(id)sender
{
    if (blnViewExpanded)
    {
        [self ShrinkView];
    }
    else
    {
        [self expandView];
    }
}


- (IBAction)OpenMail:(id)sender
{
 	if([MFMailComposeViewController canSendMail])
	{
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
		NSString *Subject = @"";
		
		NSString *Body = @"";
        
        //[mailer setToRecipients: [[NSArray alloc] initWithObjects:@"", nil]];
		[mailer setSubject:Subject];
		[mailer setMessageBody:Body isHTML:YES];
        mailer.mailComposeDelegate = self;
		
        [self presentViewController:mailer animated:YES completion:Nil];
	}
    else
    {
        [Functions OpenMail];
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
    return 0;//[self.arrFloorPlans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:indexPath.row];
    cell.textLabel.text = objVenueFloorPlan.strBriefDescription;

    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self setFloorPlanData:indexPath.row];
}

-(void) setFloorPlanData:(NSInteger)index{
    VenueFloorPlan *objVenueFloorPlan = [self.arrFloorPlans objectAtIndex:index];
    
    [lblSelectedItem setText:objVenueFloorPlan.strBriefDescription];
    
    NSURL *imgURL = [NSURL URLWithString:objVenueFloorPlan.strImageURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
    NSData *data,
    NSError *error){
        if (!error)
        {
            imgFlooPlan.image = [UIImage imageWithData:data];
        }
    }];
}

#pragma mark Mail Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
    {
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
		break;
    }
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}
#pragma mark -
@end
