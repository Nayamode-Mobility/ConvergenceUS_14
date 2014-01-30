//
//  FavouriteAttendeeViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 18/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "FavouriteAttendeeViewController.h"
#import "AttendeeDB.h"
#import "CustomCollectionViewCell.h"
#import "NSString+Custom.h"
#import "AttendeeDetailViewController.h"
#import "Shared.h"
#import "User.h"
#import "DB.h"
#import "Constants.h"
#import "DeviceManager.h"
#import "NSURLConnection+Tag.h"

@interface FavouriteAttendeeViewController ()

@end

@implementation FavouriteAttendeeViewController

@synthesize objConnection, objData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    AttendeeDB *objAttnedee = [AttendeeDB GetInstance];
    arrFavAttendee = [objAttnedee GetFavouriteAttendee];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)btnBack_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSynchFavAttendee_click:(id)sender
{
    [[self vwLoading] setHidden:NO];
    [[self avLoading] startAnimating];
    
    User *objUser = [User GetInstance];
    DB *objDB = [DB GetInstance];
    
    AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
    NSString *strAttendeeExhibitors = [objAttendeeDB GetFavAttendeesJSON];
    
    NSString *strURL = strAPI_URL;
    strURL = [strURL stringByAppendingString:strAPI_ATTENDEE_GET_ATTENDEE_FAV_LIST];
    
    NSURL *URL = [NSURL URLWithString:strURL];
    
    NSMutableURLRequest *objRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [objRequest setHTTPMethod:@"POST"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[objRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [objRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [objRequest addValue:strAPI_AUTH_TOKEN forHTTPHeaderField:@"Authorization-token"];
    //[objRequest addValue:@"iPhone" forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[DeviceManager GetDeviceType] forHTTPHeaderField:@"DeviceType"];
    [objRequest addValue:[objUser GetAccountEmail] forHTTPHeaderField:@"EmailId"];
    [objRequest addValue:strAttendeeExhibitors forHTTPHeaderField:@"FavouriteAttendeeJSON"];
    [objRequest addValue:[NSString stringWithFormat:@"%d",[objDB GetVersionForScreen:strSCREEN_ATTENDEE_EXHIBITOR]] forHTTPHeaderField:@"VersionNo"];
    
    objConnection = [[NSURLConnection alloc] initWithRequest:objRequest delegate:self startImmediately:YES tag:0];

}


#pragma mark - UICollectionViewDataSource methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
        return [arrFavAttendee count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Attendee *objAttendee = [arrFavAttendee objectAtIndex:indexPath.row];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AttendeeDetail"])
    {
        AttendeeDetailViewController *controller = segue.destinationViewController;
        CustomCollectionViewCell *attendeeCell = (CustomCollectionViewCell *)sender;
        controller.attendeeData = (Attendee *)attendeeCell.cellData;
    }
}


#pragma mark Connections Events
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
    NSInteger intTag = (int)[connection getTag];
    
    switch (intTag)
    {
        case 0:
        {
            
            AttendeeDB *objAttendeeDB = [AttendeeDB GetInstance];
            
            if([objAttendeeDB SetFavAttendees:objData])
            {
                arrFavAttendee = [objAttendeeDB GetFavouriteAttendee];
            }
            
            [collFavAttendees reloadData];

            [[self vwLoading] setHidden:YES];
            [[self avLoading] stopAnimating];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
