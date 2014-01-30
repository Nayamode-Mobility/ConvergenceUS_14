//
//  FindLikeMindedViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nikhil on 15/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "FindLikeMindedViewController.h"
#import "AttendeeDB.h"
#import "Filters.h"
#import "CustomCollectionViewCell.h"
#import "NSString+Custom.h"
#import "AttendeeDetailViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "DB.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"
#import "FBJSON.h"

@interface FindLikeMindedViewController ()

@end

@implementation FindLikeMindedViewController

@synthesize objData,objConnection;

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
    blnDropdownExpanded = NO;
    
    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc]init];
    arrCategory1 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"JobRoles"];
    arrCategory2 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"MyBusiness"];
    arrCategory3 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"ImpProducts"];
    arrCategory4 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"SellProducts"];
    arrCategory5 = [objAttendeeDB GetAttendeesCategoryOfFilterType:@"EvalProducts"];
    
    intCategory1_SelectedIndex = 0;
    intCategory2_SelectedIndex = 0;
    intCategory3_SelectedIndex = 0;
    intCategory4_SelectedIndex = 0;
    intCategory5_SelectedIndex = 0;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     [scrlFindLikeMinded setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
    
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height < 568.0f)
        {
            btnSearch.frame = CGRectMake(80.0, 375.0, 150.0, 40.0);
            
        }
       
    }
    
    
    // Newly Added code
    
    [[btnSearch layer] setBorderWidth:2.0f];
    [[btnSearch layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self setBorders];
    
}

// Newly Added Code*******

- (void)setBorders
{
    [self setBorderToView:viewTableCategory1];
    [self setBorderToView:viewTableCategory2];
    [self setBorderToView:viewTableCategory3];
    [self setBorderToView:viewTableCategory4];
    [self setBorderToView:viewTableCategory5];
}

- (void)setBorderToView:(UIView *)view
{
    //[[view layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[view layer] setBorderWidth:1.0];
    // [[viewTableCategory1 layer] setCornerRadius:10];
    [view setClipsToBounds: YES];
}


//*********************


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger intReturnValue;
    switch (tableView.tag) {
        case 1:
            intReturnValue = [arrCategory1 count];
            break;
        case 2:
            intReturnValue = [arrCategory2 count];
            break;
        case 3:
            intReturnValue = [arrCategory3 count];
            break;
        case 4:
            intReturnValue = [arrCategory4 count];
            break;
        case 5:
            intReturnValue = [arrCategory5 count];
            break;
        default:
            intReturnValue = 0;
            break;
    }
    return intReturnValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *strTitle;
    
    
    NSLog(@"%ld",(long)tableView.tag);
    
    switch (tableView.tag)
    {
        case 1:
        {
            Filters  *objFilters = [arrCategory1 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 2:
        {
            Filters  *objFilters = [arrCategory2 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 3:
        {
            Filters  *objFilters = [arrCategory3 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        case 4:
        {
            Filters  *objFilters = [arrCategory4 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
        case 5:
        {
            Filters  *objFilters = [arrCategory5 objectAtIndex:indexPath.row];
            strTitle = objFilters.strCategory;
        }
            break;
        default:
            strTitle = @"";
            break;
    }
    
    
    cell.textLabel.text = strTitle;
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(104/255.0) green:(33/255.5) blue:0 alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ShrinkAllDropdownViews];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    blnDropdownExpanded = NO;
    switch (tableView.tag)
    {
        case 1:
        {
            Filters  *objFilters = [arrCategory1 objectAtIndex:indexPath.row];
            lblCategory1.text = objFilters.strCategory;
            intCategory1_SelectedIndex = indexPath.row;
        }
            break;
        case 2:
        {
            Filters  *objFilters = [arrCategory2 objectAtIndex:indexPath.row];
            lblCategory2.text = objFilters.strCategory;
            intCategory2_SelectedIndex = indexPath.row;
        }
            break;
        case 3:
        {
            Filters  *objFilters = [arrCategory3 objectAtIndex:indexPath.row];
            lblCategory3.text = objFilters.strCategory;
            intCategory3_SelectedIndex = indexPath.row;
        }
            break;
        case 4:
        {
            Filters *objFilters = [arrCategory4 objectAtIndex:indexPath.row];
            lblCategory4.text = objFilters.strCategory;
            intCategory4_SelectedIndex = indexPath.row;
        }
            break;
        case 5:
        {
            Filters *objFilters = [arrCategory5 objectAtIndex:indexPath.row];
            lblCategory5.text = objFilters.strCategory;
            intCategory5_SelectedIndex = indexPath.row;
        }

            break;
        default:
            break;
    }
    
    //[self setFloorPlanData:indexPath.row];
    [self viewDidLayoutSubviews];
}

-(IBAction)btnSearch_Click:(id)sender
{
    if (APP.netStatus) {
        
        [[self vwLoading] setHidden:NO];
        [[self avLoading] startAnimating];
        
        User *objUser = [User GetInstance];
        
        NSString *strURL = strAPI_URL;
        strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_SEARCH_ATTENDEE];//api/Attendee/GetAttendeeListByCharacter
        
        NSURL *URL = [NSURL URLWithString:strURL];
        
        NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
        [objRequest setHTTPMethod:@"POST"];
        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
        [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
        [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
        
        NSMutableArray *arrFilters = [[NSMutableArray alloc]init];
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
        Filters *objFilters;
        
            dictTemp = [[NSMutableDictionary alloc]init];
            objFilters = [arrCategory1 objectAtIndex:intCategory1_SelectedIndex];
            [dictTemp setObject:objFilters.strCategoryID?@"" @"JobRoles":objFilters.strCategoryID forKey:@"FilterName"];
            [dictTemp setObject:[objFilters.strCategory isEqualToString:@"All"] ? @"":objFilters.strCategory forKey:@"FilterValue"];
            [arrFilters addObject:dictTemp];
        
            dictTemp = [[NSMutableDictionary alloc]init];
            objFilters = [arrCategory2 objectAtIndex:intCategory2_SelectedIndex];
            [dictTemp setObject:objFilters.strCategoryID?@"" @"MyBusiness":objFilters.strCategoryID forKey:@"FilterName"];
            [dictTemp setObject:[objFilters.strCategory isEqualToString:@"All"] ? @"":objFilters.strCategory forKey:@"FilterValue"];
            [arrFilters addObject:dictTemp];

            dictTemp = [[NSMutableDictionary alloc]init];
            objFilters = [arrCategory3 objectAtIndex:intCategory3_SelectedIndex];
            [dictTemp setObject:objFilters.strCategoryID?@"" @"IMP":objFilters.strCategoryID forKey:@"FilterName"];
            [dictTemp setObject:[objFilters.strCategory isEqualToString:@"All"] ? @"":objFilters.strCategory forKey:@"FilterValue"];
            [arrFilters addObject:dictTemp];

            dictTemp = [[NSMutableDictionary alloc]init];
            objFilters = [arrCategory4 objectAtIndex:intCategory4_SelectedIndex];
            [dictTemp setObject:objFilters.strCategoryID?@"" @"SELL":objFilters.strCategoryID forKey:@"FilterName"];
            [dictTemp setObject:[objFilters.strCategory isEqualToString:@"All"] ? @"":objFilters.strCategory forKey:@"FilterValue"];
            [arrFilters addObject:dictTemp];
        
        dictTemp = [[NSMutableDictionary alloc]init];
        objFilters = [arrCategory5 objectAtIndex:intCategory5_SelectedIndex];
        [dictTemp setObject:objFilters.strCategoryID?@"" @"EVAL":objFilters.strCategoryID forKey:@"FilterName"];
        [dictTemp setObject:[objFilters.strCategory isEqualToString:@"All"] ? @"":objFilters.strCategory forKey:@"FilterValue"];
        [arrFilters addObject:dictTemp];
   
//        dictTemp = [[NSMutableDictionary alloc]init];
//        [dictTemp setObject:@"EVAL" forKey:@"FilterName"];
//        [dictTemp setObject:@"" forKey:@"FilterValue"];
        
//        objFilters = [arrCategory4 objectAtIndex:intCategory4_SelectedIndex];
//        [dictTemp setObject:objFilters.strCategoryID?@"" @"SellProducts":objFilters.strCategoryID forKey:@"FilterName"];
//        [dictTemp setObject:[objFilters.strCategory isEqualToString:@"All"] ? @"":objFilters.strCategory forKey:@"FilterValue"];
        [arrFilters addObject:dictTemp];

        
        //[objRequest addValue:[arrFilters JSONRepresentation] forHTTPHeaderField:@"Filterpairs"];
        [objRequest setHTTPBody: [[arrFilters JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding]];
        
        objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:OPER_GET_ANTENDEE_LIST];
    }else{
        NETWORK_ALERT();
    }

//    AttendeeDB *objAttendeeDB = [[AttendeeDB alloc]init];
//    arrAttendees = [objAttendeeDB GetFilteredFindLikeMindedwithCategory1:lblCategory1.text Category2:lblCategory2.text Category3:lblCategory3.text Category4:lblCategory4.text];
//    
//    [collFindLikeMinded  reloadData];
//    [scrlFindLikeMinded setContentSize:CGSizeMake(640, 483)];
//    [scrlFindLikeMinded setContentOffset:CGPointMake(320, 0)];
}

- (IBAction)backBtnClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    objData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [objData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
//    dictData = [NSJSONSerialization JSONObjectWithData:objData options:kNilOptions error:nil];

    AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
    arrAttendees = [objAttendeeDB GetAttendeesList:objData];
    [collFindLikeMinded reloadData];
    
    [scrlFindLikeMinded setContentSize:CGSizeMake(640, 483)];
    [scrlFindLikeMinded setContentOffset:CGPointMake(320, 0)];

    [[self vwLoading] setHidden:YES];
    [[self avLoading] stopAnimating];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loadAttendeeDetail"])
    {
        AttendeeDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *attendeeCell = (CustomCollectionViewCell *)sender;
        controller.attendeeData = (Attendee *)attendeeCell.cellData;
    }
}

#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [arrAttendees count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FLMCell" forIndexPath:indexPath];

    Attendee *objAttendee;
        
    objAttendee = [arrAttendees objectAtIndex:indexPath.row];
    
        cell.lblName.text = [NSString stringWithFormat:@"%@ %@",objAttendee.strFirstName,objAttendee.strLastName];
        cell.lblTitle.text = objAttendee.strAttendeeName;
        cell.lblTitle.textColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
        cell.lblCompany.text = objAttendee.strCompany;
        cell.cellData = objAttendee;
        
        cell.imgLogo.image = nil;
        cell.imgLogo.image = [UIImage imageNamed:@"normal.png"];
        if(![NSString IsEmpty:objAttendee.strPhotoURL shouldCleanWhiteSpace:YES])
        {
            NSURL *imgURL = [NSURL URLWithString:objAttendee.strPhotoURL];
            NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
            [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                                       NSData *data,
                                                                                                                       NSError *error)
             {
                 if (!error)
                 {
                     //NSLog(@"%@ %@",response.URL.absoluteString,((Attendee*)cell.cellData).strPhotoURL);
                     if([response.URL.absoluteString isEqualToString:((Attendee*)cell.cellData).strPhotoURL])
                     {
                         cell.imgLogo.image = [UIImage imageWithData:data];
                     }
                 }
             }];
        }
    
    //[UIView addTouchEffect:cell.contentView];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[self performSegueWithIdentifier:@"loadSponsorDetail" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnCategory_Click:(id)sender
{
    if (blnDropdownExpanded)
    {
        [self ShrinkAllDropdownViews];
        blnDropdownExpanded = NO;
    }
    else
    {
        UIButton *clickedButton = (UIButton *)sender;
        [self expandView:clickedButton.tag];
        blnDropdownExpanded = YES;
    }

}

- (void)expandView:(NSInteger)tag
{
    NSInteger intExpandHeight = [UIScreen mainScreen].bounds.size.height-50;
    
    NSLog(@"%ld",(long)tag);
    
    switch (tag)
    {
        case 1:
        {
            intExpandHeight = intExpandHeight - viewTableCategory1.frame.origin.y;
            
              // CGPoint * offset=(__bridge CGPoint *)(NSStringFromCGPoint(scrlFindLikeMinded.contentOffset));
            
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory1.frame = CGRectMake(viewTableCategory1.frame.origin.x, viewTableCategory1.frame.origin.y, (viewTableCategory1.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 2:
        {
            intExpandHeight = intExpandHeight - viewTableCategory2.frame.origin.y;
            
             //  CGPoint * offset=(__bridge CGPoint *)(NSStringFromCGPoint(scrlFindLikeMinded.contentOffset));
            
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory2.frame = CGRectMake(viewTableCategory2.frame.origin.x, viewTableCategory2.frame.origin.y, (viewTableCategory2.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 3:
        {
            intExpandHeight = intExpandHeight - viewTableCategory3.frame.origin.y;
            
             //  CGPoint * offset=(__bridge CGPoint *)(NSStringFromCGPoint(scrlFindLikeMinded.contentOffset));
            
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory3.frame = CGRectMake(viewTableCategory3.frame.origin.x, viewTableCategory3.frame.origin.y, (viewTableCategory3.frame.size.width), intExpandHeight);
                
            } completion:nil];
        }
            break;
        case 4:
        {
            intExpandHeight = intExpandHeight - viewTableCategory4.frame.origin.y;
            
           // CGPoint * offset=(__bridge CGPoint *)(NSStringFromCGPoint(scrlFindLikeMinded.contentOffset));
            
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory4.frame = CGRectMake(viewTableCategory4.frame.origin.x, viewTableCategory4.frame.origin.y, (viewTableCategory4.frame.size.width), intExpandHeight);
                
            } completion:nil];
            
            break;
            
        }
        case 5:
        {
            
             NSLog(@" Offset = %@ ",NSStringFromCGPoint(scrlFindLikeMinded.contentOffset));
            
           // CGPoint * offset=(__bridge CGPoint *)(NSStringFromCGPoint(scrlFindLikeMinded.contentOffset));
            
            
            intExpandHeight = intExpandHeight - viewTableCategory5.frame.origin.y;
            
            
            [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
                viewTableCategory5.frame = CGRectMake(viewTableCategory5.frame.origin.x, viewTableCategory5.frame.origin.y, (viewTableCategory5.frame.size.width), intExpandHeight);
                
            } completion:nil];
            
            break;
        }

            break;
        default:
            break;
    }
    //blnViewExpanded = YES;
}
- (void)ShrinkAllDropdownViews
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory1.frame = CGRectMake(viewTableCategory1.frame.origin.x, viewTableCategory1.frame.origin.y, (viewTableCategory1.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory2.frame = CGRectMake(viewTableCategory2.frame.origin.x, viewTableCategory2.frame.origin.y, (viewTableCategory2.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory3.frame = CGRectMake(viewTableCategory3.frame.origin.x, viewTableCategory3.frame.origin.y, (viewTableCategory3.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory4.frame = CGRectMake(viewTableCategory4.frame.origin.x, viewTableCategory4.frame.origin.y, (viewTableCategory4.frame.size.width), 0);
    } completion:nil];
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        viewTableCategory5.frame = CGRectMake(viewTableCategory5.frame.origin.x, viewTableCategory5.frame.origin.y, (viewTableCategory5.frame.size.width), 0);
    } completion:nil];
}


@end
