//
//  CityGuideMainViewController.m
//  mgx2013
//
//  Created by Sang.Mac.04 on 15/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import "CityGuideMainViewController.h"
#import "CityGuideMapViewController.h"
#import "CityCollectionViewCell.h"
#import "VenueDB.h"
#import "Constants.h"
#import "Shared.h"
#import "DeviceManager.h"
#import "AppDelegate.h"

@interface CityGuideMainViewController ()
@property (nonatomic,retain)NSMutableArray *plistData;
@property (strong, nonatomic) IBOutlet UIView *vwMapPlace;
@property (nonatomic,retain)NSMutableArray *venuesData;
@property (nonatomic,retain)CityGuideMapViewController *mapController;
@end

@implementation CityGuideMainViewController

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
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"CitySearchList.plist"];
    self.plistData = [NSArray arrayWithContentsOfFile:finalPath];
    
    VenueDB *objVenueDB = [VenueDB GetInstance];
    self.venuesData = [NSMutableArray arrayWithArray:[objVenueDB GetVenues]];
    
    if ([DeviceManager IsiPad])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        self.mapController = [sb instantiateViewControllerWithIdentifier:@"citymapview"];
        self.mapController.venueData = [self.venuesData objectAtIndex:0];
        CGRect viewFrame=self.vwMapPlace.bounds;
        self.mapController.view.frame=CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height);
        [self.vwMapPlace addSubview:self.mapController.view];
    }
    
    [Analytics AddAnalyticsForScreen:strSCREEN_CITY_GUIDE];
    
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"citymap"])
    {
//        Shared *objShared = [Shared GetInstance];
//        
//        if([objShared GetIsInternetAvailable] == NO)
//        {
//            [self showAlert:nil withMessage:strNoInternetError withButton:@"OK" withIcon:nil];
//            return NO;
//        }
     
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"citymap"])
    {
        CityCollectionViewCell *searchCell = (CityCollectionViewCell *)sender;
        CityGuideMapViewController *controller = segue.destinationViewController;
        controller.venueData = [self.venuesData objectAtIndex:0];
        
        controller.pageTitle=[searchCell getCellData];
    }
}

- (IBAction)btnBackPress:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.plistData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    CityCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *obj = [self.plistData objectAtIndex:indexPath.row];
    [cell setData:obj];
    if(selectedRow==indexPath.row){
        cell.imgSelected.hidden=NO;
    }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}
int selectedRow=-1;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.mapController.pageTitle=[self.plistData objectAtIndex:indexPath.row];
    [self.mapController ShowNearest];
    selectedRow=indexPath.row;
    [collectionView reloadData];
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
