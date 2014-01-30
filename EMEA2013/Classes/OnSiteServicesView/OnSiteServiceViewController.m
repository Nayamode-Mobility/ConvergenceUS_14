//
//  OnSiteServiceViewController.m
//  mgx2013
//
//  Created by Amit Karande on 11/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "OnSiteServiceViewController.h"
#import "AttendeeMealCustomCell.h"
#import "Constants.h"
#import "EventInfoDB.h"
#import "OnsiteService.h"
#import "DeviceManager.h"
#import "OnSiteCustomCell.h"

@interface OnSiteServiceViewController ()

@end

@implementation OnSiteServiceViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshOnSiteService) name:@"SyncUpCompleted" object:nil];
    
    self.intSelectedIndex = 0;
    
    if (self.arrOnSiteServices == nil)
    {
        self.arrOnSiteServices = [[NSArray alloc] init];
    }
    
    EventInfoDB *objEventInfoDB = [EventInfoDB GetInstance];
    self.arrOnSiteServices = [objEventInfoDB GetOnsiteService];
    if ([self.arrOnSiteServices count] > 0)
    {
        [self setOnSiteData:0];
    }
    
    [Analytics AddAnalyticsForScreen:strSCREEN_ONSITE_SERVICE];
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    
        NSIndexPath *selection = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.tvwOnSiteServices selectRowAtIndexPath:selection animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    
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
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[self.svwOnSiteServices contentOffset].x);
    if([self.svwOnSiteServices contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [self.svwOnSiteServices setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void)RefreshOnSiteService
{
    if (self.arrOnSiteServices == nil)
    {
        self.arrOnSiteServices = [[NSArray alloc] init];
    }
    
    EventInfoDB *objEventInfoDB = [EventInfoDB GetInstance];
    self.arrOnSiteServices = [objEventInfoDB GetOnsiteService];
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [[[self.arrOnSiteServices objectAtIndex:self.intSelectedIndex] objectAtIndex:1] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AttendeeMealCustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    OnsiteService *objOnSiteService = [[[self.arrOnSiteServices objectAtIndex:self.intSelectedIndex] objectAtIndex:1] objectAtIndex:indexPath.row];
    cell.lblTitle.text = objOnSiteService.strCategory;
    [cell.lblTitle setHidden:YES];
    NSString *strData = [NSString stringWithFormat:@"<font style='color: #68217A; font-size:15; font-family: SegoeWP-Bold'>%@</font><br><font style='color: #000000; font-size:13; font-family: SegoeWP'>%@</font><br><br>%@",objOnSiteService.strTitle,objOnSiteService.strBriefDescription,objOnSiteService.strDetailDescription];
    [cell.wvAttendeeMeal setFrame:CGRectMake(cell.wvAttendeeMeal.frame.origin.x, 0, cell.wvAttendeeMeal.frame.size.width, cell.wvAttendeeMeal.frame.size.height)];
    [cell.wvAttendeeMeal setOpaque:NO];
    [cell.wvAttendeeMeal setBackgroundColor:[UIColor clearColor]];
    [cell.wvAttendeeMeal loadHTMLString:strData baseURL:nil];
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
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
    return [self.arrOnSiteServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TCell";
    OnSiteCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.lblTitle.text = [[self.arrOnSiteServices objectAtIndex:indexPath.row] objectAtIndex:0];
    if (cell.selected)
    {
        [cell.imgLogo setHidden:NO];
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OnSiteCustomCell *cell;
    int count = [self.arrOnSiteServices count];

    for (NSUInteger i=0; i < count; ++i)
    {
        cell = (OnSiteCustomCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [cell.imgLogo setHidden:YES];
    }

    cell = (OnSiteCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.imgLogo setHidden:NO];
    
    [self setOnSiteData:indexPath.row];
    
    if ([DeviceManager IsiPhone])
    {
        [self.svwOnSiteServices setContentOffset:CGPointMake(320, 0) animated:YES];
    }
}

-(void) setOnSiteData:(NSInteger)index
{
    self.intSelectedIndex = index;
    
    if ([DeviceManager IsiPhone])
    {
        [self.svwOnSiteServices setContentSize:CGSizeMake(640, self.svwOnSiteServices.frame.size.height)];
        
        NSString *strData = @"";
        for (OnsiteService *objOnsiteService in [[self.arrOnSiteServices objectAtIndex:self.intSelectedIndex] objectAtIndex:1])
        {
            NSString *strBriefDescription = objOnsiteService.strBriefDescription;
            strBriefDescription = [strBriefDescription stringByReplacingOccurrencesOfString:@"<b>" withString:@"<font style='font-family: SegoeWP-Bold'>"];
            strBriefDescription = [strBriefDescription stringByReplacingOccurrencesOfString:@"</b>" withString:@"</font>"];

            //strData = [NSString stringWithFormat:@"%@<font style='color: #7Eb900; font-size:15; font-family: SegoeWP-Bold'>%@</font></span><br><font style='color: #000000; font-size:13; font-family: SegoeWP'>%@</font><br><br>",strData,objOnsiteService.strTitle,objOnsiteService.strBriefDescription];
            strData = [NSString stringWithFormat:@"%@<font style='color: #68217A; font-size:15; font-family: SegoeWP-Bold'>%@</font></span><br><font style='color: #000000; font-size:13; font-family: SegoeWP'>%@</font><br><br>",strData,objOnsiteService.strTitle,strBriefDescription];
        }
        
        self.wvwDetails.opaque = NO;
        [self.wvwDetails setDataDetectorTypes:UIDataDetectorTypeLink];
        [self.wvwDetails setDelegate:self];
        self.wvwDetails.backgroundColor = [UIColor clearColor];
        [self.wvwDetails loadHTMLString:strData baseURL:nil];
    }
    else
    {
        [self.attendeemealsCollectionView reloadData];
        if ([DeviceManager IsiPad])
        {
            //[self.svwOnSiteServices setContentOffset:CGPointMake(320, 0) animated:YES];
            float intItemWidth = 410.0;
            float intTotalItems = [self.attendeemealsCollectionView numberOfItemsInSection:0];
            self.attendeemealsCollectionView.frame = CGRectMake(self.attendeemealsCollectionView.frame.origin.x, self.attendeemealsCollectionView.frame.origin.y,(intTotalItems*intItemWidth), self.attendeemealsCollectionView.frame.size.height);
            [self.attendeemealsCollectionView setContentSize:CGSizeMake((intTotalItems*460.0), self.attendeemealsCollectionView.frame.size.height)];
            [self.svwOnSiteServices setContentSize:CGSizeMake((intItemWidth+(intTotalItems*intItemWidth)), self.svwOnSiteServices.frame.size.height)];
        }
    }
}

- (CGSize)getActualSizeForLabel:(NSString*)strData
{
    UIFont *ft=[UIFont systemFontOfSize:17.0];
    
    CGSize expectedLabelSize = [strData sizeWithFont:ft
                                   constrainedToSize:CGSizeMake(280,1000)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    return expectedLabelSize;
}

#pragma mark Web view methods
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
