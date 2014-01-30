//
//  ViewController.m
//  Speakers
//
//  Created by Amit Karande on 23/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//
#define iPhone_Item_Width 250.0
#define iPhone_Item_Height 100.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 3.0

#import "SpeakersViewController.h"
#import "SpeakerCustomCollectionViewCell.h"
#import "SpeakerCell.h"
#import "SpeakerDetailViewController.h"
#import "CustomCollectionViewCell.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "SpeakerDB.h"
#import "Speaker.h"

@interface SpeakersViewController ()

@end

@implementation SpeakersViewController
@synthesize intSelectedIndex, items, speakersData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshSpeakers) name:@"SyncUpCompleted" object:nil];
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnRefresh] layer] setBorderWidth:2.0f];
    [[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    if (items == nil)
    {
        items = [NSArray arrayWithObjects:@"8",@"3",@"5",@"3",nil] ;
    }
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrietationDidChange) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    if (self.speakersData == nil)
    {
        self.speakersData = [[NSArray alloc] init];
    }
    
    SpeakerDB *objSpeakerDB = [SpeakerDB GetInstance];
    self.speakersData = [objSpeakerDB GetSpeakers];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_SPEAKER];
    
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

-(void)deviceOrietationDidChange
{
    if ([DeviceManager IsiPad])
    {
            [self.speakerCollectionView reloadData];
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
    return [self.speakersData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SpeakerCustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.articleTitle.text = [[NSString stringWithFormat:@"%@",[[self.speakersData objectAtIndex:indexPath.row] objectAtIndex:0]] lowercaseString];
    [cell setTableViewDataSourceDelegate:cell arrSpeakerList:[[self.speakersData objectAtIndex:indexPath.row] objectAtIndex:1]];

    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([DeviceManager IsiPad])
    {
        double itemCount = [[[self.speakersData objectAtIndex:indexPath.row] objectAtIndex:1] count];
        double numOfRows = floor(collectionView.frame.size.height/(iPhone_Item_Height+10));
        double totalWidth = ceil((itemCount/numOfRows))*(iPhone_Item_Width+10);
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"loadSpeakerDetail"]) {
        SpeakerDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *speakerCell = (CustomCollectionViewCell *)sender;
        controller.speakerData = (Speaker *)speakerCell.cellData;
    }
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.txtSearch resignFirstResponder];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnRefreshClicked:(id)sender
{
    //[[self vwLoading] setHidden:NO];
    //[[self avLoading] startAnimating];
    
    //Do not remove the search for 4 spaces
   // [[self txtSearch] setText:@"    "];
    
    //[self btnSearchClicked:[self btnSearch]];
    
   // [[self txtSearch] setText:@""];
    
    [self RefreshSpeakers];
    
    //[[self vwLoading] setHidden:YES];
    //[[self avLoading] stopAnimating];
}

- (void)RefreshSpeakers
{
    [[self txtSearch] setText:@"    "];
    
    [self btnSearchClicked:[self btnSearch]];
    
    [[self txtSearch] setText:@""];
}

- (IBAction)btnSearchClicked:(id)sender
{
    [[self lblNoItemsFound] setHidden:YES];
    
    //Min. 3 charecters need to be searched
    if(self.txtSearch.text.length < 3)
    {
        
        // Newlyy Added code
        
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid search text. Search text should not be less than 3 characters." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        
        if(self.txtSearch.text.length == 0)
        {
            [self.txtSearch resignFirstResponder];
        }
        
        return;
    }
    
    [[self txtSearch] resignFirstResponder];
    
    if (self.speakersData == nil)
    {
        self.speakersData = [[NSArray alloc] init];
    }
    
    SpeakerDB *objSpeakerDB = [SpeakerDB GetInstance];
    
    self.speakersData = [objSpeakerDB  GetSpeakersLikeName:self.txtSearch.text];
    
    [self.speakerCollectionView setHidden:NO];
    
    self.intSelectedIndex = -1;
    
    if([self.speakersData count] == 0)
    {
        [[self lblNoItemsFound] setHidden:NO];
        [self.speakerCollectionView setHidden:YES];
    }
    
    [self.speakerCollectionView reloadData];
}
@end
