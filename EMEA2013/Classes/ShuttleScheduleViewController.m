//
//  ShuttleScheduleViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 08/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "ShuttleScheduleViewController.h"
#import "AppDelegate.h"
#import "Shuttle.h"
#import "shuttleInfo.h"
#import "ShuttleRouteMap.h"
#import "ShuttleTime.h"
#import "ShuttleRouteMapLocation.h"
#import "SyncUp.h"

@interface ShuttleScheduleViewController ()

@end

@implementation ShuttleScheduleViewController
@synthesize dictData;
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
    if ([APP.dictShuttleData count] == 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *recentFilePath = [documentsDirectory stringByAppendingPathComponent:@"ShuttleData.txt"];
        NSLog(@"recent path %@",recentFilePath);
        NSData *objData = [[NSData alloc] initWithContentsOfFile:recentFilePath];
 
            SyncUp *objSync = [[SyncUp alloc]init];
            [objSync GetShuttleInfo:objData];
        
        
    }
    

  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnshuttleBack:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSchedule:(id)sender {
}

- (IBAction)btnrouteMap:(id)sender {
}

- (IBAction)btnInfo:(id)sender {
}
@end
