


//
//  ShutterRouteMapViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nayamode MacMini on 09/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "ShutterRouteMapViewController.h"
#import "AppDelegate.h"
#import "ShuttleFloorPlan.h"
#import "ShuttleRouteMap.h"
#import "LargeView.h"
#import "DeviceManager.h"
#import "ShuttleRouteMapLocation.h"

@interface ShutterRouteMapViewController ()

@end

@implementation ShutterRouteMapViewController

@synthesize blnViewExpanded,vwLocatonDropdown,lblRouteID,routeID,mapImg,demoView,sampleView,shuttlebrief;

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
    [super viewDidLoad];
    arrShuttleRouteMap = [APP.dictShuttleData valueForKey:@"RouteMap"];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    sampleView.frame=CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, self.view.frame.size.height);
    
    demoView.frame=CGRectMake(0, -600, 0, 0);
    
    
    
    UIImageView * imgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    imgView.image=[UIImage imageNamed:@"infobooth.png"];
    [sampleView addSubview:imgView];
    
    UILabel * lblInfoDescription=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    lblInfoDescription.text=@"Details";
    
    
    // Add this two label on Demo view
    
    locationName=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 180, 20)];
    locationName.text=@"Location Name";
    
    descriptionName=[[UILabel alloc]initWithFrame:CGRectMake(200, 0, 100, 20)];
    descriptionName.text=@"Description";
    
    ShuttleRouteMap *objShuttleRoutemap = [arrShuttleRouteMap objectAtIndex:0];
    ShuttleRouteMapLocation *objShuttleRouteMapLocation = [objShuttleRoutemap.location objectAtIndex:0];
                                                           
    lbllocationName=[[UILabel alloc]initWithFrame:CGRectMake(40, 30, 180, 20)];
    
    
     //lbllocationName.text=[[[[arrShuttleRouteMap objectatindex:0] location] objectatindex:0] valueforkey:@"locationname"];
    lbllocationName.text = objShuttleRouteMapLocation.LocationName;
    
    lbldescriptionName=[[UILabel alloc]initWithFrame:CGRectMake(200, 30, 100, 20)];
    lbldescriptionName.text=objShuttleRouteMapLocation.BriefDescription;
    
    [demoView addSubview:lbllocationName];
    [demoView addSubview:lbldescriptionName];
    
    [demoView addSubview:locationName];
    [demoView addSubview:descriptionName];
    
    
    //lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    //lblDescription.numberOfLines = 0;
    
    [sampleView addSubview:lblInfoDescription];
    [sampleView addGestureRecognizer:singleFingerTap];

    
    
    
    self.TableViewLocation.backgroundView = nil;
    self.TableViewLocation.backgroundColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
    lblRouteID.text = [NSString stringWithFormat:@"%@",((ShuttleRouteMap*)[arrShuttleRouteMap objectAtIndex:0]).ShuttleRouteMapId];
    
    NSURL *imgURL = [NSURL URLWithString:((ShuttleRouteMap*)[arrShuttleRouteMap objectAtIndex:0]).MapURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error){
        if (!error)
        {
             mapImg.image = [UIImage imageWithData:data];
             //[[self avLoadingVenueImage] stopAnimating];
        }
    }];
    

    
    UITapGestureRecognizer *singleFloorPlanTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadLargeView:)];
    [self.ScrollVwImage addGestureRecognizer:singleFloorPlanTap];


}

- (void)loadLargeView:(UITapGestureRecognizer *)gesture
{
    
    
    LargeView *vcLargeView;
    

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle: nil];
        vcLargeView = [storyboard instantiateViewControllerWithIdentifier:@"idLargeView"];

    
    vcLargeView.imgSource = self.mapImg.image;
    [[self navigationController] pushViewController:vcLargeView animated:YES];
}



//- (void)tapOnce:(UIGestureRecognizer *)gesture
//{
//    //on a single  tap, call zoomToRect in UIScrollView
//    [self.ScrollVwImage zoomToRect:rectToZoomInTo animated:NO];
//}
//- (void)tapTwice:(UIGestureRecognizer *)gesture
//{
//    //on a double tap, call zoomToRect in UIScrollView
//    [self.ScrollVwImage zoomToRect:rectToZoomOutTo animated:NO];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shutterrouteBackBtn:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)showDropdown:(id)sender
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


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    // CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //NSLog(@"Get Touch event");
    
    if(demoView.frame.size.height==0)
    {
        
        //demoView.frame=CGRectMake(0, self.view.frame.size.height-160, sampleView.frame.size.width, 100);
        
        demoView.frame=CGRectMake(0, sampleView.frame.origin.y-200, sampleView.frame.size.width, 200);
        
    }
    else
    {
        demoView.frame=CGRectMake(0, -600, 0, 0);
    }
    
    
    
}

- (void)expandView
{
    //NSLog(@"%d",self.arrFloorPlans.count * 44);
    //NSInteger intExpandHeight = [UIScreen mainScreen].bounds.size.height;
    //intExpandHeight = intExpandHeight - self.vwLocatonDropdown.frame.origin.y;
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{vwLocatonDropdown.frame = CGRectMake(vwLocatonDropdown.frame.origin.x,vwLocatonDropdown.frame.origin.y, (vwLocatonDropdown.frame.size.width),170 );
        
    } completion:nil];
    
    blnViewExpanded = YES;
}

- (void)ShrinkView
{
    
    [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionTransitionNone animations: ^{
        vwLocatonDropdown.frame = CGRectMake(vwLocatonDropdown.frame.origin.x, vwLocatonDropdown.frame.origin.y, (vwLocatonDropdown.frame.size.width), 0);
    } completion:nil];
    
    
    blnViewExpanded = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrShuttleRouteMap count];
    
    // AppDelegate * delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //return [delegate.RouteData count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // AppDelegate * delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    //NSString *routeLocationID = [routeID objectAtIndex:indexPath.row];
    
    NSLog(@"mapid: %@",((ShuttleRouteMap*)[arrShuttleRouteMap objectAtIndex:indexPath.row]).ShuttleRouteMapId);
    cellLabelText  = [NSString stringWithFormat:@"%@",((ShuttleRouteMap*)[arrShuttleRouteMap objectAtIndex:indexPath.row]).ShuttleRouteMapId];
   
    cell.textLabel.text = cellLabelText;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.backgroundColor = [UIColor colorWithRed:104/255.0 green:33/255.0 blue:122/255.0 alpha:1.0];
    //cell.textLabel.text = [self.routeID objectAtIndex:0];
    //NSLog(@"cell text %@",cell.textLabel.text);
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(104/255.0) green:(33/255.5) blue:0 alpha:1];
    cell.selectedBackgroundView = selectionColor;
 
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self ShrinkView];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self setFloorPlanData:indexPath.row];
}

-(void) setFloorPlanData:(NSInteger)index
{
    lblRouteID.text = [NSString stringWithFormat:@"%@",((ShuttleRouteMap*)[arrShuttleRouteMap objectAtIndex:index]).ShuttleRouteMapId];
        
  
    
    NSURL *imgURL = [NSURL URLWithString:((ShuttleRouteMap*)[arrShuttleRouteMap objectAtIndex:index]).MapURL];
    NSURLRequest *imgRequest = [NSURLRequest requestWithURL:imgURL];
    [NSURLConnection sendAsynchronousRequest:imgRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,
                                                                                                               NSData *data,
                                                                                                               NSError *error){
        if (!error)
        {
            mapImg.image = [UIImage imageWithData:data];
            //[[self avLoadingVenueImage] stopAnimating];
        }
    }];
    
}


// For ImageView Zooming Functionality
//
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return self.mapImg;
//}




@end

