//
//  AgendaViewController.m
//  MGXTestApp
//
//  Created by Amit Karande on 28/09/13.
//  Copyright (c) 2013 SangInfo. All rights reserved.
//
#define iPhone_Item_Width 300.0
#define iPhone_Item_Height 180.0
#define iPhone_NO_of_Rows 3.0
#define iPad_Item_Width 300.0
#define iPad_Item_Height 250.0
#define iPad_NO_of_Rows 3.0

#import "AgendaViewController.h"
#import "DeviceManager.h"
#import "AgendaCustomCollectionViewCell.h"
#import "SpeakerCell.h"
#import "Constants.h"
#import "AgendaDB.h"
#import "Agenda.h"

@interface AgendaViewController ()

@end

@implementation AgendaViewController
@synthesize intSelectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshAgendas) name:@"SyncUpCompleted" object:nil];
    
    
    if (self.arrAgendas == nil)
    {
        self.arrAgendas = [[NSArray alloc] init];
    }
    AgendaDB *objAgendaDB = [AgendaDB GetInstance];
    self.arrAgendas = [objAgendaDB GetAgendas];
    
    [Analytics AddAnalyticsForScreen:strSCREEN_AGENDA];
    
    //[UIView addTouchEffect:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([DeviceManager IsiPad])
    {
        NSIndexPath *selection = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.agendaCollectionView selectItemAtIndexPath:selection animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
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

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.arrAgendas count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AgendaCustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *strDate = [NSString stringWithFormat:@"%@",[[self.arrAgendas objectAtIndex:indexPath.row] objectAtIndex:0]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dbdate = [dateFormat dateFromString:strDate];
    
    if ([DeviceManager IsiPad])
    {
        [dateFormat setDateFormat:@"EEEE, LLLL d"];
        NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
        cell.articleTitle.text = strFormattedDate;
    }
    else
    {
        [dateFormat setDateFormat:@"EE, d LLL"];
        NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
        cell.articleTitle.text = [strFormattedDate lowercaseString];
    }
    
    if([DeviceManager IsiPhone])
    {
        [cell setTableViewDataSourceDelegate:cell arrAgendaList:[[self.arrAgendas objectAtIndex:indexPath.row] objectAtIndex:1]];
    }
    
    if ([DeviceManager IsiPad])
    {
        if (cell.selected)
        {
            [cell.articleImage setHidden:NO];
        }
    }
        
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([DeviceManager IsiPad])
    {
        AgendaCustomCollectionViewCell *cell;
        int count = [self.arrAgendas count];

        for (NSUInteger i=0; i < count; ++i)
        {
            cell = (AgendaCustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            [cell.articleImage setHidden:YES];
        }
        
        cell = (AgendaCustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.articleImage setHidden:NO];
        intSelectedIndex = indexPath.row;
        [self.agendaDetailTableView reloadData];
    }

    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    
    if([DeviceManager IsiPad])
    {
        if(collectionView.tag == 0)
        {
            size = CGSizeMake(250.0f, 50.0f);
        }
        else
        {
            size = CGSizeMake(300.0f, 250.0f);
        }
    }
    else
    {
        if([DeviceManager Is4Inch])
        {
            size = CGSizeMake(320.0f, 448.0f);
        }
        else
        {
            size = CGSizeMake(320.0f, 360.0f);
        }
    }
    
    return size;
}
#pragma mark -

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.arrAgendas objectAtIndex:intSelectedIndex] objectAtIndex:1]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TCell";
    SpeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Agenda *objAgenda = [[[self.arrAgendas objectAtIndex:intSelectedIndex] objectAtIndex:1] objectAtIndex:indexPath.row];
    cell.lblTiming.text = [NSString stringWithFormat:@"%@ - %@",[self formatDate:objAgenda.strStartDate],[self formatDate:objAgenda.strEndDate]];
    cell.lblTask.text = objAgenda.strTitle;
    cell.lblLocation.text = objAgenda.strBriefDescription;
    
    CGRect org=cell.lblLocation.frame;
    [cell.lblLocation sizeToFit];
    org.size.height=cell.lblLocation.frame.size.height;
    cell.lblLocation.frame=org;
 
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Agenda *objAgenda = [[[self.arrAgendas objectAtIndex:intSelectedIndex] objectAtIndex:1] objectAtIndex:indexPath.row];
    NSString *yourString=objAgenda.strBriefDescription;
    UIFont *ft=[UIFont systemFontOfSize:17.0];
    
    CGSize expectedLabelSize = [yourString sizeWithFont:ft
                                      constrainedToSize:CGSizeMake(518, 21)
                                          lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return expectedLabelSize.height + 54.0;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RefreshAgendas
{
    if (self.arrAgendas == nil)
    {
        self.arrAgendas = [[NSArray alloc] init];
    }
    AgendaDB *objAgendaDB = [AgendaDB GetInstance];
    self.arrAgendas = [objAgendaDB GetAgendas];
    
    [self.agendaCollectionView reloadData];
}


- (NSString *)formatDate:(NSString *)strDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dbdate = [dateFormat dateFromString:strDate];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *strFormattedDate = [dateFormat stringFromDate:dbdate];
    return strFormattedDate;
}
@end
