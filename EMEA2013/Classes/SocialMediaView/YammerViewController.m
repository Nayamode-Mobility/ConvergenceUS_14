//
//  YammerViewController.m
//  ConvergenceUSA_2014
//
//  Created by Nayamode on 07/01/14.
//  Copyright (c) 2014 Nayamode. All rights reserved.
//

#import "YammerViewController.h"

@interface YammerViewController ()

@end

@implementation YammerViewController
@synthesize yammerWebview,def;

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
    
     def=[NSUserDefaults standardUserDefaults];
    
    if([def objectForKey:@"Accesstoken"])
    {
        
        NSLog(@"Tokebn Found");

    }
    else
    {
        
        NSLog(@"Tokeen Not Found Yet");
       
        
         [yammerWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.yammer.com/dialog/oauth?client_id=2JhM88wUAIgK1xyhJybBQ&redirect_uri=http://goconvergence.cloudapp.net/cms/Pageredirected.html&response_type=token"]] ];
        
    }

    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
