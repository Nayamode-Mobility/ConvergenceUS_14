//
//  SponsorsViewController.m
//  MGXTestApp
//
//  Created by Amit Karande on 26/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//
#define iPhone_Item_Width 250.0
#define iPhone_Item_Height 100.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 3.0

#import "SponsorsViewController.h"
#import "SponsorsDetailViewController.h"
#import "CustomCollectionViewCell.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "SponsorDB.h"
#import "Sponsor.h"
#import "ExhibitorDB.h"
#import "Exhibitor.h"
#import "SponsorCustomCell.h"


@interface SponsorsViewController ()

@end

@implementation SponsorsViewController
@synthesize intSelectedIndex, myCollectionView, myScrollView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshSponsors) name:@"SyncUpCompleted" object:nil];
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnRefresh] layer] setBorderWidth:2.0f];
    [[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.arrSponsors == nil)
    {
        self.arrSponsors = [[NSArray alloc] init];
    }
    
    /*if (self.blnIsExhibitors) {
        self.lblTitle.text = @"exhibitors";
        self.lblHeaderTitle.text = @"EXHIBITORS";
        ExhibitorDB *objExhibitors = [ExhibitorDB GetInstance];
        self.arrSponsors = [objExhibitors GetExhibitors];
    }
    else{
        self.lblTitle.text = @"sponsors";
        self.lblHeaderTitle.text = @"SPONSORS";
        SponsorDB *objSponsorDB = [SponsorDB GetInstance];
        self.arrSponsors = [objSponsorDB GetSponsorsAndGrouped:YES];
    }*/
    
    self.lblTitle.text = @"sponsors";
    self.lblHeaderTitle.text = @"SPONSORS";
    SponsorDB *objSponsorDB = [SponsorDB GetInstance];
    self.arrSponsors = [objSponsorDB GetSponsorsAndGrouped:YES];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SPONSOR];
    
    //[UIView addTouchEffect:self.view];
}


-(void)viewDidLayoutSubviews
{
    self.myCollectionView.frame = [self collectionViewContentSize];
    
    [self.myScrollView setContentSize:CGSizeMake(self.myCollectionView.frame.origin.x+[self collectionViewContentSize].size.width, self.myScrollView.frame.size.height)];
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

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == [self txtSearch])
    {
        //[[self txtSearch] resignFirstResponder];
        [self btnSearchClicked:[self btnSearch]];
    }
    
    return  YES;
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.arrSponsors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SponsorCustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.articleTitle.text = [NSString stringWithFormat:@"%@",[[self.arrSponsors objectAtIndex:indexPath.row] objectAtIndex:0]];
    [cell setTableViewDataSourceDelegate:cell arrSponsorList:[[self.arrSponsors objectAtIndex:indexPath.row] objectAtIndex:1]];
 
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    intSelectedIndex = indexPath.item;
    //[self performSegueWithIdentifier:@"loadSponsorDetail" sender:nil];
}

- (CGRect)collectionViewContentSize
{
    double totalWidth;
    for (int i = 0; i< [self.arrSponsors count]; i++) {
        double itemCount = [[[self.arrSponsors objectAtIndex:i] objectAtIndex:1] count];
        double numOfRows = floor(self.myCollectionView.frame.size.height/(iPhone_Item_Height));
        totalWidth = totalWidth + ceil(ceil(itemCount/numOfRows))*(iPhone_Item_Width+10);
    }
    
    double itemCount = [self.myCollectionView numberOfItemsInSection:0];
    if([DeviceManager IsiPad] == YES)
    {
        //double totalWidth = ceil(itemCount/iPad_NO_of_Rows)*(iPad_Item_Width+10);
        
        return CGRectMake(self.myCollectionView.frame.origin.x, self.myCollectionView.frame.origin.y, totalWidth, self.myCollectionView.frame.size.height);
    }
    else{
        totalWidth = ceil(itemCount*(iPhone_Item_Width+10));
        return CGRectMake(self.myCollectionView.frame.origin.x, self.myCollectionView.frame.origin.y, totalWidth, self.self.myCollectionView.frame.size.height);
        
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1) {
        CGSize cellSize = (CGSize)
        {
            .width = 60,
            .height = 60
        };
        return cellSize;
    }
    else{
        if ([DeviceManager IsiPad])
        {
            NSLog(@"%f",collectionView.frame.size.height);
            double itemCount = [[[self.arrSponsors objectAtIndex:indexPath.row] objectAtIndex:1] count];
            double numOfRows = floor(collectionView.frame.size.height/(iPhone_Item_Height));
            double totalWidth = ceil(ceil(itemCount/numOfRows))*(iPhone_Item_Width+10);
            CGSize cellSize = (CGSize)
            {
                .width = totalWidth,
                .height = collectionView.frame.size.height
            };
            
            return cellSize;
        }
        else
        {
            CGSize cellSize = (CGSize)
            {
                .width = iPhone_Item_Width,
                .height = collectionView.frame.size.height
            };
            return cellSize;
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*if ([segue.identifier isEqualToString:@"loadSponsorDetail"]) {
        SponsorsDetailViewController *controller = segue.destinationViewController;
        controller.blnIsExhibitors = self.blnIsExhibitors;
        if (self.blnIsExhibitors) {
            controller.exhibitorData = [self.arrSponsors objectAtIndex:intSelectedIndex];
        }
        else{
            controller.sponsorData = [self.arrSponsors objectAtIndex:intSelectedIndex];
        }
        controller.strData = [NSString stringWithFormat:@"Booth Location: %d",intSelectedIndex];
    }*/
    if ([segue.identifier isEqualToString:@"loadSponsorDetail"]) {
        SponsorsDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *exhibitorCell = (CustomCollectionViewCell *)sender;
        controller.sponsorData = (Sponsor *)exhibitorCell.cellData;
        controller.blnIsExhibitors = NO;
    }
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRefreshClicked:(id)sender
{
    //Do not remove the search for 4 spaces
 
    //[[self txtSearch] setText:@"    "];
    
    //[self btnSearchClicked:[self btnSearch]];
    
    //[[self txtSearch] setText:@""];
    
    [self RefreshSponsors];
}

- (void)RefreshSponsors
{
    //Do not remove the search for 4 spaces
    [[self txtSearch] setText:@"    "];
    
    [self btnSearchClicked:[self btnSearch]];
    
    [[self txtSearch] setText:@""];
}

- (IBAction)btnSearchClicked:(id)sender
{
    [[self lblNoItemsFound] setHidden:YES];
    
    //Min. 3 charecters need to be searched
    //if(self.txtSearch.text.length < 3)
    //{
    if(self.txtSearch.text.length == 0)
    {
        //[self.txtSearch resignFirstResponder];
        
        [self showAlert:@"" withMessage:@"Please enter valid search criteria." withButton:@"OK" withIcon:nil];
        
        return;
    }
    
    //    [self showAlert:@"" withMessage:@"Please enter text to search. Minimum text length should be 3." withButton:@"OK" withIcon:nil];
    
    //    return;
    //}
    
    [[self txtSearch] resignFirstResponder];
    
    if (self.arrSponsors == nil)
    {
        self.arrSponsors = [[NSArray alloc] init];
    }
    
    SponsorDB *objSponsorDB = [SponsorDB GetInstance];
    
    self.arrSponsors = [objSponsorDB  GetSponsorsLikeName:self.txtSearch.text];
    
    [self.myCollectionView setHidden:NO];
    
    self.intSelectedIndex = -1;
    
    if([self.arrSponsors count] == 0)
    {
        [[self lblNoItemsFound] setHidden:NO];
        [self.myCollectionView setHidden:YES];
    }
    
    [self.myCollectionView reloadData];
    
    self.myCollectionView.frame = [self collectionViewContentSize];
    
    [self.myScrollView setContentSize:CGSizeMake(self.myCollectionView.frame.origin.x+[self collectionViewContentSize].size.width, self.myScrollView.frame.size.height)];
}

- (void)showAlert:(NSString*)titleMsg withMessage:(NSString*)alertMsg withButton:(NSString*)btnMsg withIcon:(NSString*)imagePath
{
	UIAlertView *currentAlert	= [[UIAlertView alloc]
                                   initWithTitle:titleMsg
                                   message:alertMsg
                                   delegate:nil
                                   cancelButtonTitle:btnMsg
                                   otherButtonTitles:nil];
    
	[currentAlert show];
}
@end
