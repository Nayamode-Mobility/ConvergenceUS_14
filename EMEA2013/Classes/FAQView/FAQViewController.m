//
//  FAQViewController.m
//  mgx2013
//
//  Created by Amit Karande on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "FAQViewController.h"
#import "MasterDB.h"
#import "EventInfoCategories.h"
#import "EventInfoDetails.h"
#import "CustomCollectionViewCell.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "Functions.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshFAQs) name:@"SyncUpCompleted" object:nil];
    
	// Do any additional setup after loading the view.
    
    if (self.arrFAQs == nil) {
        self.arrFAQs = [[NSArray alloc] init];
    }
    
    MasterDB *objMasterDB = [MasterDB GetInstance];
    self.arrFAQs = [objMasterDB GetFAQ];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_FAQ];
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([DeviceManager IsiPad])
    {
        NSIndexPath *selection = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.categoriesCollectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        if ([self.arrFAQs count]>0)
        {
            [self populateData:0];
        }
    }
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

- (IBAction)MakePhoneCall:(id)sender
{
    [Functions MakePhoneCall:@""];
}

- (IBAction)btnBackClicked:(id)sender
{
    //NSLog(@"%f",[svwFAQs contentOffset].x);
    if([self.svwFAQs contentOffset].x == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if ([DeviceManager IsiPhone])
        {
            [self.svwFAQs setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

- (void)RefreshFAQs
{
    if (self.arrFAQs == nil)
    {
        self.arrFAQs = [[NSArray alloc] init];
    }
    
    MasterDB *objMasterDB = [MasterDB GetInstance];
    self.arrFAQs = [objMasterDB GetFAQ];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.arrFAQs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    EventInfoCategories *objCategory = [self.arrFAQs objectAtIndex:indexPath.row];
    cell.lblName.text = objCategory.strCategory;

    if (cell.selected)
    {
        [cell.articleImage setHidden:NO];
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell;
    int count = [self.arrFAQs count];

    for (NSUInteger i=0; i < count; ++i)
    {
        cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [cell.articleImage setHidden:YES];
    }
    
    cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.articleImage setHidden:NO];
    [self populateData:indexPath.row];
}

-(void)populateData:(NSUInteger)index
{
    for(UIScrollView *view in self.svwFAQs.subviews)
    {
        if (view.tag > 0)
        {
            [view removeFromSuperview];
        }
    }
    
    for(UIWebView *view in self.svwFAQs.subviews)
    {
        if (view.tag > 0)
        {
            [view removeFromSuperview];
        }
    }
    
    EventInfoCategories *objEventCat = [self.arrFAQs objectAtIndex:index];
    int intX = 400;
    int intY = 0;
    int intItemGap = 450;
    NSInteger intWidth = 400;
    
    if ([DeviceManager IsiPhone])
    {
        intX = 320;
        intItemGap = 320;
        intWidth = 280;
        UIScrollView *detailView = [[UIScrollView alloc] initWithFrame:CGRectMake(intX, 0, intX, self.svwFAQs.frame.size.height)];
        for(EventInfoDetails *objDetail in objEventCat.arrEventInfoDetails)
        {
            
            NSString *strData = [NSString stringWithFormat:@"<font style='color: #7Eb900; font-size:15; font-family: SegoeWP-Bold'>%@</font><br><font style='color: #000000; font-size:13; font-family: SegoeWP'><div style='width: 270px; word-wrap: break-word'>%@</div></font>",objDetail.strTitle,objDetail.strBriefDescription];
            
            
            UIFont *ftTitle=[UIFont fontWithName:@"SegoeWP-Bold" size:15.0];
            
            CGSize expectedLabelSizeForTitle = [objDetail.strTitle sizeWithFont:ftTitle
                                                              constrainedToSize:CGSizeMake(intWidth,1000)
                                                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            UIFont *ftDescription=[UIFont fontWithName:@"SegoeWP" size:15.0];
            CGSize expectedLabelSizeForDescription = [objDetail.strBriefDescription sizeWithFont:ftDescription
                                                                               constrainedToSize:CGSizeMake(intWidth,1000)
                                                                                   lineBreakMode:NSLineBreakByWordWrapping];
            
            UIWebView *vwWeb = [[UIWebView alloc] initWithFrame:CGRectMake(20, intY, intWidth, (expectedLabelSizeForTitle.height + expectedLabelSizeForDescription.height + 40))];
            
            [vwWeb setOpaque:NO];
            [vwWeb setDataDetectorTypes:UIDataDetectorTypeLink];
            [vwWeb setBackgroundColor:[UIColor clearColor]];
            [vwWeb setDelegate:self];
            [vwWeb loadHTMLString:strData baseURL:nil];
            
            vwWeb.tag = intX;
            vwWeb.scrollView.scrollEnabled = NO;
            [detailView addSubview:vwWeb];
            
            intY = intY + (expectedLabelSizeForTitle.height + expectedLabelSizeForDescription.height + 0);
        }
        
        detailView.tag = 1;
        [detailView setContentSize:CGSizeMake(intX, (intY + 40))];
        [self.svwFAQs addSubview:detailView];
        [self.svwFAQs setContentSize:CGSizeMake(640, self.svwFAQs.frame.size.height)];
    }
    else
    {
        for(EventInfoDetails *objDetail in objEventCat.arrEventInfoDetails)
        {
            UIWebView *vwWeb = [[UIWebView alloc] initWithFrame:CGRectMake(intX, intY, intWidth, self.svwFAQs.frame.size.height)];
            
            NSString *strData = [NSString stringWithFormat:@"<font style='color: #000000; font-size:15; font-family: SegoeWP-Bold'>%@</font><br><font style='color: #000000; font-size:13; font-family: SegoeWP'>%@</font>",objDetail.strTitle,objDetail.strBriefDescription];
            [vwWeb setOpaque:NO];
            [vwWeb setBackgroundColor:[UIColor clearColor]];
            [vwWeb loadHTMLString:strData baseURL:nil];
            vwWeb.tag = intX;
            [self.svwFAQs addSubview:vwWeb];
            intX = intX + intItemGap;
        }
        [self.svwFAQs setContentSize:CGSizeMake(intX+20, self.svwFAQs.frame.size.height)];
    }
    if ([DeviceManager IsiPhone])
    {
        [self.svwFAQs setContentOffset:CGPointMake(320, 0) animated:YES];
    }
}

#pragma mark Web view methods
- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq navigationType:(UIWebViewNavigationType)nt
{
    if (nt == UIWebViewNavigationTypeLinkClicked)
    {
        //Previous Code
        //[[UIApplication sharedApplication] openURL:[rq URL]];
        
        //[Functions OpenWebsite:[NSString stringWithFormat:@"%@",[rq URL]]];
        
        // New Code
        NSString *str = [NSString stringWithFormat:@"%@",[rq URL]];
        str= [str stringByReplacingOccurrencesOfString:@"link:" withString: @""];
        [Functions OpenWebsite:str];
        
        
        return NO;
    }
    
    return YES;
}
#pragma mark -
@end
