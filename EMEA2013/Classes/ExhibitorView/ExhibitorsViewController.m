//
//  ExhibitorsViewController.m
//  mgx2013
//
//  Created by Amit Karande on 23/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#define iPhone_Item_Width 250.0
#define iPhone_Item_Height 100.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 3.0


#import "ExhibitorsViewController.h"
#import "ExhibitorCustomCell.h"
#import "SponsorsDetailViewController.h"
#import "CustomCollectionViewCell.h"
#import "ExhibitorDB.h"
#import "Exhibitor.h"
#import "Constants.h"
#import "DeviceManager.h"


@interface ExhibitorsViewController ()

@end

@implementation ExhibitorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.arrExhibitors == nil)
    {
        self.arrExhibitors = [[NSArray alloc] init];
    }
    
    ExhibitorDB *objExhibitorDB = [ExhibitorDB GetInstance];
    
    if(self.txtSearch.text.length == 0)
    {
        self.arrExhibitors = [objExhibitorDB GetExhibitors];
    }
    else
    {
        self.arrExhibitors = [objExhibitorDB GetExhibitorsLikeName:self.txtSearch.text];
    }
    
    [self.colExhibitorsAlphabets setHidden:YES];
    [self.colExhibitors setHidden:NO];
    
    self.intSelectedIndex = -1;

    [self.colExhibitors reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[[self btnMyExhibitors] layer] setBorderWidth:2.0f];
    [[[self btnMyExhibitors] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnMyExhibitors] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnMyExhibitors] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnSearch] layer] setBorderWidth:2.0f];
    [[[self btnSearch] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnSearch] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnSearch] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[self btnRefresh] layer] setBorderWidth:2.0f];
    [[[self btnRefresh] layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self btnRefresh] addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    [[self btnRefresh] addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
    
    //if (self.arrExhibitors == nil)
    //{
    //    self.arrExhibitors = [[NSArray alloc] init];
    //}
    
    //ExhibitorDB *objExhibitorDB = [ExhibitorDB GetInstance];
    //self.arrExhibitors = [objExhibitorDB GetExhibitors];
    
    //[self.colExhibitorsAlphabets setHidden:YES];
    //[self.colExhibitors setHidden:NO];
    
    //self.intSelectedIndex = -1;
    
    [Analytics AddAnalyticsForScreen:strSCREEN_EXHIBITOR];
    
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
        //return UIInterfaceOrientationMaskAll;
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
    }
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

- (void)resetButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}

- (void)changeButtonBackGroundColor:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0]];
}
#pragma mark -

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view.tag == 1) {
        return [self.arrExhibitors count] + 1;
    }
    else
    {
        if (self.intSelectedIndex == -1)
        {
            return [self.arrExhibitors count];
        }
        else
        {
            return 1;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ExhibitorCustomCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cv.tag == 1) {
        if (indexPath.row == 0)
        {
            cell.articleTitle.text = @"All";
        }
        else
        {
            cell.articleTitle.text = [[NSString stringWithFormat:@"%@",[[self.arrExhibitors objectAtIndex:(indexPath.row-1)] objectAtIndex:0]] lowercaseString];
        }
    }
    else
    {
        
        if (self.intSelectedIndex == -1)
        {
            cell.articleTitle.text = [[NSString stringWithFormat:@"%@",[[self.arrExhibitors objectAtIndex:indexPath.row] objectAtIndex:0]] lowercaseString];
            [cell setTableViewDataSourceDelegate:cell arrExhibitorList:[[self.arrExhibitors objectAtIndex:indexPath.row] objectAtIndex:1]];
        }
        else
        {
            cell.articleTitle.text = [[NSString stringWithFormat:@"%@",[[self.arrExhibitors objectAtIndex:self.intSelectedIndex] objectAtIndex:0]] lowercaseString];
            [cell setTableViewDataSourceDelegate:cell arrExhibitorList:[[self.arrExhibitors objectAtIndex:self.intSelectedIndex] objectAtIndex:1]];
        }
    }

    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
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
            double itemCount = [[[self.arrExhibitors objectAtIndex:indexPath.row] objectAtIndex:1] count];
            double numOfRows = floor(collectionView.frame.size.height/(iPhone_Item_Height));
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
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1)
    {
        if (indexPath.row == 0)
        {
            self.intSelectedIndex = -1;
        }
        else
        {
            self.intSelectedIndex = indexPath.row-1;
        }
        
        [self.colExhibitors reloadData];
        [self.colExhibitorsAlphabets setHidden:YES];
        [self.colExhibitors setHidden:NO];
    }

    //[self performSegueWithIdentifier:@"loadSponsorDetail" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loadExhibitorDetail1"])
    {
        SponsorsDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *exhibitorCell = (CustomCollectionViewCell *)sender;
        controller.exhibitorData = (Exhibitor *)exhibitorCell.cellData;
        controller.blnIsExhibitors = YES;
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
    
    if (self.arrExhibitors == nil)
    {
        self.arrExhibitors = [[NSArray alloc] init];
    }
    
    ExhibitorDB *objExhibitorDB = [ExhibitorDB GetInstance];
    
    self.arrExhibitors = [objExhibitorDB GetExhibitorsLikeName:self.txtSearch.text];
    
    [self.colExhibitorsAlphabets setHidden:YES];
    [self.colExhibitors setHidden:NO];
    
    self.intSelectedIndex = -1;
    
    if([self.arrExhibitors count] == 0)
    {
        [[self lblNoItemsFound] setHidden:NO];
        [self.colExhibitors setHidden:YES];
    }
    
    [self.colExhibitors reloadData];
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
